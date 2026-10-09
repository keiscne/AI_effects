* =============================================================================
* 01_import_soc2018_ksco8_crosswalk.do
* SOC 2018 세부 직업(6자리) ↔ 한국표준직업분류 8차(KSCO 8차) 세분류(4자리)
*   ↔ 한국고용직업분류 2025(KECO 2025) 세분류(4자리) 연계표
*
* 공식 SOC 2018–ISCO-08 연계표가 없으므로(BLS·O*NET 모두 미배포), BLS·통계청 연계표 3개를 이어 쓴다.
*   SOC 2018 → SOC 2010 → ISCO-08 → KSCO 8차   (report 17, 9.3절 제안 절차 1·2단계)
* KSCO 8차 → KECO 2025는 통계청 연계표(세분류 1:1 대응)로 붙인다. 1:1이므로 가중치는 KSCO 기준과 같다.
*
* 입력: $raw/exposure/bls_soc_crosswalk/
*   soc_2018/soc_2010_to_2018_crosswalk.xlsx      시트 "Sorted by 2010", 10~909행 = 900쌍
*   isco08_soc/ISCO_SOC_Crosswalk.xls             시트 "ISCO-08 to 2010 SOC", 8~1132행 = 1,125쌍
*   isco08_ksco08/한국표준직업분류(KSCO 8차)-국제표준직업분류(ISCO-08) 연계표_20260127034430.xlsx
*       시트 "4-1. (연계표) 세분류 연계표(KSCO-ISCO)", 1행 머리글 + 701행(고유 쌍 700)
*       (kostat_ksco_isco_crosswalk/ksco8_isco08/의 같은 파일과 MD5 동일)
*   isco08_ksco08/한국고용직업분류 2025 개정 - 한국표준직업분류 8차 간 연계표_20250103043442.xlsx
*       시트 "통계분류포털 요청", 1~3행 제목·머리글, 4~498행 = (KECO 2025, KSCO 8차) 495쌍, 모두 1:1
*       KECO 대분류 0의 코드는 숫자 셀이라 앞자리 0이 빠져 3자리(예: 111)로 읽힘 → 0을 붙여 4자리(0111)로 맞춤
* 출력: $proc/exposure/bls_soc_crosswalk/
*   soc2018_ksco8_paths.{csv,dta}       행 = 연결 경로(soc2018, soc2010, isco08, ksco8) + keco2025
*   soc2018_ksco8_crosswalk.{csv,dta}   행 = 고유 (soc2018, ksco8) 쌍 + keco2025 + 가중치 → 결합에 쓰는 파일
*   soc2018_ksco8_stages.{csv,dta}      행 = 단계별 연계쌍(정리 후 4개 표, 경로 연결 전; 확인·보고서용)
*     KECO 기준으로 쓸 때도 이 파일을 그대로 쓴다(keco2025 하나 = ksco8 하나이므로
*     w_mean·w_flat은 keco2025 안에서도 합 1). 대응이 없는 KSCO가 생기면 keco2025는 빈칸.
*   결과: KSCO–ISCO 표의 KSCO 494개(군인 A011~A090 → KECO 2501~2509 포함) 모두 KECO와 대응.
*     KECO 표에만 있는 KSCO 8631(일차전지 및 이차전지 제조 기계 조작원, KECO 8352)은
*     KSCO–ISCO 표에 없어 SOC와 이어지지 않는다(KECO 495개 중 494개 연결).
*
* 처리(작업자 판단):
*   - ISCO 3자리 2개(BLS가 ISCO 세분류 없이 소분류에 연결): 19-2099 → 211, 53-2022 → 315.
*     각 소분류에 속하는 ISCO 4자리 코드(BLS 표에 있는 것) 모두에 연결하고 isco3 = 1로 표시.
*   - KSCO 표의 중복 행 1개(2365–3119) 삭제.
*   - 연결이 끊기는 ISCO(한쪽 표에만 있는 코드)는 경로에서 빠진다. 목록은 로그에 출력.
* 가중치(각 단계에서 대응 코드 사이를 균등하게 나눔; 고용 가중 없음):
*   w_mean  : SOC 지표(노출도·시간 절감 등 비율 지표) → KSCO 값 = Σ w_mean × 값. ksco8 안에서 합 1.
*             단계별 단순평균을 이어 붙인 것과 같다:
*             SOC 2010 값 = 연결된 SOC 2018 평균 → ISCO 값 = 연결된 SOC 2010 평균
*             → KSCO 값 = 연결된 ISCO 평균.
*             값이 없는 SOC 2018이 있으면 그 쌍을 빼고 ksco8 안에서 w_mean을 다시 나눠 합 1로 맞춘다.
*   w_flat  : 연결된 SOC 2018 코드의 단순평균(1 / ksco8당 SOC 2018 수). ksco8 안에서 합 1. 민감도용.
*   w_alloc : SOC 양(대화 건수 등) → KSCO 배분. soc2018 안에서 합 1.
*             SOC 2018 → 대응 SOC 2010에 균등, SOC 2010 → 대응 ISCO에 균등, ISCO → 대응 KSCO에 균등.
* 매칭 키: soc2018(str7, XX-XXXX) = soc6_ai_indicators·sensortower_aei_kor_soc6_conversations의 soc6
*          ksco8(str4) = KSCO 8차 세분류 코드(군인은 A011 등 문자 포함)
*          keco2025(str4) = KECO 2025 세분류 코드(앞자리 0 포함, 예: 0111)
* =============================================================================

