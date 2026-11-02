* =============================================================================
* 04_22_analysis_kor_group_usage.do
* 성별·연령대·교육수준·임금수준 집단의 AI 사용(지표 A·B·C)과 노출도 비교   (paper 38)
*
* 입력: $proc/merged/kor_ai_usage_ksco3.dta   (03_05) 소분류 163개의 shA, shB, shC, 노출도 3개, ksco1
*       $proc/macro/kostat_lfs_regional/kostat_lfs_regional_ksco3_groups.dta   (01_09) 소분류 × 집단 취업자·근로시간
*       $proc/macro/kostat_lfs_regional/kostat_lfs_regional_wage_cuts.dta     (01_09) 임금 5분위 경계
* 출력: $results/table/38_kor_group_usage.xlsx
*   시트 groups   집단별 취업자·근로시간 비중, 사용 점유율, 상대 사용 강도 R, 노출도 평균, 상대 노출도 RX,
*                 로그 거리 d와 부트스트랩 95% 구간
*        cuts     임금 5분위 경계
*        decomp   지표 C와 노출도 기반 점유율의 "집단 몫 − 취업자 몫"을 대분류별 기여로 분해
*        top      집단마다 사용(지표 C)이 많은 소분류 상위 5와 집단 안 실효 직업 수(1/HHI)
*   38_main.tex, 38_abc.tex, 38_decomp.tex, 38_top.tex, 38_cuts.tex   (paper 38 표)
*   $results/figure/38_fig_group_R.{png,pdf}       집단별 R(지표 C)과 RX(β, OE) 점 그래프(로그 축, 기준선 1)
*   $results/figure/38_fig_group_decomp.{png,pdf}  집단 몫 − 취업자 몫의 대분류별 기여(지표 C와 β 기반 점유율)
*
* 방법(paper 33 제안, 2026-11-01 사용자 결정):
*   집단 g, 소분류 j. E_jg·H_jg = 집단 취업자·월 주업 근로시간(지역별고용조사 2022 상반기, 01_09).
*   E_j·H_j = 소분류 전체 취업자·근로시간. 성별·연령·교육은 취업자 전체, 임금은 임금근로자만(사용자 결정).
*   같은 직업 안에서는 집단과 관계없이 1인당 사용이 같다고 가정하고 소분류 점유율을 집단에 나눈다.
*     A_g ∝ Σ_j A_j E_jg / E_j,  B_g ∝ Σ_j B_j H_jg / H_j(기본; 취업자 배분은 강건성),  C_g ∝ Σ_j C_j E_jg / E_j
*     각 구분 안에서 합 1로 정규화(임금은 임금근로자에게 배분된 몫 안에서 다시 정규화).
*   W_g = 집단 취업자 비중, η_g = 집단 근로시간 비중.
*   상대 사용 강도 R^A_g = A_g / W_g, R^B_g = B_g / η_g, R^C_g = C_g / W_g(1 = 인원만큼 씀).
*   노출도: x̄_g = Σ_j E_jg x_j / Σ_j E_jg(취업자 가중), 상대 노출도 RX^x_g = x̄_g / x̄(x = Eloundou β, OE).
*     Felten은 음수가 있어 차이 x̄_g − x̄만 쓴다. RX^x_g = XS^x_g / W_g(노출도 기반 점유율과 같은 척도).
*   로그 거리 d^{m,x}_g = ln R^m_g − ln RX^x_g(사용이 노출도의 e^d배).
*   분해: C_g − W_g = Σ_k Σ_{j∈k} (c_j − w_j) E_jg / E_j(k = KSCO 대분류, c_j·w_j는 그 구분 모집단 안 비중).
*         XS_g − W_g도 같은 식(xs_j = E_j x_j / Σ E x).
*   구간: 소분류 163개를 복원추출해 같은 계산을 999번(seed 20261025), 95% 백분위 구간(paper 33과 같음).
*         소분류 안 표본오차(지역별고용조사, AEI)는 반영하지 않는다.
*   사용 0인 34개 소분류는 사용 0으로 들어간다(2026-11-01 결정). 집단 값에는 로그를 쓰지 않으므로 빼지 않는다.
* 매칭 키: ksco3(str3).
* =============================================================================

version 17
clear all
set more off

