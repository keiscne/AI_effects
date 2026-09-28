* =============================================================================
* 04_analysis_sensortower_usage_comparison.do
* Sensor Tower 이용자·사용량 지표와 외부 자료(Chatterji et al. 2025, Fan and Nguyen 2026)의 비교표
* (report 14: results/report/14_SensorTower_이용자사용량_외부비교.tex)
*
* 입력
*   $raw/macro/scaling/scaling_parameters_public.csv        논문·2차 자료에서 옮겨 적은 값(param_id로 찾음)
*   $raw/macro/scaling/sensortower_state_of_ai_2026/
*     sensortower_true_audience_monthly_long.csv            ① True Audience 이용자 수
*     sensortower_days_used_monthly_long.csv                ② 앱 이용자 월평균 사용 일수
*     sensortower_worldwide_share_by_measure_monthly_long.csv  ⑦ 경로별 Worldwide 점유율
*     sensortower_genai_apps_sessions_hours_monthly.csv     ⑨ 앱 세션(월별, Denton)
*     sensortower_genai_web_visits_hours_monthly.csv        ⑩ 웹 방문(월별, Denton)
*     sensortower_genai_apps_by_assistant_monthly.csv       ⑪ 앱 세션의 제품별 분해(True Audience 점유율)
*     sensortower_genai_web_by_assistant_monthly.csv        ⑫ 웹 방문의 제품별 분해(True Audience 점유율)
*   ⑨–⑫는 02_clean_sensortower_usage_monthly_by_assistant.do가 먼저 실행되어 있어야 한다.
* 출력
*   $results/table/14_usage_comparison.xlsx                 시트 ta_wau, chatterji, fan
*   $results/table/14_ta_wau.tex, 14_chatterji.tex, 14_fan.tex   표 본문 행(\input용)
*
* 단위: 이용자·방문·세션·메시지·대화는 억(1e8). 비율은 배, 사용 일수는 일.
* 시간 단위 통일: 모두 월간. 하루 값은 × 그 달의 일수, 주간 값은 × 그 달의 일수 ÷ 7.
* 매칭 키: 시장(Worldwide) × 제품(ChatGPT, Claude) × 월(YYYY-MM).
* Sensor Tower 제품 값 두 가지:
*   (가) ⑦ 경로별 점유율 기준 = 카테고리 월별 합계(⑨·⑩) × ⑦ 점유율(웹은 web_visits, 앱은 standalone_app_mau)
*   (나) True Audience 기준 = ⑪·⑫
* =============================================================================

version 17
clear all
set more off