version 17
clear all
set more off

if `"$root"' == "" global root "d:/research/AI_effects"
if `"$raw"'  == "" global raw  "$root/data/raw"
if `"$proc"' == "" global proc "$root/data/proc"

local cw   "$raw/exposure/bls_soc_crosswalk"
local outf "$proc/exposure/bls_soc_crosswalk"
capture mkdir "$proc/exposure"
capture mkdir "`outf'"

* -----------------------------------------------------------------------------
* 1. SOC 2010 ↔ SOC 2018 (BLS)
* -----------------------------------------------------------------------------
import excel using "`cw'/soc_2018/soc_2010_to_2018_crosswalk.xlsx", sheet("Sorted by 2010") ///
    cellrange(A10:D909) clear allstring
rename (A B C D) (soc2010 soc2010_title soc2018 soc2018_title)
foreach v of varlist _all {
    replace `v' = strtrim(`v')
}
* 명칭 끝의 BLS 각주 표시 " (#)", " (##)" 삭제
foreach v in soc2010_title soc2018_title {
    replace `v' = strtrim(regexr(`v', "\(#+\)$", ""))
}
assert regexm(soc2010, "^[0-9][0-9]-[0-9][0-9][0-9][0-9]$") & regexm(soc2018, "^[0-9][0-9]-[0-9][0-9][0-9][0-9]$")
count
assert r(N) == 900
isid soc2010 soc2018
tempfile s1018
save `s1018'

* -----------------------------------------------------------------------------
* 2. ISCO-08 ↔ SOC 2010 (BLS)
* -----------------------------------------------------------------------------
import excel using "`cw'/isco08_soc/ISCO_SOC_Crosswalk.xls", sheet("ISCO-08 to 2010 SOC") ///
    cellrange(A8:E1132) clear allstring
rename (A B C D E) (isco08 isco08_title_en isco_part soc2010 soc2010_title_isco)
foreach v of varlist _all {
    replace `v' = strtrim(`v')
}
count
assert r(N) == 1125
isid isco08 soc2010
assert regexm(soc2010, "^[0-9][0-9]-[0-9][0-9][0-9][0-9]$")
assert regexm(isco08, "^[0-9][0-9][0-9][0-9]?$")
list isco08 isco08_title_en soc2010 soc2010_title_isco if strlen(isco08) == 3, noobs abbreviate(20)
assert inlist(soc2010, "19-2099", "53-2022") == (strlen(isco08) == 3)

