* =============================================================================
* 02_clean_sensortower_usage_monthly_by_assistant.do
* Sensor Tower "State of AI 2026": 생성형 AI 앱 세션·웹 방문 사용량의 월별 변환과 제품별 분해
*
* 입력($raw/macro/scaling/sensortower_state_of_ai_2026/)
*   sensortower_genai_apps_sessions_hours_halfyear_long.csv  ④ 앱 세션 수·사용 시간, 시장 × 반기
*   sensortower_genai_web_visits_hours_quarterly_long.csv    ⑤ 웹 방문 수·사용 시간, 시장 × 분기
*   sensortower_true_audience_share_monthly_long.csv         ⑥ True Audience 제품별 점유율, 시장 × 제품 × 월
* 출력(입력과 같은 폴더. 사용자 지정 위치로, CLAUDE.md의 data/proc 규칙의 예외. log.md 2026-09-28 참고)
*   sensortower_genai_apps_sessions_hours_monthly.csv       ④의 월별 값(Denton 보간), 시장 × 월
*   sensortower_genai_web_visits_hours_monthly.csv          ⑤의 월별 값(Denton 보간), 시장 × 월
*   sensortower_genai_apps_by_assistant_monthly.csv         월별 ④를 ⑥으로 분해, 시장 × 제품 × 월
*   sensortower_genai_web_by_assistant_monthly.csv          월별 ⑤를 ⑥으로 분해, 시장 × 제품 × 월
*
* 1) 월별 변환: 비례 Denton(1차 차분). 시장·변수별로
*      min Σ_t (x_t/z_t − x_{t−1}/z_{t−1})²   s.t.  각 반기(분기)의 월별 합 = 원래 반기(분기) 값
*    을 풀어 월별 값을 만든다. 지표 계열 z_t는 기간 월평균(값 ÷ 개월 수)의 로그를 각 기간의
*    중앙 달 사이에서 선형 보간한 것(첫·마지막 기간 바깥은 인접 구간의 기울기로 연장)이다.
*    즉 월별 값은 로그 선형 추세를 따르되 기간 합계에 맞게 매끄럽게 조정된다.
*    가법 Denton(z_t = 1)은 앱 2023H1→H2처럼 값이 몇 배로 뛰는 구간에서 음수 월 값을 만들어
*    쓰지 않았다. 월별 값을 기간별로 더하면 원래 값과 같다(아래에서 assert).
*    앱 2026H1은 6월 말까지 투영한 예비 추정치이므로 그 6개월에 preliminary = 1을 붙인다.
* 2) 제품별 분해: 월별 값 × ⑥ 점유율. ⑥은 소수 첫째 자리 반올림으로 합계가 99.8–100.3이므로
*    시장·월별 합계로 나눠 100이 되게 한 share_norm_pct를 쓴다(제품별 값의 합 = 카테고리 월별 값).
*    매칭 키: market(시장 이름, 두 파일 표기 같음) × month(YYYY-MM).
*    ⑥이 있는 19개 시장(Worldwide + 18개국), 2023-04~2026-05만 분해된다.
* 주의(해석):
*  - ④·⑤는 생성형 AI 카테고리 전체(AI 컴패니언·이미지 생성 앱 등 포함)의 값이고, ⑥은 AI 어시스턴트
*    7개 + Other(다른 어시스턴트)의 이용자 점유율이다. 분해 값은 "카테고리 사용량을 어시스턴트
*    이용자 점유율대로 나눈다"는 가정 아래의 값이며, 제품별 실제 사용량이 아니다.
*  - 이용자 1명당 사용량이 제품마다 같다고 가정한다. 앱·웹 경로별 점유율 차이도 반영하지 않는다.
*  - Worldwide 범위가 다르다: ④ 표기 없음, ⑤ 56개 시장, ⑥ 25개 시장.
* =============================================================================

version 17
clear all
set more off

if `"$root"' == "" global root "d:/research/AI_effects"
if `"$raw"'  == "" global raw  "$root/data/raw"

local dir "$raw/macro/scaling/sensortower_state_of_ai_2026"

