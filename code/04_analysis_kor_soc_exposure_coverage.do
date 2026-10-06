* =============================================================================
* 04_analysis_kor_soc_exposure_coverage.do
* AEI 한국 직업(SOC)별 대화 비중과 observed exposure(Massenkoff & McCrory 2026)의 직업 매칭 범위
*   (results/paper/20 보고서용)
*
* 입력:
*   $raw/usage/anthropic_economic_index/release_2026_06_26/data/aei_claude_ai_2026-06-26.csv
*       category_name == "soc_occupation", hierarchy_level == 0(O*NET-SOC 8자리), metric_id == "pct"
*       geo_id == "KOR"(country), "GLOBAL"(global). 2026-04, 2026-05
*   $raw/usage/anthropic_economic_index/labor_market_impacts/job_exposure.csv
*       occ_code(SOC 2018 세부 직업 6자리), title, observed_exposure
* 출력: $results/table/
*   20_kor_soc_exposure_coverage.xlsx (시트 units, match, match_months, bins, by_major,
*                                       kor_not_in_exposure, occupations)
*   20_units.tex        직업 분류 단위: 8자리 코드 수(.00 / .01 이상), 6자리 수, 대분류 수, pct 합계
*   20_match.tex        job_exposure 756개 직업의 세 집단(한국 매칭 / global만 / 미공개), 2026-05
*   20_match_months.tex 세 집단 직업 수(2026-04 대 2026-05)
*   20_bins.tex         observed exposure 구간별 직업 수와 한국 매칭 비율, 2026-05
*   20_by_major.tex     대분류별 세 집단 직업 수와 평균 exposure, 2026-05
*   20_reverse.tex      AEI 직업 중 job_exposure에 없는 직업 수와 pct 합계, 2026-05
*   20_kor_not_in_exposure.tex 한국 공개 직업 중 job_exposure에 없는 직업 목록, 2026-05
*
* 매칭 키: AEI node_external_id(O*NET-SOC 8자리, 예 15-1252.00)의 앞 7자리(XX-XXXX)
*          = job_exposure occ_code(SOC 2018 세부 직업). 한 6자리 직업에 8자리 코드가 여럿이면 pct를 합한다.
* 주의: AEI는 집계 기준과 지역 표본 하한을 넘는 셀만 공개한다. 행이 없으면 "미공개"이지 0이 아니다.
* =============================================================================

version 17
clear all
set more off

if `"$root"'    == "" global root    "d:/research/AI_effects"
if `"$raw"'     == "" global raw     "$root/data/raw"
if `"$proc"'    == "" global proc    "$root/data/proc"
if `"$results"' == "" global results "$root/results"

local aei "$raw/usage/anthropic_economic_index/release_2026_06_26/data"
local lmi "$raw/usage/anthropic_economic_index/labor_market_impacts"
local out "$results/table"
local xl  "`out'/20_kor_soc_exposure_coverage.xlsx"
local hdr "% 04_analysis_kor_soc_exposure_coverage.do가 생성. 직접 고치지 말 것."

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
            local s = trim("`s'")
            if regexm("`s'", "^-0\.?0*$") local s = substr("`s'", 2, .)   // -0.00 → 0.00
            local line "`line' & `s'"
        }
    }
    file write `fh' `"`line' \\"' _n
end
tempname fh

* 대분류 한국어 명칭(report 19와 같은 대응표)
capture program drop korname
program define korname
    generate str40 soc_major_kr = ""
    replace soc_major_kr = "경영"                 if soc_major == "11"
    replace soc_major_kr = "사업·금융 운영"        if soc_major == "13"
    replace soc_major_kr = "컴퓨터·수학"           if soc_major == "15"
    replace soc_major_kr = "건축·공학"             if soc_major == "17"
    replace soc_major_kr = "생명·물리·사회과학"     if soc_major == "19"
    replace soc_major_kr = "지역사회·사회서비스"    if soc_major == "21"
    replace soc_major_kr = "법률"                 if soc_major == "23"
    replace soc_major_kr = "교육·도서관"           if soc_major == "25"
    replace soc_major_kr = "예술·디자인·엔터테인먼트·스포츠·미디어" if soc_major == "27"
    replace soc_major_kr = "보건의료 전문·기술"     if soc_major == "29"
    replace soc_major_kr = "보건의료 지원"         if soc_major == "31"
    replace soc_major_kr = "보안 서비스"           if soc_major == "33"
    replace soc_major_kr = "음식 조리·서빙"        if soc_major == "35"
    replace soc_major_kr = "건물·부지 청소·관리"    if soc_major == "37"
    replace soc_major_kr = "개인 돌봄·서비스"       if soc_major == "39"
    replace soc_major_kr = "판매"                 if soc_major == "41"
    replace soc_major_kr = "사무·행정 지원"         if soc_major == "43"
    replace soc_major_kr = "농림어업"              if soc_major == "45"
    replace soc_major_kr = "건설·채굴"             if soc_major == "47"
    replace soc_major_kr = "설치·정비·수리"         if soc_major == "49"
    replace soc_major_kr = "생산"                 if soc_major == "51"
    replace soc_major_kr = "운송·자재 이동"         if soc_major == "53"
    assert soc_major_kr != ""
