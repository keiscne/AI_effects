* =============================================================================
* 03_merge_sensortower_openai_messages.do
* Sensor Tower True Audience 이용자 수 × ChatGPT 1인당 메시지 수(Chatterji et al. 2025)
*   → 제품별·국가별·Worldwide 월간 메시지 수, 국가별·Worldwide 월간 업무용 메시지 수와 대화량
*
* 입력:
*   $raw/macro/scaling/scaling_parameters_public.csv
*       chatterji_msgs_week_2025_07 (2025-07 ChatGPT 주 메시지 180억 건, Chatterji et al. 2025 p.1)
*   $raw/macro/scaling/sensortower_state_of_ai_2026/  (02_clean_sensortower_share_all_products.do 출력)
*       sensortower_share_worldwide_by_product_monthly_long.dta  (⑯ 제품별 18개국 합계 이용자 수)
*       sensortower_share_all_products_monthly_long.dta          (⑮ 국가별 8개 제품 합계 이용자 수)
*   $raw/usage/anthropic_economic_index/release_2025_09_15/data/intermediate/
*       aei_raw_claude_ai_2025-08-04_to_2025-08-11.csv
*       AEI Claude.ai 2025-08-04~08-11(1주) 국가별 대화 비중(usage_pct) → 18개국 비중(61.01%)
*   $raw/usage/openai_signals/signals_v2.0/public_release_csv/
*       share_of_messages_by_work_related_country_month.csv  (국가별 ChatGPT 업무용 메시지 비중)
*       share_of_messages_by_work_related_month.csv          (전 세계 ChatGPT 업무용 메시지 비중)
* 출력: $proc/macro/scaling/sensortower_state_of_ai_2026/
*   1. sensortower_messages_by_product_monthly.{csv,dta}        제품별 월간 메시지 수(18개국 합계)
*   2. sensortower_messages_by_country_monthly.{csv,dta}        국가별 월간 메시지 수
*   3. sensortower_messages_worldwide_monthly.{csv,dta}         Worldwide 월간 메시지 수
*   4. sensortower_work_messages_by_country_monthly.{csv,dta}   국가별 월간 업무용 메시지 수 + 대화량
*   5. sensortower_work_messages_worldwide_monthly.{csv,dta}    Worldwide 월간 업무용 메시지 수 + 대화량
*
* 가정:
*   (A1) 모든 제품의 이용자 1인당 월 메시지 수는 같다. 또한 시점에 따라 변하지 않는다
*        (2025-07 ChatGPT 값 하나를 2023-04~2026-05 전체에 쓴다).
*   (A3) 전 세계 메시지 중 18개국 비중은 모든 제품·시기에서 같고, AEI Claude.ai 2025-08-04~08-11의
*        18개국 대화 비중(61.01%)과 같다.
*   (A2) 모든 제품의 업무용 메시지 비중은 같고, 국가별로 ChatGPT의 비중(OpenAI Signals)과 같다.
*
* 계산:
*   (1) ChatGPT 2025-07 월 메시지 M = 주 180억 × 31/7 (report 15와 같은 환산: 주간 × 그 달 일수 ÷ 7)
*       M18 = M × s18,  s18 = AEI 2025-08 18개국 usage_pct 합계 / 100 = 0.6101   (A3)
*       msgs_per_user = M18 / users(18개국, ChatGPT, 2025-07)   (⑯ unique_users)
*   (2) 제품별 messages(p,t)    = msgs_per_user × users(18개국,p,t)             (⑯)
*       국가별 messages(c,t)    = msgs_per_user × all_users(c,t)               (⑮, residual 행 포함)
*       Worldwide messages(t)  = msgs_per_user × Σ_p users(Worldwide,p,t)     (= ⑮ worldwide_users)
*   (3) 국가별 work_messages(c,t) = messages(c,t) × work_share(c,t)
*       work_share(c,t): Signals 국가별 work_related == 1 비중. 나머지 7개 시장(residual) 행은
*       국가를 알 수 없으므로 Signals 전 세계 비중을 쓴다.
*       Worldwide work_messages(t) = Σ_c work_messages(c,t)  (18개국 + residual)
*       비교용 work_messages_global(t) = Worldwide messages(t) × 전 세계 비중
*   (4) 대화량 conv_kK = work_messages / K,  K ∈ {1.5, 3, 5, 7, 10} (대화당 메시지 수)
*
* 매칭 키:
*   ⑯ ↔ 기준값: assistant == "ChatGPT", market == "18 countries", month == "2025-07"
*   AEI 18개국: Sensor Tower 18개국 ↔ ISO 3166-1 alpha-2(아래 inlist), geography == "country",
*       facet == "country", variable == "usage_pct"(release_2025_09_15, 2025-08-04~08-11)
*   ⑮ ↔ Signals: Sensor Tower 시장명 → ISO 3166-1 alpha-2(아래 표) × month(YYYY-MM;
*       Signals의 "YYYY-MM-01"을 앞 7자리로 자름)
*   업무용 파일(4·5)은 Signals가 있는 2024-07~2026-05(23개월)만 남는다.
*
* 주의:
*   - 180억 건은 ChatGPT 전체(전 세계) 값이고 ⑯ 이용자 수는 18개국 합계라, 18개국 비중 s18로 할인한다.
*     s18은 Claude.ai(AEI)의 국가 분포라 ChatGPT의 국가 분포와 다를 수 있다(report 18: AEI는
*     Sensor Tower보다 고소득국 비중이 크다). 기준값(2025-07)과 비중(2025-08 첫 주)의 시점 차이는 약 1개월.
*     AEI 2025-08 usage_pct의 분모는 공개된 173개국 대화 합계라(합 100%) 미공개 소국은 빠진다.
*   - (2-2)·(2-3)의 국가별·Worldwide 메시지는 할인된 msgs_per_user를 residual(나머지 7개 시장)과
*     25개 시장 Worldwide 이용자 수에도 그대로 곱한다.
*   - ⑮의 all_users는 제품별 이용자 수의 합(여러 어시스턴트 이용자 중복 계산)이므로, A1 아래에서
*     국가 메시지 = 그 국가 모든 제품 메시지의 합이 된다(사람 수 × 1인당 메시지가 아님).
*   - Signals 비중은 소비자 요금제(Free/Plus/Pro 등) ChatGPT 메시지 기준이다.
*   - 대화당 메시지 수 K는 공개 자료가 없어 격자로 둔다(report 15 4.4절).
* =============================================================================

