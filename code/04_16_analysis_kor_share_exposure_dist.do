* =============================================================================
* 04_16_analysis_kor_share_exposure_dist.do
* AI 점유율 지표 A~C(paper 27)와 노출도 지표 3개의 분포 비교: 분산·쏠림·분포 간 거리·탄력성   (paper 33)
*
* 순위 비교(paper 28·29)는 값의 퍼짐과 쏠림을 반영하지 못하므로, 두 지표를 같은 척도에 놓고 분포 자체를 비교한다.
*
* 입력: $proc/merged/kor_ai_usage_ksco3.dta   (03_05_merge_kor_ksco3_ai_usage.do)
*   shA, shB(지표 A·B, %), emp, hbar(지표 C 계산), observed_exposure, lm_aioe(Felten 언어모델 AIOE), elo_gpt4_beta
* 출력: $results/table/
*   33_kor_share_exposure_dist.xlsx   시트 ksco3, disp, conc, curve, dist, conc_share, elas, dsum, boot, ksco1
*   33_disp.tex, 33_conc.tex, 33_curve.tex, 33_dist.tex, 33_hhi.tex, 33_bdiff.tex, 33_elas.tex,
*   33_dsum.tex, 33_d_pos.tex, 33_d_neg.tex, 33_top_C.tex, 33_ksco1.tex   (paper 33 표)
*
* 같은 척도(소분류 129개 안에서 다시 정규화, 작업자 판단):
*   취업자 비중 w_j = E_j / Σ E, 점유율 s^m_j(합 1), m ∈ {A, B, C}(04_12와 같은 정의)
*   노출도 기반 점유율 XS^x_j = E_j x_j / Σ E x(합 1), x ∈ {OE, ELO}(Felten은 음수가 있어 만들 수 없음)
*   상대 사용 강도 R^m_j = s^m_j / w_j, 상대 노출도 RX^x_j = XS^x_j / w_j = x_j / x̄_E(둘 다 취업자 가중 평균 1)
*   R^A는 RU1, R^C는 RU2에 비례(129개 안 정규화 상수만 다름).
* 방법(paper 33 1절):
*   방법 1 중심까지의 거리: d^{m,x}_j = ln R^m_j − ln RX^x_j(= ln(s^m / XS^x), paper 29의 LR와 같음; OE = 0인 13개 결측)
*          로버스트 z: z(v) = (v − 중위값) / (1.4826 × MAD), v = ln R^m, ln RX^x, Felten 원값(비가중),
*          Δz^{m,x} = z(ln R^m) − z(노출도)
*   방법 2 분산: 취업자 가중 CV, 로그 분산, p90/p10, 지니, Theil T(대분류 간·내 분해)
*   방법 3 쏠림: 집중지수 CI(s^m | x 순) = 1 − 2 × (노출도 오름차순 집중곡선 아래 면적), 같은 노출도는 한 점으로 묶음.
*          CI(XS^x | x 순) = Gini(RX^x)(assert). 노출도 상위 q 취업자의 몫, 비유사성 지수 DI = ½ Σ|s^m − XS^x|,
*          KL 거리 D(XS^x ‖ s^m) = Σ XS ln(XS / s^m)(XS = 0 항은 0; s^m > 0이라 유한), HHI, 상위 10개 합
*   방법 4 탄력성: ln R^m = α + β ln RX^x(취업자 가중 OLS, robust SE; 비가중 OLS, 분위수 회귀 τ = .1 .5 .9)
* 불확실성: 소분류 129개를 복원추출하는 부트스트랩 999회(seed 20261025), 매 회 정규화부터 다시 계산, 백분위 95% 구간.
* 매칭 키: ksco3(str3), ksco1(str1).
* =============================================================================

version 17
clear all
set more off

if `"$root"'    == "" global root    "d:/research/AI_effects"
if `"$proc"'    == "" global proc    "$root/data/proc"
if `"$results"' == "" global results "$root/results"

local out "$results/table"
local xl  "`out'/33_kor_share_exposure_dist.xlsx"
local hdr "% 04_16_analysis_kor_share_exposure_dist.do가 생성. 직접 고치지 말 것."
local B 999

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

* -----------------------------------------------------------------------------
* Mata: 집중곡선·지니·Theil·가중 기울기, 전체 통계(부트스트랩에서도 같은 함수)
* -----------------------------------------------------------------------------
mata:
mata clear

// y(양)를 w(인원) 기준으로 x 오름차순 누적한 집중곡선의 집중지수. 같은 x는 한 점으로 묶는다.
real scalar conc(real colvector y, real colvector w, real colvector x)
{
    real colvector o, ys, ws, xs
    real scalar Y, W, n, i, j, cy, area, gy, gw
    o  = order(x, 1)
    ys = y[o]; ws = w[o]; xs = x[o]
    Y = sum(ys); W = sum(ws); n = rows(ys)
    cy = 0; area = 0; i = 1
    while (i <= n) {
        gy = 0; gw = 0; j = i
        while (j <= n) {
            if (xs[j] != xs[i]) break
            gy = gy + ys[j]; gw = gw + ws[j]; j++
        }
        area = area + (gw / W) * (2 * cy + gy / Y) / 2
        cy = cy + gy / Y
        i = j
    }
    return(1 - 2 * area)
}

