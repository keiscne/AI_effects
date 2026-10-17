* =============================================================================
* 04_analysis_kor_ai_usage_index.do
* 한국 직업별 AI 활용도 2개의 분포, 상위 직업, 노출도와의 관계, 강건성
* (report 25: results/report/25_직업별AI활용도_자료준비.tex)
*
* 입력: $proc/merged/kor_ai_usage_ksco{3,2,1}.dta (03_merge_kor_ksco3_ai_usage.do 출력)
* 출력: $results/table/  (.tex는 tabular 본문 행만; 머리글은 문서에서 씀)
*   25_summary.tex   분류 수준별 단위 수, 지표가 있는 단위, 취업자 덮개, 전국값, 중앙값, 활용도 2 > 100% 수
*   25_ksco1.tex     대분류별 활용도와 구성요소
*   25_top_use1.tex  활용도 1 상위 15개 소분류
*   25_top_use2.tex  활용도 2 상위 15개 소분류
*   25_corr.tex      소분류 순위상관(Spearman): 활용도 1·2와 노출도 지표
*   25_decomp.tex    log 활용도 2 = log 활용도 1 + log 실효 절감 시간 − log 근로시간 분해(분산 기여)
*   25_robust.tex    강건성: 분모 근로시간·기준 연도·달을 바꿨을 때 순위상관과 중앙값 비
*   25_kor_ai_usage_index.xlsx  시트 ksco3, ksco2, ksco1(전체 변수)
* 주의: 활용도 2 > 100%는 계산 오류가 아니라 "대화 과업의 직업 ≠ 사용자 직업"과 "절감 시간 = Claude 추정치"
*   때문에 생긴다(report 25 4.1절). 수준보다 순위 비교에 쓴다.
* =============================================================================

version 17
clear all
set more off

if `"$root"'    == "" global root    "d:/research/AI_effects"
if `"$proc"'    == "" global proc    "$root/data/proc"
if `"$results"' == "" global results "$root/results"

local ind "$proc/merged"
local out "$results/table"
local hdr "% 04_analysis_kor_ai_usage_index.do가 생성. 직접 고치지 말 것."
tempname fh

capture program drop fmt
program define fmt, rclass
    args x f
    if missing(`x') {
        return local s "--"
        exit
    }
    local s : display `f' `x'
    return local s = trim("`s'")
end