if `"$root"'    == "" global root    "d:/research/AI_effects"
if `"$proc"'    == "" global proc    "$root/data/proc"
if `"$results"' == "" global results "$root/results"

local out "$results/table"
local xl  "`out'/38_kor_group_usage.xlsx"
local fig "$results/figure"
capture mkdir "`fig'"
local hdr "% 04_22_analysis_kor_group_usage.do가 생성. 직접 고치지 말 것."
local nboot 999
local dims "sex age edu wage_m wage_h"
local lab_sex    "성별"
local lab_age    "연령대"
local lab_edu    "교육수준"
local lab_wage_m "월평균급여 5분위(임금근로자)"
local lab_wage_h "시간당 임금 5분위(임금근로자)"

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
keep if inlist(dim, "sex", "age", "edu", "wage_m", "wage_h")      // 산업(ind1, ind2)은 04_23
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
* 3. 집단 표(엑셀 groups 시트), 분위 경계, 분해, 상위 직업
* -----------------------------------------------------------------------------
use `res', clear
reshape wide v lo hi, i(dim grp) j(stat) string
merge 1:1 dim grp using `glab', assert(match) nogenerate
generate byte dim_o = cond(dim == "sex", 1, cond(dim == "age", 2, cond(dim == "edu", 3, cond(dim == "wage_m", 4, 5))))
* 확인: 비중 합 1, R(C)의 취업자 가중 평균 1
foreach s in W Eta SA SB SC SBe {
    bysort dim: egen double t = total(v`s')
    assert abs(t - 1) < 1e-9
    drop t
}
bysort dim: egen double t = total(vW * vRC)
assert abs(t - 1) < 1e-9
drop t
sort dim_o grp
foreach s in W Eta SA SB SC SBe {
    foreach p in v lo hi {
        replace `p'`s' = 100 * `p'`s'
    }
}
generate str40 dim_lab = ""
foreach d of local dims {
    replace dim_lab = "`lab_`d''" if dim == "`d'"
}
tempfile grp
save `grp'

label variable dim_lab "집단 구분"
label variable grp_lab "집단"
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
label variable vdF     "Felten AIOE 평균 − 구분 전체 평균"
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
list dim grp grp_lab vW vSC vRC loRC hiRC vRXE vRXO vdCE vdCO, noobs sepby(dim) abbreviate(8)

* 임금 분위 경계
use "$proc/macro/kostat_lfs_regional/kostat_lfs_regional_wage_cuts.dta", clear
generate str24 dim_lab = cond(dim == "wage_m", "월평균급여(만 원)", "시간당 임금(원)")
label variable dim_lab "기준"
export excel dim_lab grp lo hi share using "`xl'", sheet("cuts") firstrow(varlabels) sheetreplace
tempfile cuts
save `cuts'

* 분해
use `dec', clear
merge m:1 dim grp using `glab', keep(match) nogenerate keepusing(grp_lab)
generate byte dim_o = cond(dim == "sex", 1, cond(dim == "age", 2, cond(dim == "edu", 3, cond(dim == "wage_m", 4, 5))))
sort dim_o grp ksco1
generate str40 dim_lab = ""
foreach d of local dims {
    replace dim_lab = "`lab_`d''" if dim == "`d'"
}
label variable dim_lab     "집단 구분"
label variable grp_lab     "집단"
label variable ksco1       "KSCO 대분류"
label variable ksco1_title "대분류 이름"
label variable dC          "지표 C 몫 − 취업자 몫 기여(%p)"
label variable dELO        "β 기반 점유율 몫 − 취업자 몫 기여(%p)"
label variable dOE         "OE 기반 점유율 몫 − 취업자 몫 기여(%p)"
export excel dim_lab grp_lab ksco1 ksco1_title dC dELO dOE using "`xl'", sheet("decomp") firstrow(varlabels) sheetreplace
* 확인: 분해 합 = 집단 몫 − 취업자 몫
preserve
collapse (sum) dC dELO, by(dim grp)
merge 1:1 dim grp using `grp', assert(match) nogenerate keepusing(vSC vW vRXE)
assert abs(dC - (vSC - vW)) < 1e-6
assert abs(dELO - (vRXE * vW - vW)) < 1e-6
restore
tempfile decl
save `decl'

