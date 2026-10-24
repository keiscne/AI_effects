* =============================================================================
* 02_clean_sensortower_share_within_product.do
* Sensor Tower "State of AI 2026" True Audience: 제품 내 국가별 점유율
*
* 입력: $raw/macro/scaling/sensortower_state_of_ai_2026/sensortower_true_audience_monthly_long.csv
*       (① 중복 제거 독립 앱+웹 월간 이용자 수, 19개 시장 × 8개 제품 × 2023-04~2026-05)
* 출력: $proc/macro/scaling/sensortower_state_of_ai_2026/
*       sensortower_share_within_product_monthly_long.{csv,dta}
*       sensortower_share_within_product_monthly_wide.csv
*
* 정의: 제품 p, 월 t, 시장 c에 대해
*   share_within_product_pct = 100 × users(c,p,t) / users(Worldwide,p,t)
*   Worldwide는 25개 시장 합계이고 국가 시트는 18개뿐이므로, 나머지 7개 시장(이름 미공개)은
*   residual = Worldwide − 18개국 합계 로 한 행을 만든다. 18개국 + residual의 합은 100%.
*   share_within_18_pct = 100 × users(c,p,t) / 18개국 합계 (residual 행은 결측)
* 제품별 점유율(%) 파일(⑥)은 국가 합계(분모)를 알 수 없어 이 계산에 쓸 수 없다.
* ⑥은 ①을 국가 내 합계로 나눈 값이므로 ①의 수준 값에서 직접 계산한다.
* 매칭 키: assistant(제품 이름, ①의 표기 그대로) × month(YYYY-MM).
* 주의: ①의 이용자 수는 유효숫자 약 3자리로 반올림되어 있어, 이용자가 거의 없는 제품·월에는
*   residual이 조금 음수가 될 수 있다(그대로 둔다). Worldwide 이용자가 0이면 점유율은 결측.
* =============================================================================

version 17
clear all
set more off

if `"$root"' == "" global root "d:/research/AI_effects"
if `"$raw"'  == "" global raw  "$root/data/raw"
if `"$proc"' == "" global proc "$root/data/proc"

local src "$raw/macro/scaling/sensortower_state_of_ai_2026"
local out "$proc/macro/scaling/sensortower_state_of_ai_2026"
capture mkdir "`out'"

import delimited using "`src'/sensortower_true_audience_monthly_long.csv", ///
    varnames(1) encoding("utf-8") stringcols(1 2 3) clear
confirm numeric variable unique_users
assert !missing(unique_users)
isid market assistant month

* Worldwide 값을 분모로 붙인다
preserve
    keep if market == "Worldwide"
    rename unique_users worldwide_users
    keep assistant month worldwide_users
    tempfile ww
    save `ww'
restore
drop if market == "Worldwide"
quietly levelsof market
assert r(r) == 18
merge m:1 assistant month using `ww', assert(match) nogenerate

* 18개국 합계와 나머지 7개 시장(residual) 행
bysort assistant month: egen double sum18_users = total(unique_users)
preserve
    bysort assistant month: keep if _n == 1
    replace market       = "Other 7 markets (residual)"
    replace unique_users = worldwide_users - sum18_users
    tempfile resid
    save `resid'
restore
generate byte residual = 0
append using `resid'
replace residual = 1 if missing(residual)

generate double share_within_product_pct = 100 * unique_users / worldwide_users if worldwide_users > 0
generate double share_within_18_pct      = 100 * unique_users / sum18_users     if sum18_users > 0 & residual == 0

* 검증: 18개국 + residual = 100%
bysort assistant month: egen double chk = total(share_within_product_pct)
assert abs(chk - 100) < 1e-6 if worldwide_users > 0
drop chk

label variable market                   "시장(18개국 + 나머지 7개 시장 residual)"
label variable assistant                "제품(①의 표기 그대로)"
label variable month                    "월(YYYY-MM)"
label variable unique_users             "True Audience 월간 이용자 수(residual 행은 Worldwide − 18개국 합계)"
label variable worldwide_users          "Worldwide(25개 시장) 이용자 수"
label variable sum18_users              "18개국 이용자 수 합계"
label variable residual                 "1 = 나머지 7개 시장 residual 행"
label variable share_within_product_pct "제품 내 시장 점유율(%), 분모 Worldwide"
label variable share_within_18_pct      "제품 내 시장 점유율(%), 분모 18개국 합계"

order assistant month market residual unique_users worldwide_users sum18_users share_within_product_pct share_within_18_pct
sort assistant month residual market
compress
format unique_users worldwide_users sum18_users %15.0f
format share_within_product_pct share_within_18_pct %9.4f
save "`src'/sensortower_share_within_product_monthly_long.dta", replace
export delimited using "`src'/sensortower_share_within_product_monthly_long.csv", replace datafmt

* 넓은 형식: 행 = 제품 × 시장, 열 = 월, 값 = share_within_product_pct
keep assistant market residual month share_within_product_pct
replace month = "m" + subinstr(month, "-", "_", .)
reshape wide share_within_product_pct, i(assistant market residual) j(month) string
rename share_within_product_pct* *
sort assistant residual market
drop residual
export delimited using "`src'/sensortower_share_within_product_monthly_wide.csv", replace datafmt
