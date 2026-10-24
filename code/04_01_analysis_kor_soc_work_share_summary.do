* =============================================================================
* 04_01_analysis_kor_soc_work_share_summary.do
* 03_02_merge_aei_kor_soc_work_share.do가 만든 한국·전 세계 직업(SOC)별 업무용 대화 비중의 요약표
*   (paper 19: results/paper/19_한국_직업별_업무용대화비중_산출.tex)
*
* 2026-10-24 재설계: 예전 archive/04_analysis_kor_soc_conversations_summary.do(Sensor Tower 대화량 기준)를 대신한다.
*   대화 건수 표(19_korea.tex)는 없애고, GLOBAL 비중과 가정 B3 점검 표를 더했다.
*
* 입력: $proc/usage/anthropic_economic_index/
*   aei_soc_work_share_major.dta, aei_soc_work_share_detailed.dta   (03_02 출력)
*   aei_claude_ai_country_usage.dta   (01_02_import_aei_country_usage.do; AEI 공개 한국 전체 use_case_work_pct, 검증용)
* 출력: $results/table/
*   19_kor_soc_work_share.xlsx (시트 major, detailed_top30, coverage, b3)
*   19_coverage.tex      AEI SOC 공개 범위(대분류·세부 직업 수, pct 합계), KOR·GLOBAL × 2개월
*   19_workpct.tex       함의된 한국 업무용 비중 대 AEI 공개 값
*   19_major.tex         대분류별 pct, 업무용 비중, 비중(전체·업무용), GLOBAL 업무용 비중, 한국/GLOBAL(2026-05)
*   19_major_months.tex  대분류별 한국 업무용 비중(2026-04, 05, 차이, 두 달 평균)
*   19_detailed.tex      한국 세부 직업 상위 30개(2026-05, 업무용 비중 순)와 GLOBAL 비중
*   19_b3.tex            가정 B3 점검(GLOBAL): 대분류 업무용 비중을 쓴 세부 직업 비중 대 세부 직업 공개 업무용 비중을 쓴 값
* 단위: 비중 %.
* =============================================================================

version 17
clear all
set more off

if `"$root"'    == "" global root    "d:/research/AI_effects"
if `"$raw"'     == "" global raw     "$root/data/raw"
if `"$proc"'    == "" global proc    "$root/data/proc"
if `"$results"' == "" global results "$root/results"

local aei "$proc/usage/anthropic_economic_index"
local out "$results/table"
local xl  "`out'/19_kor_soc_work_share.xlsx"
local hdr "% 04_01_analysis_kor_soc_work_share_summary.do가 생성. 직접 고치지 말 것."

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

* 대분류 한국어 명칭
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
* 1. 공개 범위(KOR, GLOBAL × 2개월)
* -----------------------------------------------------------------------------
use "`aei'/aei_soc_work_share_major.dta", clear
collapse (count) n_major = pct (first) pct_sum, by(geo_id month)
tempfile cov1
save `cov1'
use "`aei'/aei_soc_work_share_detailed.dta", clear
generate byte pub = !detail_missing
collapse (sum) n_detail = pub detail_missing (sum) pct_detail = pct, by(geo_id month)
merge 1:1 geo_id month using `cov1', assert(match) nogenerate
* 열 순서: KOR 04, KOR 05, GLOBAL 04, GLOBAL 05
generate byte g = geo_id == "GLOBAL"
sort g month
export excel geo_id month n_major pct_sum n_detail pct_detail detail_missing using "`xl'", ///
    sheet("coverage", replace) firstrow(variables)