if `"$root"'    == "" global root    "d:/research/AI_effects"
if `"$raw"'     == "" global raw     "$root/data/raw"
if `"$results"' == "" global results "$root/results"

local st  "$raw/macro/scaling/sensortower_state_of_ai_2026"
local out "$results/table"

* -----------------------------------------------------------------------------
* 입력 자료를 frame으로 읽기
* -----------------------------------------------------------------------------
frame create par
frame par {
    import delimited using "$raw/macro/scaling/scaling_parameters_public.csv", ///
        varnames(1) encoding("utf-8") bindquote(strict) stringcols(_all) clear
    destring value value_low value_high, replace
    isid param_id
}
foreach f in ta:sensortower_true_audience_monthly_long days:sensortower_days_used_monthly_long ///
             sh7:sensortower_worldwide_share_by_measure_monthly_long ///
             app:sensortower_genai_apps_sessions_hours_monthly web:sensortower_genai_web_visits_hours_monthly ///
             appta:sensortower_genai_apps_by_assistant_monthly webta:sensortower_genai_web_by_assistant_monthly {
    gettoken fr file : f, parse(":")
    local file = substr("`file'", 2, .)
    frame create `fr'
    frame `fr': import delimited using "`st'/`file'.csv", varnames(1) encoding("utf-8") asdouble clear
}

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

* 한 달의 일수
capture program drop mdays
program define mdays, rclass
    args m
    local ym = monthly("`m'", "YM")
    return scalar d = dofm(`ym' + 1) - dofm(`ym')
end

* Sensor Tower 제품 값(억). 인자: 제품 이름, 월
capture program drop stvals
program define stvals, rclass
    args a m
    getv web visits market=="Worldwide" & month=="`m'"
    local webtot = r(v)
    getv app sessions market=="Worldwide" & month=="`m'"
    local apptot = r(v)
    getv sh7 share_pct measure=="web_visits" & assistant=="`a'" & month=="`m'"
    return scalar web7 = `webtot' * r(v) / 100 / 1e8
    getv sh7 share_pct measure=="standalone_app_mau" & assistant=="`a'" & month=="`m'"
    return scalar app7 = `apptot' * r(v) / 100 / 1e8
    getv webta visits market=="Worldwide" & assistant=="`a'" & month=="`m'"
    return scalar webta = r(v) / 1e8
    getv appta sessions market=="Worldwide" & assistant=="`a'" & month=="`m'"
    return scalar appta = r(v) / 1e8
    getv ta unique_users market=="Worldwide" & assistant=="`a'" & month=="`m'"
    return scalar users = r(v) / 1e8
end

* 결과를 담을 frame: 표 이름, 행 순서, 행 이름, 값 5개(열), 표시 형식
frame create res str10 tab byte ord str60 label double(c1 c2 c3 c4 c5) str6 fmt

* -----------------------------------------------------------------------------
* 표 A: True Audience(월간, 25개 시장) vs OpenAI WAU(주간, 전 세계), ChatGPT
*   열: 2023-11, 2024-11, 2025-07. 2023-11·2024-11 WAU는 로그인 이용자만.
* -----------------------------------------------------------------------------
local i = 0
foreach m in 2023-11 2024-11 2025-07 {
    local ++i
    getv ta unique_users market=="Worldwide" & assistant=="ChatGPT" & month=="`m'"
    local ta`i' = r(v) / 1e8
    local pid = cond("`m'" == "2025-07", "chatterji_wau_2025_07", "chatterji_wau_" + subinstr("`m'", "-", "_", .))
    getv par value param_id=="`pid'"
    local wau`i' = r(v) / 100
    local r`i' = `ta`i'' / `wau`i''
}
frame post res ("ta_wau") (1) ("Sensor Tower True Audience(월간, 25개 시장)") (`ta1') (`ta2') (`ta3') (.) (.) ("%9.2f")
frame post res ("ta_wau") (2) ("OpenAI WAU(주간, 전 세계)") (`wau1') (`wau2') (`wau3') (.) (.) ("%9.2f")
frame post res ("ta_wau") (3) ("비율(True Audience ÷ WAU, 배)") (`r1') (`r2') (`r3') (.) (.) ("%9.1f")

* -----------------------------------------------------------------------------
* 표 B: Chatterji et al.(2025) 메시지 수(ChatGPT 소비자 플랜) vs Sensor Tower ChatGPT
*   열: 2024-06, 2024-07, 2025-06, 2025-07, 증가(2025-06 ÷ 2024-06)
* -----------------------------------------------------------------------------
local i = 0
foreach m in 2024-06 2024-07 2025-06 2025-07 {
    local ++i
    mdays `m'
    local d = r(d)
    if "`m'" == "2024-06" | "`m'" == "2025-06" {
        getv par value param_id=="chatterji_msgs_day_" + "`=subinstr("`m'", "-", "_", .)'"
        local msg`i' = r(v) * `d' / 100
    }
    else if "`m'" == "2025-07" {
        getv par value param_id=="chatterji_msgs_week_2025_07"
        local msg`i' = r(v) * `d' / 7 / 100
    }
    else local msg`i' = .
    stvals ChatGPT `m'
    foreach s in web7 webta app7 appta users {
        local `s'`i' = r(`s')
    }
    local sum`i' = `web7`i'' + `app7`i''
    getv days avg_days_used_per_month app=="ChatGPT" & month=="`m'"
    local days`i' = r(v)
    foreach s in sum web7 app7 {
        local p`s'`i' = `msg`i'' / ``s'`i''
    }
}
local k = 0
foreach s in msg web7 webta app7 appta sum users days {
    local ++k
    local g = ``s'3' / ``s'1'
    local lab : word `k' of "메시지 수(월간 환산)" "웹 방문(⑦ 경로별 점유율)" "웹 방문(True Audience 점유율)" ///
        "앱 세션(⑦ 경로별 점유율)" "앱 세션(True Audience 점유율)" "웹 방문 + 앱 세션(⑦)" ///
        "이용자(True Audience, 25개 시장)" "앱 이용자 월평균 사용 일수(일)"
    local f = cond("`s'" == "users", "%9.2f", "%9.1f")
    frame post res ("chatterji") (`k') ("`lab'") (``s'1') (``s'2') (``s'3') (``s'4') (`g') ("`f'")
}
foreach s in sum web7 app7 {
    local ++k
    local lab = cond("`s'" == "sum", "메시지 ÷ (웹 방문 + 앱 세션)", cond("`s'" == "web7", "메시지 ÷ 웹 방문", "메시지 ÷ 앱 세션"))
    frame post res ("chatterji") (`k') ("`lab'") (`p`s'1') (`p`s'2') (`p`s'3') (`p`s'4') (.) ("%9.2f")
}

* -----------------------------------------------------------------------------
* 표 C: Fan and Nguyen(2026) Claude.ai 대화 수 vs Sensor Tower Claude
*   Fan 방식: 주 대화 수(R5 2026-02 = 2억) × Similarweb claude.ai 월 방문 수 비율. 2026-03은 웨이브가 아니라
*   report 11 방법 A의 연장. 열: 2025-08(R3), 2025-11(R4), 2026-02(R5), 2026-03, 증가(2026-02 ÷ 2025-08)
* -----------------------------------------------------------------------------
getv par value param_id=="fan_claude_conv_week"
local fanw = r(v)
getv par value param_id=="sw_visits_2026_02"
local sw_base = r(v)
local i = 0
foreach m in 2025-08 2025-11 2026-02 2026-03 {
    local ++i
    mdays `m'
    local d = r(d)
    getv par value param_id=="sw_visits_" + "`=subinstr("`m'", "-", "_", .)'"
    local sw`i' = r(v) / 100
    local fan`i' = `fanw' * (`sw`i'' * 100 / `sw_base') * `d' / 7 / 100
    stvals Claude `m'
    foreach s in web7 webta app7 appta users {
        local `s'`i' = r(`s')
    }
    local rsw`i' = `web7`i'' / `sw`i''
}
local k = 0
foreach s in fan sw web7 webta app7 appta users {
    local ++k
    local g = ``s'3' / ``s'1'
    local lab : word `k' of "Fan and Nguyen 대화 수(월간 환산)" "Similarweb claude.ai 방문(Fan의 조정 기준)" ///
        "웹 방문(⑦ 경로별 점유율)" "웹 방문(True Audience 점유율)" "앱 세션(⑦ 경로별 점유율)" ///
        "앱 세션(True Audience 점유율)" "이용자(True Audience, 25개 시장)"
    frame post res ("fan") (`k') ("`lab'") (``s'1') (``s'2') (``s'3') (``s'4') (`g') ("%9.2f")
}
frame post res ("fan") (8) ("웹 방문(⑦) ÷ Similarweb 방문(배)") (`rsw1') (`rsw2') (`rsw3') (`rsw4') (.) ("%9.2f")

* 본문에 쓰는 보조 값
getv par value param_id=="fan_web_mau_2026_02"
local fanmau = r(v)
getv par value_low param_id=="fan_claude_conv_week"
local fanlo = r(v)
getv par value_high param_id=="fan_claude_conv_week"
local fanhi = r(v)
display "Fan R5 월간 범위(억): " %5.1f `fanlo'*4/100 " - " %5.1f `fanhi'*4/100
display "Fan 웹 MAU ÷ ST 이용자(2026-02): " %6.3f (`fanmau'/100)/`users3'
display "ST 이용자로 바꾼 Fan 주 대화 수(억): " %6.1f `fanw'/100 * `users3' / (`fanmau'/100)

* -----------------------------------------------------------------------------
* 출력: xlsx(표별 시트)와 tex 표 본문 행
* -----------------------------------------------------------------------------
frame res {
    sort tab ord
    local xopt replace
    foreach t in ta_wau chatterji fan {
        preserve
        keep if tab == "`t'"
        drop tab
        export excel using "`out'/14_usage_comparison.xlsx", sheet("`t'") `xopt' firstrow(variables)
        local xopt sheetreplace
        * tex: 행 이름 & 값 ... \\ (결측은 --)
        local ncol = cond("`t'" == "ta_wau", 3, 5)
        tempname fh
        file open `fh' using "`out'/14_`t'.tex", write replace
        file write `fh' "% 04_analysis_sensortower_usage_comparison.do가 생성. 직접 고치지 말 것." _n
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
    list, sepby(tab) noobs abbreviate(12)
}
