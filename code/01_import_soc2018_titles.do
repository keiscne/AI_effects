* =============================================================================
* 01_import_soc2018_titles.do
* BLS SOC 2018 세부 직업(6자리) 공식 명칭 목록
*
* 입력: $raw/exposure/bls_soc_crosswalk/soc_2018/soc_2010_to_2018_crosswalk.xlsx
*   시트 "Sorted by 2010", 9행 머리글, 10~909행 = (2010 코드, 2010 명칭, 2018 코드, 2018 명칭) 900쌍
*   (01_import_felten_aioe.do, 01_import_soc2018_ksco8_crosswalk.do와 같은 원자료)
* 출력: $proc/exposure/bls_soc_crosswalk/soc2018_titles.{csv,dta}   행 = SOC 2018 세부 직업(soc6)
*
* 용도: soc6 단위 파일의 직업 명칭(soc6_title)을 BLS 공식 명칭으로 통일한다.
*   AEI는 O*NET-SOC 8자리 명칭만 주므로, .00 코드가 없는 SOC(예: 15-1299 "Computer Occupations,
*   All Other" → O*NET 15-1299.01~.09)는 8자리 명칭 하나가 6자리 직업 전체 이름처럼 보이는 문제가 있었다.
* 처리: 명칭 끝의 BLS 각주 표시 " (#)", " (##)" 삭제(01_import_felten_aioe.do와 같음).
* 매칭 키: soc6(str7, XX-XXXX)
* =============================================================================

version 17
clear all
set more off

if `"$root"' == "" global root "d:/research/AI_effects"
if `"$raw"'  == "" global raw  "$root/data/raw"
if `"$proc"' == "" global proc "$root/data/proc"

local outf "$proc/exposure/bls_soc_crosswalk"
capture mkdir "$proc/exposure"
capture mkdir "`outf'"

import excel using "$raw/exposure/bls_soc_crosswalk/soc_2018/soc_2010_to_2018_crosswalk.xlsx", ///
    sheet("Sorted by 2010") cellrange(A10:D909) clear allstring
rename (C D) (soc6 soc6_title)
keep soc6 soc6_title
foreach v of varlist _all {
    replace `v' = strtrim(`v')
}
replace soc6_title = strtrim(regexr(soc6_title, "\(#+\)$", ""))
assert !strpos(soc6_title, "#")
assert regexm(soc6, "^[0-9][0-9]-[0-9][0-9][0-9][0-9]$")
duplicates drop
isid soc6                                   // 코드마다 명칭 하나
count
assert r(N) == 867                          // SOC 2018 세부 직업 수

label variable soc6       "SOC 2018 세부 직업 6자리(XX-XXXX)"
label variable soc6_title "SOC 2018 직업 명칭(BLS 공식)"
sort soc6
compress
save "`outf'/soc2018_titles.dta", replace
export delimited using "`outf'/soc2018_titles.csv", replace
