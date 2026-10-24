* =============================================================================
* 04_13_analysis_aei_v6_structure.do
* Anthropic Economic Index release_2026_06_26(V6)의 공개 범위: 지리 × 범주 × 계층별 지역 수, 노드 수, 지표   (paper 30)
*
* 입력: $raw/usage/anthropic_economic_index/release_2026_06_26/data/
*   aei_claude_ai_2026-06-26.csv, aei_1p_api_2026-06-26.csv
*   행 = 월(date_start) × geo_id × category_name × hierarchy_level × metric_id × node. 값은 소수 둘째 자리 반올림.
* 출력: $results/table/
*   30_aei_v6_structure.xlsx   시트 cells(소스 × 월 × 지리 × 범주 × 계층), kor(한국, 월 × 범주 × 계층), metrics(지표 목록)
*   30_v6_cells.tex   (2026-05, claude_ai 지리 3단계 + 1p_api global)
*   30_v6_kor.tex     (한국, 2026-04·05)
* 정의(작업자 판단):
*   노드 수 = 셀(소스·월·지리·범주·계층) 안 서로 다른 node_external_id 수(지리 단계는 모든 지역 합집합).
*   지표 수 = 서로 다른 metric_id 수. artifact_{label}_pct는 따로 센다.
*   "pct 합" = 한국 행의 pct 값 합(공개된 노드만, 미공개 몫만큼 100보다 작다).
* 이 파일은 표만 만들고 data/proc에는 쓰지 않는다.
* =============================================================================

version 17
clear all
set more off

if `"$root"'    == "" global root    "d:/research/AI_effects"
if `"$raw"'     == "" global raw     "$root/data/raw"
if `"$results"' == "" global results "$root/results"

local src "$raw/usage/anthropic_economic_index/release_2026_06_26/data"
local out "$results/table"
local xl  "`out'/30_aei_v6_structure.xlsx"

* -----------------------------------------------------------------------------
* 1. 읽기
* -----------------------------------------------------------------------------
tempfile all
foreach s in claude_ai 1p_api {
    import delimited using "`src'/aei_`s'_2026-06-26.csv", varnames(1) stringcols(_all) ///
        encoding(utf-8) bindquote(strict) maxquotedrows(unlimited) clear
    generate str9 source = "`s'"
    destring hierarchy_level value, replace
    if "`s'" == "1p_api" append using `all'
    save `all', replace
}
generate str7 month = substr(date_start, 1, 7)
generate byte artifact = strpos(metric_id, "artifact_") == 1
count
assert inlist(month, "2026-04", "2026-05")
assert inlist(geo_level, "global", "country", "subregion")
assert inlist(category_name, "overall", "onet", "request", "soc_occupation")

* 지표 목록
preserve
contract source metric_id artifact
bysort source artifact: generate n_metric = _N
export excel using "`xl'", sheet("metrics") firstrow(variables) replace
restore

* -----------------------------------------------------------------------------
* 2. 셀별 공개 범위
* -----------------------------------------------------------------------------
preserve
egen tag_geo  = tag(source month geo_level category_name hierarchy_level geo_id)
egen tag_node = tag(source month geo_level category_name hierarchy_level node_external_id)
egen tag_met  = tag(source month geo_level category_name hierarchy_level metric_id)
generate byte tag_met_a = tag_met & artifact
generate byte tag_met_n = tag_met & !artifact
generate byte is_pct = metric_id == "pct"
collapse (sum) n_geo = tag_geo n_node = tag_node n_metric = tag_met_n n_artifact = tag_met_a ///
    (count) n_rows = value, by(source month geo_level category_name hierarchy_level)
generate byte g = cond(geo_level == "global", 1, cond(geo_level == "country", 2, 3))
generate byte c = cond(category_name == "overall", 1, cond(category_name == "onet", 2, ///
    cond(category_name == "request", 3, 4)))
