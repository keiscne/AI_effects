* =============================================================================
* 02_clean_sensortower_share_all_products.do
* Sensor Tower "State of AI 2026" True Audience: 전체 제품(8개 합계)의 국가별 점유율
*
* 입력: $raw/macro/scaling/sensortower_state_of_ai_2026/sensortower_true_audience_monthly_long.csv
*       (① 중복 제거 독립 앱+웹 월간 이용자 수, 19개 시장 × 8개 제품 × 2023-04~2026-05)
* 출력: $raw/macro/scaling/sensortower_state_of_ai_2026/ (사용자 지정 위치)
*       sensortower_share_all_products_monthly_long.{csv,dta}
*       sensortower_share_all_products_monthly_wide.csv
*       sensortower_share_worldwide_by_product_monthly_long.{csv,dta}  (2부, ⑯)
*   2부 비교 입력: sensortower_true_audience_share_monthly_long.csv (⑥ 공개 점유율)
*
* 2부(파일 끝): 제품별 Worldwide 점유율을 ①에서 다시 계산하고 ⑥ 공개값과 비교한다.
*
* 정의(1부): 월 t, 시장 c에 대해 8개 제품의 이용자 수를 합한 뒤
*   all_users(c,t)         = Σ_p users(c,p,t)
*   share_all_products_pct = 100 × all_users(c,t) / all_users(Worldwide,t)
*   Worldwide는 25개 시장 합계이고 국가 시트는 18개뿐이므로, 나머지 7개 시장(이름 미공개)은
*   residual = Worldwide − 18개국 합계 로 한 행을 만든다. 18개국 + residual의 합은 100%.
*   share_within_18_pct = 100 × all_users(c,t) / 18개국 합계 (residual 행은 결측)
* 제품별 버전은 02_clean_sensortower_share_within_product.do.
* 매칭 키: market × month(YYYY-MM). 제품은 합산되어 사라진다.
* 주의: ①은 제품 안에서만 앱·웹 중복을 제거한 값이다. 여러 어시스턴트를 쓰는 사람은 제품마다
*   한 번씩 세므로 all_users는 "사람 수"가 아니라 "제품별 이용자 수의 합"이다. 따라서 점유율은
*   이용 제품 수가 많은 나라에서 사람 기준 점유율보다 크게 나온다. 출시 전 제품(이용자 0)은
*   합계에 0으로 들어가므로 제품 구성이 월마다 달라진다(2023년은 사실상 ChatGPT 중심).
* =============================================================================

version 17
clear all
set more off

if `"$root"' == "" global root "d:/research/AI_effects"
if `"$raw"'  == "" global raw  "$root/data/raw"
if `"$proc"' == "" global proc "$root/data/proc"

local src "$raw/macro/scaling/sensortower_state_of_ai_2026"
local out "`src'"

import delimited using "`src'/sensortower_true_audience_monthly_long.csv", ///
    varnames(1) encoding("utf-8") stringcols(1 2 3) clear
confirm numeric variable unique_users
assert !missing(unique_users)
isid market assistant month

* 제품 8개가 모든 시장·월에 있는지 확인
quietly levelsof assistant
assert r(r) == 8
bysort market month: assert _N == 8

* 시장 × 월로 8개 제품 합산
collapse (sum) all_users = unique_users, by(market month)

* Worldwide 값을 분모로 붙인다
preserve
    keep if market == "Worldwide"
    rename all_users worldwide_users
    keep month worldwide_users
    tempfile ww
    save `ww'
restore
drop if market == "Worldwide"
quietly levelsof market
assert r(r) == 18
merge m:1 month using `ww', assert(match) nogenerate

* 18개국 합계와 나머지 7개 시장(residual) 행
bysort month: egen double sum18_users = total(all_users)
preserve
    bysort month: keep if _n == 1
    replace market    = "Other 7 markets (residual)"
    replace all_users = worldwide_users - sum18_users
    tempfile resid
    save `resid'
restore
generate byte residual = 0
append using `resid'
replace residual = 1 if missing(residual)

generate double share_all_products_pct = 100 * all_users / worldwide_users if worldwide_users > 0
generate double share_within_18_pct    = 100 * all_users / sum18_users     if sum18_users > 0 & residual == 0

* 검증: 18개국 + residual = 100%
bysort month: egen double chk = total(share_all_products_pct)
assert abs(chk - 100) < 1e-6
drop chk
assert all_users >= 0

label variable market                 "시장(18개국 + 나머지 7개 시장 residual)"
label variable month                  "월(YYYY-MM)"
label variable all_users              "8개 제품 True Audience 이용자 수 합계(residual 행은 Worldwide − 18개국)"
label variable worldwide_users        "Worldwide(25개 시장) 8개 제품 이용자 수 합계"
label variable sum18_users            "18개국 8개 제품 이용자 수 합계"
label variable residual               "1 = 나머지 7개 시장 residual 행"
label variable share_all_products_pct "전체 제품 기준 시장 점유율(%), 분모 Worldwide"
label variable share_within_18_pct    "전체 제품 기준 시장 점유율(%), 분모 18개국 합계"

