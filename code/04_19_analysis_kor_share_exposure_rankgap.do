* =============================================================================
* 04_19_analysis_kor_share_exposure_rankgap.do
* 점유율 지표 A·B·C와 노출도 3개의 순위 격차: 9개 쌍마다 격차 상위 30(사용 > 노출도), 하위 30(사용 < 노출도)
*   (paper 36)
*
* 입력: $proc/merged/kor_ai_usage_ksco3.dta   (03_05_merge_kor_ksco3_ai_usage.do)
*   shA, shB, shC(%), lm_aioe(Felten 언어모델 AIOE), elo_gpt4_beta(Eloundou GPT-4 β), observed_exposure
* 출력: $results/table/36_kor_share_exposure_rankgap.xlsx
*   시트 {A,B,C}_{FEL,ELO,OE}_pos   순위 격차 상위 30(사용 순위가 노출도 순위보다 높음)   9개
*        {A,B,C}_{FEL,ELO,OE}_neg   순위 격차 하위 30(노출도 순위가 사용 순위보다 높음)   9개
*        all                        129개 소분류의 지표·노출도·순위와 9개 순위 격차(참고)
*   36_summary.tex, 36_robust_pos.tex, 36_robust_neg.tex, 36_notes.tex   (paper 36 표)
*
* 표본: A~C와 노출도 3개가 모두 있는 소분류 129개(04_18과 같음, assert).
* 순위: 129개 안, 값 내림차순(1 = 가장 큼), 같은 값은 소분류 코드 순(04_18과 같은 순위).
* 순위 격차 G(m, x) = r(x) − r(m), m ∈ {A, B, C}, x ∈ {FEL, ELO, OE}.
*   양수 = 사용 순위가 노출도 순위보다 높음(사용 > 노출도), 음수 = 그 반대.
*   상위 30 = G 내림차순, 하위 30 = G 오름차순(하위 1 = 가장 음수). G가 같으면 소분류 코드 순.
* 여러 쌍에서 반복되는 소분류(36_robust_*): 9개 쌍 목록 중 몇 개에 드는지 센다.
* 매칭 키: ksco3(str3).
* =============================================================================

version 17
clear all
set more off

if `"$root"'    == "" global root    "d:/research/AI_effects"
if `"$proc"'    == "" global proc    "$root/data/proc"
if `"$results"' == "" global results "$root/results"

local out "$results/table"
local xl  "`out'/36_kor_share_exposure_rankgap.xlsx"
local ntop 30
local use  "A B C"
local expo "FEL ELO OE"
local lab_A   "지표 A"
local lab_B   "지표 B"
local lab_C   "지표 C"
local lab_FEL "Felten AIOE"
local lab_ELO "Eloundou β"
local lab_OE  "Observed Exposure"

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