* ISCO 3자리 → 같은 소분류의 ISCO 4자리(BLS 표에 있는 코드) 전부
preserve
keep if strlen(isco08) == 4
keep isco08 isco08_title_en
duplicates drop
generate str3 isco3 = substr(isco08, 1, 3)
tempfile isco4
save `isco4'
restore
preserve
keep if strlen(isco08) == 3
keep isco08 soc2010 soc2010_title_isco
rename isco08 isco3
joinby isco3 using `isco4'
list isco3 isco08 isco08_title_en soc2010, noobs abbreviate(20)
generate byte isco3_link = 1
drop isco3
tempfile isco3x
save `isco3x'
restore
drop if strlen(isco08) == 3
generate byte isco3_link = 0
append using `isco3x'
drop isco_part
isid isco08 soc2010
tempfile i10
save `i10'

* -----------------------------------------------------------------------------
* 3. KSCO 8차 ↔ ISCO-08 (통계청, 세분류)
* -----------------------------------------------------------------------------
import excel using ///
    "`cw'/isco08_ksco08/한국표준직업분류(KSCO 8차)-국제표준직업분류(ISCO-08) 연계표_20260127034430.xlsx", ///
    sheet("4-1. (연계표) 세분류 연계표(KSCO-ISCO)") firstrow clear allstring
rename (한국코드 한국분류 국제코드 국제분류) (ksco8 ksco8_title isco08 isco08_title_ko)
rename 대분류벗어난* ksco_cross_major
keep ksco8 ksco8_title isco08 isco08_title_ko ksco_cross_major
foreach v of varlist _all {
    replace `v' = strtrim(`v')
}
count
assert r(N) == 701
duplicates drop ksco8 isco08, force
count
assert r(N) == 700
assert regexm(ksco8, "^[0-9A][0-9][0-9][0-9]$") & regexm(isco08, "^[0-9][0-9][0-9][0-9]$")
destring ksco_cross_major, replace
assert inlist(ksco_cross_major, 0, 1)
* 같은 코드에 명칭 표기가 둘 이상인 경우(띄어쓰기, 오타 "핀매 대리인" 등)
* → 코드별로 가장 많이 쓰인 표기로 통일(같으면 표 순서상 먼저 나온 표기)
generate long row = _n
foreach x in isco08 ksco8 {
    local t = cond("`x'" == "isco08", "isco08_title_ko", "ksco8_title")
    bysort `x' (row): generate byte d_ = `t' != `t'[1]
    bysort `x': egen byte dd_ = max(d_)
    display as text "명칭 표기가 둘 이상인 `x'"
    list `x' `t' if dd_, noobs abbreviate(20) sepby(`x')
    bysort `x' `t': generate long nt_ = _N
    bysort `x' `t': egen long r0_ = min(row)
    gsort `x' -nt_ r0_
    by `x': replace `t' = `t'[1]
    drop d_ dd_ nt_ r0_
}
sort row
drop row
tempfile ki
save `ki'

* 연결 확인: KSCO 표의 ISCO와 BLS 표의 ISCO
keep isco08 isco08_title_ko
duplicates drop
merge 1:m isco08 using `i10', keepusing(isco08 isco08_title_en)
display as text "KSCO 표에만 있는 ISCO(_merge==1) / BLS 표에만 있는 ISCO(_merge==2)"
bysort isco08: keep if _n == 1
tabulate _merge
list isco08 isco08_title_ko if _merge == 1, noobs abbreviate(20)
list isco08 isco08_title_en if _merge == 2, noobs abbreviate(20)

* -----------------------------------------------------------------------------
* 4. KECO 2025 ↔ KSCO 8차 (통계청, 세분류)
* -----------------------------------------------------------------------------
import excel using ///
    "`cw'/isco08_ksco08/한국고용직업분류 2025 개정 - 한국표준직업분류 8차 간 연계표_20250103043442.xlsx", ///
    sheet("통계분류포털 요청") cellrange(A4:D498) clear allstring