// x 내림차순으로 w 누적이 q가 될 때까지의 y 몫(같은 x 묶음 안은 선형 보간)
real scalar topsh(real colvector y, real colvector w, real colvector x, real scalar q)
{
    real colvector o, ys, ws, xs
    real scalar Y, W, n, i, j, cy, cw, gy, gw
    o  = order(-x, 1)
    ys = y[o]; ws = w[o]; xs = x[o]
    Y = sum(ys); W = sum(ws); n = rows(ys)
    cy = 0; cw = 0; i = 1
    while (i <= n) {
        gy = 0; gw = 0; j = i
        while (j <= n) {
            if (xs[j] != xs[i]) break
            gy = gy + ys[j]; gw = gw + ws[j]; j++
        }
        if (cw + gw / W >= q) return(cy + (gy / Y) * (q - cw) / (gw / W))
        cy = cy + gy / Y; cw = cw + gw / W
        i = j
    }
    return(cy)
}

// Σ s ln(s / w), s = 0 항은 0 (s, w 합 1). Theil T = theil(s^m, w), KL D(XS‖s) = theil(XS, s)
real scalar theil(real colvector s, real colvector w)
{
    real colvector k
    k = selectindex(s :> 0)
    return(sum(s[k] :* ln(s[k] :/ w[k])))
}

real scalar wmean(real colvector v, real colvector w)
{
    return(sum(w :* v) / sum(w))
}

real scalar wvar(real colvector v, real colvector w)
{
    return(wmean((v :- wmean(v, w)):^2, w))
}

real scalar wslope(real colvector yv, real colvector xv, real colvector w)
{
    return(wmean((yv :- wmean(yv, w)) :* (xv :- wmean(xv, w)), w) / wvar(xv, w))
}

// 현재 자료(129개 또는 부트스트랩 표본)에서 모든 요약 통계를 다시 계산해 Stata 스칼라 S_*로 남긴다.
void calcall()
{
    real colvector emp, w, f, R, RX, k
    real matrix S, XS, X
    string rowvector mn, xn, kn
    real scalar m, x, j
    emp = st_data(., "emp")
    w   = emp / sum(emp)
    S   = st_data(., "shA"), st_data(., "shB"), st_data(., "shB") :/ st_data(., "hbar")
    for (m = 1; m <= 3; m++) S[., m] = S[., m] / sum(S[., m])
    X   = st_data(., "OE"), st_data(., "FEL"), st_data(., "ELO")
    XS  = emp :* X[., 1], emp :* X[., 3]
    for (j = 1; j <= 2; j++) XS[., j] = XS[., j] / sum(XS[., j])
    mn = ("A", "B", "C"); xn = ("OE", "FEL", "ELO"); kn = ("OE", "ELO")

    for (m = 1; m <= 3; m++) {
        R = S[., m] :/ w
        st_numscalar("S_gini_" + mn[m],  conc(S[., m], w, R))
        st_numscalar("S_theil_" + mn[m], theil(S[., m], w))
        st_numscalar("S_cv_" + mn[m],    sqrt(wvar(R, w)))
        st_numscalar("S_vln_" + mn[m],   wvar(ln(R), w))
        st_numscalar("S_hhi_" + mn[m],   sum(S[., m]:^2))
        for (x = 1; x <= 3; x++) {
            st_numscalar("S_ci_" + mn[m] + "_" + xn[x], conc(S[., m], w, X[., x]))
        }
        for (j = 1; j <= 2; j++) {
            RX = XS[., j] :/ w
            k  = selectindex(RX :> 0)
            st_numscalar("S_di_" + mn[m] + "_" + kn[j], 0.5 * sum(abs(S[., m] - XS[., j])))
            st_numscalar("S_kl_" + mn[m] + "_" + kn[j], theil(XS[., j], S[., m]))
            st_numscalar("S_b_" + mn[m] + "_" + kn[j],  wslope(ln(R[k]), ln(RX[k]), w[k]))
        }
    }
    for (j = 1; j <= 2; j++) {
        RX = XS[., j] :/ w
        k  = selectindex(RX :> 0)
        st_numscalar("S_gini_X" + kn[j],  conc(XS[., j], w, RX))
        st_numscalar("S_theil_X" + kn[j], theil(XS[., j], w))
        st_numscalar("S_cv_X" + kn[j],    sqrt(wvar(RX, w)))
        st_numscalar("S_vln_X" + kn[j],   wvar(ln(RX[k]), w[k]))
        st_numscalar("S_hhi_X" + kn[j],   sum(XS[., j]:^2))
        st_numscalar("S_ci_X" + kn[j],    conc(XS[., j], w, X[., 2 * j - 1]))
    }
    st_numscalar("S_hhi_W", sum(w:^2))
}
end

* 부트스트랩·표에 쓰는 통계 이름(S_ 접두어 없이)
local STATS ""
foreach v in A B C XOE XELO {
    local STATS "`STATS' gini_`v' theil_`v' cv_`v' vln_`v'"
}
foreach m in A B C {
    foreach x in OE FEL ELO {
        local STATS "`STATS' ci_`m'_`x'"
    }
    foreach x in OE ELO {
        local STATS "`STATS' di_`m'_`x' kl_`m'_`x' b_`m'_`x'"
    }
}
local STATS "`STATS' ci_XOE ci_XELO"

