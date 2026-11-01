* =============================================================================
* 04_21_analysis_kor_share_exposure_metrics.do
* 순위 격차 외 지표: 누적 점유율, 집중지수·HHI, 탄력성, 로그 거리, 로버스트 z   (paper 37)
*
* 정의는 04_16_analysis_kor_share_exposure_dist.do(paper 33)와 같다. 이 파일은 그 지표를 직업 목록과 함께
*   한 엑셀 파일로 정리한다(부트스트랩 구간은 paper 33에 있다).
*
* 입력: $proc/merged/kor_ai_usage_ksco3.dta   (03_05_merge_kor_ksco3_ai_usage.do)
*   shA, shB, emp, hbar, observed_exposure, lm_aioe(Felten 언어모델 AIOE), elo_gpt4_beta
* 출력: $results/table/37_kor_share_exposure_metrics.xlsx
*   시트 topshare   상위 10·20·30개 누적 점유율(자기 순: A, B, C, XS_OE, XS_ELO, 취업자 w;
*                   노출도 순: 노출도 상위 k개 소분류가 가진 A·B·C 점유율)
*        conc       집중지수 CI(사용 | 노출도 순), CI(XS | 노출도 순), HHI와 실효 직업 수 1/HHI
*        elas       탄력성 ln R = α + β ln RX(취업자 가중 OLS, 비가중 OLS, 분위수 회귀 τ = .1 .5 .9), Felten 준탄력성
*        d_all      163개 소분류의 로그 거리 d(6개 쌍; 사용 0인 34개는 빈칸)
*        d_top30    쌍마다 d 상위 30(사용 > 노출도)과 하위 30(노출도 > 사용)
*        z_all      163개 소분류의 로버스트 z(6개 지표)와 Δz(9개 쌍; 사용 0인 34개는 빈칸)
*        z_top30    쌍마다 Δz 상위 30과 하위 30
*   37_topshare.tex, 37_conc.tex, 37_hhi.tex, 37_elas.tex, 37_d_C_ELO.tex, 37_z_C_FEL.tex, 37_dzsum.tex  (paper 37 표)
*   $results/figure/ (.png 가로 2400px, .pdf; paper 37 그림, 대표 쌍 = d: 지표 C × Eloundou β, Δz: 지표 C × Felten)
*     37_fig_d_C_ELO_bar      d 상위 30·하위 30 발산형 가로 막대
*     37_fig_z_C_FEL_bar      Δz 상위 30·하위 30 발산형 가로 막대
*     37_fig_dz_scatter       사용 > 0인 129개 산점도 2칸(ln R 대 ln RX, z(사용) 대 z(노출도)), 45도선, 상위·하위 30 색
*     색은 04_20과 같은 dataviz 참고 팔레트(파랑 = 사용 > 노출도, 주황 = 노출도 > 사용, 회색 = 그 밖).
*
* 표본(2026-11-01): 소분류 163개(사용 0인 34개 포함). 로그를 쓰는 값(로그 거리, 로버스트 z, 탄력성)은
*   사용 > 0인 129개로 계산한다(04_16과 같음). 누적 점유율·집중지수·HHI는 163개.
* 같은 척도(163개 안에서 다시 정규화): w_j = E_j / ΣE, s^m_j(합 1, m ∈ A, B, C; C = (B / hbar) 정규화),
*   XS^x_j = E_j x_j / Σ E x(x ∈ OE, ELO; Felten은 음수가 있어 없음), R^m = s^m / w, RX^x = XS^x / w = x / x̄_E.
* 누적 점유율: 값 내림차순(같은 값은 코드 순) 상위 k개 합(%). 상위 30 안에 사용 0·OE 0 동점은 없다.
* 집중지수 CI(y | x) = 1 − 2 × (x 오름차순 집중곡선 아래 면적), 인원 w 기준, 같은 x는 한 점(04_16 Mata conc).
*   0 = 노출도와 무관, +1에 가까울수록 노출도 높은 직업에 몰림. CI(XS^x | x) = 지니(RX^x).
* HHI = Σ s²(0~1), 실효 직업 수 = 1 / HHI.
* 탄력성: β = d ln R / d ln RX. 1이면 사용 강도가 노출도에 비례, 1보다 크면 노출도 차이가 사용에서 증폭.
*   사용 0인 34개는 ln R이 없어, 사용 > 0이면서 OE = 0인 13개는 ln RX가 없어 빠진다(129개, OE 쌍 116개).
* 로그 거리 d^{m,x} = ln R^m − ln RX^x = ln(s^m / XS^x)(paper 29 LR와 같음). e^d = 사용 강도 / 노출도 강도.
* 로버스트 z(v) = (v − 중위값) / (1.4826 MAD), v = ln R^m, ln RX^x, Felten 원값(비가중, 사용 > 0인 129개 안).
*   Δz^{m,x} = z(ln R^m) − z(노출도). 양수 = 사용 분포 안 위치가 노출도 분포 안 위치보다 높음.
* 매칭 키: ksco3(str3).
* =============================================================================

