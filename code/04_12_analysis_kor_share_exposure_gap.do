* =============================================================================
* 04_12_analysis_kor_share_exposure_gap.do
* AI 점유율 지표 A~C(paper 27)와 노출도 지표 3개의 직업별 격차, 격차가 큰 직업   (paper 29)
*
* 2026-10-24 재설계: A·B는 03_05가 AEI 업무용 대화 비중에서 만든 점유율(shA, shB)을 그대로 쓴다(대화 총량·K 없음).
*
* 입력: $proc/merged/kor_ai_usage_ksco3.dta   (03_05_merge_kor_ksco3_ai_usage.do)
*   shA, shB(지표 A·B, %), emp, hbar(지표 C 계산), observed_exposure, lm_aioe(Felten 언어모델 AIOE), elo_gpt4_beta
* 출력: $results/table/
*   29_kor_share_exposure_gap.xlsx   시트 ksco3(지표·격차), reg, agree, abc, top10, robust, ksco1
*   29_reg.tex, 29_agree.tex, 29_abc.tex, 29_top_OE.tex, 29_top_FEL.tex, 29_top_ELO.tex,
*   29_size.tex, 29_robust_pos.tex, 29_robust_neg.tex, 29_ksco1.tex   (paper 29 표)
*
* 지표(04_11_analysis_kor_share_vs_exposure.do와 같은 정의, 소분류 129개에서 다시 계산):
*   점유율 m ∈ {CS(A), SS(B), FS(C)}(%), 노출도 x ∈ {OE, FEL, ELO},
*   노출도 기반 점유율 XS_x = 100 × emp × x / Σ(emp × x), x ∈ {OE, ELO}
* 격차(모두 양수 = 실제 사용이 노출도보다 큼, 작업자 판단):
*   방법 1 RG_m_x = r_x − r_m   (129개 안 순위, 1 = 최상위, 동순위 없음(unique))
*   방법 3 DS_m_x = m − XS_x   (%p, 합 0), LR_m_x = ln(m / XS_x)   (x ∈ {OE, ELO}; OE = 0인 13개는 LR 결측)
*   방법 4 RE_m_x = ln(m)을 x와 ln(emp)에 회귀(OLS, robust SE)한 잔차
* 격차 상위·하위 10: 격차 값으로 정렬, 같은 값은 ksco3 순. 강건 목록: 지표 C의 목록 8개
*   (RG × 3, DS × 2, RE × 3; LR는 강도 비율이라 제외) 중 상위·하위 10에 든 횟수.
* 매칭 키: ksco3(str3), ksco1(str1).
* =============================================================================

version 17
clear all
set more off

if `"$root"'    == "" global root    "d:/research/AI_effects"
if `"$proc"'    == "" global proc    "$root/data/proc"
if `"$results"' == "" global results "$root/results"

local out "$results/table"
local xl  "`out'/29_kor_share_exposure_gap.xlsx"

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
* 1. 지표와 격차
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
foreach v in CS SS FS OE FEL ELO XS_OE XS_ELO {
    egen int r_`v' = rank(-`v'), unique
}
generate double ln_emp = ln(emp)

local M "CS SS FS"
local X "OE FEL ELO"
local lab_CS  "A 대화 점유율"
local lab_SS  "B 절감 시간 점유율"
local lab_FS  "C 취업자 환산 점유율"
local lab_OE  "Observed exposure"
local lab_FEL "Felten LM AIOE"
local lab_ELO "Eloundou GPT-4 \$\beta\$"

matrix REG = J(9, 6, .)
matrix colnames REG = b_x se_x b_lnemp se_lnemp r2 N
local i = 0
foreach m of local M {
    generate double ln_`m' = ln(`m')
    foreach x of local X {
        local ++i
        generate int RG_`m'_`x' = r_`x' - r_`m'
        label variable RG_`m'_`x' "방법1 순위 격차 `m'-`x'"
        if "`x'" != "FEL" {
            generate double DS_`m'_`x' = `m' - XS_`x'
            generate double LR_`m'_`x' = ln(`m' / XS_`x') if XS_`x' > 0
            label variable DS_`m'_`x' "방법3 점유율 차이(%p) `m'-XS_`x'"
            label variable LR_`m'_`x' "방법3 로그 비율 ln(`m'/XS_`x')"
            quietly summarize DS_`m'_`x'
            assert abs(r(sum)) < 1e-9
        }
        quietly regress ln_`m' `x' ln_emp, vce(robust)
        matrix REG[`i', 1] = (_b[`x'], _se[`x'], _b[ln_emp], _se[ln_emp], e(r2), e(N))
        predict double RE_`m'_`x', residuals
        label variable RE_`m'_`x' "방법4 회귀 잔차 `m'-`x'"
    }
}
matrix list REG, format(%7.3f)
count if missing(LR_FS_OE)
assert r(N) == 13

* 부호 확인용(노트): 지표 C의 격차가 양수인 소분류 수
foreach v of varlist RG_FS_* DS_FS_* RE_FS_* {
    quietly count if `v' > 0 & !missing(`v')
    display "`v' > 0: " r(N)
}

