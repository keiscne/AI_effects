* =============================================================================
* 04_analysis_sensortower_aei_country_share.do
* Sensor Tower 기반 18개국 메시지 비중 vs Anthropic Economic Index(AEI) Claude 대화 비중
*   (전체, 업무용) — 2026-02(AEI 03_24, 1주), 2026-04·05(AEI 06_26, 월별)
*
* 입력:
*   $proc/macro/scaling/sensortower_state_of_ai_2026/sensortower_work_messages_by_country_monthly.dta
*       (03_merge_sensortower_openai_messages.do: 국가별 메시지, Signals 업무용 비중, 업무용 메시지)
*   $raw/macro/scaling/sensortower_state_of_ai_2026/sensortower_share_within_product_monthly_long.dta
*       (02_clean_sensortower_share_within_product.do: 제품별 국가 이용자 수, Claude만 사용)
*   $proc/usage/anthropic_economic_index/aei_claude_ai_country_usage.dta
*       (01_import_aei_country_usage.do: usage_pct, use_case_work_pct)
* 출력: $results/table/
*   18_sensortower_aei_country_share.xlsx  (시트 panel = 국가 × 기간 전체 변수, summary = 요약 통계)
*   18_share_{202602,202604,202605}.tex, 18_work_level.tex, 18_work_share.tex, 18_summary.tex
*
* 비교 대상(모두 18개국 합계를 100으로 다시 정규화한 비중, %):
*   st_all    Sensor Tower 8개 제품 메시지 비중. 1인당 메시지 수가 상수라 이용자(all_users) 비중과 같다
*   st_cl     Sensor Tower Claude 이용자 비중(Claude 메시지 비중과 같음, 가정 A1)
*   aei       AEI Claude.ai 대화 비중 = usage_pct / Σ18 usage_pct
*   st_work   Sensor Tower 업무용 메시지 비중 = work_messages / Σ18 (Signals ChatGPT 국가별 업무 비중 사용)
*   st_clwork Claude 이용자 × Signals 업무 비중의 비중(제품 구성 차이를 뺀 비교용)
*   aei_work  AEI 업무용 대화 비중 = usage_pct × use_case_work_pct / Σ18
* 업무용 비중 수준: Signals ChatGPT work_share(국가별) vs AEI use_case_work_pct(국가별).
* 요약 통계: Pearson 상관, Spearman 순위 상관, 비유사도 지수 D = ½ Σ|a − b| (%p; 0 = 같음, 100 = 완전 분리).
* 매칭 키: Sensor Tower 시장명 ↔ ISO2(AEI 03_24) / ISO3(AEI 06_26) (아래 표) × 달(YYYY-MM).
*   AEI 03_24는 2026-02-05~02-11 1주 표본이며 Sensor Tower 2026-02(월간)와 짝지운다.
* 주의: AEI 분모는 Claude.ai 전 세계(공개 안 된 국가 포함)라 원 비중은 Sensor Tower(25개 시장)와
*   범위가 달라, 비교는 18개국 안 비중으로 한다. AEI 06_26 값은 소수 둘째 자리로 반올림되어 있다.
*   Signals 업무 분류(work_related)와 AEI use case(work/personal/coursework)는 분류 기준이 다르다.
* =============================================================================

version 17
clear all
set more off

if `"$root"'    == "" global root    "d:/research/AI_effects"
if `"$raw"'     == "" global raw     "$root/data/raw"
if `"$proc"'    == "" global proc    "$root/data/proc"
if `"$results"' == "" global results "$root/results"

local stp "$proc/macro/scaling/sensortower_state_of_ai_2026"
local str "$raw/macro/scaling/sensortower_state_of_ai_2026"
local out "$results/table"
local periods "2026-02 2026-04 2026-05"

