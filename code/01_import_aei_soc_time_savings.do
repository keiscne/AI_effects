* =============================================================================
* 01_import_aei_soc_time_savings.do
* Anthropic Economic Index(Claude.ai): SOC 세부 직업(6자리)별 과업 소요 시간과 AI로 줄어든 시간
*
* 입력: $raw/usage/anthropic_economic_index/release_2026_06_26/data/aei_claude_ai_2026-06-26.csv
*   행 = 월 × geo_id × category_name × hierarchy_level × metric_id × node. 값은 소수 둘째 자리 반올림.
*   사용: geo_id == "GLOBAL", category_name == "soc_occupation", hierarchy_level == 0(세부 직업),
*         metric_id ∈ {pct, human_only_time_mean, human_with_ai_time_mean}, 2026-04·2026-05.
*   세부 직업의 시간 지표는 GLOBAL에만 공개된다(국가·지역은 세부 직업 pct만, data_documentation.md).
*   node_external_id = O*NET-SOC 8자리 코드(XX-XXXX.XX; 2026-04 696개, 2026-05 718개).
*
* 출력: $proc/usage/anthropic_economic_index/
*   1. aei_soc6_time_savings_monthly.{csv,dta}   월 × soc6
*   2. aei_soc6_time_savings.{csv,dta}           soc6 (2026-04·05 합침) → 직업 단위 exposure 지표와 결합용
*
* 단위 통일(data_documentation.md "Metrics"):
*   human_only_time_mean     = 시간(hours)   → × 60 해서 분(minutes)으로
*   human_with_ai_time_mean  = 분(minutes)
*   time_saved_min = human_only_min − human_with_ai_min (분), time_saved_hr = time_saved_min / 60
*
* 8자리 → 6자리: soc6 = soc_code 앞 7자리(XX-XXXX, SOC 2018 세부 직업).
*   한 soc6에 8자리 코드가 여럿이면 대화 비중 pct로 가중평균한다(각 지표가 대화 평균이므로).
*   차이는 8자리에서 먼저 계산한 뒤 같은 가중치로 평균한다(두 지표 평균의 차이와 같음).
*   pct가 0.00으로 반올림된 코드(실제 값 0~0.005%)는 가중치를 구간 중점 0.0025로 둔다.
*   비교용으로 단순평균(*_uw)도 둔다.
*   두 달을 합칠 때도 같은 가중치(월별 pct)를 쓴다: 두 달 전체 대화 수가 같다고 가정.
*
* 매칭 키(결합 시, 이 파일에서는 결합하지 않음):
*   soc6(str7, XX-XXXX) = labor_market_impacts/job_exposure.csv의 occ_code(SOC 2018, observed exposure)
*                       = Eloundou occ_level.csv O*NET-SOC 코드 앞 7자리(SOC 2018 기반)
*   Felten AIOE는 SOC 2010이므로 01_import_felten_aioe.do에서 SOC 2018로 변환한 파일을 쓴다.
*
* 주의:
*   - AEI의 SOC는 사용자의 직업이 아니라 대화 과업이 속한 직업이다.
*   - 시간은 Claude가 대화별로 추정한 값의 평균이다(실측 아님). 범위는 전 세계 Claude.ai.
*   - 공개 기준에 못 미친 직업은 행이 없다(결측 ≠ 0).
*   - 2026-05 51-5113.00은 human_only_time_mean이 공개되지 않아 차이 계산에서 뺀다.
* =============================================================================

version 17
clear all
set more off

if `"$root"' == "" global root "d:/research/AI_effects"
if `"$raw"'  == "" global raw  "$root/data/raw"
if `"$proc"' == "" global proc "$root/data/proc"

local aei "$raw/usage/anthropic_economic_index"
local out "$proc/usage/anthropic_economic_index"
capture mkdir "`out'"

* -----------------------------------------------------------------------------
* 1. GLOBAL 세부 직업(O*NET-SOC 8자리) × 월
* -----------------------------------------------------------------------------
import delimited using "`aei'/release_2026_06_26/data/aei_claude_ai_2026-06-26.csv", ///
    varnames(1) encoding("utf-8") bindquote(strict) stringcols(1/7 9 10) asdouble clear