rename (A B C D) (keco2025 keco2025_title ksco8 ksco8_title_keco)
foreach v of varlist _all {
    replace `v' = strtrim(`v')
}
count
assert r(N) == 495
* 대분류 0의 앞자리 0 복원(3자리 77개)
assert regexm(keco2025, "^[0-9][0-9][0-9][0-9]?$")
count if strlen(keco2025) == 3
assert r(N) == 77
replace keco2025 = "0" + keco2025 if strlen(keco2025) == 3
assert regexm(keco2025, "^[0-9][0-9][0-9][0-9]$") & regexm(ksco8, "^[0-9A][0-9][0-9][0-9]$")
* 세분류끼리 1:1
isid keco2025
isid ksco8
tempfile kk
save `kk'

* 연결 확인: KSCO–ISCO 표의 KSCO와 KECO 표의 KSCO
use `ki', clear
keep ksco8 ksco8_title
duplicates drop
merge 1:1 ksco8 using `kk'
display as text "KSCO–ISCO 표에만 있는 KSCO(_merge==1) / KECO 표에만 있는 KSCO(_merge==2)"
tabulate _merge
list ksco8 ksco8_title if _merge == 1, noobs abbreviate(20)
list ksco8 ksco8_title_keco keco2025 keco2025_title if _merge == 2, noobs abbreviate(20)
* 같은 KSCO 코드의 명칭이 두 표에서 다른 경우(확인용)
list ksco8 ksco8_title ksco8_title_keco if _merge == 3 & ksco8_title != ksco8_title_keco, noobs abbreviate(20)
use `kk', clear
tempfile kk_full
save `kk_full'
drop ksco8_title_keco
save `kk', replace

* 단계별 연계쌍(정리 후, 경로 연결 전) → soc2018_ksco8_stages (report 21의 단계별 표에 사용)
*   왼쪽 = SOC 2018에 가까운 쪽, 오른쪽 = KECO에 가까운 쪽
use `s1018', clear
generate byte stage = 1
rename (soc2018 soc2018_title soc2010 soc2010_title) (left left_title right right_title)
tempfile st
save `st'
use `i10', clear
generate byte stage = 2
rename (soc2010 soc2010_title_isco isco08 isco08_title_en) (left left_title right right_title)
append using `st'
save `st', replace
use `ki', clear
generate byte stage = 3
rename (isco08 isco08_title_ko ksco8 ksco8_title) (left left_title right right_title)
append using `st'
save `st', replace
use `kk_full', clear
generate byte stage = 4
rename (ksco8 ksco8_title_keco keco2025 keco2025_title) (left left_title right right_title)
append using `st'
label define stage_l 1 "SOC 2018–SOC 2010" 2 "SOC 2010–ISCO-08" 3 "ISCO-08–KSCO 8차" 4 "KSCO 8차–KECO 2025"
label values stage stage_l
keep stage left left_title right right_title isco3_link ksco_cross_major
order stage left left_title right right_title isco3_link ksco_cross_major
isid stage left right
label variable stage            "연계 단계"
label variable left             "왼쪽 코드(SOC 2018에 가까운 쪽)"
label variable left_title       "왼쪽 명칭"
label variable right            "오른쪽 코드(KECO에 가까운 쪽)"
label variable right_title      "오른쪽 명칭"
label variable isco3_link       "1 = 2단계, BLS의 ISCO 3자리 연결을 4자리로 펼친 쌍"
label variable ksco_cross_major "1 = 3단계, 통계청 표의 대분류 벗어난 연계"
sort stage left right
compress
save "`outf'/soc2018_ksco8_stages.dta", replace
export delimited using "`outf'/soc2018_ksco8_stages.csv", replace
tabulate stage

* -----------------------------------------------------------------------------
* 5. 경로 연결: SOC 2018 → SOC 2010 → ISCO-08 → KSCO 8차 (→ KECO 2025)
* -----------------------------------------------------------------------------
* 단계별 대응 수(배분·평균 가중치용). 각 표 전체 기준으로 센다.
use `s1018', clear
bysort soc2018: generate n10_per18 = _N           // SOC 2018 하나에 대응하는 SOC 2010 수
bysort soc2010: generate n18_per10 = _N           // SOC 2010 하나에 대응하는 SOC 2018 수
save `s1018', replace