* -----------------------------------------------------------------------------
* 1. 자료와 같은 척도의 지표
* -----------------------------------------------------------------------------
use "$proc/merged/kor_ai_usage_ksco3.dta", clear
keep ksco1 ksco1_title ksco3 ksco3_title emp hbar shA shB observed_exposure lm_aioe elo_gpt4_beta
keep if !missing(shA, shB, observed_exposure, lm_aioe, elo_gpt4_beta)
count
assert r(N) == 129
rename (observed_exposure lm_aioe elo_gpt4_beta) (OE FEL ELO)
assert shA > 0 & shB > 0 & emp > 0 & ELO > 0
count if OE == 0
assert r(N) == 13
tempfile raw
save `raw'

generate double fte = shB / hbar
generate double eoe = emp * OE
generate double eel = emp * ELO
foreach p in emp shA shB fte eoe eel {
    quietly summarize `p'
    local t_`p' = r(sum)
}
generate double w      = emp / `t_emp'
generate double s_A    = shA / `t_shA'
generate double s_B    = shB / `t_shB'
generate double s_C    = fte / `t_fte'
generate double XS_OE  = eoe / `t_eoe'
generate double XS_ELO = eel / `t_eel'
drop fte eoe eel
foreach m in A B C {
    generate double R_`m' = s_`m' / w
    generate double lnR_`m' = ln(R_`m')
}
foreach x in OE ELO {
    generate double RX_`x' = XS_`x' / w
    generate double lnRX_`x' = ln(RX_`x') if RX_`x' > 0
}
foreach v in R_A R_B R_C RX_OE RX_ELO {
    quietly summarize `v' [aw = w]
    assert abs(r(mean) - 1) < 1e-9
}
* R^A ∝ RU1이 아니라 129개 안 정규화를 다시 했으므로 순위만 확인(RU1·RU2는 163개 분모)
foreach v in OE FEL ELO {
    egen int r_`v' = rank(-`v'), unique
}
foreach m in A B C {
    egen int r_`m' = rank(-s_`m'), unique
}

* 방법 1: 중심까지의 거리
foreach m in A B C {
    foreach x in OE ELO {
        generate double d_`m'_`x' = lnR_`m' - lnRX_`x'
        assert abs(d_`m'_`x' - ln(s_`m' / XS_`x')) < 1e-9 if !missing(d_`m'_`x')
        label variable d_`m'_`x' "방법1 로그 거리 ln R^`m' - ln RX^`x'"
    }
    foreach x in OE FEL ELO {
        generate int RG_`m'_`x' = r_`x' - r_`m'
        label variable RG_`m'_`x' "순위 격차 r(`x') - r(`m')(paper 29 방법 1)"
    }
}
generate double zsrc_FEL = FEL
foreach v in lnR_A lnR_B lnR_C lnRX_OE lnRX_ELO zsrc_FEL {
    quietly summarize `v', detail
    local med = r(p50)
    tempvar ad
    generate double `ad' = abs(`v' - `med')
    quietly summarize `ad', detail
    local mad = 1.4826 * r(p50)
    generate double z_`v' = (`v' - `med') / `mad'
    drop `ad'
}
drop zsrc_FEL
rename (z_lnR_A z_lnR_B z_lnR_C z_lnRX_OE z_lnRX_ELO z_zsrc_FEL) (z_A z_B z_C z_OE z_ELO z_FEL)
foreach m in A B C {
    foreach x in OE FEL ELO {
        generate double dz_`m'_`x' = z_`m' - z_`x'
        label variable dz_`m'_`x' "방법1 로버스트 z 차이 z(`m') - z(`x')"
    }
}

