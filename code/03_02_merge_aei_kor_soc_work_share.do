* =============================================================================
* 03_02_merge_aei_kor_soc_work_share.do
* AEI Claude.ai 직업(SOC)별 업무용 대화 비중: 한국(KOR)과 전 세계(GLOBAL)
*   → 대분류 22개, O*NET-SOC 8자리 세부 직업, SOC 2018 세부 직업 6자리
*   (paper 19: results/paper/19_한국_직업별_업무용대화비중_산출.tex)
*
* 2026-10-24 재설계: Sensor Tower 기반 한국 대화 총량(archive/03_merge_sensortower_aei_kor_soc_conversations.do)을
*   쓰지 않는다. 대화 건수 대신 업무용 대화 비중(share_work, 월마다 합 1)만 만든다. 이후 지표(A~D, 상대 활용도)는
*   모두 비중에서 계산하므로 총량과 대화당 메시지 수 K가 필요 없다.
*
* 입력:
*   $raw/usage/anthropic_economic_index/release_2026_06_26/data/aei_claude_ai_2026-06-26.csv
*       geo_id ∈ {"KOR", "GLOBAL"}, category_name == "soc_occupation"
*       hierarchy_level 1(SOC 대분류 22개): pct, use_case_work_pct
*       hierarchy_level 0(세부 직업, O*NET-SOC 코드): pct (KOR은 pct만 공개; GLOBAL은 use_case_work_pct도 있음)
*   $proc/exposure/bls_soc_crosswalk/soc2018_titles.dta   (01_01_import_soc2018_titles.do) 6자리 명칭
* 출력: $proc/usage/anthropic_economic_index/
*   1. aei_soc_work_share_major.{csv,dta}     지역 × 월 × SOC 대분류
*   2. aei_soc_work_share_detailed.{csv,dta}  지역 × 월 × O*NET-SOC 8자리(soc_code)
*   3. aei_soc6_work_share.{csv,dta}          지역 × 월 × SOC 2018 세부 직업 6자리(soc6)
*
* 정의(지역 r, 월 t):
*   pct(g)       AEI 대화 중 직업 g의 비중(%, 모든 use case)
*   work_pct(g)  직업 g 대화 중 업무용(use case = work) 비중(%)
*   (1) 대분류: share_work(g) = pct × work_pct / Σ_g' (pct × work_pct)    (합 = 1)
*               share_all(g)  = pct / Σ pct                                (모든 use case 기준, 합 = 1; 지표 A0용)
*   (2) 세부 직업 d(대분류 g 안): share_in_major(d) = pct(d) / Σ_{d'∈g} pct(d')
*               share_work(d) = share_work(g) × share_in_major(d),  share_all(d) = share_all(g) × share_in_major(d)
*   (3) 6자리 o = 같은 앞 7자리를 가진 8자리 코드 d의 합.
*   KOR와 GLOBAL은 같은 식으로 만든다(세부 직업 업무용 비중도 GLOBAL은 공개되지만 쓰지 않음; 지표 D가 직업 구성
*   차이만 반영하도록). GLOBAL 세부 직업의 공개 업무용 비중은 B3 점검용으로 work_pct_detail에 남긴다.
*
* 가정:
*   (B1) 한국 업무용 AI 대화의 직업 구성 = AEI Claude.ai 한국 업무용 대화의 직업 구성.
*   (B2) 공개되지 않은 셀은 공개된 셀과 같은 비율로 나뉜다(합이 1이 되게 다시 정규화).
*   (B3) 세부 직업의 업무용 비중은 소속 대분류의 업무용 비중과 같다(KOR 세부 직업은 pct만 공개).
*
* 매칭 키:
*   month(YYYY-MM) = AEI date_start 앞 7자리. SOC는 2026-04, 2026-05뿐.
*   세부 직업 → 대분류: O*NET-SOC 코드 앞 2자리. 공개된 세부 직업이 없는 대분류(월)는
*     soc_code = "NN-XXXX.XX", detail_missing = 1 한 행으로 둔다.
*   8자리 → 6자리: soc6 = soc_code 앞 7자리(XX-XXXX, SOC 2018).
*
* 주의:
*   - AEI의 SOC는 사용자의 직업이 아니라 대화 내용이 해당하는 O*NET 과업의 직업이다.
*   - 값은 소수 둘째 자리 반올림이라 작은 세부 직업은 상대 오차가 크다.
* =============================================================================