order month market residual all_users worldwide_users sum18_users share_all_products_pct share_within_18_pct
sort month residual market
compress
format all_users worldwide_users sum18_users %15.0f
format share_all_products_pct share_within_18_pct %9.4f
save "`out'/sensortower_share_all_products_monthly_long.dta", replace
export delimited using "`out'/sensortower_share_all_products_monthly_long.csv", replace datafmt

* 넓은 형식: 행 = 시장, 열 = 월, 값 = share_all_products_pct
keep market residual month share_all_products_pct
replace month = "m" + subinstr(month, "-", "_", .)
reshape wide share_all_products_pct, i(market residual) j(month) string
rename share_all_products_pct* *
sort residual market
drop residual
export delimited using "`out'/sensortower_share_all_products_monthly_wide.csv", replace datafmt


* =============================================================================
* 2부: 제품별 Worldwide 점유율(⑯)
*   Worldwide 시장 안에서 제품 p가 차지하는 비중
*   ww_total_users(t) = Σ_p users(Worldwide,p,t)   (Other 포함 8개 항목)
*   share_ww_pct(p,t) = 100 × users(Worldwide,p,t) / ww_total_users(t)
*   Sensor Tower가 공개한 ⑥(sensortower_true_audience_share_monthly_long.csv)의 Worldwide 행과
*   정의가 같으므로 ⑥ 값(share_pct_st)을 붙여 비교한다. diff_pp = share_ww_pct − share_pct_st.
*   차이는 ①의 이용자 수가 유효숫자 약 3자리로, ⑥이 소수 첫째 자리로 반올림된 데서 생긴다.
* 출력: `out'/sensortower_share_worldwide_by_product_monthly_long.{csv,dta}
* 매칭 키: assistant(①·⑥의 표기 그대로) × month(YYYY-MM).
* =============================================================================

* ⑥ Worldwide 행(비교 대상)
import delimited using "`src'/sensortower_true_audience_share_monthly_long.csv", ///
    varnames(1) encoding("utf-8") stringcols(1 2 3) clear
confirm numeric variable share_pct
keep if market == "Worldwide"
isid assistant month
rename share_pct share_pct_st
keep assistant month share_pct_st
tempfile st6
save `st6'

import delimited using "`src'/sensortower_true_audience_monthly_long.csv", ///
    varnames(1) encoding("utf-8") stringcols(1 2 3) clear
keep if market == "Worldwide"
isid assistant month
bysort month: assert _N == 8

bysort month: egen double ww_total_users = total(unique_users)
generate double share_ww_pct = 100 * unique_users / ww_total_users if ww_total_users > 0
assert !missing(share_ww_pct)
bysort month: egen double chk = total(share_ww_pct)
assert abs(chk - 100) < 1e-6
drop chk

merge 1:1 assistant month using `st6', assert(match) nogenerate
generate double diff_pp = share_ww_pct - share_pct_st

* ⑥의 월별 합계(반올림 때문에 100이 아님)
bysort month: egen double sum_st_pct = total(share_pct_st)

* 비교 결과 출력
display as text _n "== ⑯ 다시 계산한 Worldwide 점유율 vs ⑥ 공개값 =="
generate double absdiff_pp = abs(diff_pp)
summarize diff_pp absdiff_pp, detail
summarize sum_st_pct
tabstat diff_pp absdiff_pp, by(assistant) statistics(mean min max) format(%9.3f) nototal
correlate share_ww_pct share_pct_st
count if absdiff_pp > 0.05 + 1e-9
display as text "|차이| > 0.05%p(⑥ 반올림 폭 초과) 행 수: " r(N) " / " _N
gsort -absdiff_pp
list month assistant unique_users share_ww_pct share_pct_st diff_pp in 1/10, noobs sep(0)
drop absdiff_pp

label variable market         "시장(Worldwide = 25개 시장)"
label variable assistant      "제품(①의 표기 그대로, Other 포함 8개)"
label variable month          "월(YYYY-MM)"
label variable unique_users   "Worldwide True Audience 이용자 수(①)"
label variable ww_total_users "Worldwide 8개 제품 이용자 수 합계"
label variable share_ww_pct   "제품별 Worldwide 점유율(%), ①에서 다시 계산"
label variable share_pct_st   "제품별 Worldwide 점유율(%), Sensor Tower 공개값(⑥)"
label variable diff_pp        "share_ww_pct − share_pct_st (%p)"
label variable sum_st_pct     "⑥ Worldwide 월별 점유율 합계(%)"

order month market assistant unique_users ww_total_users share_ww_pct share_pct_st diff_pp sum_st_pct
sort month assistant
compress
format unique_users ww_total_users %15.0f
format share_ww_pct diff_pp %9.4f
format share_pct_st sum_st_pct %9.1f
save "`out'/sensortower_share_worldwide_by_product_monthly_long.dta", replace
export delimited using "`out'/sensortower_share_worldwide_by_product_monthly_long.csv", replace datafmt
