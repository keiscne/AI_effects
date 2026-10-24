* =============================================================================
* 04_analysis_sensortower_messages_summary.do
* 03_merge_sensortower_openai_messages.do가 만든 메시지·업무용 메시지·대화량 데이터의 요약표
*   (results/paper/17 보고서용)
*
* 입력: $proc/macro/scaling/sensortower_state_of_ai_2026/
*   sensortower_messages_by_product_monthly.dta, sensortower_work_messages_by_country_monthly.dta,
*   sensortower_work_messages_worldwide_monthly.dta
*   $raw/macro/scaling/scaling_parameters_public.csv (chatterji_msgs_week_2025_07)
* 출력: $results/table/
*   17_sensortower_messages.xlsx (시트 products, country_202605, worldwide)
*   17_anchor.tex     1인당 메시지 수 산출
*   17_products.tex   제품별 18개국 합계 이용자·메시지(2024-07, 2025-07, 2026-05)
*   17_country.tex    국가별 메시지·업무용 메시지·대화(2026-05)
*   17_worldwide.tex  Worldwide 월별 메시지·업무용 메시지·대화(2024-07~2026-05)
* 단위: 이용자 백만 명(국가표)·억 명(제품표), 메시지·대화 억 건, 비중 %.
* =============================================================================

version 17
clear all
set more off

if `"$root"'    == "" global root    "d:/research/AI_effects"
if `"$raw"'     == "" global raw     "$root/data/raw"
if `"$proc"'    == "" global proc    "$root/data/proc"
if `"$results"' == "" global results "$root/results"

local stp "$proc/macro/scaling/sensortower_state_of_ai_2026"
local out "$results/table"
local hdr "% 04_analysis_sensortower_messages_summary.do가 생성. 직접 고치지 말 것."

capture program drop wrow
program define wrow
    * wrow 핸들 "라벨" 서식 값1 값2 ...
    gettoken fh 0 : 0
    gettoken lab 0 : 0
    gettoken f 0 : 0
    local line "`lab'"
    foreach x of local 0 {
        if "`x'" == "." local line "`line' & --"
        else {
            local s : display `f' `x'
            local line "`line' & `=trim("`s'")'"
        }
    }
    file write `fh' `"`line' \\"' _n
end
tempname fh

* -----------------------------------------------------------------------------
* 1. 1인당 메시지 수
* -----------------------------------------------------------------------------
import delimited using "$raw/macro/scaling/scaling_parameters_public.csv", ///
    varnames(1) encoding("utf-8") bindquote(strict) stringcols(_all) clear
destring value, replace
keep if param_id == "chatterji_msgs_week_2025_07"
assert _N == 1
local wk = value[1] * 1e6
use "`stp'/sensortower_messages_by_product_monthly.dta", clear
keep if assistant == "ChatGPT" & month == "2025-07"
assert _N == 1
local mpu = msgs_per_user[1]
local u   = unique_users[1]
local mo  = messages[1]                                   // 18개국 ChatGPT 월 메시지
local mw  = `wk' * 31 / 7                                 // 전 세계 ChatGPT 월 메시지
local s18 = `mo' / `mw'                                   // 18개국 비중(03에서 AEI 2025-08로 적용)
assert abs(`s18' - 0.610) < 0.0005
file open `fh' using "`out'/17_anchor.tex", write replace
file write `fh' "`hdr'" _n
wrow `fh' "ChatGPT 주 메시지(억 건, 2025-07, 전 세계)"                  %9.1f `=`wk' / 1e8'
wrow `fh' "ChatGPT 월 메시지(억 건, 전 세계) = 주 메시지 $\times$ 31/7" %9.1f `=`mw' / 1e8'
wrow `fh' "18개국 비중(\%, AEI Claude.ai 2025-08-04--08-11)"            %9.2f `=100 * `s18''
wrow `fh' "ChatGPT 월 메시지(억 건, 18개국) = 전 세계 $\times$ 18개국 비중" %9.1f `=`mo' / 1e8'
wrow `fh' "ChatGPT True Audience 이용자(억 명, 18개국 합계)"            %9.2f `=`u' / 1e8'
wrow `fh' "이용자 1인당 월 메시지(건)"                                   %9.2f `mpu'
file close `fh'

* -----------------------------------------------------------------------------
* 2. 제품별
* -----------------------------------------------------------------------------
use "`stp'/sensortower_messages_by_product_monthly.dta", clear
keep if inlist(month, "2024-07", "2025-07", "2026-05")
export excel month assistant unique_users share_ww_pct msgs_per_user messages ///
    using "`out'/17_sensortower_messages.xlsx", sheet("products", replace) firstrow(variables)
generate byte ord = .
local plist `" "ChatGPT" "Google Gemini" "Claude" "Microsoft Copilot" "Perplexity" "DeepSeek" "Grok" "Other" "'
local i = 0
foreach p of local plist {
    local ++i
    replace ord = `i' if assistant == "`p'"
}
assert !missing(ord)
file open `fh' using "`out'/17_products.tex", write replace
file write `fh' "`hdr'" _n
foreach p of local plist {
    local vals ""
    foreach m in 2024-07 2025-07 2026-05 {
        quietly summarize unique_users if assistant == "`p'" & month == "`m'", meanonly
        local vals "`vals' `=r(mean) / 1e8'"
    }
    foreach m in 2024-07 2025-07 2026-05 {
        quietly summarize messages if assistant == "`p'" & month == "`m'", meanonly
        local vals "`vals' `=r(mean) / 1e8'"
    }
    wrow `fh' "`p'" %9.2f `vals'
}
file write `fh' "\midrule" _n
local vals ""
foreach v in unique_users messages {
    foreach m in 2024-07 2025-07 2026-05 {
        quietly summarize `v' if month == "`m'", meanonly
        local vals "`vals' `=r(sum) / 1e8'"
    }
}
wrow `fh' "합계" %9.2f `vals'
file close `fh'

* -----------------------------------------------------------------------------
* 3. 국가별(2026-05)
* -----------------------------------------------------------------------------
use "`stp'/sensortower_work_messages_by_country_monthly.dta", clear
keep if month == "2026-05"
export excel month market iso2 residual all_users messages work_share work_share_src ///
    work_messages nonwork_messages conv_k* ///
    using "`out'/17_sensortower_messages.xlsx", sheet("country_202605", replace) firstrow(variables)