* SOC 2010 – ISCO 단계와 ISCO – KSCO 단계는 실제로 끝까지 이어지는 경로만으로 센다
* (한쪽 표에만 있는 ISCO로 가는 연결은 버림).
use `i10', clear
joinby isco08 using `ki'
keep isco08 soc2010
duplicates drop
tempfile i10ok
save `i10ok'
use `i10', clear
merge 1:1 isco08 soc2010 using `i10ok', keep(match) nogenerate
bysort soc2010: generate nisco_per10 = _N         // SOC 2010 하나에 대응하는 ISCO 수
bysort isco08:  generate n10_perisco = _N         // ISCO 하나에 대응하는 SOC 2010 수
save `i10', replace

use `i10ok', clear
keep isco08
duplicates drop
tempfile iscook
save `iscook'
use `ki', clear
merge m:1 isco08 using `iscook', keep(master match)
display as text "SOC와 연결되지 않는 KSCO–ISCO 쌍"
list ksco8 ksco8_title isco08 isco08_title_ko if _merge == 1, noobs abbreviate(20)
keep if _merge == 3
drop _merge
bysort isco08: generate nk_perisco = _N           // ISCO 하나에 대응하는 KSCO 수
bysort ksco8:  generate nisco_perk = _N           // KSCO 하나에 대응하는 ISCO 수
save `ki', replace

use `s1018', clear
joinby soc2010 using `i10'                        // SOC 2010이 ISCO와 이어지지 않으면 빠짐
joinby isco08 using `ki'
merge m:1 ksco8 using `kk', keep(master match) nogenerate   // KECO 대응이 없는 KSCO는 keco2025 빈칸
order soc2018 soc2018_title soc2010 soc2010_title isco08 isco08_title_en isco08_title_ko ///
    ksco8 ksco8_title keco2025 keco2025_title isco3_link ksco_cross_major
isid soc2018 soc2010 isco08 ksco8

* 경로별 가중치
* 평균(ksco8 안 합 1): (1/n18_per10) × (1/n10_perisco) × (1/nisco_perk)
*   단, SOC 2010 → SOC 2018 평균은 그 SOC 2010의 SOC 2018 가운데 경로가 살아 있는 것만으로 센다.
bysort soc2010 isco08 ksco8: generate n18_per10_ok = _N
generate double w_mean_p  = (1 / n18_per10_ok) * (1 / n10_perisco) * (1 / nisco_perk)
* 배분(soc2018 안 합 1): (1/n10_per18) × (1/nisco_per10) × (1/nk_perisco), 경로가 끊긴 SOC 2010은 빼고 다시 나눔
bysort soc2018 soc2010: generate byte first_10 = _n == 1
bysort soc2018: egen n10_per18_ok = total(first_10)
generate double w_alloc_p = (1 / n10_per18_ok) * (1 / nisco_per10) * (1 / nk_perisco)
drop first_10

* 확인: 합 1
bysort ksco8: egen double chk_m = total(w_mean_p)
bysort soc2018: egen double chk_a = total(w_alloc_p)
summarize chk_m chk_a
assert abs(chk_m - 1) < 1e-9 & abs(chk_a - 1) < 1e-9
drop chk_m chk_a n18_per10_ok n10_per18_ok

label variable soc2018          "SOC 2018 세부 직업(XX-XXXX)"
label variable soc2018_title    "SOC 2018 명칭(BLS)"
label variable soc2010          "SOC 2010 세부 직업(XX-XXXX)"
label variable soc2010_title    "SOC 2010 명칭(BLS SOC 2010–2018 표)"
label variable isco08           "ISCO-08 세분류(4자리)"
label variable isco08_title_en  "ISCO-08 명칭(영문, BLS)"
label variable isco08_title_ko  "ISCO-08 명칭(국문, 통계청)"
label variable ksco8            "KSCO 8차 세분류(4자리)"
label variable ksco8_title      "KSCO 8차 명칭"
label variable keco2025         "KECO 2025 세분류(4자리, KSCO와 1:1; 빈칸 = 대응 없음)"
label variable keco2025_title   "KECO 2025 명칭"
label variable isco3_link       "1 = BLS가 ISCO 3자리 소분류에 연결(19-2099→211, 53-2022→315)"
label variable ksco_cross_major "1 = 통계청 표의 대분류 벗어난 연계"
label variable n10_per18        "SOC 2018 하나에 대응하는 SOC 2010 수(BLS 표 전체)"
label variable n18_per10        "SOC 2010 하나에 대응하는 SOC 2018 수(BLS 표 전체)"
label variable nisco_per10      "SOC 2010 하나에 대응하는 ISCO 수(KSCO까지 이어지는 것)"
label variable n10_perisco      "ISCO 하나에 대응하는 SOC 2010 수(KSCO까지 이어지는 것)"
label variable nk_perisco       "ISCO 하나에 대응하는 KSCO 수(SOC까지 이어지는 것)"
label variable nisco_perk       "KSCO 하나에 대응하는 ISCO 수(SOC까지 이어지는 것)"
label variable w_mean_p         "경로 평균 가중치(ksco8 안 합 1)"
label variable w_alloc_p        "경로 배분 가중치(soc2018 안 합 1)"
sort soc2018 soc2010 isco08 ksco8
compress
save "`outf'/soc2018_ksco8_paths.dta", replace
export delimited using "`outf'/soc2018_ksco8_paths.csv", replace
count

