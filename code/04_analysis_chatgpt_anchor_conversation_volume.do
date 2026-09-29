* =============================================================================
* 04_analysis_chatgpt_anchor_conversation_volume.do
* OpenAI 자체 수치(Chatterji et al. 2025: 2025-07 WAU 7억 명·주 메시지 180억 건)를 기준값으로
* Sensor Tower 자료를 평가하고, 전 세계·제품별 메시지·대화 총량을 추정하는 표
* (report 15: results/report/15_ChatGPT기준값_SensorTower평가_대화총량추정.tex)
*
* 입력
*   $raw/macro/scaling/scaling_parameters_public.csv        chatterji_*, fan_* (param_id로 찾음)
*   $raw/macro/scaling/sensortower_state_of_ai_2026/
*     sensortower_true_audience_monthly_long.csv            ① True Audience 이용자 수
*     sensortower_days_used_monthly_long.csv                ② 앱 이용자 월평균 사용 일수
*     sensortower_true_audience_share_monthly_long.csv      ⑥ True Audience 점유율
*     sensortower_worldwide_share_by_measure_monthly_long.csv  ⑦ 경로별 Worldwide 점유율
*     sensortower_genai_apps_sessions_hours_monthly.csv     ⑨ 앱 세션·사용 시간(월별, Denton)
*     sensortower_genai_web_visits_hours_monthly.csv        ⑩ 웹 방문·사용 시간(월별, Denton)
*   ⑨·⑩은 02_clean_sensortower_usage_monthly_by_assistant.do가 먼저 실행되어 있어야 한다.
* 출력
*   $results/table/15_chatgpt_anchor.xlsx     시트 anchor, growth, series, products, conv, claude, monthly
*   $results/table/15_{anchor,growth,series,products,conv,claude}.tex   표 본문 행(\input용)
*
* 기준값(ChatGPT 소비자 플랜 메시지, 월간 환산)
*   2025-07: 주 180억 건 × 31/7 (p.1)            ← 주 기준값
*   2024-06: 하루 4.51억 건 × 30 (표 1, p.2)     ← 보조 기준값
*   2025-06: 하루 26.27억 건 × 30 (표 1, p.2)    ← 검증용(기준값으로 쓰지 않음)
* Sensor Tower 지표(Worldwide, ChatGPT). ⑦ 경로별 점유율 = 웹은 web_visits, 앱은 standalone_app_mau
*   web7  = 웹 방문 합계 × 웹 점유율           app7 = 앱 세션 합계 × 앱 MAU 점유율
*   cnt7  = web7 + app7(방문 + 세션)          hrs7 = 웹 시간 × 웹 점유율 + 앱 시간 × 앱 MAU 점유율
*   users = True Audience 이용자(25개 시장)    udays = users × 앱 이용자 월평균 사용 일수
* 기준값 결합(benchmarking): r_t = 메시지 ÷ 지표. 2024-06과 2025-07의 r을 로그 선형으로 잇고,
*   2024-06 이전은 r(2024-06) 고정, 2025-07 이후는 두 가지 — flat: r(2025-07) 고정, trend: 같은 기울기로 연장.
*   메시지 추정치 = r_t × 지표_t.
* 제품별 분해: 제품 j 메시지 = ChatGPT 메시지 × 지표_j ÷ 지표_ChatGPT(이용자 1인·방문 1회·1시간당 메시지가
*   ChatGPT와 같다는 가정). ⑦에 없는 제품은 그 경로 값을 0으로 둔다(Other에 들어 있음).
* 매칭 키: 제품(assistant, ⑦의 "Grok AI"는 "Grok"으로 통일) × 월(YYYY-MM), 시장은 Worldwide.
* 단위: 메시지·대화·방문·세션·이용자는 억(1e8), 시간은 억 시간. 월간이 기본이고 주간 = 월간 × 7 ÷ 일수.
* =============================================================================

version 17
clear all
set more off