version 17
clear all
set more off

if `"$root"' == "" global root "d:/research/AI_effects"
if `"$raw"'  == "" global raw  "$root/data/raw"
if `"$proc"' == "" global proc "$root/data/proc"

local st  "$raw/macro/scaling/sensortower_state_of_ai_2026"
local sig "$raw/usage/openai_signals/signals_v2.0/public_release_csv"
local aei "$raw/usage/anthropic_economic_index"
local out "$proc/macro/scaling/sensortower_state_of_ai_2026"
capture mkdir "`out'"

* -----------------------------------------------------------------------------
* (1) 이용자 1인당 월 메시지 수
* -----------------------------------------------------------------------------
import delimited using "$raw/macro/scaling/scaling_parameters_public.csv", ///
    varnames(1) encoding("utf-8") bindquote(strict) stringcols(_all) clear
destring value, replace
isid param_id
keep if param_id == "chatterji_msgs_week_2025_07"
assert _N == 1 & unit == "million messages" & period == "2025-07"
local msgs_week = value[1] * 1e6
local msgs_month = `msgs_week' * 31 / 7                   // 2025-07 = 31일

* 전 세계 메시지 중 18개국 비중: AEI Claude.ai 2025-08-04~08-11 국가별 대화 비중(usage_pct) 18개국 합계
import delimited using "`aei'/release_2025_09_15/data/intermediate/aei_raw_claude_ai_2025-08-04_to_2025-08-11.csv", ///
    varnames(1) encoding("utf-8") bindquote(strict) stringcols(1/9) asdouble clear
