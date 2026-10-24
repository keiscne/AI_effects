* =============================================================================
* 04_analysis_kor_soc_conversations_summary.do
* 03_merge_sensortower_aei_kor_soc_conversations.do가 만든 한국 직업(SOC)별 업무용 대화량의 요약표
*   (results/paper/19 보고서용)
*
* 입력: $proc/macro/scaling/sensortower_state_of_ai_2026/
*   sensortower_work_messages_by_country_monthly.dta     (한국 이용자·메시지·업무 비중·대화량)
*   sensortower_aei_kor_soc_major_conversations.dta      (대분류)
*   sensortower_aei_kor_soc_detailed_conversations.dta   (세부 직업)
*   $proc/usage/anthropic_economic_index/aei_claude_ai_country_usage.dta
*       (AEI 공개 한국 전체 use_case_work_pct, 검증용)
* 출력: $results/table/
*   19_kor_soc_conversations.xlsx (시트 korea, major, detailed_top30, coverage)
*   19_korea.tex      한국 월간 이용자·메시지·업무용 메시지·대화량(2026-04, 05)
*   19_coverage.tex   AEI 한국 SOC 공개 범위(대분류·세부 직업 수, pct 합계)
*   19_workpct.tex    함의된 한국 업무용 비중 대 AEI 공개 값
*   19_major.tex      대분류별 pct, 업무용 비중, 비중(전체·업무용), 대화량(2026-05)
*   19_major_months.tex 대분류별 업무용 기준 비중과 대화량(2026-04 대 2026-05)
*   19_detailed.tex   세부 직업 상위 30개(2026-05, k = 3 대화량 순)
* 단위: 이용자 백만 명, 메시지·대화 백만 건, 비중 %.
* =============================================================================

version 17
clear all
set more off

if `"$root"'    == "" global root    "d:/research/AI_effects"
if `"$raw"'     == "" global raw     "$root/data/raw"
if `"$proc"'    == "" global proc    "$root/data/proc"
if `"$results"' == "" global results "$root/results"

local stp "$proc/macro/scaling/sensortower_state_of_ai_2026"
local out "$results/table"
local xl  "`out'/19_kor_soc_conversations.xlsx"
local hdr "% 04_analysis_kor_soc_conversations_summary.do가 생성. 직접 고치지 말 것."

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
* 1. 한국 월간 값(report 17 파이프라인)
* -----------------------------------------------------------------------------
use "`stp'/sensortower_work_messages_by_country_monthly.dta", clear
keep if market == "South Korea" & inlist(month, "2026-04", "2026-05")
assert _N == 2
sort month
export excel month all_users msgs_per_user messages work_share work_messages conv_k* ///
    using "`xl'", sheet("korea", replace) firstrow(variables)
file open `fh' using "`out'/19_korea.tex", write replace
file write `fh' "`hdr'" _n
local labs `" "8개 제품 True Audience 이용자(백만 명)" "이용자 1인당 월 메시지(건)" "월간 메시지(백만 건)" "업무용 비중(\%, Signals 한국 ChatGPT)" "월간 업무용 메시지(백만 건)" "'
local vars "all_users msgs_per_user messages work_share work_messages"
local i = 0
foreach v of local vars {
    local ++i
    local lab : word `i' of `labs'
    if "`v'" == "msgs_per_user"   wrow `fh' "`lab'" %9.2f `=`v'[1]' `=`v'[2]'
    else if "`v'" == "work_share" wrow `fh' "`lab'" %9.1f `=100 * `v'[1]' `=100 * `v'[2]'
    else                          wrow `fh' "`lab'" %9.1f `=`v'[1] / 1e6' `=`v'[2] / 1e6'
}
file write `fh' "\midrule" _n
foreach k in 1p5 3 5 7 10 {
    local kk = subinstr("`k'", "p", ".", .)
    wrow `fh' "업무용 대화(백만 건), 대화당 메시지 `kk'개" %9.1f `=conv_k`k'[1] / 1e6' `=conv_k`k'[2] / 1e6'
}
file close `fh'

* -----------------------------------------------------------------------------
* 2. 공개 범위
* -----------------------------------------------------------------------------
use "`stp'/sensortower_aei_kor_soc_major_conversations.dta", clear
collapse (count) n_major = pct (first) pct_sum, by(month)
tempfile cov1
save `cov1'
use "`stp'/sensortower_aei_kor_soc_detailed_conversations.dta", clear
generate byte pub = !detail_missing
collapse (sum) n_detail = pub detail_missing (sum) pct_detail = pct, by(month)
merge 1:1 month using `cov1', assert(match) nogenerate
sort month
export excel using "`xl'", sheet("coverage", replace) firstrow(variables)
file open `fh' using "`out'/19_coverage.tex", write replace
file write `fh' "`hdr'" _n
wrow `fh' "대분류: 공개 수"                       %9.0f `=n_major[1]' `=n_major[2]'
wrow `fh' "대분류: 공개 pct 합계(\%)"             %9.2f `=pct_sum[1]' `=pct_sum[2]'
wrow `fh' "세부 직업: 공개 수"                     %9.0f `=n_detail[1]' `=n_detail[2]'
wrow `fh' "세부 직업: 공개 pct 합계(\%)"           %9.2f `=pct_detail[1]' `=pct_detail[2]'
wrow `fh' "세부 직업이 하나도 공개되지 않은 대분류 수" %9.0f `=detail_missing[1]' `=detail_missing[2]'
file close `fh'

* -----------------------------------------------------------------------------
* 3. 함의된 한국 업무용 비중 대 AEI 공개 값
* -----------------------------------------------------------------------------
use "$proc/usage/anthropic_economic_index/aei_claude_ai_country_usage.dta", clear
keep if release == "20260626" & geo_id == "KOR"
keep period use_case_work_pct
rename (period use_case_work_pct) (month work_pct_pub)
tempfile pub
save `pub'
use "`stp'/sensortower_aei_kor_soc_major_conversations.dta", clear
collapse (first) work_pct_kor pct_sum, by(month)
merge 1:1 month using `pub', assert(match) nogenerate
sort month
file open `fh' using "`out'/19_workpct.tex", write replace
file write `fh' "`hdr'" _n
wrow `fh' "대분류로 함의된 업무용 비중(\%) = \$\sum$ pct $\times$ 업무용 비중 / \$\sum$ pct" ///
    %9.2f `=work_pct_kor[1]' `=work_pct_kor[2]'