* -----------------------------------------------------------------------------
* 0. 국가 대응표
* -----------------------------------------------------------------------------
clear
input str20 market str2 iso2 str3 iso3 str30 kname
"Argentina"      "AR" "ARG" "아르헨티나"
"Australia"      "AU" "AUS" "호주"
"Brazil"         "BR" "BRA" "브라질"
"Canada"         "CA" "CAN" "캐나다"
"France"         "FR" "FRA" "프랑스"
"Germany"        "DE" "DEU" "독일"
"India"          "IN" "IND" "인도"
"Indonesia"      "ID" "IDN" "인도네시아"
"Italy"          "IT" "ITA" "이탈리아"
"Japan"          "JP" "JPN" "일본"
"Mexico"         "MX" "MEX" "멕시코"
"South Korea"    "KR" "KOR" "한국"
"Spain"          "ES" "ESP" "스페인"
"Taiwan"         "TW" "TWN" "대만"
"Turkey"         "TR" "TUR" "튀르키예"
"United Kingdom" "GB" "GBR" "영국"
"United States"  "US" "USA" "미국"
"Vietnam"        "VN" "VNM" "베트남"
end
assert _N == 18
tempfile cmap
save `cmap'

* -----------------------------------------------------------------------------
* 1. AEI: 18개국과 GLOBAL
* -----------------------------------------------------------------------------
use "$proc/usage/anthropic_economic_index/aei_claude_ai_country_usage.dta", clear
keep if inlist(period, "2026-02", "2026-04", "2026-05")
preserve
    keep if geo_level == "global"
    keep period use_case_work_pct
    rename use_case_work_pct aei_work_pct_global
    tempfile aeig
    save `aeig'
restore
* 18개국 밖을 포함한 공개 국가 합계(커버리지 확인용)
bysort period: egen double aei_pub_sum = total(usage_pct * (geo_level == "country"))
keep if geo_level == "country"
generate str2 iso2 = geo_id if geo_code_type == "alpha2"
generate str3 iso3 = geo_id if geo_code_type == "alpha3"
tempfile aei
save `aei'

use `cmap', clear
expand 3
bysort market: generate str7 period = word("`periods'", _n)
generate str2 k2 = iso2
generate str3 k3 = iso3
* 03_24(ISO2)와 06_26(ISO3)를 각각 붙인다
preserve
    use `aei', clear
    keep if geo_code_type == "alpha2"
    keep period iso2 usage_pct use_case_work_pct aei_pub_sum
    rename iso2 k2
    tempfile a2
    save `a2'
    use `aei', clear
    keep if geo_code_type == "alpha3"
    keep period iso3 usage_pct use_case_work_pct aei_pub_sum
    rename iso3 k3
    tempfile a3
    save `a3'
restore
merge 1:1 period k2 using `a2', keep(master match) nogenerate
merge 1:1 period k3 using `a3', keep(master match match_update) update nogenerate
drop k2 k3
assert !missing(usage_pct, use_case_work_pct)                // 18개국 모두 세 기간에 공개됨
merge m:1 period using `aeig', assert(match using) keep(match) nogenerate

* -----------------------------------------------------------------------------
* 2. Sensor Tower: 국가별 메시지·업무용 메시지, Claude 이용자
* -----------------------------------------------------------------------------
rename period month
merge 1:1 market month using "`stp'/sensortower_work_messages_by_country_monthly.dta", ///
    keepusing(all_users messages work_share work_messages) keep(master match)
assert _merge == 3
drop _merge
preserve
    use "`str'/sensortower_share_within_product_monthly_long.dta", clear
    keep if assistant == "Claude" & residual == 0
    keep market month unique_users share_within_product_pct
    rename (unique_users share_within_product_pct) (claude_users st_cl_ww_pct)
    tempfile cl
    save `cl'
restore
merge 1:1 market month using `cl', keep(master match)
assert _merge == 3
drop _merge
merge 1:1 market month using "`str'/sensortower_share_all_products_monthly_long.dta", ///
    keepusing(share_all_products_pct) keep(master match)
assert _merge == 3
drop _merge
rename share_all_products_pct st_all_ww_pct

* Signals 전 세계 업무 비중(03 do 파일 출력의 worldwide 파일에 있음)
preserve
    use "`stp'/sensortower_work_messages_worldwide_monthly.dta", clear
    keep month work_share_global
    tempfile sigg
    save `sigg'
restore
merge m:1 month using `sigg', keep(master match)
assert _merge == 3
drop _merge

* -----------------------------------------------------------------------------
* 3. 18개국 안 비중
* -----------------------------------------------------------------------------
generate double aei_workc   = usage_pct * use_case_work_pct / 100   // 전 세계 대화 중 그 국가 업무용(%)
generate double claude_work = claude_users * work_share
foreach v in messages claude_users usage_pct work_messages claude_work aei_workc {
    bysort month: egen double S_`v' = total(`v')
}
generate double st_all    = 100 * messages      / S_messages
generate double st_cl     = 100 * claude_users  / S_claude_users
generate double aei       = 100 * usage_pct     / S_usage_pct
generate double st_work   = 100 * work_messages / S_work_messages
generate double st_clwork = 100 * claude_work   / S_claude_work
generate double aei_work  = 100 * aei_workc     / S_aei_workc
generate double sig_work_pct = 100 * work_share
generate double r_aei_all = aei / st_all
generate double r_aei_cl  = aei / st_cl

