* =============================================================================
* 03_merge_sensortower_aei_kor_soc_conversations.do
* 한국(South Korea) 월간 업무용 대화량(Sensor Tower 기반) × AEI Claude.ai 한국 직업(SOC)별 대화 비중
*   → 한국 직업별 월간 업무용 대화량(대분류 22개, O*NET-SOC 8자리 세부 직업, SOC 2018 세부 직업 6자리)
*
* 입력:
*   $proc/macro/scaling/sensortower_state_of_ai_2026/sensortower_work_messages_by_country_monthly.dta
*       (03_merge_sensortower_openai_messages.do 출력) South Korea 행의 conv_k1p5 ~ conv_k10
*   $raw/usage/anthropic_economic_index/release_2026_06_26/data/aei_claude_ai_2026-06-26.csv
*       geo_id == "KOR", category_name == "soc_occupation"
*       hierarchy_level 1(SOC 대분류 22개): pct, use_case_work_pct 등 모든 지표
*       hierarchy_level 0(세부 직업, O*NET-SOC 코드): pct만 공개
* 출력: $proc/macro/scaling/sensortower_state_of_ai_2026/
*   1. sensortower_aei_kor_soc_major_conversations.{csv,dta}     월 × SOC 대분류
*   2. sensortower_aei_kor_soc_detailed_conversations.{csv,dta}  월 × O*NET-SOC 8자리 세부 직업(soc_code)
*   3. sensortower_aei_kor_soc6_conversations.{csv,dta}          월 × SOC 2018 세부 직업 6자리(soc6)
*      → observed exposure(labor_market_impacts/job_exposure.csv, occ_code)와 결합할 수 있는 단위
*
* 정의:
*   pct(g,t)       AEI 한국 Claude.ai 대화 중 직업 g의 비중(%, 모든 use case)
*   work_pct(g,t)  직업 g 대화 중 업무용(use case = work) 비중(%)
*   (1) 대분류: 업무용 대화 기준 비중
*       share_work(g,t) = pct × work_pct / Σ_g' (pct × work_pct)        (합 = 1)
*       conv_kK_soc(g,t) = conv_kK(KOR,t) × share_work(g,t)
*       비교용 share_all(g,t) = pct / Σ pct (모든 use case 기준, 합 = 1)
*   (2) 세부 직업 d(대분류 g 안):
*       share_in_major(d,t) = pct(d,t) / Σ_{d'∈g} pct(d',t)
*       share_work(d,t)     = share_work(g,t) × share_in_major(d,t)
*       conv_kK_soc(d,t)    = conv_kK(KOR,t) × share_work(d,t)
*   (3) SOC 2018 세부 직업 o(6자리) = 같은 앞 7자리를 가진 8자리 코드 d의 합:
*       pct(o,t), share_work(o,t), conv_kK_soc(o,t) = Σ_{d∈o} (같은 값)
*
* 가정:
*   (B1) 한국 ChatGPT 등 8개 제품 업무용 대화의 직업 구성 = AEI Claude.ai 한국 업무용 대화의 직업 구성.
*   (B2) 공개되지 않은 셀(대분류 합 약 97~99%, 세부 합 약 96~98%)은 공개된 셀과 같은 비율로 나뉜다
*        (합이 1이 되게 다시 정규화).
*   (B3) 세부 직업의 업무용 비중은 소속 대분류의 업무용 비중과 같다(세부 직업은 pct만 공개).
*
* 매칭 키:
*   Sensor Tower market == "South Korea"(iso2 "KR") ↔ AEI geo_id == "KOR"
*   month(YYYY-MM) ↔ AEI date_start의 앞 7자리. AEI SOC는 2026-04, 2026-05뿐이므로 두 달만 남는다.
*   세부 직업 → 대분류: O*NET-SOC 코드(예: 15-1252.00)의 앞 2자리 = 대분류 코드(예: 15).
*   공개된 세부 직업이 없는 대분류(월)는 soc_code = "NN-XXXX.XX", detail_missing = 1 한 행으로 둔다.
*   8자리 → 6자리: soc6 = soc_code 앞 7자리(XX-XXXX) = job_exposure.csv occ_code(SOC 2018). 이 파일에서는 결합하지 않는다.
*     미공개 행의 soc6 = "NN-XXXX"는 job_exposure와 매칭되지 않는다(2026-04 농림어업 45).
*
* 주의:
*   - AEI의 SOC는 사용자의 직업이 아니라 대화 내용이 해당하는 O*NET 과업의 직업이다.
*   - 값은 소수 둘째 자리 반올림이라 작은 세부 직업은 상대 오차가 크다.
*   - conv_kK는 업무용 메시지 ÷ 대화당 메시지 수 K(report 17). K는 격자 {1.5, 3, 5, 7, 10}.
* =============================================================================