if `"$root"'    == "" global root    "d:/research/AI_effects"
if `"$raw"'     == "" global raw     "$root/data/raw"
if `"$results"' == "" global results "$root/results"

local st  "$raw/macro/scaling/sensortower_state_of_ai_2026"
local out "$results/table"

* 조건에 맞는 행이 정확히 1개인지 확인하고 그 값을 r(v)로 돌려준다
capture program drop getv
program define getv, rclass
    gettoken fr 0 : 0
    gettoken var 0 : 0
    frame `fr': quietly summarize `var' if `0', meanonly
    if r(N) != 1 {
        display as error "getv: `fr' `var' if `0' -> " r(N) " rows"
        exit 459
    }
    return scalar v = r(mean)
end

capture program drop mdays
program define mdays, rclass
    args m
    local ym = monthly("`m'", "YM")
    return scalar d = dofm(`ym' + 1) - dofm(`ym')
end

* -----------------------------------------------------------------------------
* 1. 입력: 외부 값, Worldwide 카테고리 월별 합계, 제품 × 월 패널
* -----------------------------------------------------------------------------
frame create par
frame par {
    import delimited using "$raw/macro/scaling/scaling_parameters_public.csv", ///
        varnames(1) encoding("utf-8") bindquote(strict) stringcols(_all) clear
    destring value value_low value_high, replace
    isid param_id
}

import delimited using "`st'/sensortower_genai_web_visits_hours_monthly.csv", varnames(1) encoding("utf-8") asdouble clear
keep if market == "Worldwide"
rename (visits time_spent_hours) (webtot webh)
keep month webtot webh
tempfile web
save `web'
import delimited using "`st'/sensortower_genai_apps_sessions_hours_monthly.csv", varnames(1) encoding("utf-8") asdouble clear
keep if market == "Worldwide"
rename (sessions time_spent_hours) (apptot apph)
keep month apptot apph
merge 1:1 month using `web', keep(match) nogenerate
tempfile cat
save `cat'

import delimited using "`st'/sensortower_worldwide_share_by_measure_monthly_long.csv", varnames(1) encoding("utf-8") asdouble clear
keep if inlist(measure, "web_visits", "standalone_app_mau")
replace assistant = "Grok" if assistant == "Grok AI"
gen str1 m = cond(measure == "web_visits", "w", "a")
keep assistant month m share_pct
reshape wide share_pct, i(assistant month) j(m) string
rename (share_pctw share_pcta) (sh_web sh_app)
tempfile s7
save `s7'

import delimited using "`st'/sensortower_true_audience_share_monthly_long.csv", varnames(1) encoding("utf-8") asdouble clear
keep if market == "Worldwide"
rename share_pct sh_ta
keep assistant month sh_ta
tempfile s6
save `s6'

import delimited using "`st'/sensortower_days_used_monthly_long.csv", varnames(1) encoding("utf-8") asdouble clear
rename (app avg_days_used_per_month) (assistant days)
keep if inlist(assistant, "ChatGPT", "Claude", "DeepSeek", "Google Gemini", "Microsoft Copilot")
tempfile days
save `days'

import delimited using "`st'/sensortower_true_audience_monthly_long.csv", varnames(1) encoding("utf-8") asdouble clear
keep if market == "Worldwide"
keep assistant month unique_users
merge 1:1 assistant month using `s6', nogenerate
merge 1:1 assistant month using `s7', nogenerate
merge 1:1 assistant month using `days', keep(master match using) nogenerate
merge m:1 month using `cat', keep(match) nogenerate      // 2024-01~2026-03(웹 합계가 있는 달)
drop if missing(sh_web) & missing(sh_app) & missing(sh_ta)

* ⑦에 없는 경로는 0(Other에 포함). 두 경로 모두 없으면(DeepSeek) 결측
gen byte in7 = !missing(sh_web) | !missing(sh_app)
gen double web7  = webtot * cond(missing(sh_web), 0, sh_web) / 100 / 1e8 if in7
gen double app7  = apptot * cond(missing(sh_app), 0, sh_app) / 100 / 1e8 if in7
gen double cnt7  = web7 + app7
gen double hrs7  = (webh * cond(missing(sh_web), 0, sh_web) + apph * cond(missing(sh_app), 0, sh_app)) / 100 / 1e8 if in7
gen double users = unique_users / 1e8
gen double udays = users * days
gen int    t     = monthly(month, "YM")
format t %tm
frame copy default pm
frame change pm

* ChatGPT 월별 행을 따로
frame put if assistant == "ChatGPT", into(cg)

* -----------------------------------------------------------------------------
* 2. 기준값
* -----------------------------------------------------------------------------
getv par value param_id=="chatterji_msgs_week_2025_07"
local M1 = r(v) * 1e6 * 31 / 7 / 1e8                 // 2025-07 월간(억)
getv par value param_id=="chatterji_msgs_day_2024_06"
local M0 = r(v) * 1e6 * 30 / 1e8                     // 2024-06
getv par value param_id=="chatterji_msgs_day_2025_06"
local Mc = r(v) * 1e6 * 30 / 1e8                     // 2025-06(검증용)
getv par value param_id=="chatterji_wau_2025_07"
local wau = r(v) * 1e6 / 1e8
local t0 = tm(2024m6)
local t1 = tm(2025m7)
local tc = tm(2025m6)

* -----------------------------------------------------------------------------
* 3. 표 anchor: 2025-07 기준값과 Sensor Tower ChatGPT 값
* -----------------------------------------------------------------------------
frame create res str10 tab byte ord str70 label double(c1 c2 c3 c4 c5 c6) str6 fmt

foreach v in users web7 app7 cnt7 hrs7 days webtot apptot webh apph {
    getv cg `v' t==`t1'
    local `v' = r(v)
}
local webh7 = `webh' * (`web7' / (`webtot'/1e8)) / 1e8     // ChatGPT 웹 시간(억 시간)
local apph7 = `hrs7' - `webh7'
local mweb  = `M1' * `webh7' / `hrs7'                        // 시간 비례 배분 시 웹 메시지
local mapp  = `M1' - `mweb'
local k = 0
foreach row in ///
    "OpenAI WAU(주간, 전 세계, 억 명)|`wau'|%9.2f" ///
    "Sensor Tower True Audience(월간, 25개 시장, 억 명)|`users'|%9.2f" ///
    "WAU ÷ True Audience|`=`wau'/`users''|%9.2f" ///
    "앱 이용자 월평균 사용 일수 ÷ 31(DAU/MAU 근사)|`=`days'/31'|%9.2f" ///
    "메시지(월간 환산, 억 건)|`M1'|%9.1f" ///
    "웹 방문(⑦, 억 회)|`web7'|%9.1f" ///
    "앱 세션(⑦, 억 회)|`app7'|%9.1f" ///
    "웹 방문 + 앱 세션(⑦, 억 회)|`cnt7'|%9.1f" ///
    "사용 시간(⑦, 억 시간)|`hrs7'|%9.2f" ///
    "메시지 ÷ (웹 방문 + 앱 세션)|`=`M1'/`cnt7''|%9.2f" ///
    "메시지 ÷ 사용 시간(분당 건)|`=`M1'/(`hrs7'*60)'|%9.2f" ///
    "이용자 1인당 월 메시지(÷ True Audience)|`=`M1'/`users''|%9.1f" ///
    "WAU 1인당 하루 메시지|`=`M1'/`wau'/31'|%9.2f" ///
    "사용일 1일당 메시지(÷ True Audience × 사용 일수)|`=`M1'/(`users'*`days')'|%9.2f" ///
    "시간 비례 배분 시 웹 방문 1회당 메시지|`=`mweb'/`web7''|%9.2f" ///
    "시간 비례 배분 시 앱 세션 1회당 메시지|`=`mapp'/`app7''|%9.2f" {
    local ++k
    tokenize "`row'", parse("|")
    frame post res ("anchor") (`k') ("`1'") (`3') (.) (.) (.) (.) (.) ("`5'")
}
display "ChatGPT 사용 시간 중 웹 비중(2025-07): " %5.3f `webh7'/`hrs7'

* -----------------------------------------------------------------------------
* 4. 표 growth: 지표별 증가율과 메시지 ÷ 지표(r)의 변화, 2025-06 검증
*   열: 지표 증가(2025-07 ÷ 2024-06), r(2024-06), r(2025-07), r 변화(배), 2025-06 예측 오차(%)
* -----------------------------------------------------------------------------
frame cg {
    local k = 1
    frame post res ("growth") (1) ("메시지(Chatterji et al.)") (`M1'/`M0') (.) (.) (.) (.) (.) ("%9.2f")
    foreach v in web7 app7 cnt7 hrs7 users udays {
        local ++k
        quietly summarize `v' if t==`t0', meanonly
        local i0 = r(mean)
        quietly summarize `v' if t==`t1', meanonly
        local i1 = r(mean)
        quietly summarize `v' if t==`tc', meanonly
        local ic = r(mean)
        local r0 = `M0' / `i0'
        local r1 = `M1' / `i1'
        * 2025-06의 r: 로그 선형 보간
        local rc = exp(ln(`r0') + (`tc'-`t0')/(`t1'-`t0') * (ln(`r1') - ln(`r0')))
        local err = 100 * (`rc' * `ic' / `Mc' - 1)
        local lab : word `=`k'-1' of "웹 방문(⑦)" "앱 세션(⑦)" "웹 방문 + 앱 세션(⑦)" "사용 시간(⑦)" ///
            "True Audience 이용자" "이용자 × 사용 일수"
        frame post res ("growth") (`k') ("`lab'") (`i1'/`i0') (`r0') (`r1') (`r1'/`r0') (`err') (.) ("%9.2f")
        * 월별 기준값 결합 계열
        gen double lr_`v' = ln(`r0') + (t-`t0')/(`t1'-`t0') * (ln(`r1') - ln(`r0'))
        gen double Mf_`v' = `v' * exp(cond(t < `t0', ln(`r0'), cond(t > `t1', ln(`r1'), lr_`v')))
        gen double Mt_`v' = `v' * exp(cond(t < `t0', ln(`r0'), lr_`v'))
        drop lr_`v'
    }
}

* -----------------------------------------------------------------------------
* 5. 표 series: ChatGPT 월간 메시지 추정(억 건). 지표: 앱 세션(⑦, r 변화가 가장 작음)과 방문 + 세션(⑦)
* -----------------------------------------------------------------------------
local k = 0
foreach m in 2024-01 2024-06 2025-01 2025-06 2025-07 2025-10 2026-01 2026-02 2026-03 {
    local ++k
    local tm = monthly("`m'", "YM")
    foreach v in Mf_app7 Mt_app7 Mf_cnt7 Mt_cnt7 {
        getv cg `v' t==`tm'
        local `v' = r(v)
    }
    local obs = cond("`m'"=="2024-06", `M0', cond("`m'"=="2025-06", `Mc', cond("`m'"=="2025-07", `M1', .)))
    frame post res ("series") (`k') ("`m'") (`obs') (`Mf_app7') (`Mt_app7') (`Mf_cnt7') (`Mt_cnt7') (.) ("%9.1f")
}

* -----------------------------------------------------------------------------
* 6. 표 products: 제품별 월간 메시지(억 건). ChatGPT 값 × 지표_j ÷ 지표_ChatGPT
*   열: 2025-07(True Audience, 사용 시간 ⑦, 방문+세션 ⑦), 2026-03(같은 순서, ChatGPT는 앱 세션 기준 flat)
* -----------------------------------------------------------------------------
getv cg Mf_app7 t==tm(2026m3)
local Mc26 = r(v)
getv cg Mf_app7 t==tm(2026m2)
local Mc26f = r(v)
local plist `" "ChatGPT" "Google Gemini" "Claude" "Microsoft Copilot" "Perplexity" "DeepSeek" "Grok" "Meta AI" "Other" "'
local k = 0
foreach a of local plist {
    local ++k
    local j = 0
    foreach m in 2025m7 2026m3 {
        local Mcg = cond("`m'"=="2025m7", `M1', `Mc26')
        foreach v in users hrs7 cnt7 {
            local ++j
            getv cg `v' t==tm(`m')
            local base = r(v)
            frame pm: quietly summarize `v' if assistant=="`a'" & t==tm(`m'), meanonly
            local c`j' = cond(r(N)==1, `Mcg' * r(mean) / `base', .)
            * True Audience 기준 Other 등은 점유율로 계산(이용자 수가 없는 행)
            if "`v'"=="users" & r(N)==1 & missing(r(mean)) local c`j' = .
        }
    }
    frame post res ("products") (`k') ("`a'") (`c1') (`c2') (`c3') (`c4') (`c5') (`c6') ("%9.1f")
}
* True Audience 기준 Other는 이용자 수가 없어 점유율로: ChatGPT × sh_ta_Other ÷ sh_ta_ChatGPT
foreach m in 2025m7 2026m3 {
    local Mcg = cond("`m'"=="2025m7", `M1', `Mc26')
    getv pm sh_ta assistant=="ChatGPT" & t==tm(`m')
    local shc = r(v)
    getv pm sh_ta assistant=="Other" & t==tm(`m')
    local oth_`m' = `Mcg' * r(v) / `shc'
    local tot_ta_`m' = `Mcg' * 100 / `shc'
    * ⑦ 기준 합계 = ChatGPT × 카테고리 합계 ÷ ChatGPT 몫(점유율 합이 100이 되도록 정규화)
    foreach v in hrs7 cnt7 {
        frame pm: quietly summarize `v' if t==tm(`m'), meanonly
        local sum = r(sum)
        getv cg `v' t==tm(`m')
        local tot_`v'_`m' = `Mcg' * `sum' / r(v)
    }
}
frame res: replace c1 = `oth_2025m7' if tab=="products" & label=="Other"
frame res: replace c4 = `oth_2026m3' if tab=="products" & label=="Other"
frame post res ("products") (10) ("합계") (`tot_ta_2025m7') (`tot_hrs7_2025m7') (`tot_cnt7_2025m7') ///
    (`tot_ta_2026m3') (`tot_hrs7_2026m3') (`tot_cnt7_2026m3') ("%9.1f")
frame post res ("products") (11) ("ChatGPT 몫(%)") (100*`M1'/`tot_ta_2025m7') (100*`M1'/`tot_hrs7_2025m7') ///
    (100*`M1'/`tot_cnt7_2025m7') (100*`Mc26'/`tot_ta_2026m3') (100*`Mc26'/`tot_hrs7_2026m3') ///
    (100*`Mc26'/`tot_cnt7_2026m3') ("%9.1f")

* -----------------------------------------------------------------------------
* 7. 표 conv: 대화당 메시지 수 k에 따른 주간 대화 수(억 건)
*   열: 2025-07 ChatGPT, 전체(True Audience), 전체(사용 시간 ⑦) / 2026-03 같은 순서
* -----------------------------------------------------------------------------
local w1 = 7/31
local w2 = 7/31
local r = 0
foreach kk in 1 2 3 5 {
    local ++r
    frame post res ("conv") (`r') ("`kk'") (`M1'*`w1'/`kk') (`tot_ta_2025m7'*`w1'/`kk') (`tot_hrs7_2025m7'*`w1'/`kk') ///
        (`Mc26'*`w2'/`kk') (`tot_ta_2026m3'*`w2'/`kk') (`tot_hrs7_2026m3'*`w2'/`kk') ("%9.1f")
}

* -----------------------------------------------------------------------------
* 8. 표 claude: Claude 2026-02 주간 메시지 추정과 Fan and Nguyen 대화 수 → 함의된 대화당 메시지 수
* -----------------------------------------------------------------------------
getv par value param_id=="fan_claude_conv_week"
local fanw = r(v) * 1e6 / 1e8
getv par value param_id=="fan_web_mau_2026_02"
local fanmau = r(v) * 1e6 / 1e8
getv pm users assistant=="Claude" & t==tm(2026m2)
local cu = r(v)
local fanst = `fanw' * `cu' / `fanmau'          // Fan 방식에서 이용자만 Sensor Tower 값으로 바꾼 주 대화 수
local k = 0
foreach v in users hrs7 cnt7 {
    local ++k
    getv cg `v' t==tm(2026m2)
    local base = r(v)
    getv pm `v' assistant=="Claude" & t==tm(2026m2)
    local mw = `Mc26f' * r(v) / `base' * 7 / 28
    local lab : word `k' of "True Audience 이용자" "사용 시간(⑦)" "웹 방문 + 앱 세션(⑦)"
    frame post res ("claude") (`k') ("`lab'") (`mw') (`mw'/`fanw') (`mw'/`fanst') (.) (.) (.) ("%9.2f")
}
display "Fan 주 대화(억): " `fanw' "  Fan × (ST 이용자 ÷ Fan MAU): " %6.2f `fanst'

* -----------------------------------------------------------------------------
* 9. 출력
* -----------------------------------------------------------------------------
frame cg {
    keep month users web7 app7 cnt7 hrs7 udays Mf_* Mt_*
    export excel using "`out'/15_chatgpt_anchor.xlsx", sheet("monthly") replace firstrow(variables)
}
frame res {
    sort tab ord
    foreach t in anchor growth series products conv claude {
        preserve
        keep if tab == "`t'"
        drop tab
        export excel using "`out'/15_chatgpt_anchor.xlsx", sheet("`t'") sheetreplace firstrow(variables)
        local ncol = cond("`t'"=="anchor", 1, cond("`t'"=="growth", 5, cond("`t'"=="claude", 3, cond("`t'"=="series", 5, 6))))
        tempname fh
        file open `fh' using "`out'/15_`t'.tex", write replace
        file write `fh' "% 04_analysis_chatgpt_anchor_conversation_volume.do가 생성. 직접 고치지 말 것." _n
        forvalues r = 1/`=_N' {
            local line = label[`r']
            local f = fmt[`r']
            forvalues c = 1/`ncol' {
                local x = c`c'[`r']
                if missing(`x') local line "`line' & --"
                else {
                    local s : display `f' `x'
                    local line "`line' & `=trim("`s'")'"
                }
            }
            file write `fh' `"`line' \\"' _n
        }
        file close `fh'
        restore
    }
    list, sepby(tab) noobs abbreviate(12) string(40)
}