wrow `fh' "AEI 공개 한국 전체 업무용 비중(\%)" %9.2f `=work_pct_pub[1]' `=work_pct_pub[2]'
wrow `fh' "차이(\%p)" %9.2f `=work_pct_kor[1] - work_pct_pub[1]' `=work_pct_kor[2] - work_pct_pub[2]'
file close `fh'

* -----------------------------------------------------------------------------
* 4. 대분류(2026-05)
* -----------------------------------------------------------------------------
use "`stp'/sensortower_aei_kor_soc_major_conversations.dta", clear
korname
export excel month soc_major soc_major_title soc_major_kr pct work_pct share_all share_work conv_k* ///
    using "`xl'", sheet("major", replace) firstrow(variables)
preserve
keep if month == "2026-05"
gsort -share_work
file open `fh' using "`out'/19_major.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/`=_N' {
    wrow `fh' "`=soc_major[`i']' `=soc_major_kr[`i']'" %9.2f `=pct[`i']' `=work_pct[`i']' ///
        `=100 * share_all[`i']' `=100 * share_work[`i']' `=100 * (share_work[`i'] - share_all[`i'])' ///
        `=conv_k3[`i'] / 1e6'
}
file write `fh' "\midrule" _n
foreach v in pct share_all share_work conv_k3 {
    quietly summarize `v', meanonly
    local s_`v' = r(sum)
}
wrow `fh' "합계" %9.2f `s_pct' `=work_pct_kor[1]' `=100 * `s_share_all'' `=100 * `s_share_work'' 0 `=`s_conv_k3' / 1e6'
file close `fh'
restore

* 2026-04 대 2026-05
keep month soc_major soc_major_kr share_work conv_k3
replace month = subinstr(month, "-", "_", .)
reshape wide share_work conv_k3, i(soc_major soc_major_kr) j(month) string
gsort -share_work2026_05
file open `fh' using "`out'/19_major_months.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/`=_N' {
    wrow `fh' "`=soc_major[`i']' `=soc_major_kr[`i']'" %9.2f ///
        `=100 * share_work2026_04[`i']' `=100 * share_work2026_05[`i']' ///
        `=100 * (share_work2026_05[`i'] - share_work2026_04[`i'])' ///
        `=conv_k32026_04[`i'] / 1e6' `=conv_k32026_05[`i'] / 1e6'
}
file close `fh'

* -----------------------------------------------------------------------------
* 5. 세부 직업 상위 30개(2026-05)
* -----------------------------------------------------------------------------
use "`stp'/sensortower_aei_kor_soc_detailed_conversations.dta", clear
keep if month == "2026-05"
assert detail_missing == 0
gsort -conv_k3
keep in 1/30
export excel month soc_code soc_title soc_major soc_major_title_m pct share_in_major share_work_major ///
    share_work conv_k* using "`xl'", sheet("detailed_top30", replace) firstrow(variables)
file open `fh' using "`out'/19_detailed.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/`=_N' {
    local t = soc_title[`i']
    foreach c in "&" "%" "#" "_" {
        local t = subinstr(`"`t'"', "`c'", "\\`c'", .)
    }
    wrow `fh' "`=soc_code[`i']' & `t'" %9.2f `=pct[`i']' `=100 * share_in_major[`i']' ///
        `=100 * share_work_major[`i']' `=100 * share_work[`i']' `=conv_k3[`i'] / 1e6'
}
file close `fh'