keep if geo_id == "GLOBAL" & category_name == "soc_occupation" & hierarchy_level == "0"
keep if inlist(metric_id, "pct", "human_only_time_mean", "human_with_ai_time_mean")
generate str7 month = substr(date_start, 1, 7)
keep month node_external_id node_name metric_id value
reshape wide value, i(month node_external_id) j(metric_id) string   // node_name은 코드 안에서 상수
rename (valuepct valuehuman_only_time_mean valuehuman_with_ai_time_mean node_external_id node_name) ///
    (pct human_only_hr human_with_ai_min soc_code soc_title)
isid month soc_code
assert regexm(soc_code, "^[0-9][0-9]-[0-9][0-9][0-9][0-9]\.[0-9][0-9]$")
assert !missing(pct, human_with_ai_min)
count if missing(human_only_hr)
assert r(N) == 1
list month soc_code soc_title pct human_with_ai_min if missing(human_only_hr), noobs
tabulate month

* 단위 통일(분)과 차이
generate double human_only_min = 60 * human_only_hr
generate double time_saved_min = human_only_min - human_with_ai_min
generate double w = cond(pct == 0, 0.0025, pct)
generate str7 soc6 = substr(soc_code, 1, 7)
generate byte is00 = substr(soc_code, 9, 2) == "00"

* 8자리 대화 비중 합계(확인용; 미공개 직업 몫만큼 100보다 작다)
tabstat pct, by(month) statistics(count sum) format(%9.2f)
summarize human_only_min human_with_ai_min time_saved_min, detail

* 6자리 명칭: .00 코드 명칭 우선, 없으면 그 soc6에서 pct가 가장 큰 코드의 명칭(두 달 통틀어)
preserve
gsort soc6 -is00 -pct soc_code
by soc6: keep if _n == 1
keep soc6 soc_title
rename soc_title soc6_title
tempfile titles
save `titles'
restore

drop if missing(human_only_hr)
tempfile onet8
save `onet8'

* -----------------------------------------------------------------------------
* 2. 월 × soc6
* -----------------------------------------------------------------------------
generate double w_only  = w * human_only_min
generate double w_ai    = w * human_with_ai_min
generate double w_saved = w * time_saved_min
collapse (sum) pct w w_only w_ai w_saved ///
    (mean) human_only_min_uw = human_only_min human_with_ai_min_uw = human_with_ai_min ///
           time_saved_min_uw = time_saved_min ///
    (count) n_onet = pct (max) has00 = is00, by(month soc6)
generate double human_only_min    = w_only  / w
generate double human_with_ai_min = w_ai    / w
generate double time_saved_min    = w_saved / w
assert abs(time_saved_min - (human_only_min - human_with_ai_min)) < 1e-9
assert abs(time_saved_min_uw - (human_only_min_uw - human_with_ai_min_uw)) < 1e-9
generate double time_saved_hr = time_saved_min / 60
drop w_only w_ai w_saved
rename w weight
merge m:1 soc6 using `titles', keep(match) nogenerate
isid month soc6
tabulate month

label variable month              "월(YYYY-MM)"
label variable soc6               "SOC 2018 세부 직업 6자리(XX-XXXX)"
label variable soc6_title         "직업 명칭(.00 코드 우선, AEI node_name)"
label variable pct                "AEI 전 세계 대화 중 비중(%, 합친 8자리 코드 합계)"
label variable weight             "가중치 합계(pct, 0.00은 0.0025)"
label variable n_onet             "합친 O*NET-SOC 8자리 코드 수"
label variable has00              "1 = .00 코드가 공개됨"
label variable human_only_min     "AI 없이 사람이 걸리는 시간(분, pct 가중평균)"
label variable human_with_ai_min  "AI와 함께 걸리는 시간(분, pct 가중평균)"
label variable time_saved_min     "human_only − human_with_ai (분, pct 가중평균)"
label variable time_saved_hr      "human_only − human_with_ai (시간)"
label variable human_only_min_uw    "AI 없이 걸리는 시간(분, 8자리 단순평균)"
label variable human_with_ai_min_uw "AI와 함께 걸리는 시간(분, 8자리 단순평균)"
label variable time_saved_min_uw    "human_only − human_with_ai (분, 8자리 단순평균)"
order month soc6 soc6_title pct weight n_onet has00 human_only_min human_with_ai_min ///
    time_saved_min time_saved_hr human_only_min_uw human_with_ai_min_uw time_saved_min_uw
sort month soc6
format pct weight human_only_min human_with_ai_min time_saved_min time_saved_hr *_uw %9.2f
compress
save "`out'/aei_soc6_time_savings_monthly.dta", replace
export delimited using "`out'/aei_soc6_time_savings_monthly.csv", replace