file open `fh' using "`out'/19_coverage.tex", write replace
file write `fh' "`hdr'" _n
wrow `fh' "대분류: 공개 수"                       %9.0f `=n_major[1]' `=n_major[2]' `=n_major[3]' `=n_major[4]'
wrow `fh' "대분류: 공개 pct 합계(\%)"             %9.2f `=pct_sum[1]' `=pct_sum[2]' `=pct_sum[3]' `=pct_sum[4]'
wrow `fh' "세부 직업: 공개 수"                     %9.0f `=n_detail[1]' `=n_detail[2]' `=n_detail[3]' `=n_detail[4]'
wrow `fh' "세부 직업: 공개 pct 합계(\%)"           %9.2f `=pct_detail[1]' `=pct_detail[2]' `=pct_detail[3]' `=pct_detail[4]'
wrow `fh' "세부 직업이 하나도 공개되지 않은 대분류 수" %9.0f `=detail_missing[1]' `=detail_missing[2]' `=detail_missing[3]' `=detail_missing[4]'
file close `fh'

* -----------------------------------------------------------------------------
* 2. 함의된 한국 업무용 비중 대 AEI 공개 값
* -----------------------------------------------------------------------------
use "$proc/usage/anthropic_economic_index/aei_claude_ai_country_usage.dta", clear
keep if release == "20260626" & geo_id == "KOR"
keep period use_case_work_pct
rename (period use_case_work_pct) (month work_pct_pub)
tempfile pub
save `pub'
use "`aei'/aei_soc_work_share_major.dta" if geo_id == "KOR", clear
collapse (first) work_pct_geo pct_sum, by(month)
merge 1:1 month using `pub', assert(match) nogenerate
sort month
file open `fh' using "`out'/19_workpct.tex", write replace
file write `fh' "`hdr'" _n
wrow `fh' "대분류로 함의된 업무용 비중(\%) = \$\sum$ pct $\times$ 업무용 비중 / \$\sum$ pct" ///
    %9.2f `=work_pct_geo[1]' `=work_pct_geo[2]'
wrow `fh' "AEI 공개 한국 전체 업무용 비중(\%)" %9.2f `=work_pct_pub[1]' `=work_pct_pub[2]'
wrow `fh' "차이(\%p)" %9.2f `=work_pct_geo[1] - work_pct_pub[1]' `=work_pct_geo[2] - work_pct_pub[2]'
file close `fh'

* -----------------------------------------------------------------------------
* 3. 대분류(2026-05): 한국 대 GLOBAL
* -----------------------------------------------------------------------------
use "`aei'/aei_soc_work_share_major.dta" if geo_id == "GLOBAL", clear
keep month soc_major share_work work_pct work_pct_geo
rename (share_work work_pct work_pct_geo) (share_work_glb work_pct_glb work_pct_geo_glb)
tempfile gmaj
save `gmaj'
use "`aei'/aei_soc_work_share_major.dta" if geo_id == "KOR", clear
merge 1:1 month soc_major using `gmaj', assert(match) nogenerate
generate double ratio_glb = share_work / share_work_glb
korname
export excel month soc_major soc_major_title soc_major_kr pct work_pct share_all share_work share_work_glb ///
    work_pct_glb ratio_glb using "`xl'", sheet("major", replace) firstrow(variables)