* -----------------------------------------------------------------------------
* 1. 지표, 순위, 순위 격차
* -----------------------------------------------------------------------------
use "$proc/merged/kor_ai_usage_ksco3.dta", clear
keep ksco1 ksco1_title ksco3 ksco3_title shA shB shC lm_aioe elo_gpt4_beta observed_exposure n_month_conv
keep if !missing(shA, shB, shC, lm_aioe, elo_gpt4_beta, observed_exposure)
count
assert r(N) == 129
local N = r(N)
rename (shA shB shC lm_aioe elo_gpt4_beta observed_exposure) (A B C FEL ELO OE)
foreach v in `use' `expo' {
    gsort -`v' ksco3
    generate int r_`v' = _n
}
foreach m of local use {
    foreach x of local expo {
        generate int g_`m'_`x' = r_`x' - r_`m'
    }
}
sort ksco3

label variable ksco3       "KSCO 코드(8차 소분류)"
label variable ksco3_title "KSCO 직업명(소분류)"
label variable A           "지표 A: 업무용 대화 점유율(%)"
label variable B           "지표 B: 절감 시간 점유율(%)"
label variable C           "지표 C: 취업자 환산 절감 점유율(%)"
label variable FEL         "Felten AIOE(언어모델)"
label variable ELO         "Eloundou β(GPT-4)"
label variable OE          "Observed Exposure"
foreach v in `use' `expo' {
    label variable r_`v' "`lab_`v'' 순위"
}
foreach m of local use {
    foreach x of local expo {
        label variable g_`m'_`x' "순위 격차(`lab_`x'' 순위 − `lab_`m'' 순위)"
    }
}
tempfile k3
save `k3'

* 참고 시트: 129개 전부
order ksco3 ksco3_title A r_A B r_B C r_C FEL r_FEL ELO r_ELO OE r_OE g_*
export excel ksco3 ksco3_title A r_A B r_B C r_C FEL r_FEL ELO r_ELO OE r_OE g_* using "`xl'", ///
    sheet("all") firstrow(varlabels) replace

* -----------------------------------------------------------------------------
* 2. 쌍별 상위 30(pos), 하위 30(neg)
* -----------------------------------------------------------------------------
tempfile lists
local first 1
foreach m of local use {
    foreach x of local expo {
        foreach side in pos neg {
            use `k3', clear
            if "`side'" == "pos" {
                gsort -g_`m'_`x' ksco3
                local rl "격차 순위(사용 > 노출도, 큰 순)"
            }
            else {
                gsort g_`m'_`x' ksco3
                local rl "격차 하위 순위(사용 < 노출도, 작은 순)"
            }
            generate int rank = _n
            label variable rank "`rl'"
            keep if rank <= `ntop'
            export excel rank ksco3 ksco3_title `m' r_`m' `x' r_`x' g_`m'_`x' using "`xl'", ///
                sheet("`m'_`x'_`side'") firstrow(varlabels) sheetreplace
            * 반복 등장 집계용
            keep ksco3 g_`m'_`x'
            rename g_`m'_`x' g
            generate str3 pair_m = "`m'"
            generate str3 pair_x = "`x'"
            generate str3 side = "`side'"
            if !`first' append using `lists'
            save `lists', replace
            local first 0
        }
    }
}

* -----------------------------------------------------------------------------
* 3. 노트용 TeX 표
* -----------------------------------------------------------------------------
tempname fh
* (1) 쌍별 요약
use `k3', clear
file open `fh' using "`out'/36_summary.tex", write replace
file write `fh' "% 04_19_analysis_kor_share_exposure_rankgap.do가 생성. 직접 고치지 말 것." _n
foreach m of local use {
    foreach x of local expo {
        quietly spearman `m' `x'
        local v = r(rho)
        fmt `v' %5.2f
        local rho "`r(s)'"
        generate int ag = abs(g_`m'_`x')
        quietly summarize ag
        local v = r(mean)
        fmt `v' %5.1f
        local mabs "`r(s)'"
        quietly count if ag >= 30
        local n30 = r(N)
        quietly count if g_`m'_`x' > 0
        local npos = r(N)
        quietly summarize g_`m'_`x'
        local gmax = r(max)
        local gmin = r(min)
        * 상위 30·하위 30 경계값(30번째 값)
        gsort -g_`m'_`x' ksco3
        local cpos = g_`m'_`x'[`ntop']
        gsort g_`m'_`x' ksco3
        local cneg = g_`m'_`x'[`ntop']
        drop ag
        file write `fh' "`lab_`m'' & `lab_`x'' & `rho' & `mabs' & `n30' & `npos' & +`gmax' & `gmin' & +`cpos' & `cneg' \\" _n
    }
    if "`m'" != "C" file write `fh' "\midrule" _n
}
file close `fh'

* (2) 여러 쌍에서 반복되는 소분류
use `lists', clear
assert _N == 9 * 2 * `ntop'
foreach side in pos neg {
    preserve
    keep if side == "`side'"
    collapse (count) k = g (mean) gbar = g, by(ksco3)
    merge 1:1 ksco3 using `k3', keep(match) nogenerate keepusing(ksco3_title r_A r_C r_FEL r_ELO r_OE)
    quietly count if k == 9
    local all9_`side' = r(N)
    quietly count
    local nuniq_`side' = r(N)
    keep if k >= 7
    if "`side'" == "pos" gsort -k -gbar ksco3
    else                 gsort -k gbar ksco3
    local nrob_`side' = _N
    file open `fh' using "`out'/36_robust_`side'.tex", write replace
    file write `fh' "% 04_19_analysis_kor_share_exposure_rankgap.do가 생성. 직접 고치지 말 것." _n
    forvalues i = 1/`=_N' {
        fmt gbar[`i'] %6.1f
        local gb "`r(s)'"
        if "`side'" == "pos" local gb "+`gb'"
        texesc `"`=ksco3_title[`i']'"'
        file write `fh' `"`=ksco3[`i']' `r(s)' & `=k[`i']' & `gb' & `=r_A[`i']' & `=r_C[`i']' & `=r_FEL[`i']' & `=r_ELO[`i']' & `=r_OE[`i']' \\"' _n
    }
    file close `fh'
    list ksco3 ksco3_title k gbar r_A r_C r_FEL r_ELO r_OE, noobs abbreviate(10)
    restore
}

* (3) 읽을 때 주의할 수치
use `lists', clear
merge m:1 ksco3 using `k3', keep(match) nogenerate keepusing(OE n_month_conv)
quietly count if side == "pos" & pair_x == "OE" & OE == 0
local oe0_pos = r(N)
quietly count if side == "pos" & pair_x == "OE"
local oe_pos = r(N)
quietly count if side == "neg" & n_month_conv == 1
local m1_neg = r(N)
quietly count if side == "pos" & n_month_conv == 1
local m1_pos = r(N)
use `k3', clear
quietly count if OE == 0
local oe0 = r(N)
quietly count if n_month_conv == 1
local m1 = r(N)
file open `fh' using "`out'/36_notes.tex", write replace
file write `fh' "% 04_19_analysis_kor_share_exposure_rankgap.do가 생성. 직접 고치지 말 것." _n
file write `fh' "비교 소분류 수 & `N' \\" _n
file write `fh' "9개 쌍 상위 30 목록에 한 번 이상 든 소분류 수 / 9개 모두에 든 수 & `nuniq_pos' / `all9_pos' \\" _n
file write `fh' "9개 쌍 하위 30 목록에 한 번 이상 든 소분류 수 / 9개 모두에 든 수 & `nuniq_neg' / `all9_neg' \\" _n
file write `fh' "Observed Exposure = 0인 소분류 수 & `oe0' \\" _n
file write `fh' "Observed Exposure 쌍 상위 30(3개 목록, 90칸) 중 Observed Exposure = 0인 칸 & `oe0_pos' / `oe_pos' \\" _n
file write `fh' "한 달만 공개된 소분류 수 & `m1' \\" _n
file write `fh' "한 달만 공개된 소분류가 든 칸: 상위 30 목록 / 하위 30 목록(각 270칸) & `m1_pos' / `m1_neg' \\" _n
file close `fh'
display "pos uniq `nuniq_pos' all9 `all9_pos' rob `nrob_pos' | neg uniq `nuniq_neg' all9 `all9_neg' rob `nrob_neg' | OE0 in pos `oe0_pos'/`oe_pos' | 1m pos `m1_pos' neg `m1_neg'"