version 17
clear all
set more off

if `"$root"' == "" global root "d:/research/AI_effects"
if `"$raw"'  == "" global raw  "$root/data/raw"
if `"$proc"' == "" global proc "$root/data/proc"

local stp "$proc/macro/scaling/sensortower_state_of_ai_2026"
local aei "$raw/usage/anthropic_economic_index/release_2026_06_26/data"
local out "`stp'"
local klist "k1p5 k3 k5 k7 k10"

* -----------------------------------------------------------------------------
* 한국 업무용 대화량(Sensor Tower 기반)
* -----------------------------------------------------------------------------
use "`stp'/sensortower_work_messages_by_country_monthly.dta", clear
keep if market == "South Korea"
assert iso2 == "KR"
isid month
keep month work_messages conv_k*
foreach k of local klist {
    rename conv_`k' kor_conv_`k'
}
rename work_messages kor_work_messages
tempfile kor
save `kor'

* -----------------------------------------------------------------------------
* AEI 한국 SOC 원자료
* -----------------------------------------------------------------------------
import delimited using "`aei'/aei_claude_ai_2026-06-26.csv", ///
    varnames(1) encoding("utf-8") bindquote(strict) stringcols(1/7 9 10) asdouble clear
keep if geo_id == "KOR" & geo_level == "country" & category_name == "soc_occupation"
generate str7 month = substr(date_start, 1, 7)
destring hierarchy_level, replace
keep if (hierarchy_level == 1 & inlist(metric_id, "pct", "use_case_work_pct")) | ///
        (hierarchy_level == 0 & metric_id == "pct")
keep month hierarchy_level metric_id value node_name node_external_id
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
reshape wide value, i(month node_external_id node_name) j(metric_id) string
rename (valuepct valueuse_case_work_pct node_external_id node_name) (pct work_pct soc_major soc_major_title)
drop hierarchy_level
isid month soc_major
assert strlen(soc_major) == 2
bysort month: assert _N == 22
assert !missing(pct, work_pct)

bysort month: egen double pct_sum = total(pct)
generate double work_w = pct * work_pct
bysort month: egen double work_w_sum = total(work_w)
generate double share_all  = pct / pct_sum
generate double share_work = work_w / work_w_sum
generate double work_pct_kor = work_w_sum / pct_sum         // 함의된 한국 업무용 비중(%)

merge m:1 month using `kor', keep(match) nogenerate
quietly levelsof month
assert r(r) == 2
foreach k of local klist {
    generate double conv_`k' = kor_conv_`k' * share_work
}

