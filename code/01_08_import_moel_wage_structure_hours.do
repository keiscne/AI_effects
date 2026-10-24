* =============================================================================
* 01_08_import_moel_wage_structure_hours.do
* 고용형태별근로실태조사(2025년부터 고용형태별노동실태조사) 총괄 마이크로데이터
*   → 연도 × 직업 대분류별 임금근로자 월 실근로시간(사업체 기준)
* (report 25: 활용도 2 분모 근로시간의 강건성 검토. 가구조사(지역별고용조사) 시간을 사업체 기준으로 보정)
*
* 입력: $raw/macro/moel_wage_structure/data/YYYY_총괄_*.csv  (2022~2025, CP949)
*   근로자 단위(임금근로자만, 조사 기준 6월). 사용 변수(파일설계서 항목번호):
*     11 직업대분류코드(1~9; 공공용 자료는 대분류만), 14 소정실근로시간수, 15 초과실근로시간수,
*     16 휴일실근로시간수, 29 가중값
* 출력: $proc/macro/moel_wage_structure/moel_wage_structure_hours_ksco1.{dta,csv}   year × ksco1
*
* 정의(가중치 w = 가중값):
*   hrs_mo_est     = Σ w × (소정 + 초과) / Σ w       임금근로자 1인당 월 실근로시간(기본)
*   hrs_mo_est_hol = Σ w × (소정 + 초과 + 휴일) / Σ w  휴일 실근로시간을 따로 더한 값(비교용)
*   emp_est        = Σ w
* 대상: 특수형태근로종사자(고용형태코드 1)는 뺀다. 2023년 자료부터 이들의 직업과 근로시간이 비어 있어
*   ('.'), 연도 간 같은 범위를 쓰기 위해 2022년에서도 뺀다. 2025년에는 특수형태가 아닌데 직업이 빈 근로자
*   (45,412명 표본, 주로 일일·단시간)가 있어 이들도 뺀다(2022~2024년에는 없음).
* 판단(작업자): 고용노동부 공표 기준 총실근로시간 = 소정실근로 + 초과실근로로 보고 이를 기본으로 한다.
*   휴일 실근로시간이 초과에 포함되는지는 파일설계서에 적혀 있지 않아 더한 값을 비교용으로 남긴다.
*   2022년 자료의 직업 대분류가 KSCO 7차인지 8차인지 코드집에 적혀 있지 않다(대분류 명칭은 두 판이 같음).
* 매칭 키: ksco1(str1) = 직업대분류코드 = KSCO 8차 소분류 코드의 첫 자리.
* =============================================================================

version 17
clear all
set more off

if `"$root"' == "" global root "d:/research/AI_effects"
if `"$raw"'  == "" global raw  "$root/data/raw"
if `"$proc"' == "" global proc "$root/data/proc"

local ind  "$raw/macro/moel_wage_structure/data"
local outd "$proc/macro/moel_wage_structure"
capture mkdir "`outd'"

local first = 1
foreach y in 2022 2023 2024 2025 {
    local f : dir "`ind'" files "`y'_총괄_*.csv"
    local nf : word count `f'
    assert `nf' == 1
    local f `f'
    import delimited using "`ind'/`f'", varnames(1) encoding("cp949") stringcols(_all) clear
    unab allv : _all
    assert `: word count `allv'' == 29
    local pos  "3 11 14 15 16 29"
    local new  "emptype ksco1 h_reg h_ot h_hol w"
    local chk  "고용형태코드 직업대분류코드 소정실근로시간수 초과실근로시간수 휴일실근로시간수 가중값"
    forvalues i = 1/6 {
        local v : word `: word `i' of `pos'' of `allv'
        local lab : variable label `v'
        assert strpos(`"`v' `lab'"', "`: word `i' of `chk''") > 0
        rename `v' `: word `i' of `new''
    }
    keep `new'
    destring emptype h_reg h_ot h_hol w, replace force
    * 특수형태(고용형태 1)는 2023년부터 직업과 근로시간이 비어 있다 → 모든 해에서 뺀다(연도 간 일관성)
    count if emptype == 1
    drop if emptype == 1
    replace ksco1 = strtrim(ksco1)
    * 2025년은 특수형태 외에도 직업이 빈 근로자가 있다(주로 일일·단시간) → 직업을 알 수 없어 뺀다
    count if ksco1 == ""
    if `y' < 2025 assert r(N) == 0
    drop if ksco1 == ""
    assert inlist(ksco1, "1", "2", "3", "4", "5", "6", "7", "8", "9")
    assert !missing(h_reg, h_ot, h_hol, w)
    generate int year = `y'
    if !`first' append using `all'
    tempfile all
    save `all'
    local first = 0
}

use `all', clear
* 휴일 실근로시간이 초과 실근로시간보다 큰 비중(초과에 포함되는지 판단 참고)
generate byte hol_gt_ot = h_hol > h_ot
tabulate year hol_gt_ot, row nofreq
generate double wh     = w * (h_reg + h_ot)
generate double wh_hol = w * (h_reg + h_ot + h_hol)
generate byte one = 1
collapse (sum) emp_est = w wh wh_hol n_obs_est = one, by(year ksco1)
generate double hrs_mo_est     = wh / emp_est
generate double hrs_mo_est_hol = wh_hol / emp_est
drop wh wh_hol

label variable year           "조사 연도(6월 기준)"
label variable ksco1          "직업 대분류(1~9)"
label variable emp_est        "임금근로자 수(가중값 합)"
label variable n_obs_est      "표본 수"
label variable hrs_mo_est     "임금근로자 1인당 월 실근로시간(소정+초과, 사업체 기준)"
label variable hrs_mo_est_hol "임금근로자 1인당 월 실근로시간(소정+초과+휴일)"
order year ksco1 n_obs_est emp_est hrs_mo_est hrs_mo_est_hol
sort year ksco1
isid year ksco1
compress
save "`outd'/moel_wage_structure_hours_ksco1.dta", replace
export delimited using "`outd'/moel_wage_structure_hours_ksco1.csv", replace
list if year == 2022, noobs clean