* -----------------------------------------------------------------------------
* Denton 가법 1차 차분 보간(Mata)
*   denton_panel(): 시장(panel) × 기간 순으로 정렬된 기간 자료에서 변수 하나를 받아,
*   같은 순서로 m배 늘린(expand) 자료의 새 변수에 월별 값을 채운다.
* -----------------------------------------------------------------------------
mata:
real colvector denton(real colvector y, real scalar m)
{
    real scalar    K, n
    real matrix    C, D, A
    real colvector b, s, t, lv, mid, slope, kk, z
    K = rows(y)
    n = K*m
    // 지표 계열 z: 기간 월평균의 로그를 기간 중앙 달 사이에서 선형 보간(양 끝은 연장)
    t     = (1::n)
    lv    = ln(y :/ m)
    mid   = ((1::K) :- 0.5) :* m :+ 0.5
    slope = (lv[|2 \ K|] - lv[|1 \ K-1|]) :/ m
    kk    = floor((t :- 0.5) :/ m :- 0.5) :+ 1
    kk    = rowmin((rowmax((kk, J(n, 1, 1))), J(n, 1, K-1)))
    z     = exp(lv[kk] + slope[kk] :* (t - mid[kk]))
    // 비례 Denton: min Σ (x_t/z_t − x_{t−1}/z_{t−1})²  s.t. 기간 합계 보존. r = x/z로 풀고 x = z·r
    C = (I(K) # J(1, m, 1)) :* z'                           // 기간 합계 행렬 × diag(z)
    D = (J(n-1, 1, 0), I(n-1)) - (I(n-1), J(n-1, 1, 0))     // 1차 차분 행렬
    A = (2*D'*D, C') \ (C, J(K, K, 0))
    b = J(n, 1, 0) \ y
    s = lusolve(A, b)
    return(z :* s[|1 \ n|])
}

real colvector denton_panel(string scalar var, string scalar pvar, real scalar m)
{
    real colvector y, p, out
    real matrix    info
    real scalar    j
    y = st_data(., var); p = st_data(., pvar)
    info = panelsetup(p, 1)
    out = J(0, 1, .)
    for (j = 1; j <= rows(info); j++) out = out \ denton(y[|info[j,1] \ info[j,2]|], m)
    return(out)
}
end

* -----------------------------------------------------------------------------
* 1) 앱: 반기 → 월
* -----------------------------------------------------------------------------
import delimited using "`dir'/sensortower_genai_apps_sessions_hours_halfyear_long.csv", ///
    varnames(1) encoding("utf-8") stringcols(1 2) asdouble clear
assert sessions > 0 & time_spent_hours > 0 & !missing(sessions, time_spent_hours)
isid market half_year
generate int yr = real(substr(half_year, 1, 4))
generate byte h = real(substr(half_year, 6, 1))
sort market yr h
by market: assert _N == 7                                   // 2023H1~2026H1
egen int pid = group(market)
mata: st_matrix("A_s", denton_panel("sessions", "pid", 6)); st_matrix("A_h", denton_panel("time_spent_hours", "pid", 6))
expand 6
sort market yr h
by market yr h: generate byte sub = _n
generate str7 month = string(yr) + "-" + string((h - 1)*6 + sub, "%02.0f")
rename (sessions time_spent_hours) (hy_sessions hy_time_spent_hours)
svmat double A_s, names(sessions)
svmat double A_h, names(time_spent_hours)
rename (sessions1 time_spent_hours1) (sessions time_spent_hours)
* 검증: 월별 합 = 반기 값
foreach v in sessions time_spent_hours {
    bysort market half_year: egen double chk = total(`v')
    assert reldif(chk, hy_`v') < 1e-9
    drop chk
}
assert sessions > 0
assert time_spent_hours > 0
keep market month half_year preliminary sessions time_spent_hours
order market month half_year preliminary sessions time_spent_hours
label variable sessions         "월별 세션 수(Denton 보간, 반기 합계 보존)"
label variable time_spent_hours "월별 사용 시간(시간, Denton 보간, 반기 합계 보존)"
label variable preliminary      "1 = 2026H1 예비 추정치에서 나온 달"
sort market month
format sessions time_spent_hours %20.0f
tempfile apps
save `apps'
export delimited using "`dir'/sensortower_genai_apps_sessions_hours_monthly.csv", replace datafmt

* -----------------------------------------------------------------------------
* 2) 웹: 분기 → 월
* -----------------------------------------------------------------------------
import delimited using "`dir'/sensortower_genai_web_visits_hours_quarterly_long.csv", ///
    varnames(1) encoding("utf-8") stringcols(1 2) asdouble clear