* 집단 안 상위 직업
use `top', clear
merge m:1 dim grp using `glab', keep(match) nogenerate keepusing(grp_lab)
generate byte dim_o = cond(dim == "sex", 1, cond(dim == "age", 2, cond(dim == "edu", 3, cond(dim == "wage_m", 4, 5))))
sort dim_o grp rank
generate str40 dim_lab = ""
foreach d of local dims {
    replace dim_lab = "`lab_`d''" if dim == "`d'"
}
label variable dim_lab     "집단 구분"
label variable grp_lab     "집단"
label variable rank        "집단 안 순위"
label variable ksco3       "KSCO 코드(소분류)"
label variable ksco3_title "직업명(소분류)"
label variable ws          "집단 사용(지표 C) 중 몫(%)"
label variable neff        "집단 안 실효 직업 수(1 / HHI)"
export excel dim_lab grp_lab rank ksco3 ksco3_title ws neff using "`xl'", sheet("top") firstrow(varlabels) sheetreplace
tempfile topl
save `topl'

* -----------------------------------------------------------------------------
* 4. 노트용 TeX 표
* -----------------------------------------------------------------------------
tempname fh
* (1) 주 표: 취업자 비중, C 점유율, R(C)[구간], RX(β), RX(OE), d(C, β)[구간], d(C, OE)
use `grp', clear
file open `fh' using "`out'/38_main.tex", write replace
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
    file write `fh' `"\quad `=grp_lab[`i']' & `w' & `c' & `r' {\footnotesize [`rl', `rh']} & `xe' & `xo' & `de' {\footnotesize [`dl', `dh']} & `do' \\"' _n
}
file close `fh'

* (2) 근로시간 비중, R(A)·R(B)·R(B, 취업자 배분)·R(C), Felten 차이[구간]
file open `fh' using "`out'/38_abc.tex", write replace
file write `fh' "`hdr'" _n
local prev ""
forvalues i = 1/`=_N' {
    if dim[`i'] != "`prev'" {
        if "`prev'" != "" file write `fh' "\midrule" _n
        file write `fh' "\multicolumn{7}{l}{\textit{`=dim_lab[`i']'}} \\" _n
        local prev = dim[`i']
    }
    local row "\quad `=grp_lab[`i']'"
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

* (3) 분해: 대표 집단 4개(여자, 60세 이상, 대졸, 월급 5분위)의 C − W와 XS(β) − W
use `decl', clear
generate str4 key = ""
replace key = "f"  if dim == "sex" & grp == 2
replace key = "o"  if dim == "age" & grp == 5
replace key = "u"  if dim == "edu" & grp == 4
replace key = "w5" if dim == "wage_m" & grp == 5
keep if key != ""
keep key ksco1 ksco1_title dC dELO
reshape wide dC dELO, i(ksco1 ksco1_title) j(key) string
sort ksco1
file open `fh' using "`out'/38_decomp.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/`=_N' {
    local row "`=ksco1[`i']' `=ksco1_title[`i']'"
    foreach k in f o u w5 {
        foreach m in C ELO {
            fmt d`m'`k'[`i'] %5.1f sign
            local row "`row' & `r(s)'"
        }
    }
    file write `fh' "`row' \\" _n
}
file write `fh' "\midrule" _n
local row "합계(집단 몫 \$-\$ 취업자 몫)"
foreach k in f o u w5 {
    foreach m in C ELO {
        quietly summarize d`m'`k'
        local v = r(sum)
        fmt `v' %5.1f sign
        local row "`row' & `r(s)'"
    }
}
file write `fh' "`row' \\" _n
file close `fh'

* (4) 집단 안 상위 3 직업과 실효 직업 수
use `topl', clear
keep if rank <= 3
keep dim dim_o dim_lab grp grp_lab rank ksco3 ksco3_title ws neff
reshape wide ksco3 ksco3_title ws, i(dim dim_o dim_lab grp grp_lab neff) j(rank)
sort dim_o grp
file open `fh' using "`out'/38_top.tex", write replace
file write `fh' "`hdr'" _n
local prev ""
forvalues i = 1/`=_N' {
    if dim[`i'] != "`prev'" {
        if "`prev'" != "" file write `fh' "\midrule" _n
        file write `fh' "\multicolumn{5}{l}{\textit{`=dim_lab[`i']'}} \\" _n
        local prev = dim[`i']
    }
    local row "\quad `=grp_lab[`i']'"
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

* (5) 임금 분위 경계
use `cuts', clear
file open `fh' using "`out'/38_cuts.tex", write replace
file write `fh' "`hdr'" _n
forvalues q = 1/5 {
    local row "`q'분위"
    foreach d in wage_m wage_h {
        quietly summarize lo if dim == "`d'" & grp == `q'
        local a = r(mean)
        quietly summarize hi if dim == "`d'" & grp == `q'
        local b = r(mean)
        quietly summarize share if dim == "`d'" & grp == `q'
        local c = r(mean)
        local f = cond("`d'" == "wage_m", "%6.0fc", "%8.0fc")
        fmt `a' `f'
        local a "`r(s)'"
        fmt `b' `f'
        local row "`row' & `a'\$\sim\$`r(s)'"
        fmt `c' %4.1f
        local row "`row' & `r(s)'"
    }
    file write `fh' "`row' \\" _n
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

* (1) 집단별 R(C)[구간]과 RX(β), RX(OE): 로그 축, 기준선 1. 구분마다 제목 줄을 둔다
use `grp', clear
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
    local ylab `"`ylab' `p' "   `=grp_lab[`i']'""'
}
local np = `p'
twoway (rcap loRC hiRC pos, horizontal lcolor("`c_blue'%60") lwidth(medthin)) ///
    (scatter pos vRXE, msymbol(D) msize(small) mcolor("`c_orange'") mlwidth(none)) ///
    (scatter pos vRXO, msymbol(T) msize(small) mcolor("`c_aqua'") mlwidth(none)) ///
    (scatter pos vRC, msymbol(O) msize(medsmall) mcolor("`c_blue'") mlwidth(none)), ///
    yscale(reverse range(0.5 `=`np' + 0.5')) ylabel(`ylab', angle(0) labsize(vsmall) noticks nogrid) ytitle("") ///
    xscale(log) xlabel(0.0625 "0.0625" 0.125 "0.125" 0.25 "0.25" 0.5 "0.5" 1 "1" 2 "2" 4 "4", labsize(small) grid glcolor("`c_light'") glwidth(vthin)) ///
    xline(1, lcolor("`c_ink'") lwidth(thin)) ///
    xtitle("평균 대비 배수(로그 축, 1 = 그 구분 전체 평균)", size(small) margin(t=2)) ///
    legend(order(4 "사용 강도 R(지표 C)" 1 "R의 95% 구간" 2 "노출도 RX(Eloundou β)" 3 "노출도 RX(Observed)") ///
        rows(2) size(small) region(lcolor(white))) ///
    title("집단별 AI 사용 강도와 노출도", size(medium) color("`c_ink'")) ///
    note("직업 구성으로 배분한 값(같은 직업 안에서는 1인당 사용이 같다고 가정). 임금 분위는 임금근로자만." ///
        "구간: 소분류 163개 복원추출 부트스트랩 999회.", size(vsmall) span) ///
    `gopt' graphregion(margin(l=4 r=4)) xsize(8) ysize(10)
savefig "`fig'/38_fig_group_R"

* (2) 분해: 대표 집단의 "집단 몫 − 취업자 몫"을 대분류 묶음 4개로(지표 C와 β 기반 점유율)
use `decl', clear
generate byte cat = cond(inlist(ksco1, "1", "2"), 1, cond(ksco1 == "3", 2, cond(inlist(ksco1, "4", "5"), 3, 4)))
generate byte go = .
replace go = 1 if dim == "sex" & grp == 2
replace go = 2 if dim == "age" & grp == 1
replace go = 3 if dim == "age" & grp == 5
replace go = 4 if dim == "edu" & grp == 4
replace go = 5 if dim == "edu" & grp == 2
replace go = 6 if dim == "wage_m" & grp == 5
replace go = 7 if dim == "wage_m" & grp == 1
keep if !missing(go)
collapse (sum) dC dELO, by(go cat)
rename (dC dELO) (d1 d2)
reshape long d, i(go cat) j(meas)
reshape wide d, i(go meas) j(cat)
label define golab 1 "여자" 2 "15–29세" 3 "60세 이상" 4 "대졸" 5 "고졸" 6 "월급 5분위" 7 "월급 1분위"
label values go golab
label define measlab 1 "사용(C)" 2 "노출도(β)"
label values meas measlab
graph hbar (asis) d1 d2 d3 d4, over(meas, label(labsize(vsmall))) over(go, label(labsize(small)) gap(60)) ///
    bar(1, color("`c_blue'") lwidth(none)) bar(2, color("`c_orange'") lwidth(none)) ///
    bar(3, color("`c_aqua'") lwidth(none)) bar(4, color("`c_gray'") lwidth(none)) ///
    yline(0, lcolor("`c_ink'") lwidth(thin)) ///
    ylabel(, labsize(small) grid glcolor("`c_light'") glwidth(vthin)) ytitle("집단 몫 − 취업자 몫에 대한 기여(%p)", size(small) margin(t=3)) ///
    legend(order(1 "관리자·전문가" 2 "사무" 3 "서비스·판매" 4 "기능·장치·단순노무·농림어업") ///
        rows(2) size(small) symxsize(4) keygap(1) region(lcolor(white))) ///
    title("집단 몫 − 취업자 몫의 대분류별 기여", size(medium) color("`c_ink'")) ///
    note("집단마다 위 = 실제 사용(지표 C), 아래 = 노출도(Eloundou β 기반 점유율)." ///
        "막대 합 = 그 집단의 몫 − 취업자 몫. 양수면 그 대분류 때문에 집단 몫이 인원보다 크다." ///
        "월급 분위는 임금근로자 안의 값.", size(vsmall) span) ///
    `gopt' graphregion(margin(l=8 r=4)) xsize(10) ysize(9)
savefig "`fig'/38_fig_group_decomp"
display "done"