version 17
clear all
set more off

if `"$root"' == "" global root "d:/research/AI_effects"
if `"$raw"'  == "" global raw  "$root/data/raw"
if `"$proc"' == "" global proc "$root/data/proc"

local aei "$raw/usage/anthropic_economic_index/release_2026_06_26/data"
local out "$proc/usage/anthropic_economic_index"
capture mkdir "`out'"

* -----------------------------------------------------------------------------
* AEI SOC 원자료(KOR, GLOBAL)
* -----------------------------------------------------------------------------
import delimited using "`aei'/aei_claude_ai_2026-06-26.csv", ///
    varnames(1) encoding("utf-8") bindquote(strict) stringcols(1/7 9 10) asdouble clear
keep if inlist(geo_id, "KOR", "GLOBAL") & category_name == "soc_occupation"
assert inlist(geo_level, "country", "global")
generate str7 month = substr(date_start, 1, 7)
destring hierarchy_level, replace
keep if inlist(metric_id, "pct", "use_case_work_pct")
keep geo_id month hierarchy_level metric_id value node_name node_external_id
* node_name은 strL로 읽혀 reshape·merge 키로 못 쓰므로 str#로 바꾼다
assert strlen(node_name) <= 244
generate str244 nn = node_name
drop node_name
rename nn node_name
compress
confirm str# variable node_name node_external_id
tempfile soc
save `soc'

* -----------------------------------------------------------------------------
* (1) SOC 대분류
* -----------------------------------------------------------------------------
use `soc', clear
keep if hierarchy_level == 1
reshape wide value, i(geo_id month node_external_id node_name) j(metric_id) string
rename (valuepct valueuse_case_work_pct node_external_id node_name) (pct work_pct soc_major soc_major_title)
drop hierarchy_level
isid geo_id month soc_major
assert strlen(soc_major) == 2
bysort geo_id month: assert _N == 22
assert !missing(pct, work_pct)
quietly levelsof month
assert r(r) == 2

bysort geo_id month: egen double pct_sum = total(pct)
generate double work_w = pct * work_pct
bysort geo_id month: egen double work_w_sum = total(work_w)
generate double share_all  = pct / pct_sum
generate double share_work = work_w / work_w_sum
generate double work_pct_geo = work_w_sum / pct_sum         // 함의된 지역 전체 업무용 비중(%)