tabstat time_saved_min human_only_min human_with_ai_min, by(month) ///
    statistics(count mean p50 min max) format(%9.1f)

* -----------------------------------------------------------------------------
* 3. soc6 (2026-04·05 합침)
* -----------------------------------------------------------------------------
use `onet8', clear
generate double w_only  = w * human_only_min
generate double w_ai    = w * human_with_ai_min
generate double w_saved = w * time_saved_min
bysort soc6 month: generate byte tag_m = _n == 1
collapse (sum) w w_only w_ai w_saved n_months = tag_m ///
    (mean) human_only_min_uw = human_only_min human_with_ai_min_uw = human_with_ai_min ///
           time_saved_min_uw = time_saved_min ///
    (max) has00 = is00, by(soc6)
generate double human_only_min    = w_only  / w
generate double human_with_ai_min = w_ai    / w
generate double time_saved_min    = w_saved / w
assert abs(time_saved_min - (human_only_min - human_with_ai_min)) < 1e-9
generate double time_saved_hr = time_saved_min / 60
drop w_only w_ai w_saved
rename w weight
merge 1:1 soc6 using `titles', keep(match) nogenerate
isid soc6
tabulate n_months

label variable soc6               "SOC 2018 세부 직업 6자리(XX-XXXX)"
label variable soc6_title         "직업 명칭(.00 코드 우선, AEI node_name)"
label variable weight             "가중치 합계(두 달 pct, 0.00은 0.0025)"
label variable n_months           "값이 있는 달 수(2026-04·05 중)"
label variable has00              "1 = .00 코드가 공개됨(어느 달이든)"
label variable human_only_min     "AI 없이 사람이 걸리는 시간(분, pct 가중평균)"
label variable human_with_ai_min  "AI와 함께 걸리는 시간(분, pct 가중평균)"
label variable time_saved_min     "human_only − human_with_ai (분, pct 가중평균)"
label variable time_saved_hr      "human_only − human_with_ai (시간)"
label variable human_only_min_uw    "AI 없이 걸리는 시간(분, 8자리 × 월 단순평균)"
label variable human_with_ai_min_uw "AI와 함께 걸리는 시간(분, 8자리 × 월 단순평균)"
label variable time_saved_min_uw    "human_only − human_with_ai (분, 8자리 × 월 단순평균)"
order soc6 soc6_title weight n_months has00 human_only_min human_with_ai_min ///
    time_saved_min time_saved_hr human_only_min_uw human_with_ai_min_uw time_saved_min_uw
sort soc6
format weight human_only_min human_with_ai_min time_saved_min time_saved_hr *_uw %9.2f
compress
save "`out'/aei_soc6_time_savings.dta", replace
export delimited using "`out'/aei_soc6_time_savings.csv", replace

summarize time_saved_min, detail
correlate time_saved_min time_saved_min_uw
count if time_saved_min < 0
gsort -time_saved_min
list soc6 soc6_title time_saved_min human_only_min human_with_ai_min in 1/10, noobs abbreviate(20)
gsort time_saved_min
list soc6 soc6_title time_saved_min human_only_min human_with_ai_min in 1/10, noobs abbreviate(20)