order ksco3 ksco3_title ksco1 ksco1_title emp CS SS FS OE FEL ELO XS_OE XS_ELO r_* RG_* DS_* LR_* RE_*
drop ln_*
gsort -FS ksco3
export excel using "`xl'", sheet("ksco3") firstrow(variables) replace
tempfile d
save `d'

* -----------------------------------------------------------------------------
* 2. 회귀(방법 4)
* -----------------------------------------------------------------------------
tempname fh
file open `fh' using "`out'/29_reg.tex", write replace
file write `fh' "% 04_12_analysis_kor_share_exposure_gap.do가 생성. 직접 고치지 말 것." _n
preserve
clear
svmat REG, names(col)
generate str3 지표 = ""
generate str3 노출도 = ""
local i = 0
foreach m of local M {
    foreach x of local X {
        local ++i
        replace 지표 = "`m'" in `i'
        replace 노출도 = "`x'" in `i'
        local lead = cond("`x'" == "OE", "`lab_`m''", "")
        if `i' > 1 & "`x'" == "OE" file write `fh' "\midrule" _n
        fmt b_x[`i'] %6.2f
        local a "`r(s)'"
        fmt se_x[`i'] %6.2f
        local b "`r(s)'"
        fmt b_lnemp[`i'] %6.2f
        local c "`r(s)'"
        fmt se_lnemp[`i'] %6.2f
        local e "`r(s)'"
        fmt r2[`i'] %5.2f
        local f "`r(s)'"
        file write `fh' "`lead' & `lab_`x'' & `a' & (`b') & `c' & (`e') & `f' & `=N[`i']' \\" _n
    }
}
file close `fh'
order 지표 노출도
export excel using "`xl'", sheet("reg") firstrow(variables) sheetreplace
restore

* -----------------------------------------------------------------------------
* 3. 방법 간 일치(Spearman): 같은 지표·노출도 안 방법 쌍, 같은 방법·노출도 안 A·B 대 C
* -----------------------------------------------------------------------------
tempname pf
tempfile ag
postfile `pf' str3 지표 str3 노출도 str2 방법1 str2 방법2 double rho int n using `ag'
foreach m of local M {
    foreach x of local X {
        local G "RG RE"
        if "`x'" != "FEL" local G "RG DS LR RE"
        local ng : word count `G'
        forvalues a = 1/`ng' {
            forvalues b = `=`a'+1'/`ng' {
                local ga : word `a' of `G'
                local gb : word `b' of `G'
                quietly spearman `ga'_`m'_`x' `gb'_`m'_`x'
                post `pf' ("`m'") ("`x'") ("`ga'") ("`gb'") (r(rho)) (r(N))
            }
        }
    }
}
postclose `pf'
preserve
use `ag', clear
export excel using "`xl'", sheet("agree") firstrow(variables) sheetreplace
* TeX: 지표 C, 행 = 방법 쌍, 열 = 노출도
file open `fh' using "`out'/29_agree.tex", write replace
file write `fh' "% 04_12_analysis_kor_share_exposure_gap.do가 생성. 직접 고치지 말 것." _n
local nm_RG "순위 격차(1)"
local nm_DS "점유율 차이(3)"
local nm_LR "로그 비율(3)"
local nm_RE "회귀 잔차(4)"
foreach p in "RG DS" "RG LR" "RG RE" "DS LR" "DS RE" "LR RE" {
    local ga : word 1 of `p'
    local gb : word 2 of `p'
    local row "`nm_`ga'' -- `nm_`gb''"
    foreach x of local X {
        quietly summarize rho if 지표 == "FS" & 노출도 == "`x'" & 방법1 == "`ga'" & 방법2 == "`gb'"
        if r(N) == 0 local row "`row' & --"
        else {
            fmt `=r(mean)' %5.2f
            local row "`row' & `r(s)'"
        }
    }
    file write `fh' "`row' \\" _n
}
file close `fh'
restore

postfile `pf' str2 방법 str3 노출도 str3 지표 double rho_with_FS using `ag', replace
foreach g in RG DS LR RE {
    foreach x of local X {
        capture confirm variable `g'_FS_`x'
        if _rc continue
        foreach m in CS SS {
            quietly spearman `g'_`m'_`x' `g'_FS_`x'
            post `pf' ("`g'") ("`x'") ("`m'") (r(rho))
        }
    }
}
postclose `pf'
preserve
use `ag', clear
export excel using "`xl'", sheet("abc") firstrow(variables) sheetreplace
file open `fh' using "`out'/29_abc.tex", write replace
file write `fh' "% 04_12_analysis_kor_share_exposure_gap.do가 생성. 직접 고치지 말 것." _n
foreach g in RG DS LR RE {
    local row "`nm_`g''"
    foreach x of local X {
        foreach m in CS SS {
            quietly summarize rho_with_FS if 방법 == "`g'" & 노출도 == "`x'" & 지표 == "`m'"
            if r(N) == 0 local row "`row' & --"
            else {
                fmt `=r(mean)' %5.2f
                local row "`row' & `r(s)'"
            }
        }
    }
    file write `fh' "`row' \\" _n
}
file close `fh'
restore

* 격차와 직업 규모(취업자 수)의 Spearman 상관(지표 C): 방법이 규모를 얼마나 남기는지
file open `fh' using "`out'/29_size.tex", write replace
file write `fh' "% 04_12_analysis_kor_share_exposure_gap.do가 생성. 직접 고치지 말 것." _n
foreach g in RG DS LR RE {
    local row "`nm_`g''"
    foreach x of local X {
        capture confirm variable `g'_FS_`x'
        if _rc local row "`row' & --"
        else {
            quietly spearman `g'_FS_`x' emp
            fmt `=r(rho)' %5.2f
            local row "`row' & `r(s)'"
        }
    }
    file write `fh' "`row' \\" _n
}
file close `fh'

* -----------------------------------------------------------------------------
* 4. 격차 상위·하위 10(모든 지표·노출도·방법)
* -----------------------------------------------------------------------------
tempfile tops
local first = 1
foreach m of local M {
    foreach x of local X {
        foreach g in RG DS LR RE {
            use `d', clear
            capture confirm variable `g'_`m'_`x'
            if _rc continue
            foreach sd in pos neg {
                use `d', clear
                keep if !missing(`g'_`m'_`x')
                if "`sd'" == "pos" gsort -`g'_`m'_`x' ksco3
                else               gsort  `g'_`m'_`x' ksco3
                keep in 1/10
                generate byte 순위 = _n
                generate str3 지표 = "`m'"
                generate str3 노출도 = "`x'"
                generate str2 방법 = "`g'"
                generate str3 방향 = "`sd'"
                generate double 격차 = `g'_`m'_`x'
                generate double 점유율 = `m'
                generate int 점유율순위 = r_`m'
                generate double 노출도값 = `x'
                generate int 노출도순위 = r_`x'
                keep 지표 노출도 방법 방향 순위 ksco3 ksco3_title ksco1 격차 점유율 점유율순위 노출도값 노출도순위 emp
                if !`first' append using `tops'
                save `tops', replace
                local first = 0
            }
        }
    }
}
use `tops', clear
sort 지표 노출도 방법 방향 순위
export excel using "`xl'", sheet("top10") firstrow(variables) sheetreplace

* TeX: 지표 C, 노출도별, 열 = 방법(RG, DS, RE), 위 = 사용 > 노출도, 아래 = 노출도 > 사용
foreach x of local X {
    use `tops', clear
    keep if 지표 == "FS" & 노출도 == "`x'" & 방법 != "LR"
    foreach sd in pos neg {
        foreach g in RG DS RE {
            forvalues r = 1/10 {
                local c_`sd'_`g'_`r' ""
            }
        }
    }
    forvalues k = 1/`=_N' {
        local g  = 방법[`k']
        local sd = 방향[`k']
        local r  = 순위[`k']
        if "`g'" == "RG" fmt 격차[`k'] %4.0f sign
        if "`g'" == "DS" fmt 격차[`k'] %5.2f sign
        if "`g'" == "RE" fmt 격차[`k'] %5.2f sign
        local c_`sd'_`g'_`r' "`=ksco3[`k']' `=ksco3_title[`k']' (`r(s)')"
    }
    file open `fh' using "`out'/29_top_`x'.tex", write replace
    file write `fh' "% 04_12_analysis_kor_share_exposure_gap.do가 생성. 직접 고치지 말 것." _n
    foreach sd in pos neg {
        local hd = cond("`sd'" == "pos", "\multicolumn{4}{l}{\textit{사용 > 노출도(격차 상위 10)}} \\", "\multicolumn{4}{l}{\textit{노출도 > 사용(격차 하위 10)}} \\")
        if "`sd'" == "neg" file write `fh' "\midrule" _n
        file write `fh' "`hd'" _n
        forvalues r = 1/10 {
            local row "`r'"
            foreach g in RG DS RE {
                if "`c_`sd'_`g'_`r''" == "" local row "`row' & --"
                else local row "`row' & `c_`sd'_`g'_`r''"
            }
            file write `fh' "`row' \\" _n
        }
    }
    file close `fh'

}

* -----------------------------------------------------------------------------
* 5. 강건 목록: 지표 C 목록 8개 중 상위·하위 10에 든 횟수
* -----------------------------------------------------------------------------
use `tops', clear
keep if 지표 == "FS" & 방법 != "LR"
assert _N == 8 * 2 * 10
generate byte one = 1
collapse (sum) n = one, by(ksco3 방향)
reshape wide n, i(ksco3) j(방향) string
merge 1:1 ksco3 using `d', keep(match using) nogenerate
replace nneg = 0 if missing(nneg)
replace npos = 0 if missing(npos)
label variable npos "상위 10 횟수(8개 목록 중)"
label variable nneg "하위 10 횟수(8개 목록 중)"
gsort -npos -nneg ksco3
export excel ksco3 ksco3_title ksco1 npos nneg FS r_FS r_OE r_FEL r_ELO RG_FS_* DS_FS_* RE_FS_* emp ///
    using "`xl'", sheet("robust") firstrow(varlabels) sheetreplace
foreach sd in pos neg {
    preserve
    keep if n`sd' >= 5
    gsort -n`sd' r_FS ksco3
    if "`sd'" == "neg" gsort -n`sd' -r_FS ksco3
    display "robust `sd' (>= 5 of 8): " _N
    file open `fh' using "`out'/29_robust_`sd'.tex", write replace
    file write `fh' "% 04_12_analysis_kor_share_exposure_gap.do가 생성. 직접 고치지 말 것." _n
    forvalues k = 1/`=_N' {
        fmt FS[`k'] %5.2f
        local a "`r(s)'"
        fmt emp[`k']/1000 %6.0fc
        local b "`r(s)'"
        fmt RE_FS_ELO[`k'] %5.2f sign
        local e "`r(s)'"
        file write `fh' "`=ksco3[`k']' `=ksco3_title[`k']' & `=n`sd'[`k']' & `a' & `=r_FS[`k']' & `=r_OE[`k']' & `=r_FEL[`k']' & `=r_ELO[`k']' & `e' & `b' \\" _n
    }
    file close `fh'
    restore
}

* -----------------------------------------------------------------------------
* 6. 대분류별 격차(지표 C): RG·RE 단순 평균, DS 합(%p)
* -----------------------------------------------------------------------------
use `d', clear
generate byte n = 1
collapse (sum) n FS DS_FS_OE DS_FS_ELO (mean) RG_FS_OE RG_FS_FEL RG_FS_ELO RE_FS_OE RE_FS_FEL RE_FS_ELO, ///
    by(ksco1 ksco1_title)
sort ksco1
export excel using "`xl'", sheet("ksco1") firstrow(variables) sheetreplace
file open `fh' using "`out'/29_ksco1.tex", write replace
file write `fh' "% 04_12_analysis_kor_share_exposure_gap.do가 생성. 직접 고치지 말 것." _n
forvalues k = 1/`=_N' {
    local row "`=ksco1[`k']' `=ksco1_title[`k']' & `=n[`k']'"
    fmt FS[`k'] %5.1f
    local row "`row' & `r(s)'"
    foreach v in RG_FS_OE RG_FS_FEL RG_FS_ELO {
        fmt `v'[`k'] %5.1f sign
        local row "`row' & `r(s)'"
    }
    foreach v in DS_FS_OE DS_FS_ELO RE_FS_OE RE_FS_FEL RE_FS_ELO {
        fmt `v'[`k'] %5.2f sign
        local row "`row' & `r(s)'"
    }
    file write `fh' "`row' \\" _n
}
file close `fh'
list ksco1 n FS RG_FS_* DS_FS_* RE_FS_*, noobs abbreviate(10)
