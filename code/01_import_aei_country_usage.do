* =============================================================================
* 01_import_aei_country_usage.do
* Anthropic Economic Index(Claude.ai): 국가별 대화 비중(usage_pct)과 업무용 대화 비중
*
* 입력: $raw/usage/anthropic_economic_index/
*   release_2026_03_24/data/aei_raw_claude_ai_2026-02-05_to_2026-02-12.csv
*       1주(2026-02-05~02-11) 표본. 행 = geo_id(ISO2) × facet × variable × cluster_name.
*       usage_count = 표본 대화 수(전 세계 표본 100만 건), usage_pct = usage_count / 1e6 × 100
*       use_case_count/pct(cluster_name = work·personal·coursework·none). pct 분모는 그 국가의 usage_count
*   release_2026_06_26/data/aei_claude_ai_2026-06-26.csv
*       월별(2026-04, 2026-05). 행 = geo_id(ISO3) × category_name × metric_id. 건수 없음(소수 둘째 자리).
*       category_name == "overall"의 usage_pct, usage_per_capita_index, use_case_{work,personal,coursework}_pct
* 출력: $proc/usage/anthropic_economic_index/aei_claude_ai_country_usage.{csv,dta}
*   행 = release × period × geo_id (global 1행 + 국가). 국가 코드는 원자료 그대로
*   (03_24는 ISO 3166-1 alpha-2, 06_26은 alpha-3; geo_code_type으로 구분).
* 정의:
*   usage_pct          Claude.ai 전 세계 대화 중 그 국가 비중(%). 분모 = 전 세계(공개되지 않은 국가 포함)
*   use_case_work_pct  그 국가 대화 중 업무용(use case = work) 비중(%)
* 매칭 키: geo_id × period(YYYY-MM). 03_24의 period는 표본 주가 속한 달(2026-02)로 둔다.
* 주의: 03_24의 geo_id "NONE"(국가 미상, 0.234%)은 geo_level = "unknown"으로 둔다.
*   공개 기준(표본 하한)에 못 미친 국가는 행이 없다. 06_26은 공개 국가 합계가 100%가 아니다
*   (2026-04 82.0%, 2026-05 87.5%). 범위는 Claude.ai(Free·Pro·Max, 06_26은 Cowork 포함)이고
*   API·Claude Code는 빠진다.
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
* release_2026_03_24 (1주, 건수 포함)
* -----------------------------------------------------------------------------
import delimited using "`aei'/release_2026_03_24/data/aei_raw_claude_ai_2026-02-05_to_2026-02-12.csv", ///
    varnames(1) encoding("utf-8") bindquote(strict) stringcols(1/9) asdouble clear
keep if inlist(geography, "country", "global")
keep if (facet == "country" & inlist(variable, "usage_count", "usage_pct")) | ///
        (facet == "use_case" & inlist(variable, "use_case_count", "use_case_pct"))
generate str40 v = variable
replace v = cond(variable == "use_case_count", "uc_", "up_") + cluster_name if facet == "use_case"
keep geo_id geography date_start date_end v value
reshape wide value, i(geo_id geography date_start date_end) j(v) string
rename value* *

* GLOBAL에는 country facet 행이 없다: 건수는 use case 건수 합계(= 표본 100만 건), 비중은 100
egen double uc_total = rowtotal(uc_*)
replace usage_count = uc_total if geography == "global"
replace usage_pct   = 100      if geography == "global"
assert !missing(usage_count, usage_pct)
quietly summarize usage_count if geography == "global", meanonly
local n_global = r(mean)
assert abs(usage_pct - 100 * usage_count / `n_global') < 1e-6
* use case 셀은 공개 기준 미달이면 빠진다(소국). 비중은 원자료 use_case_pct를 쓰고
* (분모 = 그 국가 usage_count), 업무용 셀이 없는 국가는 결측으로 둔다.
assert uc_total <= usage_count
assert abs(up_work - 100 * uc_work / usage_count) < 1e-6 if !missing(up_work)
rename (up_work up_personal up_coursework uc_work) ///
    (use_case_work_pct use_case_personal_pct use_case_coursework_pct work_count)
drop uc_* up_*
generate double usage_per_capita_index = .
generate str8 release = "20260324"
generate str7 period  = substr(date_start, 1, 7)
* geo_id "NONE" = 국가를 알 수 없는 대화(2026-02 0.234%). 국가와 구분해 geo_level = "unknown"
replace geography = "unknown" if geo_id == "NONE"
generate str7 geo_code_type = cond(geography == "country", "alpha2", geography)
rename geography geo_level
tempfile r0324
save `r0324'

* -----------------------------------------------------------------------------
* release_2026_06_26 (월별, 비중만)
* -----------------------------------------------------------------------------
import delimited using "`aei'/release_2026_06_26/data/aei_claude_ai_2026-06-26.csv", ///
    varnames(1) encoding("utf-8") bindquote(strict) stringcols(1/7 9 10) asdouble clear
keep if inlist(geo_level, "country", "global") & category_name == "overall" & geo_id != "not_classified"
keep if inlist(metric_id, "usage_pct", "usage_per_capita_index", ///
    "use_case_work_pct", "use_case_personal_pct", "use_case_coursework_pct")
keep date_start date_end geo_id geo_level metric_id value
reshape wide value, i(date_start date_end geo_id geo_level) j(metric_id) string
rename value* *
assert !missing(usage_pct)
generate double usage_count = .
generate double work_count  = .
generate str8 release = "20260626"
generate str7 period  = substr(date_start, 1, 7)
generate str7 geo_code_type = cond(geo_level == "global", "global", "alpha3")

append using `r0324'

isid release period geo_id
label variable release        "AEI release(YYYYMMDD)"
label variable period         "기간이 속한 달(YYYY-MM)"
label variable date_start     "집계 시작일(포함)"
label variable date_end       "집계 종료일(제외)"
label variable geo_id         "국가 코드(원자료 그대로) 또는 GLOBAL"
label variable geo_level      "global / country / unknown(03_24 NONE)"
label variable geo_code_type  "alpha2(03_24) / alpha3(06_26) / global / unknown"
label variable usage_count    "표본 대화 수(03_24만)"
label variable usage_pct      "Claude.ai 전 세계 대화 중 비중(%)"
label variable usage_per_capita_index "Anthropic AI Usage Index(06_26만)"
label variable work_count     "업무용 표본 대화 수(03_24만)"
label variable use_case_work_pct       "업무용 대화 비중(%)"
label variable use_case_personal_pct   "개인용 대화 비중(%)"
label variable use_case_coursework_pct "학업용 대화 비중(%)"
order release period date_start date_end geo_level geo_code_type geo_id usage_count usage_pct ///
    usage_per_capita_index work_count use_case_work_pct use_case_personal_pct use_case_coursework_pct
sort release period geo_level geo_id
compress
save "`out'/aei_claude_ai_country_usage.dta", replace
export delimited using "`out'/aei_claude_ai_country_usage.csv", replace

* 확인용: 기간별 공개 국가 수와 usage_pct 합계
tabstat usage_pct use_case_work_pct if geo_level == "country", by(period) statistics(count sum) format(%9.2f)
