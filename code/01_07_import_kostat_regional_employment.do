* =============================================================================
* 01_07_import_kostat_regional_employment.do
* 지역별고용조사 상반기(B형, 전국, 소분류) 마이크로데이터 → 연도 × KSCO 8차 소분류별 취업자 수와 근로시간
* (report 25: 직업별 AI 활용도의 분모. 기준 시점 = 2022년 상반기, 나머지 연도는 비교용)
*
* 입력: $raw/macro/kostat_lfs_regional/data/YYYY_상반기(B형_전국_소분류)_*.csv  (2022~2025, CP949)
*   개인 단위. 조사연월 = 각 해 4월(202204 등). 파일설계서: 같은 폴더의 '파일설계서' 하위 폴더(코드집 포함 xlsx)
*   사용 변수(파일설계서 항목번호):
*     12 조사대상주간_일시휴직여부(1 = 일시휴직; 이들은 근로시간이 비어 있어 0시간으로 둠),
*     15 조사대상주간_주업근무시간수, 16 _부업근무시간수, 17 _근무총계시간수 (조사대상주간 실제 시간)
*     21 3자리_8차직업소분류코드(KSCO 8차, 2022년 자료도 8차로 제공), 22 종사상지위코드(1 상용 2 임시 3 일용
*     4 고용원 있는 자영업자 5 고용원 없는 자영업자 6 무급가족종사자), 42 시도전국가중값, 43 경제활동인구상태코드(1 취업자)
* 출력: $proc/macro/kostat_lfs_regional/
*   kostat_lfs_regional_ksco3.{dta,csv}   year × ksco3 (취업자가 있는 소분류만)
*
* 정의(가중치 w = 시도전국가중값, 취업자만):
*   emp           = Σ w                         취업자 수(명)
*   hrs_main_wk   = Σ w × 주업시간 / emp          주당 평균 주업 근로시간(일시휴직자 0시간 포함)
*   hrs_tot_wk    = Σ w × 총계시간 / emp          주당 평균 총 근로시간(부업 포함)
*   hrs_main_mo   = Σ w × 주업시간 × 4.345        월 총 주업 근로시간(시간) ← 활용도 2의 기본 분모
*   *_wage / *_nonwage: 임금근로자(종사상지위 1~3) / 비임금근로자(4~6)로 나눈 값(강건성 보정용)
*   n_obs         = 표본 수(가중치 없음). 작은 소분류의 표본오차 판단용.
* 판단(작업자):
*   - 분모 근로시간은 주업 시간으로 한다. 부업 시간은 부업의 직업을 알 수 없어 직업별 노동투입에서 뺀다
*     (hrs_tot_*는 비교용으로 남김).
*   - 일시휴직자(취업자, 근로시간 0)는 취업자 수와 시간 평균에 모두 포함한다(총노동투입 개념).
*   - 4월 한 주의 시간이므로 월 환산은 × 4.345(= 52.14주 / 12)로 한다.
* 매칭 키: ksco3(str3) = 3자리_8차직업소분류코드 = data/proc/merged/kor_ksco3_conv_ai_indicators의 ksco3.
* =============================================================================

version 17
clear all
set more off

if `"$root"' == "" global root "d:/research/AI_effects"
if `"$raw"'  == "" global raw  "$root/data/raw"
if `"$proc"' == "" global proc "$root/data/proc"

local ind  "$raw/macro/kostat_lfs_regional/data"
local outd "$proc/macro/kostat_lfs_regional"
capture mkdir "`outd'"

local wk2mo = 52.143 / 12      // 주 → 월 환산(4.345)

