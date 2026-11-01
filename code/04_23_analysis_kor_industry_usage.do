* =============================================================================
* 04_23_analysis_kor_industry_usage.do
* 산업 집단의 AI 사용(지표 A·B·C)과 노출도 비교   (paper 39)
*
* 입력: $proc/merged/kor_ai_usage_ksco3.dta   (03_05) 소분류 163개의 shA, shB, shC, 노출도 3개, ksco1
*       $proc/macro/kostat_lfs_regional/kostat_lfs_regional_ksco3_groups.dta   (01_09) 소분류 × 집단(dim = ind1, ind2)
* 출력: $results/table/39_kor_industry_usage.xlsx
*   시트 groups   산업별 취업자·근로시간 비중, 사용 점유율, 상대 사용 강도 R, 노출도 평균, 상대 노출도 RX,
*                 로그 거리 d와 부트스트랩 95% 구간(ind1, ind2 모두)
*        decomp   지표 C와 노출도 기반 점유율의 "산업 몫 − 취업자 몫"을 직업 대분류별 기여로 분해
*        top      산업마다 사용(지표 C)이 많은 소분류 상위 5와 산업 안 실효 직업 수(1/HHI)
*   39_main.tex, 39_abc.tex, 39_decomp.tex, 39_top.tex   (paper 39 표; ind1 21개 + ind2의 제조업 13개)
*   $results/figure/39_fig_ind_R.{png,pdf}       산업별 R(지표 C)과 RX(β, OE) 점 그래프(로그 축, 기준선 1)
*   $results/figure/39_fig_ind_decomp.{png,pdf}  산업 몫 − 취업자 몫의 직업 대분류별 기여(대표 산업)
*
* 산업분류(2026-11-01 사용자 결정, 01_09에서 만듦):
*   ind1 = KSIC 11차 대분류 A~U(21개)
*   ind2 = 제조업 밖은 KSIC 대분류, 제조업은 국민계정 13개 산업 C01~C13(33개; 한국은행 『우리나라의 국민계정체계
*          (2025)』 <표 Ⅲ-2-6>·<표 Ⅲ-2-7>). 제조업 밖 20개 산업의 값은 ind1과 같다.
* 방법은 04_22(paper 38)와 같다: 소분류 점유율을 산업 취업자(B는 근로시간) 구성비로 나누고, 같은 직업 안에서는
*   산업과 관계없이 1인당 사용이 같다고 가정한다. R = 몫 / 취업자(근로시간) 비중, RX = 산업 취업자 가중 노출도 /
*   전체 평균, d = ln R − ln RX. 구간은 소분류 163개 복원추출 부트스트랩 999회(seed 20261025).
*   대상은 취업자 전체. 사용 0인 34개 소분류는 사용 0으로 포함.
* 매칭 키: ksco3(str3).
* =============================================================================

version 17
clear all
set more off

if `"$root"'    == "" global root    "d:/research/AI_effects"
if `"$proc"'    == "" global proc    "$root/data/proc"
if `"$results"' == "" global results "$root/results"

local out "$results/table"
local xl  "`out'/39_kor_industry_usage.xlsx"
local fig "$results/figure"
capture mkdir "`fig'"
local hdr "% 04_23_analysis_kor_industry_usage.do가 생성. 직접 고치지 말 것."
local nboot 999
local dims "ind1 ind2"
local lab_ind1 "KSIC 11차 대분류"
local lab_ind2 "제조업 세부: 국민계정 13개 산업"