* -----------------------------------------------------------------------------
* 1. 분류 수준별 요약 (25_summary)
* -----------------------------------------------------------------------------
local lvname3 "소분류"
local lvname2 "중분류"
local lvname1 "대분류"
file open `fh' using "`out'/25_summary.tex", write replace
file write `fh' "`hdr'" _n
foreach lv in 3 2 1 {
    use "`ind'/kor_ai_usage_ksco`lv'.dta", clear
    quietly count
    local n = r(N)
    quietly count if !missing(use1)
    local nv = r(N)
    quietly summarize emp
    local te = r(sum)
    quietly summarize emp if !missing(use1)
    fmt 100*r(sum)/`te' %5.1f
    local cov "`r(s)'"
    * 전국값: 분자 합 / 분모 합(소분류 대화량 결측은 0)
    quietly summarize C
    local tc = r(sum)
    quietly summarize S
    local ts = r(sum)
    quietly summarize H
    local th = r(sum)
    fmt `tc'/`te' %6.2f
    local nat1 "`r(s)'"
    fmt 100*`ts'/`th' %6.2f
    local nat2 "`r(s)'"
    quietly summarize use1, detail
    fmt r(p50) %8.2f
    local md1 "`r(s)'"
    quietly summarize use2, detail
    fmt r(p50) %8.2f
    local md2 "`r(s)'"
    quietly count if use2 > 100 & !missing(use2)
    local o100 = r(N)
    file write `fh' "`lvname`lv'' & `n' & `nv' & `cov' & `nat1' & `nat2' & `md1' & `md2' & `o100' \\" _n
}
file close `fh'

* -----------------------------------------------------------------------------
* 2. 대분류 (25_ksco1)
* -----------------------------------------------------------------------------
use "`ind'/kor_ai_usage_ksco1.dta", clear
file open `fh' using "`out'/25_ksco1.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/`=_N' {
    fmt emp[`i']/10000 %6.0fc
    local a "`r(s)'"
    fmt 100*emp_cover[`i'] %5.1f
    local b "`r(s)'"
    fmt use1[`i'] %6.2f
    local c "`r(s)'"
    fmt use2[`i'] %6.2f
    local d "`r(s)'"
    fmt use2_est[`i'] %6.2f
    local e "`r(s)'"
    fmt tau_eff[`i'] %5.0f
    local f "`r(s)'"
    fmt hrs_wk[`i'] %5.1f
    local g "`r(s)'"
    file write `fh' "`=ksco1[`i']' `=ksco1_title[`i']' & `a' & `=n_ksco3_conv[`i']'/`=n_ksco3[`i']' & `b' & `c' & `d' & `e' & `f' & `g' \\" _n
}
file close `fh'

* -----------------------------------------------------------------------------
* 3. 상위 소분류 (25_top_use1, 25_top_use2)
* -----------------------------------------------------------------------------
foreach u in use1 use2 {
    use "`ind'/kor_ai_usage_ksco3.dta", clear
    keep if !missing(`u')
    gsort -`u'
    file open `fh' using "`out'/25_top_`u'.tex", write replace
    file write `fh' "`hdr'" _n
    forvalues i = 1/15 {
        fmt emp[`i']/1000 %6.0fc
        local a "`r(s)'"
        fmt C[`i']/10000 %7.0fc
        local b "`r(s)'"
        fmt use1[`i'] %6.1f
        local c "`r(s)'"
        fmt use2[`i'] %6.1f
        local d "`r(s)'"
        fmt tau_eff[`i'] %5.0f
        local e "`r(s)'"
        local fl ""
        if conv_lb[`i'] local fl "`fl'\$^{a}\$"
        if small[`i']   local fl "`fl'\$^{b}\$"
        file write `fh' "`=ksco3[`i']' `=ksco3_title[`i']'`fl' & `a' & `b' & `c' & `d' & `e' \\" _n
    }
    file close `fh'
}

* -----------------------------------------------------------------------------
* 4. 노출도와의 순위상관 (25_corr) — 소분류, 두 지표가 모두 있는 소분류
* -----------------------------------------------------------------------------
use "`ind'/kor_ai_usage_ksco3.dta", clear
local xs "use1 use2 observed_exposure lm_aioe elo_gpt4_beta"
local xl1 "활용도 1"
local xl2 "활용도 2"
local xl3 "Observed exposure"
local xl4 "Felten AIOE(LM)"
local xl5 "Eloundou GPT-4 \$\beta\$"
file open `fh' using "`out'/25_corr.tex", write replace
file write `fh' "`hdr'" _n
forvalues r = 1/5 {
    local line "`xl`r''"
    forvalues c = 1/5 {
        if `c' > `r' {
            local line "`line' & "
            continue
        }
        local vr : word `r' of `xs'
        local vc : word `c' of `xs'
        if `r' == `c' {
            local line "`line' & 1"
            continue
        }
        quietly spearman `vr' `vc'
        fmt r(rho) %5.2f
        local line "`line' & `r(s)'"
        local nn`r'`c' = r(N)
    }
    file write `fh' "`line' \\" _n
}
quietly count if !missing(use1, observed_exposure, lm_aioe, elo_gpt4_beta)
file write `fh' "% N(모든 지표가 있는 소분류) = `r(N)'" _n
file close `fh'

* -----------------------------------------------------------------------------
* 5. 분해 (25_decomp): log use2 = log use1 + log tau_eff − log hrs_wk + 상수
* -----------------------------------------------------------------------------
use "`ind'/kor_ai_usage_ksco3.dta", clear
keep if !missing(use2) & use2 > 0
generate double l2 = ln(use2)
generate double l1 = ln(use1)
generate double lt = ln(tau_eff)
generate double lh = -ln(hrs_wk)
quietly summarize l2
local v2 = r(Var)
local n = r(N)
file open `fh' using "`out'/25_decomp.tex", write replace
file write `fh' "`hdr'" _n
local nm_l1 "log 활용도 1(취업자 1인당 대화 수)"
local nm_lt "log 대화당 실효 절감 시간"
local nm_lh "\$-\$ log 1인당 주당 근로시간"
local tot = 0
foreach c in l1 lt lh {
    quietly correlate l2 `c', covariance
    local sh = r(cov_12) / `v2'
    local tot = `tot' + `sh'
    quietly summarize `c'
    fmt r(sd) %5.2f
    local sd "`r(s)'"
    fmt 100*`sh' %6.1f
    file write `fh' "`nm_`c'' & `sd' & `r(s)' \\" _n
}
file write `fh' "\midrule" _n
fmt sqrt(`v2') %5.2f
local sd "`r(s)'"
fmt 100*`tot' %6.1f
file write `fh' "log 활용도 2 & `sd' & `r(s)' \\" _n
file write `fh' "% N = `n'" _n
file close `fh'

* -----------------------------------------------------------------------------
* 6. 강건성 (25_robust): 소분류 순위상관과 중앙값 비(대안 / 기준)
* -----------------------------------------------------------------------------
use "`ind'/kor_ai_usage_ksco3.dta", clear
local pairs "use2:use2_est use2:use2_tot use1:use1_b2025 use2:use2_b2025 use1_m04:use1_m05 use2_m04:use2_m05"
local pl1 "활용도 2: 분모 사업체 기준 보정"
local pl2 "활용도 2: 분모 주업+부업 시간"
local pl3 "활용도 1: 분모 2025년 상반기"
local pl4 "활용도 2: 분모 2025년 상반기"
local pl5 "활용도 1: 2026-04 대 2026-05"
local pl6 "활용도 2: 2026-04 대 2026-05"
file open `fh' using "`out'/25_robust.tex", write replace
file write `fh' "`hdr'" _n
local j = 0
foreach p of local pairs {
    local ++j
    gettoken a b : p, parse(":")
    local b = subinstr("`b'", ":", "", 1)
    quietly spearman `a' `b'
    local nn = r(N)
    fmt r(rho) %6.3f
    local rho "`r(s)'"
    generate double ratio = `b' / `a'
    quietly summarize ratio, detail
    local p50 = r(p50)
    local pmin = r(min)
    local pmax = r(max)
    fmt `p50' %6.3f
    local md "`r(s)'"
    fmt `pmin' %6.3f
    local mn "`r(s)'"
    fmt `pmax' %6.3f
    local mx "`r(s)'"
    drop ratio
    file write `fh' "`pl`j'' & `nn' & `rho' & `md' & `mn' & `mx' \\" _n
}
file close `fh'

* -----------------------------------------------------------------------------
* 7. 엑셀(전체 변수)
* -----------------------------------------------------------------------------
local first = 1
foreach lv in 3 2 1 {
    use "`ind'/kor_ai_usage_ksco`lv'.dta", clear
    if `first' export excel using "`out'/25_kor_ai_usage_index.xlsx", sheet("ksco`lv'") firstrow(varlabels) replace
    else       export excel using "`out'/25_kor_ai_usage_index.xlsx", sheet("ksco`lv'") firstrow(varlabels) sheetreplace
    local first = 0
}

* 확인용 출력
foreach t in summary ksco1 top_use1 top_use2 corr decomp robust {
    type "`out'/25_`t'.tex"
}