local first = 1
foreach y in 2022 2023 2024 2025 {
    local f : dir "`ind'" files "`y'_상반기(B형_전국_소분류)_*.csv"
    local nf : word count `f'
    assert `nf' == 1
    local f `f'
    import delimited using "`ind'/`f'", varnames(1) encoding("cp949") stringcols(_all) clear
    * 열 위치(파일설계서 항목번호)로 영문 이름을 붙인다. 숫자로 시작하는 한글 열 이름은 Stata가 v##로
    * 바꾸므로 위치를 쓰고, 첫 행의 원래 이름(변수 라벨 또는 변수 이름)으로 맞는 열인지 확인한다.
    unab allv : _all
    assert `: word count `allv'' == 45
    local pos  "1 12 15 16 17 21 22 42 43"
    local new  "yyyymm absent h_main h_side h_tot ksco3 status w ecst"
    local chk  "조사연월 일시휴직여부 주업근무시간수 부업근무시간수 근무총계시간수 8차직업소분류코드 종사상지위코드 시도전국가중값 경제활동인구상태코드"
    forvalues i = 1/9 {
        local v : word `: word `i' of `pos'' of `allv'
        local lab : variable label `v'
        assert strpos(`"`v' `lab'"', "`: word `i' of `chk''") > 0
        rename `v' `: word `i' of `new''
    }
    keep `new'
    destring absent h_main h_side h_tot status w ecst, replace
    assert yyyymm == "`y'04"
    assert inlist(ecst, 1, 2, 3)
    keep if ecst == 1
    * 취업자는 직업 코드와 종사상지위가 모두 있어야 함
    replace ksco3 = strtrim(ksco3)
    assert strlen(ksco3) == 3
    assert inrange(status, 1, 6)
    * 근로시간 결측은 일시휴직자(일시휴직여부 = 1)뿐 → 0시간으로 둔다
    assert absent == 1 if missing(h_main) | missing(h_tot)
    assert missing(h_main) & missing(h_tot) if absent == 1
    count if absent == 1
    replace h_main = 0 if absent == 1
    replace h_tot  = 0 if absent == 1
    assert !missing(h_main, h_tot, w)
    assert h_tot == h_main + cond(missing(h_side), 0, h_side)
    generate int year = `y'
    generate byte wage = status <= 3
    if !`first' append using `all'
    tempfile all
    save `all'
    local first = 0
}

use `all', clear
generate double wh_main = w * h_main
generate double wh_tot  = w * h_tot
generate double w_wage  = w * wage
generate double w_nonw  = w * !wage
generate double wh_main_wage = wh_main * wage
generate double wh_main_nonw = wh_main * !wage
generate byte one = 1
collapse (sum) emp = w emp_wage = w_wage emp_nonwage = w_nonw sh_main = wh_main sh_tot = wh_tot ///
    sh_main_wage = wh_main_wage sh_main_nonwage = wh_main_nonw n_obs = one, by(year ksco3)

generate double hrs_main_wk = sh_main / emp
generate double hrs_tot_wk  = sh_tot / emp
generate double hrs_main_wk_wage    = sh_main_wage / emp_wage if emp_wage > 0
generate double hrs_main_wk_nonwage = sh_main_nonwage / emp_nonwage if emp_nonwage > 0
generate double hrs_main_mo = sh_main * `wk2mo'
generate double hrs_tot_mo  = sh_tot * `wk2mo'
generate double hrs_main_mo_wage    = sh_main_wage * `wk2mo'
generate double hrs_main_mo_nonwage = sh_main_nonwage * `wk2mo'
drop sh_*

label variable year        "조사 연도(상반기, 4월 조사)"
label variable ksco3       "KSCO 8차 소분류(3자리)"
label variable emp         "취업자 수(명, 시도전국가중값 합)"
label variable emp_wage    "임금근로자 수(종사상지위 1~3)"
label variable emp_nonwage "비임금근로자 수(종사상지위 4~6)"
label variable n_obs       "표본 수(가중치 없음)"
label variable hrs_main_wk "주당 평균 주업 근로시간(조사대상주간, 일시휴직 0 포함)"
label variable hrs_tot_wk  "주당 평균 총 근로시간(주업+부업)"
label variable hrs_main_wk_wage    "임금근로자 주당 평균 주업 근로시간"
label variable hrs_main_wk_nonwage "비임금근로자 주당 평균 주업 근로시간"
label variable hrs_main_mo "월 총 주업 근로시간(시간; Σ w × 주업시간 × 4.345)"
label variable hrs_tot_mo  "월 총 근로시간(주업+부업, 시간)"
label variable hrs_main_mo_wage    "임금근로자 월 총 주업 근로시간"
label variable hrs_main_mo_nonwage "비임금근로자 월 총 주업 근로시간"

order year ksco3 n_obs emp emp_wage emp_nonwage hrs_main_wk hrs_tot_wk hrs_main_wk_wage hrs_main_wk_nonwage ///
    hrs_main_mo hrs_tot_mo hrs_main_mo_wage hrs_main_mo_nonwage
sort year ksco3
isid year ksco3
compress
save "`outd'/kostat_lfs_regional_ksco3.dta", replace
export delimited using "`outd'/kostat_lfs_regional_ksco3.csv", replace

* 확인용 요약
preserve
collapse (sum) emp hrs_main_mo n_obs (count) n_ksco3 = emp, by(year)
generate double avg_wk = hrs_main_mo / emp / `wk2mo'
format emp %14.0fc
list, noobs clean
restore
tabulate year if n_obs < 30