capture program drop fmt
program define fmt, rclass
    args x f
    if missing(`x') {
        return local s "--"
        exit
    }
    local s : display `f' `x'
    local s = trim("`s'")
    if "`3'" == "sign" & `x' > 0 local s "+`s'"
    return local s "`s'"
end

capture program drop texesc
program define texesc, rclass
    args s
    local s = subinstr(`"`s'"', "&", "\&", .)
    local s = subinstr(`"`s'"', "%", "\%", .)
    local s = subinstr(`"`s'"', "#", "\#", .)
    local s = subinstr(`"`s'"', "_", "\_", .)
    return local s `"`s'"'
end

* -----------------------------------------------------------------------------
* Mata: 집단 통계 한 벌(행 색인 idx로 소분류를 고름; 부트스트랩에서는 중복 허용)
*   E, H: n × G 집단 취업자·근로시간, Et, Ht: 소분류 전체 취업자·근로시간, S: n × 3(A, B, C), X: n × 3(FEL, ELO, OE)
*   반환: 블록 22개 × G (순서는 아래 stn과 같음)
* -----------------------------------------------------------------------------
mata:
mata clear
real rowvector gstats(real colvector idx, real matrix E, real matrix H, real colvector Et,
    real colvector Ht, real matrix S, real matrix X)
{
    real matrix e, h, s, x, uA, uB, uBe, uC
    real colvector et, ht, eu
    real rowvector W, Eta, SA, SB, SBe, SC, RA, RB, RBe, RC, xb, xF, xE, xO, RXE, RXO, dF
    real scalar k
    e = E[idx, .]; h = H[idx, .]; et = Et[idx]; ht = Ht[idx]; s = S[idx, .]; x = X[idx, .]
    eu = rowsum(e)
    W   = colsum(e) / sum(e)
    Eta = colsum(h) / sum(h)
    uA  = s[., 1] :* (e :/ et)
    uB  = s[., 2] :* (h :/ ht)
    uBe = s[., 2] :* (e :/ et)
    uC  = s[., 3] :* (e :/ et)
    SA  = colsum(uA) / sum(uA)
    SB  = colsum(uB) / sum(uB)
    SBe = colsum(uBe) / sum(uBe)
    SC  = colsum(uC) / sum(uC)
    RA = SA :/ W; RB = SB :/ Eta; RBe = SBe :/ W; RC = SC :/ W
    xF = colsum(e :* x[., 1]) :/ colsum(e)
    xE = colsum(e :* x[., 2]) :/ colsum(e)
    xO = colsum(e :* x[., 3]) :/ colsum(e)
    RXE = xE / (sum(eu :* x[., 2]) / sum(eu))
    RXO = xO / (sum(eu :* x[., 3]) / sum(eu))
    dF  = xF :- sum(eu :* x[., 1]) / sum(eu)
    return((W, Eta, SA, SB, SC, SBe, RA, RB, RC, RBe, xF, xE, xO, RXE, RXO, dF,
        ln(RA) - ln(RXE), ln(RA) - ln(RXO), ln(RB) - ln(RXE), ln(RB) - ln(RXO),
        ln(RC) - ln(RXE), ln(RC) - ln(RXO)))
}


// 정렬된 열벡터의 분위수(선형 보간)
real scalar quant(real colvector v, real scalar q)
{
    real scalar n, h, lo
    n = rows(v)
    h = (n - 1) * q + 1
    lo = floor(h)
    if (lo >= n) return(v[n])
    return(v[lo] + (h - lo) * (v[lo + 1] - v[lo]))
}

// 점추정 P와 부트스트랩 95% 백분위 구간 L, U(각 1 × 22G)를 Stata 행렬로 남긴다
void runboot(real scalar B, real scalar seed)
{
    real matrix E, H, S, X, BS
    real colvector Et, Ht, idx, v
    real rowvector p, lo, hi
    real scalar n, b, c
    E  = st_matrix("M_E"); H = st_matrix("M_H"); Et = st_matrix("M_Et"); Ht = st_matrix("M_Ht")
    S  = st_matrix("M_S"); X = st_matrix("M_X")
    n  = rows(E)
    p  = gstats((1::n), E, H, Et, Ht, S, X)
    rseed(seed)
    BS = J(B, cols(p), .)
    for (b = 1; b <= B; b++) {
        idx = ceil(runiform(n, 1) * n)
        BS[b, .] = gstats(idx, E, H, Et, Ht, S, X)
    }
    lo = J(1, cols(p), .); hi = lo
    for (c = 1; c <= cols(p); c++) {
        v = select(BS[., c], BS[., c] :< .)
        if (rows(v) > 0) {
            v = sort(v, 1)
            lo[c] = quant(v, 0.025)
            hi[c] = quant(v, 0.975)
        }
    }
    st_matrix("P", p); st_matrix("L", lo); st_matrix("U", hi)
}
end

* -----------------------------------------------------------------------------
* 1. 소분류 지표와 소분류 전체 취업자·근로시간
* -----------------------------------------------------------------------------
use "$proc/merged/kor_ai_usage_ksco3.dta", clear
keep ksco1 ksco1_title ksco3 ksco3_title shA shB shC lm_aioe elo_gpt4_beta observed_exposure zero_use
assert _N == 163
rename (lm_aioe elo_gpt4_beta observed_exposure) (FEL ELO OE)
assert !missing(shA, shB, shC, FEL, ELO, OE)
tempfile k3
save `k3'

local gf "$proc/macro/kostat_lfs_regional/kostat_lfs_regional_ksco3_groups.dta"
use "`gf'", clear
keep if dim == "sex"
collapse (sum) Et = emp Ht = hrs, by(ksco3)
merge 1:1 ksco3 using `k3', assert(match) nogenerate
assert Et > 0 & Ht > 0
sort ksco3
save `k3', replace

* 집단 이름·표본 수
use "`gf'", clear
generate byte pos = emp > 0
keep if inlist(dim, "ind1", "ind2")                              // 산업 집단만
collapse (sum) n_obs n_ksco3 = pos, by(dim grp grp_lab)
tempfile glab
save `glab'

* -----------------------------------------------------------------------------
* 2. 구분마다 점추정·부트스트랩, 분해, 집단 안 상위 직업
* -----------------------------------------------------------------------------
local stn "W Eta SA SB SC SBe RA RB RC RBe xF xE xO RXE RXO dF dAE dAO dBE dBO dCE dCO"
tempname pr
tempfile res dec top
postfile `pr' str8 dim byte grp str4 stat double(v lo hi) using `res'
local firstd 1
foreach d of local dims {
    use "`gf'", clear
    keep if dim == "`d'"
    keep ksco3 grp emp hrs
    quietly summarize grp
    local G = r(max)
    reshape wide emp hrs, i(ksco3) j(grp)
    merge 1:1 ksco3 using `k3', assert(match using) nogenerate
    local el ""
    local hl ""
    forvalues g = 1/`G' {
        replace emp`g' = 0 if missing(emp`g')
        replace hrs`g' = 0 if missing(hrs`g')
        local el "`el' emp`g'"
        local hl "`hl' hrs`g'"
    }
    sort ksco3
    mkmat `el', matrix(M_E)
    mkmat `hl', matrix(M_H)
    mkmat Et, matrix(M_Et)
    mkmat Ht, matrix(M_Ht)
    mkmat shA shB shC, matrix(M_S)
    mkmat FEL ELO OE, matrix(M_X)
    mata: runboot(`nboot', 20261025)
    forvalues k = 1/22 {
        local st : word `k' of `stn'
        forvalues g = 1/`G' {
            local c = (`k' - 1) * `G' + `g'
            post `pr' ("`d'") (`g') ("`st'") (P[1, `c']) (L[1, `c']) (U[1, `c'])
        }
    }

    * 분해: 집단 몫 − 취업자 몫 = Σ_j (c_j − w_j) E_jg / E_j (구분 모집단 안 비중)
    egen double Eu = rowtotal(`el')
    generate double cu = shC * Eu / Et
    quietly summarize cu
    generate double c_j = cu / r(sum)
    quietly summarize Eu
    generate double w_j = Eu / r(sum)
    foreach x in ELO OE {
        generate double xu = Eu * `x'
        quietly summarize xu
        generate double xs`x'_j = xu / r(sum)
        drop xu
    }
    preserve
    forvalues g = 1/`G' {
        generate double sh`g' = cond(Eu > 0, emp`g' / Eu, 0)
        generate double dC`g'   = 100 * (c_j - w_j) * sh`g'
        generate double dELO`g' = 100 * (xsELO_j - w_j) * sh`g'
        generate double dOE`g'  = 100 * (xsOE_j - w_j) * sh`g'
    }
    collapse (sum) dC* dELO* dOE*, by(ksco1 ksco1_title)
    reshape long dC dELO dOE, i(ksco1 ksco1_title) j(grp)
    generate str8 dim = "`d'"
    if !`firstd' append using `dec'
    save `dec', replace
    restore

    * 집단 안 사용(지표 C) 분포: 상위 5 소분류와 실효 직업 수
    preserve
    forvalues g = 1/`G' {
        generate double u`g' = cond(Eu > 0, c_j * emp`g' / Eu, 0)
    }
    keep ksco3 ksco3_title u*
    reshape long u, i(ksco3 ksco3_title) j(grp)
    bysort grp: egen double tu = total(u)
    generate double ws = 100 * u / tu
    bysort grp: egen double hhi = total((ws / 100)^2)
    generate double neff = 1 / hhi
    gsort grp -ws ksco3
    by grp: generate byte rank = _n
    keep if rank <= 5
    keep grp rank ksco3 ksco3_title ws neff
    generate str8 dim = "`d'"
    if !`firstd' append using `top'
    save `top', replace
    restore
    local firstd 0
}
postclose `pr'


