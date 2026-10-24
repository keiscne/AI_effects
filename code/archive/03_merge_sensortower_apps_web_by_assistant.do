* =============================================================================
* 03_merge_sensortower_apps_web_by_assistant.do
* Sensor Tower "State of AI 2026": 제품별 앱 세션 수와 웹 방문 수를 합친 월별 데이터
*
* 입력($raw/macro/scaling/sensortower_state_of_ai_2026/, 02_clean_sensortower_usage_monthly_by_assistant.do의 출력)
*   sensortower_genai_apps_by_assistant_monthly.csv   ⑪ 앱 세션·사용 시간, 시장 × 제품 × 월(2023-04~2026-05)
*   sensortower_genai_web_by_assistant_monthly.csv    ⑫ 웹 방문·사용 시간, 시장 × 제품 × 월(2024-01~2026-03)
*   sensortower_genai_apps_sessions_hours_monthly.csv  ⑨ 앱 세션·사용 시간, 시장 × 월(2023-01~2026-06, 24개 시장)
*   sensortower_genai_web_visits_hours_monthly.csv     ⑩ 웹 방문·사용 시간, 시장 × 월(2024-01~2026-03, 23개 시장)
* 출력(입력과 같은 폴더. ⑨–⑫와 같이 사용자 지정 위치로, CLAUDE.md의 data/proc 규칙의 예외)
*   sensortower_genai_apps_web_by_assistant_monthly.csv   ⑬ 시장 × 제품 × 월(2023-04~2026-05), 19 × 8 × 38 = 5,776행
*   sensortower_genai_apps_web_monthly.csv                ⑭ 제품 구분 없는 카테고리 합계, 시장 × 월(2023-01~2026-06),
*                                                            24 × 42 = 1,008행. ⑨·⑩을 market × month로 결합(아래 2부).
*                                                            China Mainland는 웹 값이 없어 합계 결측.
*
* 매칭 키: market × assistant × month(YYYY-MM). ⑪·⑫는 같은 19개 시장(Worldwide + 18개국)·8개 제품.
* 월 범위는 ⑪ 기준(outer merge). 웹이 없는 달(2023-04~12, 2026-04~05)은 웹 변수와 합계가 결측.
*   sessions_visits          = sessions + visits (횟수 합계, 둘 다 있을 때만)
*   time_spent_hours_total   = 앱 사용 시간 + 웹 사용 시간 (둘 다 있을 때만)
* 주의(report 13 §8.1):
*  - 앱 세션(평균 약 2분)과 웹 방문(평균 약 20분, 30분 비활동 기준)은 단위 크기가 달라
*    횟수 합계는 앱 쪽으로 크게 치우친다. 사용량 합계로는 time_spent_hours_total이 더 적절하다.
*  - Worldwide는 범위가 다르다(앱 ④ 시장 수 표기 없음, 웹 ⑤ 56개 시장). Worldwide 합계는 참고용.
*  - 두 값 모두 카테고리 사용량을 True Audience 점유율(⑥)로 나눈 값이므로 합계도 같은 가정을 따른다.
* =============================================================================

version 17
clear all
set more off

if `"$root"' == "" global root "d:/research/AI_effects"
if `"$raw"'  == "" global raw  "$root/data/raw"

local dir "$raw/macro/scaling/sensortower_state_of_ai_2026"

* ---- 웹(⑫) ------------------------------------------------------------------
import delimited using "`dir'/sensortower_genai_web_by_assistant_monthly.csv", ///
    clear varnames(1) encoding(utf8) stringcols(1 2 3 4)
keep market assistant month quarter share_norm_pct visits time_spent_hours
rename share_norm_pct   share_norm_pct_web
rename time_spent_hours time_spent_hours_web
tempfile web
save `web'

* ---- 앱(⑪) ------------------------------------------------------------------
import delimited using "`dir'/sensortower_genai_apps_by_assistant_monthly.csv", ///
    clear varnames(1) encoding(utf8) stringcols(1 2 3 4)
keep market assistant month half_year preliminary share_norm_pct sessions time_spent_hours
rename time_spent_hours time_spent_hours_app