quietly summarize all_users, meanonly
local tot_u = r(sum)
gsort residual -messages
file open `fh' using "`out'/17_country.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/`=_N' {
    local lab = market[`i']
    if residual[`i'] == 1 {
        file write `fh' "\midrule" _n
        local lab "나머지 7개 시장(residual)"
    }
    wrow `fh' "`lab'" %9.1f `=all_users[`i'] / 1e6' `=100 * all_users[`i'] / `tot_u'' ///
        `=messages[`i'] / 1e8' `=100 * work_share[`i']' `=work_messages[`i'] / 1e8' `=conv_k3[`i'] / 1e8'
}
file write `fh' "\midrule" _n
foreach v in all_users messages work_messages conv_k3 {
    quietly summarize `v', meanonly
    local s_`v' = r(sum)
}
wrow `fh' "Worldwide(합계)" %9.1f `=`s_all_users' / 1e6' 100 `=`s_messages' / 1e8' ///
    `=100 * `s_work_messages' / `s_messages'' `=`s_work_messages' / 1e8' `=`s_conv_k3' / 1e8'
file close `fh'

* -----------------------------------------------------------------------------
* 4. Worldwide 월별
* -----------------------------------------------------------------------------
use "`stp'/sensortower_work_messages_worldwide_monthly.dta", clear
export excel using "`out'/17_sensortower_messages.xlsx", sheet("worldwide", replace) firstrow(variables)
sort month
file open `fh' using "`out'/17_worldwide.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/`=_N' {
    wrow `fh' "`=month[`i']'" %9.1f `=messages[`i'] / 1e8' `=100 * work_share_implied[`i']' ///
        `=100 * work_share_global[`i']' `=work_messages[`i'] / 1e8' ///
        `=conv_k1p5[`i'] / 1e8' `=conv_k3[`i'] / 1e8' `=conv_k5[`i'] / 1e8' ///
        `=conv_k7[`i'] / 1e8' `=conv_k10[`i'] / 1e8'
}
file close `fh'