generate byte so = source == "1p_api"
sort so month g c hierarchy_level
export excel source month geo_level category_name hierarchy_level n_geo n_node n_metric n_artifact n_rows ///
    using "`xl'", sheet("cells") firstrow(variables) sheetreplace

local lab_overall "overall"
local lab_onet "onet"
local lab_request "request"
local lab_soc_occupation "soc\_occupation"
local lv_overall_0 "전체"
local lv_onet_0 "Task"
local lv_onet_1 "DWA"
local lv_onet_2 "IWA"
local lv_onet_3 "GWA"
local lv_request_0 "Detailed"
local lv_request_1 "Minor"
local lv_request_2 "Major"
local lv_soc_occupation_0 "세부 직업"
local lv_soc_occupation_1 "대분류"
local gl_global "전 세계"
local gl_country "국가"
local gl_subregion "하위 지역"

tempname fh
file open `fh' using "`out'/30_v6_cells.tex", write replace
file write `fh' "% 04_13_analysis_aei_v6_structure.do가 생성. 직접 고치지 말 것." _n
keep if month == "2026-05"
local prev ""
forvalues i = 1/`=_N' {
    local s  = source[`i']
    local gl = geo_level[`i']
    local ct = category_name[`i']
    local lv = hierarchy_level[`i']
    local key "`s' `gl'"
    if "`key'" != "`prev'" & "`prev'" != "" file write `fh' "\midrule" _n
    local lead = cond("`key'" != "`prev'", "`s' / `gl_`gl''", "")
    local lead : subinstr local lead "_" "\_", all
    local prev "`key'"
    local met = cond(n_metric[`i'] == 1, "pct만", "전체 지표")
    if "`ct'" == "overall" local met "전체 지표(pct 없음)"
    file write `fh' "`lead' & `lab_`ct'' & `lv' `lv_`ct'_`lv'' & `=n_geo[`i']' & `=n_node[`i']' & `=n_metric[`i']' & `=n_artifact[`i']' & `met' \\" _n
}
file close `fh'
restore

* -----------------------------------------------------------------------------
* 3. 한국(KOR)
* -----------------------------------------------------------------------------
preserve
keep if source == "claude_ai" & geo_id == "KOR"
egen tag_node = tag(month category_name hierarchy_level node_external_id)
egen tag_met  = tag(month category_name hierarchy_level metric_id)
generate byte tag_met_n = tag_met & !artifact
generate double pctv = value if metric_id == "pct"
collapse (sum) n_node = tag_node n_metric = tag_met_n pct_sum = pctv, by(month category_name hierarchy_level)
replace pct_sum = . if category_name == "overall"
generate byte c = cond(category_name == "overall", 1, cond(category_name == "onet", 2, ///
    cond(category_name == "request", 3, 4)))
replace month = "_" + substr(month, 6, 2)
reshape wide n_node n_metric pct_sum, i(c category_name hierarchy_level) j(month) string
sort c hierarchy_level
export excel using "`xl'", sheet("kor") firstrow(variables) sheetreplace
list, noobs abbreviate(12)
file open `fh' using "`out'/30_v6_kor.tex", write replace
file write `fh' "% 04_13_analysis_aei_v6_structure.do가 생성. 직접 고치지 말 것." _n
forvalues i = 1/`=_N' {
    local ct = category_name[`i']
    local lv = hierarchy_level[`i']
    local a : display %6.2f pct_sum_04[`i']
    local b : display %6.2f pct_sum_05[`i']
    if missing(pct_sum_04[`i']) local a "--"
    if missing(pct_sum_05[`i']) local b "--"
    local met = cond(n_metric_05[`i'] == 1, "pct만", "전체 지표")
    if "`ct'" == "overall" local met "전체 지표(pct 없음)"
    file write `fh' "`lab_`ct'' & `lv' `lv_`ct'_`lv'' & `=n_node_04[`i']' & `=n_node_05[`i']' & `=trim("`a'")' & `=trim("`b'")' & `met' \\" _n
}
file close `fh'
restore