keep if geography == "country" & facet == "country" & variable == "usage_pct"
isid geo_id
quietly summarize value
assert abs(r(sum) - 100) < 1e-6                           // 분모 = 공개된 173개국 대화 합계
keep if inlist(geo_id, "AR", "AU", "BR", "CA", "FR", "DE", "IN", "ID", "IT") | ///
        inlist(geo_id, "JP", "MX", "KR", "ES", "TW", "TR", "GB", "US", "VN")
assert _N == 18
assert !missing(value)
quietly summarize value
local share18 = r(sum) / 100
assert abs(`share18' - 0.610) < 0.0005                    // 61.01%
local msgs_month18 = `msgs_month' * `share18'

use "`st'/sensortower_share_worldwide_by_product_monthly_long.dta", clear
assert market == "18 countries"
keep if assistant == "ChatGPT" & month == "2025-07"
assert _N == 1
local users_cg = unique_users[1]
local mpu = `msgs_month18' / `users_cg'
display as text "ChatGPT 2025-07 월 메시지(전 세계) = " %15.0fc `msgs_month' ///
    ", 18개국 비중(AEI 2025-08) = " %6.4f `share18' ///
    ", 18개국 메시지 = " %15.0fc `msgs_month18' _n ///
    "  18개국 이용자 = " %15.0fc `users_cg' ", 1인당 월 메시지 = " %9.3f `mpu'

* -----------------------------------------------------------------------------
* (2-1) 제품별 월간 메시지 수(Worldwide)
* -----------------------------------------------------------------------------
use "`st'/sensortower_share_worldwide_by_product_monthly_long.dta", clear
keep month market assistant unique_users ww_total_users share_ww_pct
generate double msgs_per_user = `mpu'
generate double messages = msgs_per_user * unique_users
assert abs(messages - `msgs_month18') < 1 if assistant == "ChatGPT" & month == "2025-07"

label variable market        "시장(18 countries = 18개국 합계)"
label variable assistant     "제품(Other 포함 8개)"
label variable month         "월(YYYY-MM)"
label variable unique_users  "18개국 True Audience 이용자 수 합계(⑯)"
label variable ww_total_users "18개국 8개 제품 이용자 수 합계"
label variable share_ww_pct  "제품별 점유율(%), 18개국 기준"
label variable msgs_per_user "이용자 1인당 월 메시지 수(ChatGPT 2025-07, 18개국 할인, 고정)"
label variable messages      "월간 메시지 수(추정)"
order month market assistant unique_users ww_total_users share_ww_pct msgs_per_user messages
sort month assistant
format unique_users ww_total_users messages %15.0f
format share_ww_pct %9.4f
format msgs_per_user %9.3f
compress
save "`out'/sensortower_messages_by_product_monthly.dta", replace
export delimited using "`out'/sensortower_messages_by_product_monthly.csv", replace datafmt

* 3번 검증용 제품 합계
collapse (sum) msgs_sum_products = messages, by(month)
tempfile prodsum
save `prodsum'

* -----------------------------------------------------------------------------
* (2-2) 국가별 월간 메시지 수
* -----------------------------------------------------------------------------
use "`st'/sensortower_share_all_products_monthly_long.dta", clear
keep month market residual all_users worldwide_users share_all_products_pct
generate double msgs_per_user = `mpu'
generate double messages = msgs_per_user * all_users

* Signals 매칭용 ISO2 코드
generate str2 iso2 = ""
replace iso2 = "AR" if market == "Argentina"
replace iso2 = "AU" if market == "Australia"
replace iso2 = "BR" if market == "Brazil"
replace iso2 = "CA" if market == "Canada"
replace iso2 = "FR" if market == "France"
replace iso2 = "DE" if market == "Germany"
replace iso2 = "IN" if market == "India"
replace iso2 = "ID" if market == "Indonesia"
replace iso2 = "IT" if market == "Italy"
replace iso2 = "JP" if market == "Japan"
replace iso2 = "MX" if market == "Mexico"
replace iso2 = "KR" if market == "South Korea"
replace iso2 = "ES" if market == "Spain"
replace iso2 = "TW" if market == "Taiwan"
replace iso2 = "TR" if market == "Turkey"
replace iso2 = "GB" if market == "United Kingdom"
replace iso2 = "US" if market == "United States"
replace iso2 = "VN" if market == "Vietnam"
assert (iso2 == "") == (residual == 1)

label variable market        "시장(18개국 + 나머지 7개 시장 residual)"
label variable iso2          "ISO 3166-1 alpha-2(residual 행은 빈칸)"
label variable month         "월(YYYY-MM)"
label variable residual      "1 = 나머지 7개 시장 residual 행"
label variable all_users     "8개 제품 True Audience 이용자 수 합계(⑮)"
label variable worldwide_users "Worldwide(25개 시장) 8개 제품 이용자 수 합계"
label variable share_all_products_pct "전체 제품 기준 시장 점유율(%), 분모 Worldwide"
label variable msgs_per_user "이용자 1인당 월 메시지 수(ChatGPT 2025-07 기준, 고정)"
label variable messages      "월간 메시지 수(추정, 8개 제품 합계)"
order month market iso2 residual all_users worldwide_users share_all_products_pct msgs_per_user messages
sort month residual market
format all_users worldwide_users messages %15.0f
format share_all_products_pct %9.4f
format msgs_per_user %9.3f
compress
save "`out'/sensortower_messages_by_country_monthly.dta", replace
export delimited using "`out'/sensortower_messages_by_country_monthly.csv", replace datafmt

* -----------------------------------------------------------------------------
* (2-3) Worldwide 월간 메시지 수
* -----------------------------------------------------------------------------
preserve
    generate double messages18 = messages if residual == 0
    collapse (sum) msgs_sum_countries = messages msgs_sum_18 = messages18 ///
        (first) worldwide_users msgs_per_user, by(month)
    generate double messages = msgs_per_user * worldwide_users
    merge 1:1 month using `prodsum', assert(match) nogenerate
    * 검증: 국가 합계(18개국 + residual) = Worldwide, 제품 합계(⑯, 18개국) = 18개국 국가 합계
    assert abs(msgs_sum_countries / messages - 1) < 1e-9
    assert abs(msgs_sum_products  / msgs_sum_18 - 1) < 1e-9
    drop msgs_sum_products msgs_sum_countries msgs_sum_18
    generate market = "Worldwide"
    label variable market          "시장(Worldwide = 25개 시장)"
    label variable month           "월(YYYY-MM)"
    label variable worldwide_users "Worldwide 8개 제품 이용자 수 합계"
    label variable msgs_per_user   "이용자 1인당 월 메시지 수(ChatGPT 2025-07 기준, 고정)"
    label variable messages        "월간 메시지 수(추정, 8개 제품 합계)"
    order month market worldwide_users msgs_per_user messages
    sort month
    format worldwide_users messages %15.0f
    format msgs_per_user %9.3f
    compress
    save "`out'/sensortower_messages_worldwide_monthly.dta", replace
    export delimited using "`out'/sensortower_messages_worldwide_monthly.csv", replace datafmt
    tempfile wwmsg
    save `wwmsg'
restore
tempfile ctrymsg
save `ctrymsg'

* -----------------------------------------------------------------------------
* (3) 업무용 메시지 비중(OpenAI Signals)
* -----------------------------------------------------------------------------
import delimited using "`sig'/share_of_messages_by_work_related_month.csv", ///
    varnames(1) encoding("utf-8") stringcols(1) clear
isid month work_related
bysort month: egen double chk = total(share_of_messages)
assert abs(chk - 1) < 0.002
keep if work_related == 1
replace month = substr(month, 1, 7)
rename share_of_messages work_share_global
keep month work_share_global
tempfile wglobal
save `wglobal'

import delimited using "`sig'/share_of_messages_by_work_related_country_month.csv", ///
    varnames(1) encoding("utf-8") stringcols(1 2) clear
isid month country work_related
bysort month country: egen double chk = total(share_of_messages)
assert abs(chk - 1) < 0.002
keep if work_related == 1
replace month = substr(month, 1, 7)
rename (country share_of_messages) (iso2 work_share)
keep month iso2 work_share
tempfile wctry
save `wctry'

* -----------------------------------------------------------------------------
* (3-1) 국가별 월간 업무용 메시지 수 + 대화량
* -----------------------------------------------------------------------------
use `ctrymsg', clear
merge m:1 month using `wglobal', keep(match) nogenerate     // 2024-07~2026-05만 남음
merge m:1 month iso2 using `wctry', keep(master match)
assert _merge == 3 if residual == 0                          // 18개국은 모든 달에 비중이 있음
drop _merge
generate byte work_share_src = cond(residual == 1, 2, 1)
replace work_share = work_share_global if residual == 1
assert !missing(work_share)
label define wsrc 1 "Signals 국가별" 2 "Signals 전 세계(residual)"
label values work_share_src wsrc

generate double work_messages    = messages * work_share
generate double nonwork_messages = messages - work_messages

* 대화량: 대화당 메시지 수 K
local klist "1.5 3 5 7 10"
foreach k of local klist {
    local kn = subinstr("`k'", ".", "p", .)
    generate double conv_k`kn' = work_messages / `k'
    label variable conv_k`kn' "월간 업무용 대화 수(대화당 메시지 `k'개)"
}

label variable work_share       "업무용 메시지 비중(ChatGPT, OpenAI Signals)"
label variable work_share_src   "업무용 비중 출처"
label variable work_share_global "전 세계 ChatGPT 업무용 메시지 비중(Signals)"
label variable work_messages    "월간 업무용 메시지 수(추정)"
label variable nonwork_messages "월간 비업무용 메시지 수(추정)"
order month market iso2 residual all_users msgs_per_user messages work_share work_share_src ///
    work_messages nonwork_messages conv_k*
drop worldwide_users share_all_products_pct work_share_global
sort month residual market
format work_messages nonwork_messages conv_k* %15.0f
format work_share %9.3f
compress
save "`out'/sensortower_work_messages_by_country_monthly.dta", replace
export delimited using "`out'/sensortower_work_messages_by_country_monthly.csv", replace datafmt

* -----------------------------------------------------------------------------
* (3-2) Worldwide 월간 업무용 메시지 수 + 대화량
* -----------------------------------------------------------------------------
collapse (sum) work_messages nonwork_messages messages_sum = messages, by(month)
merge 1:1 month using `wwmsg', keep(match) nogenerate
merge 1:1 month using `wglobal', assert(match using) keep(match) nogenerate
assert abs(messages_sum / messages - 1) < 1e-9
drop messages_sum
generate double work_share_implied   = work_messages / messages
generate double work_messages_global = messages * work_share_global

foreach k of local klist {
    local kn = subinstr("`k'", ".", "p", .)
    generate double conv_k`kn' = work_messages / `k'
    label variable conv_k`kn' "월간 업무용 대화 수(대화당 메시지 `k'개)"
}

label variable work_messages        "월간 업무용 메시지 수(18개국 + residual 합계)"
label variable nonwork_messages     "월간 비업무용 메시지 수(18개국 + residual 합계)"
label variable work_share_implied   "함의된 Worldwide 업무용 비중 = work_messages / messages"
label variable work_share_global    "전 세계 ChatGPT 업무용 메시지 비중(Signals)"
label variable work_messages_global "비교용: messages × 전 세계 비중"
order month market worldwide_users msgs_per_user messages work_share_implied work_messages ///
    nonwork_messages work_share_global work_messages_global conv_k*
sort month
format work_messages nonwork_messages work_messages_global conv_k* %15.0f
format work_share_implied work_share_global %9.4f
compress
save "`out'/sensortower_work_messages_worldwide_monthly.dta", replace
export delimited using "`out'/sensortower_work_messages_worldwide_monthly.csv", replace datafmt

list month messages work_share_implied work_share_global work_messages conv_k3, noobs sep(0) abbreviate(20)