merge 1:1 market assistant month using `web'
* 웹에만 있는 행은 없어야 한다(웹 월 범위가 앱 범위 안에 있음)
assert _merge != 2
gen byte has_web = (_merge == 3)
drop _merge

* 두 파일의 점유율은 같은 ⑥에서 왔으므로 같아야 한다
assert abs(share_norm_pct - share_norm_pct_web) < 1e-3 if has_web
drop share_norm_pct_web

gen double sessions_visits        = sessions + visits                         if has_web
gen double time_spent_hours_total = time_spent_hours_app + time_spent_hours_web if has_web
gen double app_share_count_pct    = 100 * sessions / sessions_visits
gen double app_share_time_pct     = 100 * time_spent_hours_app / time_spent_hours_total

label variable has_web                "1 = 웹 값이 있는 달(2024-01~2026-03)"
label variable sessions               "앱 세션 수(⑪)"
label variable visits                 "웹 방문 수(⑫)"
label variable sessions_visits        "앱 세션 + 웹 방문(회)"
label variable time_spent_hours_app   "앱 사용 시간(시간, ⑪)"
label variable time_spent_hours_web   "웹 사용 시간(시간, ⑫)"
label variable time_spent_hours_total "앱 + 웹 사용 시간(시간)"
label variable app_share_count_pct    "횟수 합계 중 앱 세션 비중(%)"
label variable app_share_time_pct     "사용 시간 합계 중 앱 비중(%)"

* 검증: 행 수, 결측 구조, 음수 없음(출시 전 제품 등 점유율 0인 행은 0, 비중 변수는 결측)
assert _N == 19*8*38
assert has_web == (month >= "2024-01" & month <= "2026-03")
assert sessions_visits >= 0 & time_spent_hours_total >= 0 if has_web

sort market assistant month
order market assistant month half_year quarter preliminary has_web share_norm_pct ///
      sessions visits sessions_visits app_share_count_pct ///
      time_spent_hours_app time_spent_hours_web time_spent_hours_total app_share_time_pct
format sessions visits sessions_visits time_spent_hours_app time_spent_hours_web ///
       time_spent_hours_total %20.0f
format app_share_count_pct app_share_time_pct %9.4f
export delimited using "`dir'/sensortower_genai_apps_web_by_assistant_monthly.csv", replace datafmt

* =============================================================================
* 2부: 제품 구분 없는 카테고리 합계(⑨ + ⑩ → ⑭)
*   매칭 키: market × month. 앱(⑨) 기준 outer merge. 합계는 웹이 있는 2024-01~2026-03, 23개 시장만.
*   주의는 1부와 같다(횟수 합계의 앱 치우침, Worldwide 범위 차이).
* =============================================================================
import delimited using "`dir'/sensortower_genai_web_visits_hours_monthly.csv", ///
    clear varnames(1) encoding(utf8) stringcols(1 2 3)
rename time_spent_hours time_spent_hours_web
tempfile webc
save `webc'

import delimited using "`dir'/sensortower_genai_apps_sessions_hours_monthly.csv", ///
    clear varnames(1) encoding(utf8) stringcols(1 2 3)
rename time_spent_hours time_spent_hours_app

merge 1:1 market month using `webc'
assert _merge != 2
gen byte has_web = (_merge == 3)
drop _merge

gen double sessions_visits        = sessions + visits                           if has_web
gen double time_spent_hours_total = time_spent_hours_app + time_spent_hours_web if has_web
gen double app_share_count_pct    = 100 * sessions / sessions_visits
gen double app_share_time_pct     = 100 * time_spent_hours_app / time_spent_hours_total

label variable has_web                "1 = 웹 값이 있는 시장·달(2024-01~2026-03, China Mainland 제외)"
label variable sessions               "앱 세션 수(⑨)"
label variable visits                 "웹 방문 수(⑩)"
label variable sessions_visits        "앱 세션 + 웹 방문(회)"
label variable time_spent_hours_app   "앱 사용 시간(시간, ⑨)"
label variable time_spent_hours_web   "웹 사용 시간(시간, ⑩)"
label variable time_spent_hours_total "앱 + 웹 사용 시간(시간)"
label variable app_share_count_pct    "횟수 합계 중 앱 세션 비중(%)"
label variable app_share_time_pct     "사용 시간 합계 중 앱 비중(%)"

assert _N == 24*42
assert has_web == (month >= "2024-01" & month <= "2026-03" & market != "China Mainland")
assert sessions_visits > 0 & time_spent_hours_total > 0 if has_web

sort market month
order market month half_year quarter preliminary has_web ///
      sessions visits sessions_visits app_share_count_pct ///
      time_spent_hours_app time_spent_hours_web time_spent_hours_total app_share_time_pct
format sessions visits sessions_visits time_spent_hours_app time_spent_hours_web ///
       time_spent_hours_total %20.0f
format app_share_count_pct app_share_time_pct %9.4f
export delimited using "`dir'/sensortower_genai_apps_web_monthly.csv", replace datafmt