order ksco3 ksco3_title ksco1 ksco1_title emp w s_* XS_* R_* RX_* OE FEL ELO r_* d_* dz_* RG_* z_*
gsort -s_C ksco3
export excel using "`xl'", sheet("ksco3") firstrow(variables) replace
tempfile d
save `d'

* -----------------------------------------------------------------------------
* 2. 점 추정과 부트스트랩
* -----------------------------------------------------------------------------
use `raw', clear
mata: calcall()
foreach s of local STATS {
    local P_`s' = scalar(S_`s')
}
* CI(XS^x | x 순) = Gini(RX^x)
assert abs(`P_ci_XOE' - `P_gini_XOE') < 1e-9
assert abs(`P_ci_XELO' - `P_gini_XELO') < 1e-9

set seed 20261025
tempname pf
tempfile bt
local pvars ""
foreach s of local STATS {
    local pvars "`pvars' double `s'"
}
postfile `pf' int rep `pvars' using `bt'
forvalues b = 1/`B' {
    preserve
    bsample
    mata: calcall()
    local pe ""
    foreach s of local STATS {
        local pe "`pe' (scalar(S_`s'))"
    }
    post `pf' (`b') `pe'
    restore
}
postclose `pf'

preserve
use `bt', clear
foreach m in A B C {
    foreach x in OE ELO {
        generate double dg_`m'_`x' = gini_`m' - gini_X`x'
        generate double dc_`m'_`x' = ci_`m'_`x' - ci_X`x'
    }
}
local BSTATS "`STATS'"
foreach m in A B C {
    foreach x in OE ELO {
        local BSTATS "`BSTATS' dg_`m'_`x' dc_`m'_`x'"
        local P_dg_`m'_`x' = `P_gini_`m'' - `P_gini_X`x''
        local P_dc_`m'_`x' = `P_ci_`m'_`x'' - `P_ci_X`x''
    }
}
tempname bp
tempfile bsum
postfile `bp' str16 통계 double(점추정 하한 상한 부트평균 부트SE) int n using `bsum'
foreach s of local BSTATS {
    quietly count if !missing(`s')
    local n = r(N)
    _pctile `s', p(2.5 97.5)
    local lo = r(r1)
    local hi = r(r2)
    quietly summarize `s'
    post `bp' ("`s'") (`P_`s'') (`lo') (`hi') (r(mean)) (r(sd)) (`n')
    local L_`s' = `lo'
    local H_`s' = `hi'
}
postclose `bp'
use `bsum', clear
export excel using "`xl'", sheet("boot") firstrow(variables) sheetreplace
restore

* 구간 문자열: [lo, hi]
capture program drop ci2
program define ci2, rclass
    args lo hi f
    local a : display `f' `lo'
    local b : display `f' `hi'
    return local s "[`=trim("`a'")', `=trim("`b'")']"
end

* -----------------------------------------------------------------------------
* 3. 방법 2: 분산 요약(취업자 가중), Theil 대분류 분해
* -----------------------------------------------------------------------------
use `d', clear
tempname fh
tempfile dp
postfile `pf' str5 지표 double(cv vln n_ln p10 p50 p90 p9010 gini gini_lo gini_hi theil theil_lo theil_hi ///
    theil_between between_pct gini_unw cv_unw) using `dp'
local i = 0
foreach v in A B C XOE XELO {
    if inlist("`v'", "A", "B", "C") {
        local R "R_`v'"
        local s "s_`v'"
    }
    else {
        local x = substr("`v'", 2, .)
        local R "RX_`x'"
        local s "XS_`x'"
    }
    _pctile `R' [aw = w], p(10 50 90)
    local p10 = r(r1)
    local p50 = r(r2)
    local p90 = r(r3)
    quietly count if `R' > 0
    local nln = r(N)
    * Theil 대분류 간: Σ_g S_g ln(S_g / W_g)
    preserve
    collapse (sum) S = `s' W = w, by(ksco1)
    generate double tb = cond(S > 0, S * ln(S / W), 0)
    quietly summarize tb
    local tb = r(sum)
    restore
    * 비가중 지니·CV(값 자체의 퍼짐, 참고)
    generate double one = 1
    mata: st_numscalar("S_gu", conc(st_data(., "`R'"), st_data(., "one"), st_data(., "`R'")))
    quietly summarize `R'
    local cvu = r(sd) / r(mean)
    drop one
    post `pf' ("`v'") (`P_cv_`v'') (`P_vln_`v'') (`nln') (`p10') (`p50') (`p90') (`p90' / `p10') ///
        (`P_gini_`v'') (`L_gini_`v'') (`H_gini_`v'') (`P_theil_`v'') (`L_theil_`v'') (`H_theil_`v'') ///
        (`tb') (100 * `tb' / `P_theil_`v'') (scalar(S_gu)) (`cvu')
}
postclose `pf'
preserve
use `dp', clear
replace p9010 = . if p10 == 0
export excel using "`xl'", sheet("disp") firstrow(variables) sheetreplace
local lab_A    "\(R^{\mathrm{A}}\) 대화"
local lab_B    "\(R^{\mathrm{B}}\) 절감 시간"
local lab_C    "\(R^{\mathrm{C}}\) 취업자 환산"
local lab_XOE  "\(RX^{\mathrm{OE}}\) Observed exposure"
local lab_XELO "\(RX^{\beta}\) Eloundou \(\beta\)"
file open `fh' using "`out'/33_disp.tex", write replace
file write `fh' "`hdr'" _n
forvalues k = 1/`=_N' {
    local v = 지표[`k']
    if "`v'" == "XOE" file write `fh' "\midrule" _n
    fmt cv[`k'] %5.2f
    local a "`r(s)'"
    fmt vln[`k'] %5.2f
    local b "`r(s)'"
    if n_ln[`k'] < 129 local b "`b'\$^{\ast}\$"
    fmt p10[`k'] %6.3f
    local c "`r(s)'"
    fmt p90[`k'] %5.2f
    local e "`r(s)'"
    fmt p9010[`k'] %6.1f
    local f "`r(s)'"
    fmt gini[`k'] %5.2f
    local g "`r(s)'"
    ci2 gini_lo[`k'] gini_hi[`k'] %4.2f
    local gc "`r(s)'"
    fmt theil[`k'] %5.2f
    local t "`r(s)'"
    ci2 theil_lo[`k'] theil_hi[`k'] %4.2f
    local tc "`r(s)'"
    fmt between_pct[`k'] %4.0f
    local bt "`r(s)'"
    file write `fh' "`lab_`v'' & `a' & `b' & `c' & `e' & `f' & `g' & `t' & `bt' \\" _n
    file write `fh' " & & & & & & {\footnotesize `gc'} & {\footnotesize `tc'} & \\" _n
}
file close `fh'
restore

* HHI·상위 10개 합(점유율 분포 자체의 집중)
tempfile hh
postfile `pf' str6 분포 double(hhi neff top10) using `hh'
foreach v in s_A s_B s_C XS_OE XS_ELO w {
    quietly generate double sq = `v'^2
    quietly summarize sq
    local h = r(sum)
    drop sq
    gsort -`v'
    quietly summarize `v' in 1/10
    local t10 = r(sum)
    post `pf' ("`v'") (`h') (1 / `h') (100 * `t10')
}
postclose `pf'
preserve
use `hh', clear
export excel using "`xl'", sheet("hhi") firstrow(variables) sheetreplace
local nm_s_A    "지표 A 대화 점유율"
local nm_s_B    "지표 B 절감 시간 점유율"
local nm_s_C    "지표 C 취업자 환산 점유율"
local nm_XS_OE  "노출도 점유율(OE)"
local nm_XS_ELO "노출도 점유율(\$\beta\$)"
local nm_w      "취업자 비중"
file open `fh' using "`out'/33_hhi.tex", write replace
file write `fh' "`hdr'" _n
forvalues k = 1/`=_N' {
    local v = 분포[`k']
    if inlist("`v'", "XS_OE", "w") file write `fh' "\midrule" _n
    fmt hhi[`k'] %6.3f
    local a "`r(s)'"
    fmt neff[`k'] %5.1f
    local b "`r(s)'"
    fmt top10[`k'] %5.1f
    local c "`r(s)'"
    file write `fh' "`nm_`v'' & `a' & `b' & `c' \\" _n
}
file close `fh'
restore

* -----------------------------------------------------------------------------
* 4. 방법 3: 집중지수, 노출도 상위 q의 몫, 분포 간 거리
* -----------------------------------------------------------------------------
* 집중지수 표: 행 = 정렬 노출도, 열 = CI(A, B, C), CI(XS^x) = Gini(RX^x), CI(C) / Gini(R^C)
tempfile cc
postfile `pf' str3 정렬 double(ci_A ci_B ci_C ci_XS gini_RC align_C) using `cc'
foreach x in OE FEL ELO {
    local cx = cond("`x'" == "FEL", ., cond("`x'" == "OE", `P_ci_XOE', `P_ci_XELO'))
    post `pf' ("`x'") (`P_ci_A_`x'') (`P_ci_B_`x'') (`P_ci_C_`x'') (`cx') (`P_gini_C') (`P_ci_C_`x'' / `P_gini_C')
}
postclose `pf'
preserve
use `cc', clear
export excel using "`xl'", sheet("conc") firstrow(variables) sheetreplace
local xl_OE  "Observed exposure"
local xl_FEL "Felten LM AIOE"
local xl_ELO "Eloundou GPT-4 \$\beta\$"
file open `fh' using "`out'/33_conc.tex", write replace
file write `fh' "`hdr'" _n
forvalues k = 1/`=_N' {
    local x = 정렬[`k']
    local row "`xl_`x''"
    foreach v in ci_A ci_B ci_C ci_XS align_C {
        fmt `v'[`k'] %5.2f
        local row "`row' & `r(s)'"
    }
    file write `fh' "`row' \\" _n
    local row " "
    foreach m in A B C {
        ci2 `L_ci_`m'_`x'' `H_ci_`m'_`x'' %4.2f
        local row "`row' & {\footnotesize `r(s)'}"
    }
    if "`x'" == "FEL" local row "`row' & & \\"
    else {
        ci2 `L_ci_X`x'' `H_ci_X`x'' %4.2f
        local row "`row' & {\footnotesize `r(s)'} & \\"
    }
    file write `fh' "`row'" _n
}
file close `fh'
restore

* 노출도 상위 q(취업자 기준)가 차지하는 몫
use `d', clear
tempfile cv
postfile `pf' str3 정렬 double q A B C XS using `cv'
foreach x in OE FEL ELO {
    foreach q in 0.1 0.2 0.5 {
        foreach m in A B C {
            mata: st_numscalar("S_t", topsh(st_data(., "s_`m'"), st_data(., "w"), st_data(., "`x'"), `q'))
            local t_`m' = scalar(S_t)
        }
        if "`x'" == "FEL" local t_X = .
        else {
            mata: st_numscalar("S_t", topsh(st_data(., "XS_`x'"), st_data(., "w"), st_data(., "`x'"), `q'))
            local t_X = scalar(S_t)
        }
        post `pf' ("`x'") (`q') (100 * `t_A') (100 * `t_B') (100 * `t_C') (100 * `t_X')
    }
}
postclose `pf'
preserve
use `cv', clear
export excel using "`xl'", sheet("curve") firstrow(variables) sheetreplace
file open `fh' using "`out'/33_curve.tex", write replace
file write `fh' "`hdr'" _n
forvalues k = 1/`=_N' {
    local x = 정렬[`k']
    if `k' > 1 & q[`k'] == 0.1 file write `fh' "\midrule" _n
    local lead = cond(q[`k'] == 0.1, "`xl_`x''", "")
    local row "`lead' & `=string(100 * q[`k'], "%2.0f")'"
    foreach v in A B C XS {
        fmt `v'[`k'] %5.1f
        local row "`row' & `r(s)'"
    }
    file write `fh' "`row' \\" _n
}
file close `fh'
restore

* 비유사성 지수·KL 거리와 대분류 간 몫
use `d', clear
tempfile ds
postfile `pf' str1 지표 str3 노출도 double(di di_lo di_hi di_between di_between_pct kl kl_lo kl_hi kl_between ///
    kl_between_pct kl_rev di_emp di_xs_emp) using `ds'
foreach m in A B C {
    foreach x in OE ELO {
        preserve
        collapse (sum) S = s_`m' X = XS_`x' W = w, by(ksco1)
        generate double ad = abs(S - X)
        generate double kb = cond(X > 0, X * ln(X / S), 0)
        quietly summarize ad
        local dib = r(sum) / 2
        quietly summarize kb
        local klb = r(sum)
        restore
        generate double kr = s_`m' * ln(s_`m' / XS_`x') if XS_`x' > 0
        quietly count if XS_`x' == 0
        if r(N) > 0 local klr = .
        else {
            quietly summarize kr
            local klr = r(sum)
        }
        drop kr
        generate double ae = abs(s_`m' - w)
        quietly summarize ae
        local die = r(sum) / 2
        replace ae = abs(XS_`x' - w)
        quietly summarize ae
        local dix = r(sum) / 2
        drop ae
        post `pf' ("`m'") ("`x'") (`P_di_`m'_`x'') (`L_di_`m'_`x'') (`H_di_`m'_`x'') (`dib') (100 * `dib' / `P_di_`m'_`x'') ///
            (`P_kl_`m'_`x'') (`L_kl_`m'_`x'') (`H_kl_`m'_`x'') (`klb') (100 * `klb' / `P_kl_`m'_`x'') (`klr') (`die') (`dix')
    }
}
postclose `pf'
preserve
use `ds', clear
export excel using "`xl'", sheet("dist") firstrow(variables) sheetreplace
local ml_A "A 대화"
local ml_B "B 절감 시간"
local ml_C "C 취업자 환산"
local xs_OE  "OE"
local xs_ELO "\$\beta\$"
file open `fh' using "`out'/33_dist.tex", write replace
file write `fh' "`hdr'" _n
forvalues k = 1/`=_N' {
    local m = 지표[`k']
    local x = 노출도[`k']
    if `k' > 1 & "`x'" == "OE" file write `fh' "\midrule" _n
    local lead = cond("`x'" == "OE", "`ml_`m''", "")
    fmt 100*di[`k'] %5.1f
    local a "`r(s)'"
    ci2 100*di_lo[`k'] 100*di_hi[`k'] %4.1f
    local ac "`r(s)'"
    fmt di_between_pct[`k'] %4.0f
    local b "`r(s)'"
    fmt kl[`k'] %5.2f
    local c "`r(s)'"
    ci2 kl_lo[`k'] kl_hi[`k'] %4.2f
    local cc "`r(s)'"
    fmt kl_between_pct[`k'] %4.0f
    local e "`r(s)'"
    fmt 100*di_emp[`k'] %5.1f
    local f "`r(s)'"
    fmt 100*di_xs_emp[`k'] %5.1f
    local g "`r(s)'"
    file write `fh' "`lead' & `xs_`x'' & `a' {\footnotesize `ac'} & `b' & `c' {\footnotesize `cc'} & `e' & `f' & `g' \\" _n
}
file close `fh'
restore

* 지니·집중지수 차이(사용 − 노출도)의 부트스트랩 구간
file open `fh' using "`out'/33_bdiff.tex", write replace
file write `fh' "`hdr'" _n
foreach m in A B C {
    foreach x in OE ELO {
        if "`m'" != "A" & "`x'" == "OE" file write `fh' "\midrule" _n
        local lead = cond("`x'" == "OE", "`ml_`m''", "")
        fmt `P_dg_`m'_`x'' %5.2f sign
        local a "`r(s)'"
        ci2 `L_dg_`m'_`x'' `H_dg_`m'_`x'' %4.2f
        local ac "`r(s)'"
        fmt `P_dc_`m'_`x'' %5.2f sign
        local b "`r(s)'"
        ci2 `L_dc_`m'_`x'' `H_dc_`m'_`x'' %4.2f
        local bc "`r(s)'"
        file write `fh' "`lead' & `xs_`x'' & `a' & `ac' & `b' & `bc' \\" _n
    }
}
file close `fh'

* -----------------------------------------------------------------------------
* 5. 방법 4: 탄력성 ln R^m = α + β ln RX^x
* -----------------------------------------------------------------------------
use `d', clear
tempfile el
postfile `pf' str1 지표 str3 노출도 double(b se b_lo b_hi r2 n b_unw se_unw q10 q50 q90) using `el'
foreach m in A B C {
    foreach x in OE ELO {
        quietly regress lnR_`m' lnRX_`x' [aw = w], vce(robust)
        local b = _b[lnRX_`x']
        local se = _se[lnRX_`x']
        local r2 = e(r2)
        local n = e(N)
        assert abs(`b' - `P_b_`m'_`x'') < 1e-8
        quietly regress lnR_`m' lnRX_`x', vce(robust)
        local bu = _b[lnRX_`x']
        local seu = _se[lnRX_`x']
        foreach q in 10 50 90 {
            quietly qreg lnR_`m' lnRX_`x', quantile(0.`q') vce(robust)
            local q`q' = _b[lnRX_`x']
        }
        post `pf' ("`m'") ("`x'") (`b') (`se') (`L_b_`m'_`x'') (`H_b_`m'_`x'') (`r2') (`n') (`bu') (`seu') (`q10') (`q50') (`q90')
    }
}
* (참고) Felten: ln R^m을 Felten 원값에 회귀(준탄력성, 취업자 가중)
foreach m in A B C {
    quietly regress lnR_`m' FEL [aw = w], vce(robust)
    post `pf' ("`m'") ("FEL") (_b[FEL]) (_se[FEL]) (.) (.) (e(r2)) (e(N)) (.) (.) (.) (.) (.)
}
postclose `pf'
preserve
use `el', clear
export excel using "`xl'", sheet("elas") firstrow(variables) sheetreplace
keep if 노출도 != "FEL"
file open `fh' using "`out'/33_elas.tex", write replace
file write `fh' "`hdr'" _n
forvalues k = 1/`=_N' {
    local m = 지표[`k']
    local x = 노출도[`k']
    if `k' > 1 & "`x'" == "OE" file write `fh' "\midrule" _n
    local lead = cond("`x'" == "OE", "`ml_`m''", "")
    fmt b[`k'] %5.2f
    local a "`r(s)'"
    fmt se[`k'] %5.2f
    local a2 "`r(s)'"
    ci2 b_lo[`k'] b_hi[`k'] %4.2f
    local ac "`r(s)'"
    fmt r2[`k'] %5.2f
    local c "`r(s)'"
    local row "`lead' & `xs_`x'' & `a' (`a2') & {\footnotesize `ac'} & `c' & `=n[`k']'"
    foreach v in b_unw q10 q50 q90 {
        fmt `v'[`k'] %5.2f
        local row "`row' & `r(s)'"
    }
    file write `fh' "`row' \\" _n
}
file close `fh'
restore

* -----------------------------------------------------------------------------
* 6. 방법 1: 거리 분포 요약과 직업 목록
* -----------------------------------------------------------------------------
use `d', clear
tempfile dq
postfile `pf' str3 지표 str6 거리 str3 노출도 int n double(p10 p50 p90 mabs n2 n10 rho_rg rho_emp rho_d) using `dq'
foreach m in A B C {
    foreach x in OE ELO {
        quietly summarize d_`m'_`x', detail
        local n = r(N)
        local p10 = r(p10)
        local p50 = r(p50)
        local p90 = r(p90)
        generate double ad = abs(d_`m'_`x')
        quietly summarize ad
        local ma = r(mean)
        quietly count if ad > ln(2) & !missing(ad)
        local n2 = r(N)
        quietly count if ad > ln(10) & !missing(ad)
        local n10 = r(N)
        drop ad
        quietly spearman d_`m'_`x' RG_`m'_`x'
        local rr = r(rho)
        quietly spearman d_`m'_`x' emp
        local re = r(rho)
        post `pf' ("`m'") ("d") ("`x'") (`n') (`p10') (`p50') (`p90') (`ma') (`n2') (`n10') (`rr') (`re') (1)
    }
    foreach x in OE FEL ELO {
        quietly summarize dz_`m'_`x', detail
        local n = r(N)
        local p10 = r(p10)
        local p50 = r(p50)
        local p90 = r(p90)
        generate double ad = abs(dz_`m'_`x')
        quietly summarize ad
        local ma = r(mean)
        drop ad
        quietly spearman dz_`m'_`x' RG_`m'_`x'
        local rr = r(rho)
        quietly spearman dz_`m'_`x' emp
        local re = r(rho)
        if "`x'" == "FEL" local rd = .
        else {
            quietly spearman dz_`m'_`x' d_`m'_`x'
            local rd = r(rho)
        }
        post `pf' ("`m'") ("dz") ("`x'") (`n') (`p10') (`p50') (`p90') (`ma') (.) (.) (`rr') (`re') (`rd')
    }
}
postclose `pf'
preserve
use `dq', clear
export excel using "`xl'", sheet("dsum") firstrow(variables) sheetreplace
* TeX: 지표 C, 열 = d(β), d(OE), Δz(β), Δz(OE), Δz(Felten)
keep if 지표 == "C"
generate byte col = .
replace col = 1 if 거리 == "d"  & 노출도 == "ELO"
replace col = 2 if 거리 == "d"  & 노출도 == "OE"
replace col = 3 if 거리 == "dz" & 노출도 == "ELO"
replace col = 4 if 거리 == "dz" & 노출도 == "OE"
replace col = 5 if 거리 == "dz" & 노출도 == "FEL"
sort col
file open `fh' using "`out'/33_dsum.tex", write replace
file write `fh' "`hdr'" _n
local rl_n      "소분류 수"
local rl_p10    "10분위"
local rl_p50    "중위값"
local rl_p90    "90분위"
local rl_mabs   "절댓값 평균"
local rl_n2     "\(|d| > \ln 2\)(2배 넘게 차이)인 소분류 수"
local rl_n10    "\(|d| > \ln 10\)(10배 넘게 차이)인 소분류 수"
local rl_rho_rg "순위 격차 RG와의 Spearman 상관"
local rl_rho_emp "취업자 수와의 Spearman 상관"
local rl_rho_d  "같은 노출도의 \(d\)와의 Spearman 상관"
foreach st in n p10 p50 p90 mabs n2 n10 rho_rg rho_emp rho_d {
    local row "`rl_`st''"
    forvalues k = 1/5 {
        local v = `st'[`k']
        if inlist("`st'", "n", "n2", "n10") & !missing(`v') local s = string(`v', "%3.0f")
        else if "`st'" == "rho_d" & `k' <= 2 local s "--"
        else {
            fmt `v' %5.2f
            local s "`r(s)'"
        }
        if missing(`v') local s "--"
        local row "`row' & `s'"
    }
    file write `fh' "`row' \\" _n
}
file close `fh'
restore

* 상세 목록: 지표 C 대 Eloundou β의 d 상위·하위 15
foreach sd in pos neg {
    use `d', clear
    if "`sd'" == "pos" gsort -d_C_ELO ksco3
    else               gsort  d_C_ELO ksco3
    keep in 1/15
    file open `fh' using "`out'/33_d_`sd'.tex", write replace
    file write `fh' "`hdr'" _n
    forvalues k = 1/15 {
        fmt R_C[`k'] %9.2g
        local a "`r(s)'"
        fmt RX_ELO[`k'] %5.2f
        local b "`r(s)'"
        fmt d_C_ELO[`k'] %5.2f sign
        local c "`r(s)'"
        local ex = exp(d_C_ELO[`k'])
        if `ex' >= 1 local e = string(`ex', "%6.1f")
        else         local e = "1/" + string(1 / `ex', "%4.0f")
        fmt RG_C_ELO[`k'] %4.0f sign
        local g "`r(s)'"
        fmt emp[`k']/1000 %6.0fc
        local h "`r(s)'"
        file write `fh' "`k' & `=ksco3[`k']' `=ksco3_title[`k']' & `a' & `b' & `c' & `e' & `=r_C[`k']' & `=r_ELO[`k']' & `g' & `h' \\" _n
    }
    file close `fh'
}

* 세 거리의 상위·하위 10 목록(지표 C): d(β), d(OE), Δz(Felten)
use `d', clear
foreach sd in pos neg {
    foreach g in d_C_ELO d_C_OE dz_C_FEL {
        preserve
        keep if !missing(`g')
        if "`sd'" == "pos" gsort -`g' ksco3
        else               gsort  `g' ksco3
        forvalues r = 1/10 {
            fmt `g'[`r'] %5.2f sign
            local c_`sd'_`g'_`r' "`=ksco3[`r']' `=ksco3_title[`r']' (`r(s)')"
        }
        restore
    }
}
file open `fh' using "`out'/33_top_C.tex", write replace
file write `fh' "`hdr'" _n
foreach sd in pos neg {
    local hd = cond("`sd'" == "pos", "\multicolumn{4}{l}{\textit{사용이 노출도보다 중심에서 더 위(상위 10)}} \\", "\multicolumn{4}{l}{\textit{노출도가 사용보다 중심에서 더 위(하위 10)}} \\")
    if "`sd'" == "neg" file write `fh' "\midrule" _n
    file write `fh' "`hd'" _n
    forvalues r = 1/10 {
        file write `fh' "`r' & `c_`sd'_d_C_ELO_`r'' & `c_`sd'_d_C_OE_`r'' & `c_`sd'_dz_C_FEL_`r'' \\" _n
    }
}
file close `fh'

* -----------------------------------------------------------------------------
* 7. 대분류: 점유율, 상대 강도, KL 대분류 간 항의 기여(지표 C)
* -----------------------------------------------------------------------------
use `d', clear
generate byte n = 1
collapse (sum) n W = w C = s_C XO = XS_OE XE = XS_ELO, by(ksco1 ksco1_title)
generate double RC  = C / W
generate double RXO = XO / W
generate double RXE = XE / W
generate double klE = XE * ln(XE / C)
generate double klO = cond(XO > 0, XO * ln(XO / C), 0)
sort ksco1
export excel using "`xl'", sheet("ksco1") firstrow(variables) sheetreplace
file open `fh' using "`out'/33_ksco1.tex", write replace
file write `fh' "`hdr'" _n
forvalues k = 1/`=_N' {
    local row "`=ksco1[`k']' `=ksco1_title[`k']' & `=n[`k']'"
    foreach v in W C XO XE {
        fmt 100*`v'[`k'] %5.1f
        local row "`row' & `r(s)'"
    }
    foreach v in RC RXO RXE {
        fmt `v'[`k'] %5.2f
        local row "`row' & `r(s)'"
    }
    foreach v in klO klE {
        fmt `v'[`k'] %6.3f sign
        local row "`row' & `r(s)'"
    }
    file write `fh' "`row' \\" _n
}
file close `fh'
list ksco1 n W C XO XE RC RXO RXE klO klE, noobs abbreviate(8)

* 노트용 출력
use `d', clear
display "Gini: A " %5.3f `P_gini_A' " B " %5.3f `P_gini_B' " C " %5.3f `P_gini_C' " XOE " %5.3f `P_gini_XOE' " XELO " %5.3f `P_gini_XELO'
display "Theil: A " %5.3f `P_theil_A' " B " %5.3f `P_theil_B' " C " %5.3f `P_theil_C' " XOE " %5.3f `P_theil_XOE' " XELO " %5.3f `P_theil_XELO'
foreach m in A B C {
    display "CI `m': OE " %5.3f `P_ci_`m'_OE' " FEL " %5.3f `P_ci_`m'_FEL' " ELO " %5.3f `P_ci_`m'_ELO' ///
        "  DI OE " %5.3f `P_di_`m'_OE' " ELO " %5.3f `P_di_`m'_ELO' "  KL OE " %5.3f `P_kl_`m'_OE' " ELO " %5.3f `P_kl_`m'_ELO' ///
        "  b OE " %5.3f `P_b_`m'_OE' " ELO " %5.3f `P_b_`m'_ELO'
}