* 검증: 대분류 합계 = 한국 대화량
foreach k of local klist {
    bysort month: egen double chk = total(conv_`k')
    assert abs(chk / kor_conv_`k' - 1) < 1e-9
    drop chk
}

label variable month           "월(YYYY-MM)"
label variable soc_major       "SOC 대분류 코드(2자리)"
label variable soc_major_title "SOC 대분류 명칭(AEI node_name)"
label variable pct             "AEI 한국 대화 중 비중(%, 모든 use case)"
label variable work_pct        "AEI 직업 대화 중 업무용 비중(%)"
label variable pct_sum         "공개된 대분류 pct 합계(%)"
label variable work_w          "pct × work_pct"
label variable work_w_sum      "Σ pct × work_pct"
label variable share_all       "직업 비중(모든 use case, 합 = 1)"
label variable share_work      "직업 비중(업무용 대화 기준, 합 = 1)"
label variable work_pct_kor    "함의된 AEI 한국 업무용 비중(%) = Σ(pct × work_pct) / Σ pct"
label variable kor_work_messages "한국 월간 업무용 메시지 수(Sensor Tower 기반)"
foreach k of local klist {
    local kk = subinstr(substr("`k'", 2, .), "p", ".", .)
    label variable kor_conv_`k' "한국 월간 업무용 대화 수(대화당 메시지 `kk'개)"
    label variable conv_`k'     "직업별 월간 업무용 대화 수(대화당 메시지 `kk'개)"
}
order month soc_major soc_major_title pct work_pct share_all share_work conv_* ///
    pct_sum work_w work_w_sum work_pct_kor kor_work_messages kor_conv_*
sort month soc_major
format pct work_pct pct_sum work_pct_kor %9.2f
format share_all share_work %9.6f
format conv_* kor_conv_* kor_work_messages %15.0f
compress
save "`out'/sensortower_aei_kor_soc_major_conversations.dta", replace
export delimited using "`out'/sensortower_aei_kor_soc_major_conversations.csv", replace datafmt

keep month soc_major soc_major_title share_work
rename (soc_major_title share_work) (soc_major_title_m share_work_major)
tempfile major
save `major'

* -----------------------------------------------------------------------------
* (2) 세부 직업
* -----------------------------------------------------------------------------
use `soc', clear
keep if hierarchy_level == 0
drop hierarchy_level metric_id
rename (value node_external_id node_name) (pct soc_code soc_title)
isid month soc_code
assert regexm(soc_code, "^[0-9][0-9]-[0-9][0-9][0-9][0-9]\.[0-9][0-9]$")
generate str2 soc_major = substr(soc_code, 1, 2)

merge m:1 month soc_major using `major', assert(match using)
* 세부 직업이 하나도 공개되지 않은 대분류(월)는 "세부 직업 미공개" 한 행으로 대분류 몫 전체를 둔다
generate byte detail_missing = (_merge == 2)
list month soc_major soc_major_title_m if detail_missing, noobs
replace soc_code  = soc_major + "-XXXX.XX"                if detail_missing
replace soc_title = "(세부 직업 미공개) " + soc_major_title_m if detail_missing
drop _merge
generate str7 soc6 = substr(soc_code, 1, 7)            // SOC 2018 세부 직업(6자리). 미공개 행은 "NN-XXXX"

bysort month soc_major: egen double pct_major_sum = total(pct)
generate double share_in_major = cond(detail_missing, 1, pct / pct_major_sum)
replace pct_major_sum = . if detail_missing
generate double share_work = share_work_major * share_in_major

merge m:1 month using `kor', keep(match) nogenerate
foreach k of local klist {
    generate double conv_`k' = kor_conv_`k' * share_work
}

* 검증: 세부 직업 합계 = 한국 대화량
foreach k of local klist {
    bysort month: egen double chk = total(conv_`k')
    assert abs(chk / kor_conv_`k' - 1) < 1e-9
    drop chk
}

label variable month            "월(YYYY-MM)"
label variable soc_code         "O*NET-SOC 세부 직업 코드"
label variable soc6             "SOC 2018 세부 직업 코드(soc_code 앞 7자리)"
label variable soc_title        "세부 직업 명칭(AEI node_name)"
label variable soc_major        "SOC 대분류 코드(soc_code 앞 2자리)"
label variable soc_major_title_m "SOC 대분류 명칭"
label variable pct              "AEI 한국 대화 중 비중(%, 모든 use case)"
label variable pct_major_sum    "같은 대분류 안 공개된 세부 직업 pct 합계(%)"
label variable share_in_major   "대분류 안 세부 직업 비중"
label variable detail_missing   "1 = 대분류에 공개된 세부 직업이 없어 대분류 전체를 한 행으로 둠"
label variable share_work_major "대분류 비중(업무용 대화 기준)"
label variable share_work       "세부 직업 비중(업무용 대화 기준) = share_work_major × share_in_major"
label variable kor_work_messages "한국 월간 업무용 메시지 수(Sensor Tower 기반)"
foreach k of local klist {
    local kk = subinstr(substr("`k'", 2, .), "p", ".", .)
    label variable kor_conv_`k' "한국 월간 업무용 대화 수(대화당 메시지 `kk'개)"
    label variable conv_`k'     "직업별 월간 업무용 대화 수(대화당 메시지 `kk'개)"
}
order month soc_code soc6 soc_title soc_major soc_major_title_m pct share_in_major share_work_major ///
    share_work conv_* detail_missing pct_major_sum kor_work_messages kor_conv_*
sort month soc_major soc_code
format pct pct_major_sum %9.2f
format share_in_major share_work_major share_work %9.6f
format conv_* kor_conv_* kor_work_messages %15.0f
compress
save "`out'/sensortower_aei_kor_soc_detailed_conversations.dta", replace
export delimited using "`out'/sensortower_aei_kor_soc_detailed_conversations.csv", replace datafmt

* -----------------------------------------------------------------------------
* (3) SOC 2018 세부 직업(6자리): observed exposure(job_exposure.csv occ_code)와 결합할 수 있는 단위
* -----------------------------------------------------------------------------
use "`out'/sensortower_aei_kor_soc_detailed_conversations.dta", clear
generate byte is00 = substr(soc_code, 9, 2) == "00"
generate byte one = 1
* 6자리 직업 명칭: .00 코드 명칭 우선, 없으면 코드 순 첫 번째 8자리 코드 명칭
generate byte neg00 = -is00
bysort month soc6 (neg00 soc_code): generate str244 soc6_title = soc_title[1]
collapse (sum) pct share_in_major share_work conv_* n_onet = one has00 = is00 ///
    (first) soc6_title soc_major soc_major_title_m share_work_major detail_missing pct_major_sum ///
    kor_work_messages kor_conv_*, by(month soc6)
replace has00 = has00 > 0
replace pct = . if detail_missing
isid month soc6
assert regexm(soc6, "^[0-9][0-9]-[0-9][0-9][0-9][0-9]$") | (detail_missing & regexm(soc6, "^[0-9][0-9]-XXXX$"))
assert substr(soc6, 1, 2) == soc_major

* 검증: 6자리 합계 = 한국 대화량
foreach k of local klist {
    bysort month: egen double chk = total(conv_`k')
    assert abs(chk / kor_conv_`k' - 1) < 1e-9
    drop chk
}

label variable month             "월(YYYY-MM)"
label variable soc6              "SOC 2018 세부 직업 코드(6자리, job_exposure.csv occ_code와 같은 형식)"
label variable soc6_title        "세부 직업 명칭(AEI node_name, .00 코드 우선)"
label variable n_onet            "합친 O*NET-SOC 8자리 코드 수"
label variable has00             "1 = .00 코드(SOC 세부 직업과 같은 단위)가 공개됨"
label variable soc_major         "SOC 대분류 코드(soc6 앞 2자리)"
label variable soc_major_title_m "SOC 대분류 명칭"
label variable pct               "AEI 한국 대화 중 비중(%, 모든 use case, 8자리 합계)"
label variable pct_major_sum     "같은 대분류 안 공개된 세부 직업 pct 합계(%)"
label variable share_in_major    "대분류 안 세부 직업 비중(8자리 합계)"
label variable detail_missing    "1 = 대분류에 공개된 세부 직업이 없어 대분류 전체를 한 행으로 둠"
label variable share_work_major  "대분류 비중(업무용 대화 기준)"
label variable share_work        "세부 직업 비중(업무용 대화 기준, 8자리 합계)"
label variable kor_work_messages "한국 월간 업무용 메시지 수(Sensor Tower 기반)"
foreach k of local klist {
    local kk = subinstr(substr("`k'", 2, .), "p", ".", .)
    label variable kor_conv_`k' "한국 월간 업무용 대화 수(대화당 메시지 `kk'개)"
    label variable conv_`k'     "직업별 월간 업무용 대화 수(대화당 메시지 `kk'개)"
}
order month soc6 soc6_title soc_major soc_major_title_m n_onet has00 pct share_in_major ///
    share_work_major share_work conv_* detail_missing pct_major_sum kor_work_messages kor_conv_*
sort month soc_major soc6
format pct pct_major_sum %9.2f
format share_in_major share_work_major share_work %9.6f
format conv_* kor_conv_* kor_work_messages %15.0f
compress
save "`out'/sensortower_aei_kor_soc6_conversations.dta", replace
export delimited using "`out'/sensortower_aei_kor_soc6_conversations.csv", replace datafmt
tab month detail_missing

* 요약: 2026-05 대분류 상위
use "`out'/sensortower_aei_kor_soc_major_conversations.dta", clear
keep if month == "2026-05"
gsort -conv_k3
format soc_major_title %-45s
list soc_major soc_major_title pct work_pct share_work conv_k3 in 1/22, noobs sep(0) abbreviate(16) linesize(200)
display as text "함의된 AEI 한국 업무용 비중(2026-05): " %6.2f work_pct_kor[1] "%"