assert visits > 0 & time_spent_hours > 0 & !missing(visits, time_spent_hours)
isid market quarter
generate int yr = real(substr(quarter, 1, 4))
generate byte q = real(substr(quarter, 6, 1))
sort market yr q
by market: assert _N == 9                                   // 2024Q1~2026Q1
egen int pid = group(market)
mata: st_matrix("W_v", denton_panel("visits", "pid", 3)); st_matrix("W_h", denton_panel("time_spent_hours", "pid", 3))
expand 3
sort market yr q
by market yr q: generate byte sub = _n
generate str7 month = string(yr) + "-" + string((q - 1)*3 + sub, "%02.0f")
rename (visits time_spent_hours) (q_visits q_time_spent_hours)
svmat double W_v, names(visits)
svmat double W_h, names(time_spent_hours)
rename (visits1 time_spent_hours1) (visits time_spent_hours)
foreach v in visits time_spent_hours {
    bysort market quarter: egen double chk = total(`v')
    assert reldif(chk, q_`v') < 1e-9
    drop chk
}
assert visits > 0
assert time_spent_hours > 0
keep market month quarter visits time_spent_hours
order market month quarter visits time_spent_hours
label variable visits           "월별 방문 수(Denton 보간, 분기 합계 보존)"
label variable time_spent_hours "월별 사용 시간(시간, Denton 보간, 분기 합계 보존)"
sort market month
format visits time_spent_hours %20.0f
tempfile web
save `web'
export delimited using "`dir'/sensortower_genai_web_visits_hours_monthly.csv", replace datafmt

* -----------------------------------------------------------------------------
* 3) ⑥ True Audience 점유율: 합계 100으로 정규화
* -----------------------------------------------------------------------------
import delimited using "`dir'/sensortower_true_audience_share_monthly_long.csv", ///
    varnames(1) encoding("utf-8") stringcols(1 2 3) asdouble clear
assert !missing(share_pct)
isid market assistant month
bysort market month: egen double share_sum = total(share_pct)
generate double share_norm_pct = 100 * share_pct / share_sum
drop share_sum
tempfile share
save `share'

* -----------------------------------------------------------------------------
* 4) 제품별 분해
* -----------------------------------------------------------------------------
foreach src in apps web {
    use `share', clear
    merge m:1 market month using ``src'', keep(match master)
    * ⑥의 모든 시장이 사용량 자료에 있어야 한다. 사용량 자료 기간 밖의 달만 매칭되지 않는다.
    if "`src'" == "apps" {
        assert _merge == 3
        local vars sessions time_spent_hours
        local keepx half_year preliminary
    }
    else {
        assert _merge == 3 if month >= "2024-01" & month <= "2026-03"
        keep if _merge == 3
        local vars visits time_spent_hours
        local keepx quarter
    }
    drop _merge
    foreach v of local vars {
        rename `v' total_`v'
        generate double `v' = total_`v' * share_norm_pct / 100
        bysort market month: egen double chk = total(`v')
        assert reldif(chk, total_`v') < 1e-9
        drop chk
    }
    order market assistant month `keepx' share_pct share_norm_pct `vars' total_*
    label variable share_pct      "⑥ True Audience 점유율(%, 원 값)"
    label variable share_norm_pct "⑥ 점유율을 시장·월 합계 100으로 정규화(%)"
    sort market assistant month
    format `vars' total_* %20.0f
    format share_norm_pct %9.4f
    export delimited using "`dir'/sensortower_genai_`src'_by_assistant_monthly.csv", replace datafmt
    quietly count
    display "`src' by assistant rows = " r(N)
}
