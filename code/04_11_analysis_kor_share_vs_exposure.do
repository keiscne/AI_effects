* =============================================================================
* 04_11_analysis_kor_share_vs_exposure.do
* AI 점유율 지표 A~C(paper 27)와 노출도 지표 3개의 상관관계, 상위 순위 비교   (paper 28)
*
* 2026-10-24 재설계: A·B는 03_05가 AEI 업무용 대화 비중에서 만든 점유율(shA, shB)을 그대로 쓴다(대화 총량·K 없음).
*
* 입력: $proc/merged/kor_ai_usage_ksco3.dta   (03_05_merge_kor_ksco3_ai_usage.do)
*   shA, shB(지표 A·B, %), emp, hbar(지표 C 계산), observed_exposure, lm_aioe(Felten 언어모델 AIOE), elo_gpt4_beta
*   (노출도는 SOC 값을 연계표 w_mean으로 평균한 소분류 값, paper 23)
* 출력: $results/table/
*   28_kor_share_vs_exposure.xlsx   시트 ksco3(지표·순위), spearman, pearson, overlap30, top_fs, top_expo
*   28_corr.tex, 28_overlap.tex, 28_top_fs.tex, 28_top_expo.tex   (paper 28 표)
*
* 지표(소분류 j, 합은 비교 대상 소분류 전체):
*   A CS = shA, B SS = shB(129개 안 다시 정규화, 값은 같음), C FS = (shB / hbar) / Σ(shB / hbar), hbar = H / emp
*     (04_10_analysis_kor_ai_share_index.do와 같은 정의, 여기서 다시 계산)
*   노출도(강도): OE = observed exposure, FEL = Felten LM AIOE, ELO = Eloundou GPT-4 β
*   노출도 기반 점유율(작업자 판단, 규모를 맞춘 비교용): XS_x = emp × x / Σ(emp × x), x ∈ {OE, ELO}
*     Felten은 표준화 점수(음수 포함)라 점유율로 만들지 않는다.
* 비교 대상: A~C와 노출도 3개가 모두 있는 소분류(paper 25와 같은 129개, assert).
* 상관: Spearman(주), Pearson(엑셀만). 상위 순위: 상위 30 겹침 수, 지표 C 상위 20, 노출도별 상위 10.
* 매칭 키: ksco3(str3).
* =============================================================================

version 17
clear all
set more off

if `"$root"'    == "" global root    "d:/research/AI_effects"
if `"$proc"'    == "" global proc    "$root/data/proc"
if `"$results"' == "" global results "$root/results"

local out "$results/table"
local xl  "`out'/28_kor_share_vs_exposure.xlsx"

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
* 1. 지표
* -----------------------------------------------------------------------------
use "$proc/merged/kor_ai_usage_ksco3.dta", clear
keep ksco1 ksco1_title ksco3 ksco3_title emp hbar shA shB observed_exposure lm_aioe elo_gpt4_beta
keep if !missing(shA, shB, observed_exposure, lm_aioe, elo_gpt4_beta)
count
assert r(N) == 129
rename (observed_exposure lm_aioe elo_gpt4_beta) (OE FEL ELO)

generate double fte = shB / hbar
generate double eoe = emp * OE
generate double eel = emp * ELO
foreach p in shA shB fte eoe eel {
    quietly summarize `p'
    local t_`p' = r(sum)
}
generate double CS     = 100 * shA / `t_shA'
generate double SS     = 100 * shB / `t_shB'
generate double FS     = 100 * fte / `t_fte'
generate double XS_OE  = 100 * eoe / `t_eoe'
generate double XS_ELO = 100 * eel / `t_eel'
drop fte eoe eel shA shB hbar

local all "CS SS FS OE FEL ELO XS_OE XS_ELO"
foreach v of local all {
    egen int r_`v' = rank(-`v'), unique
}