* 18개국 합계·가중 평균
bysort month: egen double cov_st_all = total(st_all_ww_pct)    // 25개 시장 중 18개국(%)
bysort month: egen double cov_st_cl  = total(st_cl_ww_pct)
generate double cov_aei   = S_usage_pct                         // Claude.ai 전 세계 중 18개국(%)
generate double sig_work18 = 100 * S_work_messages / S_messages  // Signals 비중, ST 메시지 가중
generate double aei_work18 = 100 * S_aei_workc / S_usage_pct     // AEI 비중, AEI 대화 가중
generate double sig_work_global = 100 * work_share_global

foreach a in all cl {
    assert abs(st_`a') < 100
}
bysort month: egen double chk = total(aei)
assert abs(chk - 100) < 1e-9
drop chk

* -----------------------------------------------------------------------------
* 4. 요약 통계(기간별)
* -----------------------------------------------------------------------------
tempname S
postfile `S' str40 stat str7 month double v using "`c(tmpdir)'/st_aei_summary.dta", replace
foreach m of local periods {
    foreach p in "aei st_all" "aei st_cl" "aei_work st_work" "aei_work st_clwork" "use_case_work_pct sig_work_pct" {
        gettoken a b : p
        local b = trim("`b'")
        quietly correlate `a' `b' if month == "`m'"
        post `S' ("corr:`a':`b'") ("`m'") (r(rho))
        quietly spearman `a' `b' if month == "`m'"
        post `S' ("spear:`a':`b'") ("`m'") (r(rho))
        quietly generate double _d = abs(`a' - `b') if month == "`m'"
        quietly summarize _d, meanonly
        post `S' ("D:`a':`b'") ("`m'") (r(sum) / 2)
        quietly generate double _e = `a' - `b' if month == "`m'"
        quietly summarize _e, meanonly
        post `S' ("mdiff:`a':`b'") ("`m'") (r(mean))
        drop _d _e
    }
    foreach v in cov_st_all cov_st_cl cov_aei sig_work18 aei_work18 sig_work_global aei_work_pct_global {
        quietly summarize `v' if month == "`m'", meanonly
        post `S' ("`v'") ("`m'") (r(mean))
    }
}
postclose `S'

* -----------------------------------------------------------------------------
* 5. 엑셀
* -----------------------------------------------------------------------------
* 표 행 순서: 2026-05 AEI 비중 내림차순(모든 표 공통)
generate double _o = -aei if month == "2026-05"
bysort market: egen double ord = min(_o)
drop _o
sort month ord
label variable st_all    "ST 8개 제품 메시지 비중(18개국=100)"
label variable st_cl     "ST Claude 이용자 비중(18개국=100)"
label variable aei       "AEI Claude.ai 대화 비중(18개국=100)"
label variable st_work   "ST 업무용 메시지 비중(18개국=100)"
label variable st_clwork "ST Claude 이용자×Signals 업무 비중의 비중(18개국=100)"
label variable aei_work  "AEI 업무용 대화 비중(18개국=100)"
label variable sig_work_pct "Signals ChatGPT 업무용 메시지 비중(%)"
label variable use_case_work_pct "AEI Claude.ai 업무용 대화 비중(%)"
label variable r_aei_all "aei / st_all"
label variable r_aei_cl  "aei / st_cl"
export excel month market kname iso2 iso3 all_users messages claude_users usage_pct ///
    st_all_ww_pct st_cl_ww_pct st_all st_cl aei r_aei_all r_aei_cl ///
    sig_work_pct use_case_work_pct work_messages st_work st_clwork aei_work ///
    using "`out'/18_sensortower_aei_country_share.xlsx", sheet("panel", replace) firstrow(variables)
preserve
    use "`c(tmpdir)'/st_aei_summary.dta", clear
    replace month = "m" + subinstr(month, "-", "", .)
    reshape wide v, i(stat) j(month) string
    export excel using "`out'/18_sensortower_aei_country_share.xlsx", sheet("summary", replace) firstrow(variables)
restore

* -----------------------------------------------------------------------------
* 6. LaTeX 표(행 본문만, 머리·틀은 보고서에서)
* -----------------------------------------------------------------------------
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

local hdr "% 04_analysis_sensortower_aei_country_share.do가 생성. 직접 고치지 말 것."
tempname fh

* 6-1. 기간별 국가 비중
foreach m of local periods {
    local tag = subinstr("`m'", "-", "", .)
    file open `fh' using "`out'/18_share_`tag'.tex", write replace
    file write `fh' "`hdr'" _n
    forvalues i = 1/`=_N' {
        if month[`i'] != "`m'" continue
        wrow `fh' "`=kname[`i']'" %9.2f `=st_all[`i']' `=st_cl[`i']' `=aei[`i']' `=r_aei_all[`i']' `=r_aei_cl[`i']'
    }
    file write `fh' "\midrule" _n
    quietly summarize cov_st_all if month == "`m'", meanonly
    local c1 = r(mean)
    quietly summarize cov_st_cl if month == "`m'", meanonly
    local c2 = r(mean)
    quietly summarize cov_aei if month == "`m'", meanonly
    local c3 = r(mean)
    wrow `fh' "18개국의 원 분모 대비 비중" %9.1f `c1' `c2' `c3' . .
    file close `fh'
}

* 6-2. 업무용 비중 수준
file open `fh' using "`out'/18_work_level.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/`=_N' {
    if month[`i'] != "2026-05" continue
    local mk = market[`i']
    local vals ""
    foreach m of local periods {
        quietly summarize sig_work_pct if market == "`mk'" & month == "`m'", meanonly
        local vals "`vals' `r(mean)'"
        quietly summarize use_case_work_pct if market == "`mk'" & month == "`m'", meanonly
        local vals "`vals' `r(mean)'"
    }
    wrow `fh' "`=kname[`i']'" %9.1f `vals'
}
file write `fh' "\midrule" _n
foreach pr in "sig_work18 aei_work18 18개국 가중 평균" "sig_work_global aei_work_pct_global 전 세계" {
    gettoken a pr : pr
    gettoken b lab : pr
    local vals ""
    foreach m of local periods {
        quietly summarize `a' if month == "`m'", meanonly
        local vals "`vals' `r(mean)'"
        quietly summarize `b' if month == "`m'", meanonly
        local vals "`vals' `r(mean)'"
    }
    wrow `fh' "`=trim("`lab'")'" %9.1f `vals'
}
file close `fh'

* 6-3. 업무용 국가 비중
file open `fh' using "`out'/18_work_share.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/`=_N' {
    if month[`i'] != "2026-05" continue
    local mk = market[`i']
    local vals ""
    foreach m of local periods {
        foreach v in st_work st_clwork aei_work {
            quietly summarize `v' if market == "`mk'" & month == "`m'", meanonly
            local vals "`vals' `r(mean)'"
        }
    }
    wrow `fh' "`=kname[`i']'" %9.2f `vals'
}
file close `fh'

* 6-4. 요약 통계
use "`c(tmpdir)'/st_aei_summary.dta", clear
file open `fh' using "`out'/18_summary.tex", write replace
file write `fh' "`hdr'" _n
local r1 "corr:aei:st_all|국가 비중: AEI vs ST 8개 제품 --- 상관"
local r2 "spear:aei:st_all|\quad 순위 상관"
local r3 "D:aei:st_all|\quad 비유사도 D(\%p)"
local r4 "corr:aei:st_cl|국가 비중: AEI vs ST Claude --- 상관"
local r5 "spear:aei:st_cl|\quad 순위 상관"
local r6 "D:aei:st_cl|\quad 비유사도 D(\%p)"
local r7 "corr:aei_work:st_work|업무용 국가 비중: AEI vs ST 8개 제품 --- 상관"
local r8 "D:aei_work:st_work|\quad 비유사도 D(\%p)"
local r9 "corr:aei_work:st_clwork|업무용 국가 비중: AEI vs ST Claude --- 상관"
local r10 "D:aei_work:st_clwork|\quad 비유사도 D(\%p)"
local r11 "corr:use_case_work_pct:sig_work_pct|업무용 비중 수준: AEI vs Signals --- 상관"
local r12 "spear:use_case_work_pct:sig_work_pct|\quad 순위 상관"
local r13 "mdiff:use_case_work_pct:sig_work_pct|\quad 평균 차이(AEI $-$ Signals, \%p)"
forvalues j = 1/13 {
    gettoken key lab : r`j', parse("|")
    local lab = substr("`lab'", 2, .)
    local f = cond(strpos("`key'", "corr") | strpos("`key'", "spear"), "%9.3f", "%9.1f")
    local vals ""
    foreach m of local periods {
        quietly summarize v if stat == "`key'" & month == "`m'", meanonly
        assert r(N) == 1
        local vals "`vals' `r(mean)'"
    }
    wrow `fh' `"`lab'"' `f' `vals'
}
file close `fh'

list stat month v, noobs sep(0) abbreviate(30)