* 검증: 대분류 비중 합 = 1
foreach v in share_all share_work {
    bysort geo_id month: egen double chk = total(`v')
    assert abs(chk - 1) < 1e-9
    drop chk
}

label variable geo_id          "AEI 지역(KOR, GLOBAL)"
label variable month           "월(YYYY-MM)"
label variable soc_major       "SOC 대분류 코드(2자리)"
label variable soc_major_title "SOC 대분류 명칭(AEI node_name)"
label variable pct             "AEI 대화 중 비중(%, 모든 use case)"
label variable work_pct        "AEI 직업 대화 중 업무용 비중(%)"
label variable pct_sum         "공개된 대분류 pct 합계(%)"
label variable work_w          "pct × work_pct"
label variable work_w_sum      "Σ pct × work_pct"
label variable share_all       "직업 비중(모든 use case, 합 = 1)"
label variable share_work      "직업 비중(업무용 대화 기준, 합 = 1)"
label variable work_pct_geo    "함의된 지역 전체 업무용 비중(%) = Σ(pct × work_pct) / Σ pct"
order geo_id month soc_major soc_major_title pct work_pct share_all share_work pct_sum work_w work_w_sum work_pct_geo
sort geo_id month soc_major
format pct work_pct pct_sum work_pct_geo %9.2f
format share_all share_work %9.6f
compress
save "`out'/aei_soc_work_share_major.dta", replace
export delimited using "`out'/aei_soc_work_share_major.csv", replace datafmt

keep geo_id month soc_major soc_major_title share_work share_all
rename (soc_major_title share_work share_all) (soc_major_title_m share_work_major share_all_major)
tempfile major
save `major'

* -----------------------------------------------------------------------------
* (2) 세부 직업
* -----------------------------------------------------------------------------
use `soc', clear
keep if hierarchy_level == 0
drop hierarchy_level
reshape wide value, i(geo_id month node_external_id node_name) j(metric_id) string
rename (valuepct node_external_id node_name) (pct soc_code soc_title)
capture rename valueuse_case_work_pct work_pct_detail
assert !missing(pct)
assert missing(work_pct_detail) if geo_id == "KOR"
isid geo_id month soc_code
assert regexm(soc_code, "^[0-9][0-9]-[0-9][0-9][0-9][0-9]\.[0-9][0-9]$")
generate str2 soc_major = substr(soc_code, 1, 2)

merge m:1 geo_id month soc_major using `major', assert(match using)
* 세부 직업이 하나도 공개되지 않은 대분류(지역·월)는 "세부 직업 미공개" 한 행으로 대분류 몫 전체를 둔다
generate byte detail_missing = (_merge == 2)
list geo_id month soc_major soc_major_title_m if detail_missing, noobs
replace soc_code  = soc_major + "-XXXX.XX"                if detail_missing
replace soc_title = "(세부 직업 미공개) " + soc_major_title_m if detail_missing
drop _merge
generate str7 soc6 = substr(soc_code, 1, 7)            // SOC 2018 세부 직업(6자리). 미공개 행은 "NN-XXXX"

bysort geo_id month soc_major: egen double pct_major_sum = total(pct)
generate double share_in_major = cond(detail_missing, 1, pct / pct_major_sum)
replace pct_major_sum = . if detail_missing
generate double share_work = share_work_major * share_in_major
generate double share_all  = share_all_major * share_in_major

* 검증: 세부 직업 비중 합 = 1
foreach v in share_work share_all {
    bysort geo_id month: egen double chk = total(`v')
    assert abs(chk - 1) < 1e-9
    drop chk
}

label variable geo_id           "AEI 지역(KOR, GLOBAL)"
label variable month            "월(YYYY-MM)"
label variable soc_code         "O*NET-SOC 세부 직업 코드"
label variable soc6             "SOC 2018 세부 직업 코드(soc_code 앞 7자리)"
label variable soc_title        "세부 직업 명칭(AEI node_name)"
label variable soc_major        "SOC 대분류 코드(soc_code 앞 2자리)"
label variable soc_major_title_m "SOC 대분류 명칭"
label variable pct              "AEI 대화 중 비중(%, 모든 use case)"
label variable work_pct_detail  "세부 직업 업무용 비중(%, GLOBAL만 공개; 계산에는 쓰지 않음)"
label variable pct_major_sum    "같은 대분류 안 공개된 세부 직업 pct 합계(%)"
label variable share_in_major   "대분류 안 세부 직업 비중"
label variable detail_missing   "1 = 대분류에 공개된 세부 직업이 없어 대분류 전체를 한 행으로 둠"
label variable share_work_major "대분류 비중(업무용 대화 기준)"
label variable share_all_major  "대분류 비중(모든 use case)"
label variable share_work       "세부 직업 비중(업무용 대화 기준) = share_work_major × share_in_major"
label variable share_all        "세부 직업 비중(모든 use case) = share_all_major × share_in_major"
order geo_id month soc_code soc6 soc_title soc_major soc_major_title_m pct share_in_major share_work_major ///
    share_work share_all_major share_all work_pct_detail detail_missing pct_major_sum
sort geo_id month soc_major soc_code
format pct pct_major_sum work_pct_detail %9.2f
format share_in_major share_work_major share_work share_all_major share_all %9.6f
compress
save "`out'/aei_soc_work_share_detailed.dta", replace
export delimited using "`out'/aei_soc_work_share_detailed.csv", replace datafmt

* -----------------------------------------------------------------------------
* (3) SOC 2018 세부 직업(6자리): 노출도·시간 절감·연계표와 결합하는 단위
* -----------------------------------------------------------------------------
use "`out'/aei_soc_work_share_detailed.dta", clear
generate byte is00 = substr(soc_code, 9, 2) == "00"
generate byte one = 1
* 6자리 직업 명칭: BLS SOC 2018 공식 명칭(01_01_import_soc2018_titles.do).
*   미공개 자리표시 행("NN-XXXX")만 8자리 행의 명칭을 그대로 둔다.
generate byte neg00 = -is00
bysort geo_id month soc6 (neg00 soc_code): generate str244 soc6_title = soc_title[1]
collapse (sum) pct share_in_major share_work share_all n_onet = one has00 = is00 ///
    (first) soc6_title soc_major soc_major_title_m share_work_major detail_missing pct_major_sum, by(geo_id month soc6)
rename soc6_title soc6_title_aei
merge m:1 soc6 using "$proc/exposure/bls_soc_crosswalk/soc2018_titles.dta", keep(master match)
tabulate geo_id _merge
assert _merge == 3 | detail_missing | geo_id == "GLOBAL"   // 한국 공개 soc6 전부 BLS 목록에 있음
replace soc6_title = soc6_title_aei if _merge == 1
drop _merge soc6_title_aei
replace has00 = has00 > 0
replace pct = . if detail_missing
isid geo_id month soc6
assert regexm(soc6, "^[0-9][0-9]-[0-9][0-9][0-9][0-9]$") | (detail_missing & regexm(soc6, "^[0-9][0-9]-XXXX$"))
assert substr(soc6, 1, 2) == soc_major

* 검증: 6자리 비중 합 = 1
foreach v in share_work share_all {
    bysort geo_id month: egen double chk = total(`v')
    assert abs(chk - 1) < 1e-9
    drop chk
}

label variable geo_id            "AEI 지역(KOR, GLOBAL)"
label variable month             "월(YYYY-MM)"
label variable soc6              "SOC 2018 세부 직업 코드(6자리)"
label variable soc6_title        "SOC 2018 직업 명칭(BLS 공식; 자리표시·BLS 목록 밖 행은 AEI 명칭)"
label variable n_onet            "합친 O*NET-SOC 8자리 코드 수"
label variable has00             "1 = .00 코드(SOC 세부 직업과 같은 단위)가 공개됨"
label variable soc_major         "SOC 대분류 코드(soc6 앞 2자리)"
label variable soc_major_title_m "SOC 대분류 명칭"
label variable pct               "AEI 대화 중 비중(%, 모든 use case, 8자리 합계)"
label variable pct_major_sum     "같은 대분류 안 공개된 세부 직업 pct 합계(%)"
label variable share_in_major    "대분류 안 세부 직업 비중(8자리 합계)"
label variable detail_missing    "1 = 대분류에 공개된 세부 직업이 없어 대분류 전체를 한 행으로 둠"
label variable share_work_major  "대분류 비중(업무용 대화 기준)"
label variable share_work        "세부 직업 비중(업무용 대화 기준, 8자리 합계)"
label variable share_all         "세부 직업 비중(모든 use case, 8자리 합계)"
order geo_id month soc6 soc6_title soc_major soc_major_title_m n_onet has00 pct share_in_major ///
    share_work_major share_work share_all detail_missing pct_major_sum
sort geo_id month soc_major soc6
format pct pct_major_sum %9.2f
format share_in_major share_work_major share_work share_all %9.6f
compress
save "`out'/aei_soc6_work_share.dta", replace
export delimited using "`out'/aei_soc6_work_share.csv", replace datafmt
tab month detail_missing if geo_id == "KOR"
tab month detail_missing if geo_id == "GLOBAL"

* 요약: 2026-05 한국 대분류 상위
use "`out'/aei_soc_work_share_major.dta", clear
keep if month == "2026-05" & geo_id == "KOR"
gsort -share_work
format soc_major_title %-45s
list soc_major soc_major_title pct work_pct share_all share_work in 1/22, noobs sep(0) abbreviate(16) linesize(200)
display as text "함의된 AEI 한국 업무용 비중(2026-05): " %6.2f work_pct_geo[1] "%"