preserve
keep if month == "2026-05"
gsort -share_work
file open `fh' using "`out'/19_major.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/`=_N' {
    wrow `fh' "`=soc_major[`i']' `=soc_major_kr[`i']'" %9.2f `=pct[`i']' `=work_pct[`i']' ///
        `=100 * share_all[`i']' `=100 * share_work[`i']' `=100 * (share_work[`i'] - share_all[`i'])' ///
        `=100 * share_work_glb[`i']' `=ratio_glb[`i']'
}
file write `fh' "\midrule" _n
foreach v in pct share_all share_work share_work_glb {
    quietly summarize `v', meanonly
    local s_`v' = r(sum)
}
wrow `fh' "합계" %9.2f `s_pct' `=work_pct_geo[1]' `=100 * `s_share_all'' `=100 * `s_share_work'' 0 `=100 * `s_share_work_glb'' .
file close `fh'
display as text "GLOBAL 함의된 업무용 비중(2026-05): " %6.2f work_pct_geo_glb[1]
restore

* 2026-04 대 2026-05(한국)
keep month soc_major soc_major_kr share_work
replace month = subinstr(month, "-", "_", .)
reshape wide share_work, i(soc_major soc_major_kr) j(month) string
generate double share_work_avg = (share_work2026_04 + share_work2026_05) / 2
gsort -share_work_avg
file open `fh' using "`out'/19_major_months.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/`=_N' {
    wrow `fh' "`=soc_major[`i']' `=soc_major_kr[`i']'" %9.2f ///
        `=100 * share_work2026_04[`i']' `=100 * share_work2026_05[`i']' ///
        `=100 * (share_work2026_05[`i'] - share_work2026_04[`i'])' `=100 * share_work_avg[`i']'
}
file close `fh'

* -----------------------------------------------------------------------------
* 4. 한국 세부 직업 상위 30개(2026-05)와 GLOBAL 비중
* -----------------------------------------------------------------------------
use "`aei'/aei_soc_work_share_detailed.dta" if geo_id == "GLOBAL" & month == "2026-05", clear
keep soc_code share_work
rename share_work share_work_glb
tempfile gdet
save `gdet'
use "`aei'/aei_soc_work_share_detailed.dta" if geo_id == "KOR" & month == "2026-05", clear
assert detail_missing == 0
merge 1:1 soc_code using `gdet', keep(master match)
generate byte glb_pub = _merge == 3
drop _merge
generate double ratio_glb = share_work / share_work_glb
gsort -share_work soc_code
keep in 1/30
export excel month soc_code soc_title soc_major soc_major_title_m pct share_in_major share_work_major ///
    share_work share_work_glb ratio_glb using "`xl'", sheet("detailed_top30", replace) firstrow(variables)
file open `fh' using "`out'/19_detailed.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/`=_N' {
    local t = soc_title[`i']
    foreach c in "&" "%" "#" "_" {
        local t = subinstr(`"`t'"', "`c'", "\\`c'", .)
    }
    local g = cond(glb_pub[`i'], 100 * share_work_glb[`i'], .)
    local r = cond(glb_pub[`i'], ratio_glb[`i'], .)
    wrow `fh' "`=soc_code[`i']' & `t'" %9.2f `=pct[`i']' `=100 * share_in_major[`i']' ///
        `=100 * share_work_major[`i']' `=100 * share_work[`i']' `g' `r'
}
file close `fh'

* -----------------------------------------------------------------------------
* 5. 가정 B3 점검(GLOBAL, 세부 직업 업무용 비중이 공개됨)
*    (가) B3: share_work_major(g) × share_in_major(d)
*    (나) 공개 값: pct(d) × work_pct_detail(d)를 대분류 안 공개 세부 직업에서 정규화한 뒤 대분류 비중을 곱함
*        (대분류 몫은 (가)와 같게 두고, 대분류 안 배분만 세부 직업 업무용 비중으로 바꿈)
* -----------------------------------------------------------------------------
use "`aei'/aei_soc_work_share_detailed.dta" if geo_id == "GLOBAL", clear
assert detail_missing == 0
count if missing(work_pct_detail)
generate double ww = pct * work_pct_detail
bysort month soc_major: egen double ww_sum = total(ww)
generate double share_work_alt = share_work_major * ww / ww_sum
replace share_work_alt = share_work if missing(work_pct_detail)
tempname pf
tempfile b3
postfile `pf' str7 month double(n rho mad mad_rel ov30 sum_absdiff) using `b3'
foreach m in 2026-04 2026-05 {
    preserve
    keep if month == "`m'"
    quietly count
    local n = r(N)
    quietly spearman share_work share_work_alt
    local rho = r(rho)
    generate double ad = abs(share_work - share_work_alt)
    quietly summarize ad
    local sad = r(sum)
    local mad = r(mean)
    quietly summarize share_work
    local mad_rel = `mad' / r(mean)
    egen int r1 = rank(-share_work), unique
    egen int r2 = rank(-share_work_alt), unique
    quietly count if r1 <= 30 & r2 <= 30
    local ov = r(N)
    post `pf' ("`m'") (`n') (`rho') (100 * `mad') (`mad_rel') (`ov') (100 * `sad')
    restore
}
postclose `pf'
use `b3', clear
export excel using "`xl'", sheet("b3", replace) firstrow(variables)
file open `fh' using "`out'/19_b3.tex", write replace
file write `fh' "`hdr'" _n
wrow `fh' "세부 직업 수" %9.0f `=n[1]' `=n[2]'
wrow `fh' "(가)와 (나)의 Spearman 순위상관" %9.3f `=rho[1]' `=rho[2]'
wrow `fh' "절대 차이의 평균(\%p)" %9.4f `=mad[1]' `=mad[2]'
wrow `fh' "절대 차이의 평균 / 비중 평균" %9.2f `=mad_rel[1]' `=mad_rel[2]'
wrow `fh' "절대 차이의 합(\%p; 2로 나누면 옮겨 가는 몫)" %9.2f `=sum_absdiff[1]' `=sum_absdiff[2]'
wrow `fh' "상위 30 겹침(개)" %9.0f `=ov30[1]' `=ov30[2]'
file close `fh'
list, noobs

foreach t in coverage workpct major major_months detailed b3 {
    type "`out'/19_`t'.tex"
}