* -----------------------------------------------------------------------------
* 6. 고유 (soc2018, ksco8) 쌍(KECO 2025 열 포함)
* -----------------------------------------------------------------------------
* 경로 목록 문자열(확인용)
foreach x in soc2010 isco08 {
    sort soc2018 ksco8 `x'
    by soc2018 ksco8 `x': generate byte f_`x' = _n == 1
    generate str7 s_i = cond(f_`x', `x', "")
    by soc2018 ksco8: generate str244 via_`x' = s_i if _n == 1
    by soc2018 ksco8: replace via_`x' = via_`x'[_n-1] + cond(via_`x'[_n-1] != "" & s_i != "", ";", "") + s_i if _n > 1
    by soc2018 ksco8: replace via_`x' = via_`x'[_N]
    drop s_i f_`x'
}
generate byte n_path = 1
collapse (sum) w_mean = w_mean_p w_alloc = w_alloc_p n_path (max) isco3_link ksco_cross_major, ///
    by(soc2018 soc2018_title ksco8 ksco8_title keco2025 keco2025_title via_soc2010 via_isco08)
isid soc2018 ksco8

bysort soc2018: generate nk_per18 = _N
bysort ksco8:   generate n18_perk = _N
generate double w_flat = 1 / n18_perk

foreach w in w_mean w_flat {
    bysort ksco8: egen double chk = total(`w')
    assert abs(chk - 1) < 1e-9
    drop chk
}
bysort soc2018: egen double chk = total(w_alloc)
assert abs(chk - 1) < 1e-9
drop chk

label variable soc2018          "SOC 2018 세부 직업(XX-XXXX)"
label variable soc2018_title    "SOC 2018 명칭(BLS)"
label variable ksco8            "KSCO 8차 세분류(4자리)"
label variable ksco8_title      "KSCO 8차 명칭"
label variable keco2025         "KECO 2025 세분류(4자리, KSCO와 1:1; 빈칸 = 대응 없음)"
label variable keco2025_title   "KECO 2025 명칭"
label variable w_mean           "평균 가중치: SOC 비율 지표 → KSCO(단계별 단순평균, ksco8 안 합 1)"
label variable w_flat           "평균 가중치: 연결된 SOC 2018 단순평균(ksco8 안 합 1)"
label variable w_alloc          "배분 가중치: SOC 양 → KSCO(단계별 균등 배분, soc2018 안 합 1)"
label variable nk_per18         "SOC 2018 하나에 연결된 KSCO 수"
label variable n18_perk         "KSCO 하나에 연결된 SOC 2018 수"
label variable n_path           "이 쌍을 잇는 경로 수(soc2010 × isco08)"
label variable via_soc2010      "거친 SOC 2010 코드(;로 구분)"
label variable via_isco08       "거친 ISCO-08 코드(;로 구분)"
label variable isco3_link       "1 = ISCO 3자리 소분류 연결을 거침"
label variable ksco_cross_major "1 = 통계청 표의 대분류 벗어난 연계를 거침"
order soc2018 soc2018_title ksco8 ksco8_title keco2025 keco2025_title w_mean w_flat w_alloc nk_per18 n18_perk n_path ///
    via_soc2010 via_isco08 isco3_link ksco_cross_major
sort soc2018 ksco8
compress
save "`outf'/soc2018_ksco8_crosswalk.dta", replace
export delimited using "`outf'/soc2018_ksco8_crosswalk.csv", replace

* -----------------------------------------------------------------------------
* 7. 요약과 범위 확인
* -----------------------------------------------------------------------------
count
preserve
bysort soc2018: keep if _n == 1
display as text "SOC 2018 코드 수"
count
tabulate nk_per18
restore
preserve
bysort ksco8: keep if _n == 1
display as text "KSCO 8차 세분류 수"
count
tabulate n18_perk
display as text "KECO 2025 대응이 없는 KSCO"
list ksco8 ksco8_title if missing(keco2025), noobs abbreviate(20)
restore

* KECO 기준 확인: keco2025 하나 = ksco8 하나이므로 평균 가중치는 keco2025 안에서도 합 1
preserve
drop if missing(keco2025)
bysort keco2025 (ksco8): assert ksco8 == ksco8[1]
bysort keco2025: egen double chk = total(w_mean)
assert abs(chk - 1) < 1e-9
bysort keco2025: keep if _n == 1
display as text "SOC와 이어지는 KECO 2025 세분류 수"
count
restore

* KECO 2025 세분류(통계청 표 495개) 가운데 SOC에 이어지지 않는 코드
preserve
use `kk', clear
merge 1:m keco2025 using "`outf'/soc2018_ksco8_crosswalk.dta", keepusing(keco2025)
bysort keco2025: keep if _n == 1
tabulate _merge
list keco2025 keco2025_title ksco8 if _merge == 1, noobs abbreviate(20)
restore

* SOC 2018 목록(BLS 867개) 가운데 KSCO에 이어지지 않는 코드
preserve
use `s1018', clear
keep soc2018 soc2018_title
duplicates drop
merge 1:m soc2018 using "`outf'/soc2018_ksco8_crosswalk.dta", keepusing(soc2018)
bysort soc2018: keep if _n == 1
tabulate _merge
list soc2018 soc2018_title if _merge == 1, noobs abbreviate(20)
restore

* KSCO 세분류(통계청 표 494개) 가운데 SOC에 이어지지 않는 코드
preserve
import excel using ///
    "`cw'/isco08_ksco08/한국표준직업분류(KSCO 8차)-국제표준직업분류(ISCO-08) 연계표_20260127034430.xlsx", ///
    sheet("4-1. (연계표) 세분류 연계표(KSCO-ISCO)") firstrow clear allstring
rename (한국코드 한국분류) (ksco8 ksco8_title)
keep ksco8 ksco8_title
replace ksco8 = strtrim(ksco8)
duplicates drop ksco8, force
count
merge 1:m ksco8 using "`outf'/soc2018_ksco8_crosswalk.dta", keepusing(ksco8)
bysort ksco8: keep if _n == 1
tabulate _merge
list ksco8 ksco8_title if _merge == 1, noobs abbreviate(20)
restore

* 이 프로젝트의 SOC 2018 지표 파일과의 매칭(있을 때만)
local f1 "$proc/merged/soc6_ai_indicators.dta"
local f2 "$proc/macro/scaling/sensortower_state_of_ai_2026/sensortower_aei_kor_soc6_conversations.dta"
foreach f in f1 f2 {
    capture confirm file "``f''"
    if _rc == 0 {
        preserve
        use soc6 using "``f''", clear
        duplicates drop
        rename soc6 soc2018
        merge 1:m soc2018 using "`outf'/soc2018_ksco8_crosswalk.dta", keepusing(soc2018)
        bysort soc2018: keep if _n == 1
        display as text "``f'': _merge==1 → 연계표에 없는 soc6"
        tabulate _merge
        list soc2018 if _merge == 1, noobs
        restore
    }
}