label variable ksco3    "KSCO 8차 소분류"
label variable ksco3_title "소분류 명칭"
label variable ksco1    "대분류"
label variable ksco1_title "대분류 명칭"
label variable emp      "취업자 수(2022 상반기)"
label variable CS       "A 대화 점유율(%)"
label variable SS       "B 절감 시간 점유율(%)"
label variable FS       "C 취업자 환산 절감 점유율(%)"
label variable OE       "Observed exposure"
label variable FEL      "Felten LM AIOE"
label variable ELO      "Eloundou GPT-4 β"
label variable XS_OE    "노출도 기반 점유율(%, 취업자 × OE)"
label variable XS_ELO   "노출도 기반 점유율(%, 취업자 × Eloundou β)"
foreach v of local all {
    label variable r_`v' "`v' 순위"
}
order ksco3 ksco3_title ksco1 ksco1_title CS SS FS OE FEL ELO XS_OE XS_ELO r_* emp
gsort -FS ksco3
export excel using "`xl'", sheet("ksco3") firstrow(varlabels) replace
tempfile d
save `d'

* -----------------------------------------------------------------------------
* 2. 상관행렬(Spearman, Pearson)과 상위 30 겹침
* -----------------------------------------------------------------------------
local nv : word count `all'
foreach m in spearman pearson overlap30 {
    matrix M_`m' = J(`nv', `nv', .)
    matrix rownames M_`m' = `all'
    matrix colnames M_`m' = `all'
}
forvalues i = 1/`nv' {
    local a : word `i' of `all'
    forvalues j = 1/`nv' {
        local b : word `j' of `all'
        quietly spearman `a' `b'
        matrix M_spearman[`i', `j'] = r(rho)
        quietly correlate `a' `b'
        matrix M_pearson[`i', `j'] = r(rho)
        quietly count if r_`a' <= 30 & r_`b' <= 30
        matrix M_overlap30[`i', `j'] = r(N)
    }
}
matrix list M_spearman, format(%5.2f)
matrix list M_overlap30
foreach m in spearman pearson overlap30 {
    preserve
    clear
    svmat M_`m', names(col)
    generate str8 지표 = ""
    forvalues i = 1/`nv' {
        replace 지표 = "`: word `i' of `all''" in `i'
    }
    order 지표
    export excel using "`xl'", sheet("`m'") firstrow(variables) sheetreplace
    restore
}

local lab_CS     "A 대화 점유율"
local lab_SS     "B 절감 시간 점유율"
local lab_FS     "C 취업자 환산 점유율"
local lab_OE     "Observed exposure"
local lab_FEL    "Felten LM AIOE"
local lab_ELO    "Eloundou GPT-4 \$\beta\$"
local lab_XS_OE  "노출도 점유율(OE)"
local lab_XS_ELO "노출도 점유율(\$\beta\$)"

* TeX: 하삼각(Spearman) / 상위 30 겹침
foreach m in spearman overlap30 {
    local f = cond("`m'" == "spearman", "28_corr.tex", "28_overlap.tex")
    tempname fh
    file open `fh' using "`out'/`f'", write replace
    file write `fh' "% 04_11_analysis_kor_share_vs_exposure.do가 생성. 직접 고치지 말 것." _n
    forvalues i = 1/`nv' {
        local a : word `i' of `all'
        local row "(`i') `lab_`a''"
        forvalues j = 1/`nv' {
            if `j' < `i' {
                if "`m'" == "spearman" {
                    fmt `=M_spearman[`i',`j']' %5.2f
                    local row "`row' & `r(s)'"
                }
                else local row "`row' & `=M_overlap30[`i', `j']'"
            }
            else if `j' == `i' local row "`row' & --"
            else local row "`row' & "
        }
        file write `fh' "`row' \\" _n
    }
    file close `fh'
}

* -----------------------------------------------------------------------------
* 3. 지표 C 상위 20의 각 지표 순위
* -----------------------------------------------------------------------------
use `d', clear
gsort r_FS
keep if r_FS <= 20
export excel ksco3 ksco3_title FS r_FS r_CS r_SS r_OE r_FEL r_ELO r_XS_OE r_XS_ELO emp using "`xl'", ///
    sheet("top_fs") firstrow(varlabels) sheetreplace
tempname fh
file open `fh' using "`out'/28_top_fs.tex", write replace
file write `fh' "% 04_11_analysis_kor_share_vs_exposure.do가 생성. 직접 고치지 말 것." _n
forvalues i = 1/20 {
    fmt FS[`i'] %5.2f
    local a "`r(s)'"
    file write `fh' "`=r_FS[`i']' & `=ksco3[`i']' `=ksco3_title[`i']' & `a' & `=r_CS[`i']' & `=r_SS[`i']' & `=r_OE[`i']' & `=r_FEL[`i']' & `=r_ELO[`i']' & `=r_XS_OE[`i']' & `=r_XS_ELO[`i']' \\" _n
}
file close `fh'

* -----------------------------------------------------------------------------
* 4. 노출도 지표별 상위 10과 지표 C 순위
* -----------------------------------------------------------------------------
file open `fh' using "`out'/28_top_expo.tex", write replace
file write `fh' "% 04_11_analysis_kor_share_vs_exposure.do가 생성. 직접 고치지 말 것." _n
local first = 1
foreach x in OE FEL ELO {
    use `d', clear
    gsort r_`x'
    keep if r_`x' <= 10
    generate str20 지표 = "`x'"
    keep 지표 r_`x' ksco3 ksco3_title `x' emp r_FS FS r_CS
    rename (r_`x' `x') (순위 값)
    tempfile t`x'
    save `t`x''
    if "`x'" == "OE"  local nm "Observed exposure"
    if "`x'" == "FEL" local nm "Felten LM AIOE"
    if "`x'" == "ELO" local nm "Eloundou GPT-4 \$\beta\$"
    if !`first' file write `fh' "\midrule" _n
    local first = 0
    forvalues i = 1/10 {
        local lead = cond(`i' == 1, "`nm'", "")
        fmt 값[`i'] %5.2f
        local a "`r(s)'"
        fmt emp[`i']/1000 %6.0fc
        local b "`r(s)'"
        fmt FS[`i'] %5.2f
        local c "`r(s)'"
        file write `fh' "`lead' & `i' & `=ksco3[`i']' `=ksco3_title[`i']' & `a' & `b' & `c' & `=r_FS[`i']' \\" _n
    }
}
file close `fh'
use `tOE', clear
append using `tFEL' `tELO'
export excel using "`xl'", sheet("top_expo") firstrow(variables) sheetreplace

* 노출도 상위 10의 지표 C 순위 요약(노트용)
foreach x in OE FEL ELO {
    use `t`x'', clear
    quietly summarize r_FS, detail
    display "`x' top10: FS rank median = " r(p50) ", in FS top30 = " _continue
    quietly count if r_FS <= 30
    display r(N)
}