* -----------------------------------------------------------------------------
* 3. 산업 표(엑셀 groups 시트), 분해, 상위 직업
* -----------------------------------------------------------------------------
use `res', clear
reshape wide v lo hi, i(dim grp) j(stat) string
merge 1:1 dim grp using `glab', assert(match) nogenerate
generate byte dim_o = cond(dim == "ind1", 1, 2)
* 확인: 비중 합 1, R(C)의 취업자 가중 평균 1, ind2의 제조업 밖 값 = ind1
foreach s in W Eta SA SB SC SBe {
    bysort dim: egen double t = total(v`s')
    assert abs(t - 1) < 1e-9
    drop t
}
bysort dim: egen double t = total(vW * vRC)
assert abs(t - 1) < 1e-9
drop t
preserve
keep if dim == "ind2" & !inrange(grp, 3, 15)
replace grp = cond(grp <= 2, grp, grp - 12)
keep grp vRC vRXE vdCE
rename (vRC vRXE vdCE) (r2 x2 d2)
tempfile i2
save `i2'
restore
preserve
keep if dim == "ind1" & grp != 3
merge 1:1 grp using `i2', assert(match) nogenerate
assert reldif(vRC, r2) < 1e-9 & reldif(vRXE, x2) < 1e-9
restore
* ind2 제조업 13개의 몫 합 = ind1 제조업 몫
preserve
quietly summarize vSC if dim == "ind2" & inrange(grp, 3, 15)
local s2 = r(sum)
quietly summarize vSC if dim == "ind1" & grp == 3
assert abs(`s2' - r(mean)) < 1e-9
restore
sort dim_o grp
foreach s in W Eta SA SB SC SBe {
    foreach p in v lo hi {
        replace `p'`s' = 100 * `p'`s'
    }
}
generate str80 dim_lab = cond(dim == "ind1", "`lab_ind1'", "`lab_ind2'")
tempfile grp
save `grp'

label variable dim_lab "산업분류"
label variable grp_lab "산업"
label variable n_obs   "표본 수"
label variable n_ksco3 "취업자가 있는 소분류 수"
label variable vW      "취업자 비중(%)"
label variable vEta    "근로시간 비중(%)"
label variable vSA     "지표 A 점유율(%)"
label variable vSB     "지표 B 점유율(%, 근로시간 배분)"
label variable vSC     "지표 C 점유율(%)"
label variable vSBe    "지표 B 점유율(%, 취업자 배분, 강건성)"
label variable vRA     "R(A) = A / 취업자 비중"
label variable vRB     "R(B) = B / 근로시간 비중"
label variable vRC     "R(C) = C / 취업자 비중"
label variable loRC    "R(C) 95% 하한"
label variable hiRC    "R(C) 95% 상한"
label variable vRBe    "R(B, 취업자 배분) = B / 취업자 비중"
label variable vxF     "Felten AIOE 평균"
label variable vdF     "Felten AIOE 평균 − 전체 평균"
label variable lodF    "Felten 차이 95% 하한"
label variable hidF    "Felten 차이 95% 상한"
label variable vxE     "Eloundou β 평균"
label variable vxO     "Observed Exposure 평균"
label variable vRXE    "RX(β) = β 평균 / 전체 평균"
label variable loRXE   "RX(β) 95% 하한"
label variable hiRXE   "RX(β) 95% 상한"
label variable vRXO    "RX(OE) = OE 평균 / 전체 평균"
label variable loRXO   "RX(OE) 95% 하한"
label variable hiRXO   "RX(OE) 95% 상한"
label variable vdCE    "d(C, β) = ln R(C) − ln RX(β)"
label variable lodCE   "d(C, β) 95% 하한"
label variable hidCE   "d(C, β) 95% 상한"
label variable vdCO    "d(C, OE) = ln R(C) − ln RX(OE)"
label variable lodCO   "d(C, OE) 95% 하한"
label variable hidCO   "d(C, OE) 95% 상한"
label variable vdAE    "d(A, β)"
label variable vdAO    "d(A, OE)"
label variable vdBE    "d(B, β)"
label variable vdBO    "d(B, OE)"
export excel dim_lab grp_lab n_obs n_ksco3 vW vEta vSA vSB vSC vSBe vRA vRB vRC loRC hiRC vRBe ///
    vxF vdF lodF hidF vxE vxO vRXE loRXE hiRXE vRXO loRXO hiRXO vdCE lodCE hidCE vdCO lodCO hidCO vdAE vdAO vdBE vdBO ///
    using "`xl'", sheet("groups") firstrow(varlabels) replace
list dim grp grp_lab vW vSC vRC loRC hiRC vRXE vRXO vdCE, noobs sepby(dim) abbreviate(8)

* 분해
use `dec', clear
merge m:1 dim grp using `glab', keep(match) nogenerate keepusing(grp_lab)
generate byte dim_o = cond(dim == "ind1", 1, 2)
sort dim_o grp ksco1
generate str80 dim_lab = cond(dim == "ind1", "`lab_ind1'", "`lab_ind2'")
label variable dim_lab     "산업분류"
label variable grp_lab     "산업"
label variable ksco1       "KSCO 대분류"
label variable ksco1_title "직업 대분류 이름"
label variable dC          "지표 C 몫 − 취업자 몫 기여(%p)"
label variable dELO        "β 기반 점유율 몫 − 취업자 몫 기여(%p)"
label variable dOE         "OE 기반 점유율 몫 − 취업자 몫 기여(%p)"
export excel dim_lab grp_lab ksco1 ksco1_title dC dELO dOE using "`xl'", sheet("decomp") firstrow(varlabels) sheetreplace
preserve
collapse (sum) dC dELO, by(dim grp)
merge 1:1 dim grp using `grp', assert(match) nogenerate keepusing(vSC vW vRXE)
assert abs(dC - (vSC - vW)) < 1e-6
assert abs(dELO - (vRXE * vW - vW)) < 1e-6
restore
tempfile decl
save `decl'

* 산업 안 상위 직업
use `top', clear
merge m:1 dim grp using `glab', keep(match) nogenerate keepusing(grp_lab)
generate byte dim_o = cond(dim == "ind1", 1, 2)
sort dim_o grp rank
generate str80 dim_lab = cond(dim == "ind1", "`lab_ind1'", "`lab_ind2'")
label variable dim_lab     "산업분류"
label variable grp_lab     "산업"
label variable rank        "산업 안 순위"
label variable ksco3       "KSCO 코드(소분류)"
label variable ksco3_title "직업명(소분류)"
label variable ws          "산업 사용(지표 C) 중 몫(%)"
label variable neff        "산업 안 실효 직업 수(1 / HHI)"
export excel dim_lab grp_lab rank ksco3 ksco3_title ws neff using "`xl'", sheet("top") firstrow(varlabels) sheetreplace
tempfile topl
save `topl'

* -----------------------------------------------------------------------------
* 4. 노트용 TeX 표: ind1 21개 + ind2의 제조업 13개(제조업 밖은 ind1과 같아 생략)
* -----------------------------------------------------------------------------
tempname fh
use `grp', clear
keep if dim == "ind1" | inrange(grp, 3, 15)
sort dim_o grp
* (1) 주 표
file open `fh' using "`out'/39_main.tex", write replace
file write `fh' "`hdr'" _n
local prev ""
forvalues i = 1/`=_N' {
    if dim[`i'] != "`prev'" {
        if "`prev'" != "" file write `fh' "\midrule" _n
        file write `fh' "\multicolumn{8}{l}{\textit{`=dim_lab[`i']'}} \\" _n
        local prev = dim[`i']
    }
    fmt vW[`i'] %5.1f
    local w "`r(s)'"
    fmt vSC[`i'] %5.1f
    local c "`r(s)'"
    fmt vRC[`i'] %5.2f
    local r "`r(s)'"
    fmt loRC[`i'] %5.2f
    local rl "`r(s)'"
    fmt hiRC[`i'] %5.2f
    local rh "`r(s)'"
    fmt vRXE[`i'] %5.2f
    local xe "`r(s)'"
    fmt vRXO[`i'] %5.2f
    local xo "`r(s)'"
    fmt vdCE[`i'] %5.2f sign
    local de "`r(s)'"
    fmt lodCE[`i'] %5.2f
    local dl "`r(s)'"
    fmt hidCE[`i'] %5.2f
    local dh "`r(s)'"
    fmt vdCO[`i'] %5.2f sign
    local do "`r(s)'"
    texesc `"`=grp_lab[`i']'"'
    file write `fh' `"\quad `r(s)' & `w' & `c' & `r' {\footnotesize [`rl', `rh']} & `xe' & `xo' & `de' {\footnotesize [`dl', `dh']} & `do' \\"' _n
}
file close `fh'

* (2) 근로시간 비중, R(A)·R(B)·R(B, 취업자 배분)·R(C), Felten 차이[구간]
file open `fh' using "`out'/39_abc.tex", write replace
file write `fh' "`hdr'" _n
local prev ""
forvalues i = 1/`=_N' {
    if dim[`i'] != "`prev'" {
        if "`prev'" != "" file write `fh' "\midrule" _n
        file write `fh' "\multicolumn{7}{l}{\textit{`=dim_lab[`i']'}} \\" _n
        local prev = dim[`i']
    }
    texesc `"`=grp_lab[`i']'"'
    local row "\quad `r(s)'"
    foreach s in Eta RA RB RBe RC {
        local f = cond("`s'" == "Eta", "%5.1f", "%5.2f")
        fmt v`s'[`i'] `f'
        local row "`row' & `r(s)'"
    }
    fmt vdF[`i'] %5.2f sign
    local row "`row' & `r(s)'"
    fmt lodF[`i'] %5.2f
    local a "`r(s)'"
    fmt hidF[`i'] %5.2f
    file write `fh' `"`row' {\footnotesize [`a', `r(s)']} \\"' _n
}
file close `fh'

* (3) 분해: 대표 산업 4개(C 제조업, J 정보통신, M 전문·과학·기술, Q 보건·사회복지)
use `decl', clear
keep if dim == "ind1" & inlist(grp, 3, 10, 13, 17)
generate str4 key = cond(grp == 3, "c", cond(grp == 10, "j", cond(grp == 13, "m", "q")))
keep key ksco1 ksco1_title dC dELO
reshape wide dC dELO, i(ksco1 ksco1_title) j(key) string
sort ksco1
file open `fh' using "`out'/39_decomp.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/`=_N' {
    local row "`=ksco1[`i']' `=ksco1_title[`i']'"
    foreach k in c j m q {
        foreach m in C ELO {
            fmt d`m'`k'[`i'] %5.1f sign
            local row "`row' & `r(s)'"
        }
    }
    file write `fh' "`row' \\" _n
}
file write `fh' "\midrule" _n
local row "합계(산업 몫 \$-\$ 취업자 몫)"
foreach k in c j m q {
    foreach m in C ELO {
        quietly summarize d`m'`k'
        local v = r(sum)
        fmt `v' %5.1f sign
        local row "`row' & `r(s)'"
    }
}
file write `fh' "`row' \\" _n
file close `fh'

* (4) 산업 안 상위 3 직업과 실효 직업 수
use `topl', clear
keep if dim == "ind1" | inrange(grp, 3, 15)
keep if rank <= 3
keep dim dim_o dim_lab grp grp_lab rank ksco3 ksco3_title ws neff
reshape wide ksco3 ksco3_title ws, i(dim dim_o dim_lab grp grp_lab neff) j(rank)
sort dim_o grp
file open `fh' using "`out'/39_top.tex", write replace
file write `fh' "`hdr'" _n
local prev ""
forvalues i = 1/`=_N' {
    if dim[`i'] != "`prev'" {
        if "`prev'" != "" file write `fh' "\midrule" _n
        file write `fh' "\multicolumn{5}{l}{\textit{`=dim_lab[`i']'}} \\" _n
        local prev = dim[`i']
    }
    texesc `"`=grp_lab[`i']'"'
    local row "\quad `r(s)'"
    forvalues k = 1/3 {
        fmt ws`k'[`i'] %4.1f
        local v "`r(s)'"
        texesc `"`=ksco3_title`k'[`i']'"'
        local row `"`row' & `=ksco3`k'[`i']' `r(s)' (`v')"'
    }
    fmt neff[`i'] %4.1f
    file write `fh' `"`row' & `r(s)' \\"' _n
}
file close `fh'

* -----------------------------------------------------------------------------
* 5. 그림
* -----------------------------------------------------------------------------
graph set window fontface "Malgun Gothic"
set scheme s2color
local c_blue   "42 120 214"
local c_orange "235 104 52"
local c_aqua   "27 175 122"
local c_gray   "154 152 147"
local c_light  "200 199 194"
local c_ink    "82 81 78"
local gopt "graphregion(color(white)) plotregion(color(white))"
capture program drop savefig
program define savefig
    args path
    graph export "`path'.png", width(2400) replace
    graph export "`path'.pdf", replace
end

* (1) 산업별 R(C)[구간]과 RX(β), RX(OE): ind1 21개 + 제조업 13개. 로그 축, 기준선 1
use `grp', clear
keep if dim == "ind1" | inrange(grp, 3, 15)
sort dim_o grp
generate int pos = .
local p = 0
local prev ""
local ylab ""
forvalues i = 1/`=_N' {
    if dim[`i'] != "`prev'" {
        local ++p
        local ylab `"`ylab' `p' "{bf:`=dim_lab[`i']'}""'
        local prev = dim[`i']
    }
    local ++p
    replace pos = `p' in `i'
    local t = grp_lab[`i']
    if ustrlen("`t'") > 22 local t = usubstr("`t'", 1, 21) + "…"
    local ylab `"`ylab' `p' "`t'""'
}
local np = `p'
twoway (rcap loRC hiRC pos, horizontal lcolor("`c_blue'%60") lwidth(medthin)) ///
    (scatter pos vRXE, msymbol(D) msize(small) mcolor("`c_orange'") mlwidth(none)) ///
    (scatter pos vRXO, msymbol(T) msize(small) mcolor("`c_aqua'") mlwidth(none)) ///
    (scatter pos vRC, msymbol(O) msize(medsmall) mcolor("`c_blue'") mlwidth(none)), ///
    yscale(reverse range(0.5 `=`np' + 0.5')) ylabel(`ylab', angle(0) labsize(vsmall) noticks nogrid) ytitle("") ///
    xscale(log) xlabel(0.03125 "1/32" 0.125 "1/8" 0.5 "1/2" 2 "2" 8 "8", labsize(small) grid glcolor("`c_light'") glwidth(vthin)) ///
    xline(1, lcolor("`c_ink'") lwidth(thin)) ///
    xtitle("평균 대비 배수(로그 축, 1 = 평균)", size(small) margin(t=2)) ///
    legend(order(4 "사용 강도 R(지표 C)" 1 "R의 95% 구간" 2 "노출도 RX(Eloundou β)" 3 "노출도 RX(Observed)") ///
        cols(1) size(small) symxsize(5) keygap(1) region(lcolor(white))) ///
    title("산업별 AI 사용 강도와 노출도", size(medsmall) color("`c_ink'")) ///
    note("직업 구성으로 배분한 값" "(같은 직업 안에서는 산업과 관계없이 1인당 사용이 같다고 가정)." ///
        "제조업 세부는 국민계정 13개 산업." "구간: 소분류 163개 복원추출 부트스트랩 999회.", size(vsmall) span) ///
    `gopt' graphregion(margin(l=22 r=12)) xsize(8.5) ysize(13)
savefig "`fig'/39_fig_ind_R"

* (2) 분해: 대표 산업의 "산업 몫 − 취업자 몫"을 직업 대분류 묶음 4개로(지표 C와 β 기반 점유율)
use `decl', clear
keep if dim == "ind1" & inlist(grp, 3, 7, 9, 10, 11, 13, 17)
generate byte cat = cond(inlist(ksco1, "1", "2"), 1, cond(ksco1 == "3", 2, cond(inlist(ksco1, "4", "5"), 3, 4)))
generate byte go = cond(grp == 3, 1, cond(grp == 7, 2, cond(grp == 9, 3, cond(grp == 10, 4, cond(grp == 11, 5, cond(grp == 13, 6, 7))))))
collapse (sum) dC dELO, by(go cat)
rename (dC dELO) (d1 d2)
reshape long d, i(go cat) j(meas)
reshape wide d, i(go meas) j(cat)
label define golab 1 "C 제조업" 2 "G 도매 및 소매업" 3 "I 숙박 및 음식점업" 4 "J 정보통신업" 5 "K 금융 및 보험업" ///
    6 "M 전문·과학·기술" 7 "Q 보건·사회복지"
label values go golab
label define measlab 1 "사용(C)" 2 "노출도(β)"
label values meas measlab
graph hbar (asis) d1 d2 d3 d4, over(meas, label(labsize(vsmall))) over(go, label(labsize(small)) gap(60)) ///
    bar(1, color("`c_blue'") lwidth(none)) bar(2, color("`c_orange'") lwidth(none)) ///
    bar(3, color("`c_aqua'") lwidth(none)) bar(4, color("`c_gray'") lwidth(none)) ///
    yline(0, lcolor("`c_ink'") lwidth(thin)) ///
    ylabel(, labsize(small) grid glcolor("`c_light'") glwidth(vthin)) ytitle("산업 몫 − 취업자 몫에 대한 기여(%p)", size(small) margin(t=3)) ///
    legend(order(1 "관리자·전문가" 2 "사무" 3 "서비스·판매" 4 "기능·장치·단순노무·농림어업") ///
        rows(2) size(small) symxsize(4) keygap(1) region(lcolor(white))) ///
    title("산업 몫 − 취업자 몫의 직업 대분류별 기여", size(medium) color("`c_ink'")) ///
    note("산업마다 위 = 실제 사용(지표 C), 아래 = 노출도(Eloundou β 기반 점유율)." ///
        "막대 합 = 그 산업의 몫 − 취업자 몫. 양수면 그 직업 대분류 때문에 산업 몫이 인원보다 크다.", size(vsmall) span) ///
    `gopt' graphregion(margin(l=8 r=4)) xsize(10) ysize(9)
savefig "`fig'/39_fig_ind_decomp"
display "done"