version 17
clear all
set more off

if `"$root"'    == "" global root    "d:/research/AI_effects"
if `"$proc"'    == "" global proc    "$root/data/proc"
if `"$results"' == "" global results "$root/results"

local out "$results/table"
local xl  "`out'/37_kor_share_exposure_metrics.xlsx"
local hdr "% 04_21_analysis_kor_share_exposure_metrics.do가 생성. 직접 고치지 말 것."
local ntop 30
local lab_A   "지표 A"
local lab_B   "지표 B"
local lab_C   "지표 C"
local lab_OE  "Observed Exposure"
local lab_ELO "Eloundou β"
local lab_FEL "Felten AIOE"
local lab_W   "취업자 비중"

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

* TeX 특수문자(명칭 안 &, %, #, _)
capture program drop texesc
program define texesc, rclass
    args s
    local s = subinstr(`"`s'"', "&", "\&", .)
    local s = subinstr(`"`s'"', "%", "\%", .)
    local s = subinstr(`"`s'"', "#", "\#", .)
    local s = subinstr(`"`s'"', "_", "\_", .)
    return local s `"`s'"'
end

* 집중지수(04_16과 같은 함수): y를 w 기준으로 x 오름차순 누적, 같은 x는 한 점으로 묶음
mata:
mata clear
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
end

* -----------------------------------------------------------------------------
* 1. 같은 척도의 지표
* -----------------------------------------------------------------------------
use "$proc/merged/kor_ai_usage_ksco3.dta", clear
keep ksco1 ksco1_title ksco3 ksco3_title emp hbar shA shB observed_exposure lm_aioe elo_gpt4_beta
keep if !missing(shA, shB, observed_exposure, lm_aioe, elo_gpt4_beta)
count
assert r(N) == 163
local N = r(N)
rename (observed_exposure lm_aioe elo_gpt4_beta) (OE FEL ELO)
assert emp > 0 & ELO > 0
assert (shA > 0) == (shB > 0)
quietly count if shA == 0
assert r(N) == 34
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
generate double s_W    = w
drop fte eoe eel
foreach m in A B C {
    generate double R_`m'   = s_`m' / w
    generate double lnR_`m' = ln(R_`m') if R_`m' > 0
}
foreach x in OE ELO {
    generate double RX_`x'   = XS_`x' / w
    generate double lnRX_`x' = ln(RX_`x') if RX_`x' > 0
}
foreach v in R_A R_B R_C RX_OE RX_ELO {
    quietly summarize `v' [aw = w]
    assert abs(r(mean) - 1) < 1e-9
}
* 로그 거리
foreach m in A B C {
    foreach x in OE ELO {
        generate double d_`m'_`x' = lnR_`m' - lnRX_`x'
        assert abs(d_`m'_`x' - ln(s_`m' / XS_`x')) < 1e-9 if !missing(d_`m'_`x')
    }
}
* 로버스트 z(비가중, 사용 > 0인 129개 안; OE는 그중 ln RX가 있는 116개 안)
generate double zsrc_FEL = FEL
foreach v in lnR_A lnR_B lnR_C lnRX_OE lnRX_ELO zsrc_FEL {
    quietly summarize `v' if s_A > 0, detail
    local med = r(p50)
    tempvar ad
    generate double `ad' = abs(`v' - `med') if s_A > 0
    quietly summarize `ad', detail
    generate double z_`v' = (`v' - `med') / (1.4826 * r(p50)) if s_A > 0
    drop `ad'
}
drop zsrc_FEL
rename (z_lnR_A z_lnR_B z_lnR_C z_lnRX_OE z_lnRX_ELO z_zsrc_FEL) (z_A z_B z_C z_OE z_ELO z_FEL)
foreach m in A B C {
    foreach x in FEL ELO OE {
        generate double dz_`m'_`x' = z_`m' - z_`x'
    }
}
sort ksco3
tempfile k3
save `k3'

* -----------------------------------------------------------------------------
* 2. 누적 점유율(%)
* -----------------------------------------------------------------------------
tempname pf
tempfile ts
postfile `pf' str60 dist str60 order double(top10 top20 top30) using `ts'
* (1) 자기 값 순
foreach v in A B C OE ELO W {
    local sv = cond(inlist("`v'", "OE", "ELO"), "XS_`v'", "s_`v'")
    gsort -`sv' ksco3
    forvalues k = 10(10)30 {
        quietly summarize `sv' in 1/`k'
        local t`k' = 100 * r(sum)
    }
    local dn = cond(inlist("`v'", "OE", "ELO"), "노출도 기반 점유율(`lab_`v'')", "`lab_`v''")
    post `pf' ("`dn'") ("자기 값 순") (`t10') (`t20') (`t30')
}
* (2) 노출도 순: 노출도 상위 k개 소분류가 가진 사용 점유율
foreach x in FEL ELO OE {
    foreach m in A B C W {
        gsort -`x' ksco3
        forvalues k = 10(10)30 {
            quietly summarize s_`m' in 1/`k'
            local t`k' = 100 * r(sum)
        }
        post `pf' ("`lab_`m''") ("`lab_`x'' 순") (`t10') (`t20') (`t30')
    }
}
postclose `pf'
preserve
use `ts', clear
label variable dist  "분포"
label variable order "정렬 기준"
label variable top10 "상위 10개 합(%)"
label variable top20 "상위 20개 합(%)"
label variable top30 "상위 30개 합(%)"
export excel using "`xl'", sheet("topshare") firstrow(varlabels) replace
list, noobs clean
tempname fh
file open `fh' using "`out'/37_topshare.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/`=_N' {
    if `i' == 7 file write `fh' "\midrule" _n
    if `i' > 7 & mod(`i' - 7, 4) == 0 file write `fh' "\midrule" _n
    fmt top10[`i'] %5.1f
    local a "`r(s)'"
    fmt top20[`i'] %5.1f
    local b "`r(s)'"
    fmt top30[`i'] %5.1f
    file write `fh' "`=dist[`i']' & `=order[`i']' & `a' & `b' & `r(s)' \\" _n
}
file close `fh'
restore

* -----------------------------------------------------------------------------
* 3. 집중지수와 HHI
* -----------------------------------------------------------------------------
tempfile cc
postfile `pf' str60 dist str60 order double ci using `cc'
foreach m in A B C {
    foreach x in FEL ELO OE {
        mata: st_numscalar("S_ci", conc(st_data(., "s_`m'"), st_data(., "w"), st_data(., "`x'")))
        post `pf' ("`lab_`m''") ("`lab_`x'' 순") (S_ci)
    }
}
foreach x in ELO OE {
    mata: st_numscalar("S_ci", conc(st_data(., "XS_`x'"), st_data(., "w"), st_data(., "`x'")))
    mata: st_numscalar("S_gx", conc(st_data(., "XS_`x'"), st_data(., "w"), st_data(., "RX_`x'")))
    assert abs(S_ci - S_gx) < 1e-9
    post `pf' ("노출도 기반 점유율(`lab_`x'')") ("`lab_`x'' 순") (S_ci)
}
postclose `pf'
tempfile hh
postfile `pf' str60 dist double(hhi neff) using `hh'
foreach v in A B C OE ELO W {
    local sv = cond(inlist("`v'", "OE", "ELO"), "XS_`v'", "s_`v'")
    generate double sq = `sv'^2
    quietly summarize sq
    local h = r(sum)
    drop sq
    local dn = cond(inlist("`v'", "OE", "ELO"), "노출도 기반 점유율(`lab_`v'')", "`lab_`v''")
    post `pf' ("`dn'") (`h') (1 / `h')
}
postclose `pf'
preserve
use `cc', clear
label variable dist  "분포"
label variable order "정렬 기준(노출도 오름차순 누적)"
label variable ci    "집중지수 CI"
export excel using "`xl'", sheet("conc") firstrow(varlabels) sheetreplace
list, noobs clean
* 표: 행 = 지표 A·B·C, 열 = Felten·Eloundou·Observed, 마지막 행 = 노출도 기반 점유율
file open `fh' using "`out'/37_conc.tex", write replace
file write `fh' "`hdr'" _n
forvalues r = 1/3 {
    local row "`=dist[3*`r'-2]'"
    forvalues c = 1/3 {
        fmt ci[3*(`r'-1)+`c'] %5.2f
        local row "`row' & `r(s)'"
    }
    file write `fh' "`row' \\" _n
}
file write `fh' "\midrule" _n
fmt ci[11] %5.2f
local a "`r(s)'"
fmt ci[10] %5.2f
file write `fh' "노출도 기반 점유율(같은 노출도 순) & -- & `r(s)' & `a' \\" _n
file close `fh'
use `hh', clear
label variable dist "분포"
label variable hhi  "HHI(Σ s²)"
label variable neff "실효 직업 수(1 / HHI)"
export excel using "`xl'", sheet("conc") cell(E1) firstrow(varlabels) sheetmodify
list, noobs clean
file open `fh' using "`out'/37_hhi.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/`=_N' {
    fmt hhi[`i'] %6.4f
    local a "`r(s)'"
    fmt neff[`i'] %5.1f
    file write `fh' "`=dist[`i']' & `a' & `r(s)' \\" _n
}
file close `fh'
restore

* -----------------------------------------------------------------------------
* 4. 탄력성
* -----------------------------------------------------------------------------
tempfile el
postfile `pf' str20 m str60 x double(b se lo hi r2 n b_unw se_unw q10 q50 q90) using `el'
foreach m in A B C {
    foreach x in ELO OE {
        quietly regress lnR_`m' lnRX_`x' [aw = w], vce(robust)
        local b = _b[lnRX_`x']
        local se = _se[lnRX_`x']
        local tq = invttail(e(df_r), 0.025)
        local r2 = e(r2)
        local n = e(N)
        quietly regress lnR_`m' lnRX_`x', vce(robust)
        local bu = _b[lnRX_`x']
        local seu = _se[lnRX_`x']
        foreach q in 10 50 90 {
            quietly qreg lnR_`m' lnRX_`x', quantile(0.`q') vce(robust)
            local q`q' = _b[lnRX_`x']
        }
        post `pf' ("`lab_`m''") ("`lab_`x''") (`b') (`se') (`b' - `tq' * `se') (`b' + `tq' * `se') (`r2') (`n') ///
            (`bu') (`seu') (`q10') (`q50') (`q90')
    }
    quietly regress lnR_`m' FEL [aw = w], vce(robust)
    local tq = invttail(e(df_r), 0.025)
    post `pf' ("`lab_`m''") ("`lab_FEL'(준탄력성)") (_b[FEL]) (_se[FEL]) (_b[FEL] - `tq' * _se[FEL]) ///
        (_b[FEL] + `tq' * _se[FEL]) (e(r2)) (e(N)) (.) (.) (.) (.) (.)
}
postclose `pf'
preserve
use `el', clear
label variable m      "사용 지표"
label variable x      "노출도"
label variable b      "β(취업자 가중 OLS)"
label variable se     "robust SE"
label variable lo     "95% 구간 하한"
label variable hi     "95% 구간 상한"
label variable r2     "R²"
label variable n      "소분류 수"
label variable b_unw  "β(비가중 OLS)"
label variable se_unw "robust SE(비가중)"
label variable q10    "분위수 회귀 τ=0.1"
label variable q50    "분위수 회귀 τ=0.5"
label variable q90    "분위수 회귀 τ=0.9"
export excel using "`xl'", sheet("elas") firstrow(varlabels) sheetreplace
list m x b se lo hi r2 n b_unw q10 q50 q90, noobs clean
file open `fh' using "`out'/37_elas.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/`=_N' {
    if `i' > 1 & m[`i'] != m[`i'-1] file write `fh' "\midrule" _n
    local row "`=m[`i']' & `=x[`i']'"
    foreach v in b se {
        fmt `v'[`i'] %5.2f
        local row "`row' & `r(s)'"
    }
    fmt lo[`i'] %5.2f
    local a "`r(s)'"
    fmt hi[`i'] %5.2f
    local row "`row' & [`a', `r(s)']"
    fmt r2[`i'] %4.2f
    local row "`row' & `r(s)' & `=n[`i']'"
    foreach v in b_unw q10 q50 q90 {
        fmt `v'[`i'] %5.2f
        local row "`row' & `r(s)'"
    }
    file write `fh' "`row' \\" _n
}
file close `fh'
restore

* -----------------------------------------------------------------------------
* 5. 로그 거리: 전체와 쌍별 상위·하위 30
* -----------------------------------------------------------------------------
use `k3', clear
label variable ksco3       "KSCO 코드(8차 소분류)"
label variable ksco3_title "KSCO 직업명(소분류)"
label variable emp         "취업자 수(2022 상반기)"
label variable w           "취업자 비중(163개 안)"
foreach m in A B C {
    label variable s_`m'   "`lab_`m'' 점유율(163개 안, 합 1)"
    label variable R_`m'   "`lab_`m'' 상대 강도 R = s / w"
    label variable z_`m'   "로버스트 z: ln R(`lab_`m'')"
    foreach x in OE ELO {
        label variable d_`m'_`x' "로그 거리 d = ln R(`lab_`m'') − ln RX(`lab_`x'')"
    }
    foreach x in FEL ELO OE {
        label variable dz_`m'_`x' "Δz = z(`lab_`m'') − z(`lab_`x'')"
    }
}
foreach x in OE ELO {
    label variable XS_`x' "노출도 기반 점유율(`lab_`x'', 합 1)"
    label variable RX_`x' "상대 노출도 RX(`lab_`x'') = x / 취업자 가중 평균"
    label variable z_`x'  "로버스트 z: ln RX(`lab_`x'')"
}
label variable z_FEL "로버스트 z: Felten 원값"
label variable OE    "Observed Exposure"
label variable ELO   "Eloundou β"
label variable FEL   "Felten AIOE"
export excel ksco3 ksco3_title emp w s_A s_B s_C XS_OE XS_ELO R_A R_B R_C RX_OE RX_ELO d_* ///
    using "`xl'", sheet("d_all") firstrow(varlabels) sheetreplace
export excel ksco3 ksco3_title OE ELO FEL z_A z_B z_C z_OE z_ELO z_FEL dz_* ///
    using "`xl'", sheet("z_all") firstrow(varlabels) sheetreplace

* 쌍별 상위·하위 30(long). kind = d 또는 dz
foreach kind in d dz {
    local xs = cond("`kind'" == "d", "ELO OE", "FEL ELO OE")
    tempfile lst_`kind'
    local first 1
    foreach m in A B C {
        foreach x of local xs {
            foreach side in pos neg {
                use `k3', clear
                keep if !missing(`kind'_`m'_`x')
                if "`side'" == "pos" gsort -`kind'_`m'_`x' ksco3
                else                 gsort  `kind'_`m'_`x' ksco3
                keep in 1/`ntop'
                generate int rank = _n
                generate str12 pair_m = "`lab_`m''"
                generate str24 pair_x = "`lab_`x''"
                generate str20 side = cond("`side'" == "pos", "사용 > 노출도", "노출도 > 사용")
                generate double val = `kind'_`m'_`x'
                if "`kind'" == "d" {
                    generate double use_v = R_`m'
                    generate double exp_v = RX_`x'
                }
                else {
                    generate double use_v = z_`m'
                    generate double exp_v = z_`x'
                }
                keep pair_m pair_x side rank ksco3 ksco3_title val use_v exp_v emp
                if !`first' append using `lst_`kind''
                save `lst_`kind'', replace
                local first 0
            }
        }
    }
    use `lst_`kind'', clear
    generate byte mo = cond(pair_m == "`lab_A'", 1, cond(pair_m == "`lab_B'", 2, 3))
    generate byte xo = cond(pair_x == "`lab_FEL'", 1, cond(pair_x == "`lab_ELO'", 2, 3))
    generate byte so = cond(side == "사용 > 노출도", 1, 2)
    sort mo xo so rank
    drop mo xo so
    label variable pair_m "사용 지표"
    label variable pair_x "노출도"
    label variable side   "방향"
    label variable rank   "순위(방향 안, 1 = 가장 큼)"
    label variable ksco3  "KSCO 코드(8차 소분류)"
    label variable ksco3_title "KSCO 직업명(소분류)"
    label variable emp    "취업자 수(2022 상반기)"
    if "`kind'" == "d" {
        label variable val   "로그 거리 d"
        label variable use_v "사용 상대 강도 R"
        label variable exp_v "노출도 상대 강도 RX"
        generate double ratio = exp(val)
        label variable ratio "e^d(사용 강도 / 노출도 강도, 배)"
        order pair_m pair_x side rank ksco3 ksco3_title val ratio use_v exp_v emp
        export excel using "`xl'", sheet("d_top30") firstrow(varlabels) sheetreplace
    }
    else {
        label variable val   "로버스트 z 차이 Δz"
        label variable use_v "z(사용)"
        label variable exp_v "z(노출도)"
        order pair_m pair_x side rank ksco3 ksco3_title val use_v exp_v emp
        export excel using "`xl'", sheet("z_top30") firstrow(varlabels) sheetreplace
    }
    count
    save `lst_`kind'', replace
}

* -----------------------------------------------------------------------------
* 6. 노트용 표: 대표 쌍 상위·하위 10, 거리 요약
* -----------------------------------------------------------------------------
foreach spec in "d C ELO 37_d_C_ELO" "dz C FEL 37_z_C_FEL" {
    local kind : word 1 of `spec'
    local m    : word 2 of `spec'
    local x    : word 3 of `spec'
    local f    : word 4 of `spec'
    use `lst_`kind'', clear
    keep if pair_m == "`lab_`m''" & pair_x == "`lab_`x''" & rank <= 10
    file open `fh' using "`out'/`f'.tex", write replace
    file write `fh' "`hdr'" _n
    forvalues r = 1/10 {
        local row "`r'"
        foreach sd in "사용 > 노출도" "노출도 > 사용" {
            quietly levelsof ksco3 if rank == `r' & side == "`sd'", local(k) clean
            quietly levelsof ksco3_title if rank == `r' & side == "`sd'", local(t) clean
            quietly summarize val if rank == `r' & side == "`sd'"
            local v = r(mean)
            fmt `v' %5.2f sign
            local vs "`r(s)'"
            if "`kind'" == "d" {
                * e^d: 1 이상이면 "x배", 1 미만이면 "1/x배"
                local e = exp(`v')
                if `e' >= 1 local es : display %5.1f `e'
                else        local es = "1/" + string(round(1 / `e'))
                local vs "`vs' (`=trim("`es'")'배)"
            }
            texesc `"`t'"'
            local row `"`row' & `k' `r(s)' & `vs'"'
        }
        file write `fh' `"`row' \\"' _n
    }
    file close `fh'
}

* 거리 요약(지표 C): 분위수, 절댓값 평균, 2배·10배 넘는 수, 취업자 수와의 Spearman
use `k3', clear
file open `fh' using "`out'/37_dzsum.tex", write replace
file write `fh' "`hdr'" _n
local cols "d_C_ELO d_C_OE dz_C_FEL dz_C_ELO dz_C_OE"
foreach st in n p10 p50 p90 mabs n2 n10 rho {
    local lb = cond("`st'" == "n", "소분류 수", cond("`st'" == "p10", "10분위", cond("`st'" == "p50", "중위값", ///
        cond("`st'" == "p90", "90분위", cond("`st'" == "mabs", "절댓값 평균", ///
        cond("`st'" == "n2", "\$|d| > \ln 2\$(2배 넘게 차이)인 수", cond("`st'" == "n10", "\$|d| > \ln 10\$(10배 넘게 차이)인 수", ///
        "취업자 수와의 Spearman 상관")))))))
    local row "`lb'"
    foreach c of local cols {
        quietly summarize `c', detail
        if "`st'" == "n"    local s = r(N)
        if "`st'" == "p10"  {
            local v = r(p10)
            fmt `v' %5.2f
            local s "`r(s)'"
        }
        if "`st'" == "p50"  {
            local v = r(p50)
            fmt `v' %5.2f
            local s "`r(s)'"
        }
        if "`st'" == "p90"  {
            local v = r(p90)
            fmt `v' %5.2f
            local s "`r(s)'"
        }
        if inlist("`st'", "mabs", "n2", "n10") {
            generate double ab = abs(`c')
            quietly summarize ab
            local v = r(mean)
            fmt `v' %5.2f
            if "`st'" == "mabs" local s "`r(s)'"
            quietly count if ab > ln(2) & !missing(ab)
            if "`st'" == "n2" local s = cond(substr("`c'", 1, 2) == "d_", "`r(N)'", "--")
            quietly count if ab > ln(10) & !missing(ab)
            if "`st'" == "n10" local s = cond(substr("`c'", 1, 2) == "d_", "`r(N)'", "--")
            drop ab
        }
        if "`st'" == "rho" {
            quietly spearman `c' emp
            local v = r(rho)
            fmt `v' %5.2f
            local s "`r(s)'"
        }
        local row "`row' & `s'"
    }
    file write `fh' "`row' \\" _n
}
file close `fh'

* -----------------------------------------------------------------------------
* 7. 그림(paper 37): 대표 쌍의 상위·하위 30 막대, 사용 > 0인 129개 산점도
* -----------------------------------------------------------------------------
local fig "$results/figure"
capture mkdir "`fig'"
graph set window fontface "Malgun Gothic"
set scheme s2color
local c_blue   "42 120 214"
local c_orange "235 104 52"
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

* (1)·(2) 발산형 가로 막대: 왼쪽 칸 = 상위 30(파랑, 0에서 오른쪽), 오른쪽 칸 = 하위 30(주황, 0에서 왼쪽, 라벨은 오른쪽)
foreach spec in "d C ELO 37_fig_d_C_ELO_bar" "dz C FEL 37_fig_z_C_FEL_bar" {
    local kind : word 1 of `spec'
    local m    : word 2 of `spec'
    local x    : word 3 of `spec'
    local f    : word 4 of `spec'
    local vname = cond("`kind'" == "d", "로그 거리 d", "로버스트 z 차이 Δz")
    foreach side in pos neg {
        use `k3', clear
        keep if !missing(`kind'_`m'_`x')
        if "`side'" == "pos" gsort -`kind'_`m'_`x' ksco3
        else                 gsort  `kind'_`m'_`x' ksco3
        keep in 1/`ntop'
        generate int pos = _n
        generate double v = `kind'_`m'_`x'
        capture label drop bl`side'
        forvalues i = 1/`ntop' {
            local t = ksco3_title[`i']
            if ustrlen("`t'") > 15 local t = usubstr("`t'", 1, 14) + "…"
            if "`kind'" == "d" {
                local e = exp(v[`i'])
                if `e' >= 1 local es = "×" + strtrim(string(`e', "%5.1f"))
                else        local es = "×1/" + string(round(1 / `e'))
            }
            else local es = cond(v[`i'] > 0, "+", "") + strtrim(string(v[`i'], "%5.2f"))
            label define bl`side' `i' `"`=ksco3[`i']' `t' (`es')"', add
        }
        label values pos bl`side'
        if "`side'" == "pos" {
            local col "`c_blue'"
            local ttl "사용 > 노출도: 상위 30"
            local yopt "ylabel(1/`ntop', valuelabel angle(0) labsize(tiny) noticks nogrid)"
        }
        else {
            local col "`c_orange'"
            local ttl "노출도 > 사용: 하위 30"
            local yopt "ylabel(1/`ntop', valuelabel angle(0) labsize(tiny) noticks nogrid) yscale(alt)"
        }
        twoway (bar v pos, horizontal base(0) barwidth(0.7) color("`col'") lwidth(none)), ///
            yscale(reverse) `yopt' ytitle("") ///
            xline(0, lcolor("`c_ink'") lwidth(thin)) ///
            xlabel(, labsize(small) grid glcolor("`c_light'") glwidth(vthin)) ///
            xtitle("`vname'", size(small) margin(t=3)) ///
            title("`ttl'", size(medsmall) color("`c_ink'")) ///
            legend(off) `gopt' name(g_`side', replace) nodraw
    }
    if "`kind'" == "d" {
        local gt "지표 C와 Eloundou β의 로그 거리 d = ln R − ln RX (괄호 = e^d, 사용 강도 / 노출도 강도)"
        local nt "d > 0: 사용 강도가 노출도 강도보다 큼. 사용 0인 34개와 Observed Exposure = 0인 소분류는 d가 없다."
    }
    else {
        local gt "지표 C와 Felten AIOE의 로버스트 z 차이 Δz = z(사용) − z(노출도) (괄호 = Δz)"
        local nt "z = (값 − 중위값) / (1.4826 × MAD), 비가중. Δz > 0: 사용 분포 안 위치가 노출도 분포 안 위치보다 높음. 사용 0인 34개는 빠진다."
    }
    graph combine g_pos g_neg, cols(2) title("`gt'", size(small) color("`c_ink'")) ///
        note("`nt'", size(vsmall) span) graphregion(color(white)) xsize(12) ysize(8)
    savefig "`fig'/`f'"
}

* (3) 사용 > 0인 129개 산점도 2칸: 대각선에서 세로로 떨어진 정도가 거리. 상위·하위 30 색, 상위·하위 5 코드
foreach spec in "d C ELO lnR_C lnRX_ELO" "dz C FEL z_C z_FEL" {
    local kind : word 1 of `spec'
    local m    : word 2 of `spec'
    local x    : word 3 of `spec'
    local yv   : word 4 of `spec'
    local xv   : word 5 of `spec'
    use `k3', clear
    keep if !missing(`kind'_`m'_`x')
    gsort -`kind'_`m'_`x' ksco3
    generate int rk_hi = _n
    gsort `kind'_`m'_`x' ksco3
    generate int rk_lo = _n
    generate byte grp = cond(rk_hi <= `ntop', 1, cond(rk_lo <= `ntop', 2, 0))
    generate str3 code = ksco3 if rk_hi <= 5 | rk_lo <= 5
    * 같은 칸에서 가까운 라벨은 코드가 큰 쪽을 왼쪽 위(11시)에
    generate byte lpos = 3
    quietly summarize `xv'
    local dx = (r(max) - r(min)) / 25
    quietly summarize `yv'
    local dy = (r(max) - r(min)) / 30
    forvalues i = 1/`=_N' {
        if code[`i'] == "" continue
        forvalues j = 1/`=_N' {
            if `j' == `i' | code[`j'] == "" continue
            if abs(`xv'[`i'] - `xv'[`j']) < `dx' & abs(`yv'[`i'] - `yv'[`j']) < `dy' & code[`i'] > code[`j'] ///
                quietly replace lpos = 11 in `i'
        }
    }
    quietly summarize `xv'
    local x0 = r(min)
    local x1 = r(max)
    if "`kind'" == "d" {
        local xt "Eloundou β 상대 노출도 ln RX"
        local yt "지표 C 상대 사용 강도 ln R"
        local tt "로그 거리 d(지표 C × Eloundou β)"
    }
    else {
        local xt "z(Felten AIOE 원값)"
        local yt "z(ln R, 지표 C)"
        local tt "로버스트 z 차이 Δz(지표 C × Felten)"
    }
    twoway (function y = x, range(`x0' `x1') lcolor("`c_light'") lwidth(medthin)) ///
        (scatter `yv' `xv' if grp == 0, msymbol(O) msize(small) mcolor("`c_gray'%60") mlwidth(none)) ///
        (scatter `yv' `xv' if grp == 1, msymbol(O) msize(small) mcolor("`c_blue'") mlwidth(none) ///
            mlabel(code) mlabsize(vsmall) mlabcolor("`c_ink'") mlabvposition(lpos)) ///
        (scatter `yv' `xv' if grp == 2, msymbol(O) msize(small) mcolor("`c_orange'") mlwidth(none) ///
            mlabel(code) mlabsize(vsmall) mlabcolor("`c_ink'") mlabvposition(lpos)), ///
        xtitle("`xt'", size(small) margin(t=2)) ytitle("`yt'", size(small)) ///
        xlabel(, labsize(small) grid glcolor("`c_light'") glwidth(vthin)) ///
        ylabel(, labsize(small) angle(0) grid glcolor("`c_light'") glwidth(vthin)) ///
        title("`tt'", size(medsmall) color("`c_ink'")) ///
        legend(order(3 "사용 > 노출도 상위 30" 4 "노출도 > 사용 하위 30" 2 "그 밖" 1 "45도선(거리 0)") ///
            rows(2) size(small) region(lcolor(white))) ///
        `gopt' name(s_`kind', replace) nodraw
}
graph combine s_d s_dz, cols(2) ///
    title("사용 > 0인 129개 소분류의 거리: 대각선에서 세로로 떨어진 정도 = d 또는 Δz", size(small) color("`c_ink'")) ///
    note("왼쪽: 사용의 퍼짐(세로)이 노출도의 퍼짐(가로)보다 훨씬 커서 d는 사실상 사용 강도 순서를 따른다." ///
        "오른쪽: 두 축을 각자의 중위값·MAD로 맞춰 퍼짐 차이를 지운 비교. 코드 = 상위·하위 5.", size(vsmall) span) ///
    graphregion(color(white)) xsize(12) ysize(6.5)
savefig "`fig'/37_fig_dz_scatter"
display "done"