end

* -----------------------------------------------------------------------------
* AEI 세부 직업(O*NET-SOC 8자리) pct: KOR, GLOBAL
* -----------------------------------------------------------------------------
import delimited using "`aei'/aei_claude_ai_2026-06-26.csv", ///
    varnames(1) encoding("utf-8") bindquote(strict) stringcols(1/7 9 10) asdouble clear
keep if category_name == "soc_occupation" & hierarchy_level == "0" & metric_id == "pct"
keep if (geo_id == "KOR" & geo_level == "country") | (geo_id == "GLOBAL" & geo_level == "global")
generate str7 month = substr(date_start, 1, 7)
generate str3 geo = cond(geo_id == "KOR", "kor", "glb")
generate str244 title8 = node_name
rename (node_external_id value) (soc8 pct)
keep geo month soc8 title8 pct
isid geo month soc8
assert regexm(soc8, "^[0-9][0-9]-[0-9][0-9][0-9][0-9]\.[0-9][0-9]$")
generate str7 soc6 = substr(soc8, 1, 7)
generate byte is00 = substr(soc8, 9, 2) == "00"
quietly levelsof month
assert r(r) == 2
tempfile aei8
save `aei8'

* 6자리로 합침
use `aei8', clear
generate byte neg00 = -is00
bysort geo month soc6 (neg00 soc8): generate str244 title_any = title8[1]   // .00 명칭 우선
collapse (sum) pct (count) n8 = pct (max) has00 = is00 (firstnm) title_any, by(geo month soc6)
rename title_any aei_title
tempfile aei6
save `aei6'

* -----------------------------------------------------------------------------
* job_exposure(observed exposure)
* -----------------------------------------------------------------------------
import delimited using "`lmi'/job_exposure.csv", ///
    varnames(1) encoding("utf-8") bindquote(strict) stringcols(1 2) asdouble clear
rename occ_code soc6
isid soc6
assert regexm(soc6, "^[0-9][0-9]-[0-9][0-9][0-9][0-9]$")
assert substr(soc6, 7, 1) != "0"          // 끝자리 0 = Broad occupation 코드가 없음
assert !missing(observed_exposure)
generate str2 soc_major = substr(soc6, 1, 2)
quietly levelsof soc_major
assert r(r) == 22
local n_je = _N
tempfile je
save `je'

* -----------------------------------------------------------------------------
* 1. 분류 단위
* -----------------------------------------------------------------------------
use `aei8', clear
generate byte not00 = !is00
collapse (count) n8 = pct (sum) n00 = is00 n01 = not00 pct8 = pct, by(geo month)
tempfile u8
save `u8'
use `aei6', clear
generate str2 soc_major = substr(soc6, 1, 2)
bysort geo month soc_major: generate byte first_major = _n == 1
generate byte only01 = !has00
collapse (count) n6 = pct (sum) n_major = first_major n6_only01 = only01, by(geo month)
merge 1:1 geo month using `u8', assert(match) nogenerate
sort geo month
export excel using "`xl'", sheet("units", replace) firstrow(variables)
* 열 순서: 한국 04, 한국 05, global 04, global 05
gsort -geo month
assert geo[1] == "kor" & month[1] == "2026-04" & geo[4] == "glb" & month[4] == "2026-05"
file open `fh' using "`out'/20_units.tex", write replace
file write `fh' "`hdr'" _n
wrow `fh' "O*NET-SOC 8자리 코드 수"            %9.0f `=n8[1]' `=n8[2]' `=n8[3]' `=n8[4]' .
wrow `fh' "\quad 끝자리 .00(= SOC 세부 직업)"   %9.0f `=n00[1]' `=n00[2]' `=n00[3]' `=n00[4]' .
wrow `fh' "\quad 끝자리 .01 이상(O*NET 세분)"   %9.0f `=n01[1]' `=n01[2]' `=n01[3]' `=n01[4]' .
wrow `fh' "SOC 세부 직업(6자리) 수"             %9.0f `=n6[1]' `=n6[2]' `=n6[3]' `=n6[4]' `n_je'
wrow `fh' "\quad .00 없이 .01 이상으로만 나타남" %9.0f `=n6_only01[1]' `=n6_only01[2]' `=n6_only01[3]' `=n6_only01[4]' .
wrow `fh' "SOC 대분류 수"                      %9.0f `=n_major[1]' `=n_major[2]' `=n_major[3]' `=n_major[4]' 22
wrow `fh' "공개 세부 직업 pct 합계(\%)"          %9.2f `=pct8[1]' `=pct8[2]' `=pct8[3]' `=pct8[4]' .
file close `fh'

* -----------------------------------------------------------------------------
* 2. job_exposure 직업의 세 집단
*    grp 1 = 한국 매칭, 2 = global에만 공개(한국 미공개), 3 = global에서도 미공개
* -----------------------------------------------------------------------------
use `aei6', clear
keep geo month soc6 pct
replace month = subinstr(month, "-", "_", .)
generate str10 gm = geo + month
drop geo month
reshape wide pct, i(soc6) j(gm) string
tempfile aeiw
save `aeiw'

use `je', clear
merge 1:1 soc6 using `aeiw', keep(master match) nogenerate
foreach m in 2026_04 2026_05 {
    capture assert missing(pctkor`m') if missing(pctglb`m')   // 한국 공개 직업은 global에도 공개
    assert _rc == 0
    generate byte grp`m' = cond(!missing(pctkor`m'), 1, cond(!missing(pctglb`m'), 2, 3))
}
label define grp 1 "한국 매칭" 2 "global에만 공개" 3 "global에서도 미공개"
label values grp2026_04 grp2026_05 grp
generate byte exp0 = observed_exposure == 0
korname
order soc6 title soc_major soc_major_kr observed_exposure grp2026_05 grp2026_04 ///
    pctkor2026_05 pctglb2026_05 pctkor2026_04 pctglb2026_04
sort soc6
export excel soc6-pctglb2026_04 using "`xl'", sheet("occupations", replace) firstrow(variables)
tempfile occ
save `occ'

* 2-1. 2026-05 집단별 요약
local glab1 "(1) 한국 매칭"
local glab2 "(2) global에만 공개(한국 미공개)"
local glab3 "(3) global에서도 미공개"
file open `fh' using "`out'/20_match.tex", write replace
file write `fh' "`hdr'" _n
forvalues g = 1/4 {
    if `g' < 4 local cond "grp2026_05 == `g'"
    else       local cond "1"
    quietly summarize observed_exposure if `cond', detail
    local n = r(N)
    local mn = r(mean)
    local md = r(p50)
    quietly count if exp0 & `cond'
    local z = r(N)
    quietly summarize pctkor2026_05 if `cond', meanonly
    local pk = cond(r(N) > 0, r(sum), .)
    quietly summarize pctglb2026_05 if `cond', meanonly
    local pg = cond(r(N) > 0, r(sum), .)
    if `g' == 4 file write `fh' "\midrule" _n
    local lab = cond(`g' == 4, "합계", "`glab`g''")
    local s1 : display %9.0f `n'
    local s2 : display %9.1f 100 * `n' / `n_je'
    local s3 : display %9.4f `mn'
    local s4 : display %9.4f `md'
    local s5 : display %9.0f `z'
    local s6 : display %9.1f 100 * `z' / `n'
    local s7 = cond(missing(`pk'), "--", trim(string(`pk', "%9.2f")))
    local s8 = cond(missing(`pg'), "--", trim(string(`pg', "%9.2f")))
    forvalues j = 1/6 {
        local s`j' = trim("`s`j''")
    }
    file write `fh' "`lab' & `s1' & `s2' & `s3' & `s4' & `s5' & `s6' & `s7' & `s8' \\" _n
}
file close `fh'

* 2-2. 집단별 직업 수: 2026-04 대 2026-05
preserve
contract grp2026_04 grp2026_05
export excel using "`xl'", sheet("match_months", replace) firstrow(variables)
restore
file open `fh' using "`out'/20_match_months.tex", write replace
file write `fh' "`hdr'" _n
forvalues g = 1/3 {
    quietly count if grp2026_04 == `g'
    local a = r(N)
    quietly count if grp2026_05 == `g'
    local b = r(N)
    wrow `fh' "`glab`g''" %9.0f `a' `b' `=`b' - `a''
}
file close `fh'

* -----------------------------------------------------------------------------
* 3. observed exposure 구간별(2026-05)
* -----------------------------------------------------------------------------
use `occ', clear
generate byte bin = 1 if observed_exposure == 0
replace bin = 2 if observed_exposure > 0    & observed_exposure <= 0.05
replace bin = 3 if observed_exposure > 0.05 & observed_exposure <= 0.10
replace bin = 4 if observed_exposure > 0.10 & observed_exposure <= 0.20
replace bin = 5 if observed_exposure > 0.20 & observed_exposure <= 0.40
replace bin = 6 if observed_exposure > 0.40
assert !missing(bin)
generate byte g1 = grp2026_05 == 1
generate byte g2 = grp2026_05 == 2
generate byte g3 = grp2026_05 == 3
collapse (count) n = observed_exposure (sum) g1 g2 g3 pctkor = pctkor2026_05, by(bin)
generate double rate_kor = 100 * g1 / n
export excel using "`xl'", sheet("bins", replace) firstrow(variables)
local blab1 "0"
local blab2 "0 초과 0.05 이하"
local blab3 "0.05 초과 0.10 이하"
local blab4 "0.10 초과 0.20 이하"
local blab5 "0.20 초과 0.40 이하"
local blab6 "0.40 초과"
file open `fh' using "`out'/20_bins.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/`=_N' {
    local b = bin[`i']
    file write `fh' "`blab`b''"
    foreach v in n g1 g2 g3 {
        file write `fh' " & " (trim(string(`v'[`i'], "%9.0f")))
    }
    file write `fh' " & " (trim(string(rate_kor[`i'], "%9.1f"))) " & " (trim(string(pctkor[`i'], "%9.2f"))) " \\" _n
}
file close `fh'

* -----------------------------------------------------------------------------
* 4. 대분류별(2026-05)
* -----------------------------------------------------------------------------
use `occ', clear
generate byte g1 = grp2026_05 == 1
generate byte g2 = grp2026_05 == 2
generate byte g3 = grp2026_05 == 3
generate double exp_g1 = observed_exposure if g1
generate double exp_un = observed_exposure if !g1
collapse (count) n = observed_exposure (sum) g1 g2 g3 (mean) exp_g1 exp_un, by(soc_major soc_major_kr)
generate double rate_kor = 100 * g1 / n
sort soc_major
export excel using "`xl'", sheet("by_major", replace) firstrow(variables)
file open `fh' using "`out'/20_by_major.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/`=_N' {
    file write `fh' "`=soc_major[`i']' `=soc_major_kr[`i']'"
    foreach v in n g1 g2 g3 {
        file write `fh' " & " (trim(string(`v'[`i'], "%9.0f")))
    }
    file write `fh' " & " (trim(string(rate_kor[`i'], "%9.1f")))
    foreach v in exp_g1 exp_un {
        local s = cond(missing(`v'[`i']), "--", trim(string(`v'[`i'], "%9.3f")))
        file write `fh' " & `s'"
    }
    file write `fh' " \\" _n
}
file close `fh'

* -----------------------------------------------------------------------------
* 5. 반대 방향: AEI 공개 직업 중 job_exposure에 없는 직업(2026-05)
* -----------------------------------------------------------------------------
use `aei6', clear
keep if month == "2026-05"
merge m:1 soc6 using `je', keep(master match) keepusing(observed_exposure)
generate byte in_je = _merge == 3
drop _merge
preserve
generate byte not_je = !in_je
generate double pct_not = pct if !in_je
collapse (count) n6 = pct (sum) n_in = in_je n_not = not_je pct_not, by(geo)
gsort -geo
assert geo[1] == "kor"
export excel using "`xl'", sheet("reverse", replace) firstrow(variables)
file open `fh' using "`out'/20_reverse.tex", write replace
file write `fh' "`hdr'" _n
wrow `fh' "공개 SOC 세부 직업(6자리) 수"          %9.0f `=n6[1]' `=n6[2]'
wrow `fh' "\quad job\_exposure에 있음"           %9.0f `=n_in[1]' `=n_in[2]'
wrow `fh' "\quad job\_exposure에 없음"           %9.0f `=n_not[1]' `=n_not[2]'
wrow `fh' "job\_exposure에 없는 직업의 pct 합계(\%)" %9.2f `=pct_not[1]' `=pct_not[2]'
file close `fh'
restore

* 한국 공개 직업 중 job_exposure에 없는 직업 목록
keep if !in_je
keep geo soc6 pct n8 aei_title
reshape wide pct n8 aei_title, i(soc6) j(geo) string
keep if !missing(pctkor)
gsort -pctkor soc6
export excel soc6 aei_titlekor n8kor pctkor pctglb using "`xl'", ///
    sheet("kor_not_in_exposure", replace) firstrow(variables)
file open `fh' using "`out'/20_kor_not_in_exposure.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/`=_N' {
    local t = aei_titlekor[`i']
    foreach c in "&" "%" "#" "_" {
        local t = subinstr(`"`t'"', "`c'", "\\`c'", .)
    }
    file write `fh' "`=soc6[`i']' & `t' & " (trim(string(n8kor[`i'], "%9.0f"))) " & " ///
        (trim(string(pctkor[`i'], "%9.2f"))) " & " (trim(string(pctglb[`i'], "%9.2f"))) " \\" _n
}
file close `fh'
