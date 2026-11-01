* =============================================================================
* 04_18_analysis_kor_share_exposure_rank.do
* 점유율 지표 A·B·C와 노출도 3개의 순위 비교: Spearman 순위상관, 지표별 상위·하위 30 목록   (paper 35)
*
* 입력: $proc/merged/kor_ai_usage_ksco3.dta   (03_05_merge_kor_ksco3_ai_usage.do)
*   shA, shB, shC(지표 A·B·C, %), lm_aioe(Felten 언어모델 AIOE), elo_gpt4_beta(Eloundou GPT-4 β),
*   observed_exposure(Observed Exposure). 노출도는 SOC 값을 연계표 w_mean으로 평균한 소분류 값(paper 23).
* 출력: $results/table/35_kor_share_exposure_rank.xlsx
*   시트 spearman     6개 지표의 Spearman 순위상관(위) 과 p값(아래)
*        felten30     Felten AIOE 상위·하위 30과 지표 A·B·C(값, 순위)
*        elo30        Eloundou β 상위·하위 30과 지표 A·B·C
*        oe30         Observed Exposure 상위·하위 30과 지표 A·B·C
*        A30, B30, C30  지표 A·B·C 상위·하위 30과 노출도 3개(값, 순위)
*   35_spearman.tex, 35_cross.tex, 35_cross_rev.tex, 35_topC10.tex, 35_notes.tex   (paper 35 표)
*
* 표본: A~C와 노출도 3개가 모두 있는 KSCO 8차 소분류 129개(paper 27·28과 같은 표본, assert).
* 순위: 129개 안, 값 내림차순(1 = 가장 큼), 같은 값은 소분류 코드 순. 상위 30 = 순위 1~30, 하위 30 = 순위 100~129.
*   한 시트 안에 상위 30(순위 순) 다음 하위 30(순위 순)을 놓고 "구분" 열로 나눈다.
* 매칭 키: ksco3(str3).
* =============================================================================

version 17
clear all
set more off

if `"$root"'    == "" global root    "d:/research/AI_effects"
if `"$proc"'    == "" global proc    "$root/data/proc"
if `"$results"' == "" global results "$root/results"

local out "$results/table"
local xl  "`out'/35_kor_share_exposure_rank.xlsx"
local ntop 30
local vars "shA shB shC FEL ELO OE"

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

* key 순위 상위·하위 n개를 한 시트로(구분 열, 순위 순). vars = 구분 뒤에 놓을 열.
capture program drop topbot
program define topbot
    syntax varlist, key(varname) sheet(string) xl(string) [n(integer 30)]
    preserve
    quietly count
    local N = r(N)
    keep if r_`key' <= `n' | r_`key' > `N' - `n'
    generate str12 grp = cond(r_`key' <= `n', "상위", "하위")
    label variable grp "구분"
    sort r_`key'
    export excel grp `varlist' using "`xl'", sheet("`sheet'") firstrow(varlabels) sheetreplace
    restore
end

* -----------------------------------------------------------------------------
* 1. 지표와 순위
* -----------------------------------------------------------------------------
use "$proc/merged/kor_ai_usage_ksco3.dta", clear
keep ksco1 ksco1_title ksco3 ksco3_title shA shB shC lm_aioe elo_gpt4_beta observed_exposure n_month_conv
keep if !missing(shA, shB, shC, lm_aioe, elo_gpt4_beta, observed_exposure)
count
assert r(N) == 129
rename (lm_aioe elo_gpt4_beta observed_exposure) (FEL ELO OE)
foreach v of local vars {
    gsort -`v' ksco3
    generate int r_`v' = _n
}
sort ksco3

label variable ksco3       "KSCO 코드(8차 소분류)"
label variable ksco3_title "KSCO 직업명(소분류)"
label variable shA         "지표 A: 업무용 대화 점유율(%)"
label variable shB         "지표 B: 절감 시간 점유율(%)"
label variable shC         "지표 C: 취업자 환산 절감 점유율(%)"
label variable FEL         "Felten AIOE(언어모델) 값"
label variable ELO         "Eloundou 노출도(GPT-4 β) 값"
label variable OE          "Observed Exposure 값"
label variable r_shA       "지표 A 순위"
label variable r_shB       "지표 B 순위"
label variable r_shC       "지표 C 순위"
label variable r_FEL       "Felten AIOE 순위"
label variable r_ELO       "Eloundou β 순위"
label variable r_OE        "Observed Exposure 순위"
tempfile k3
save `k3'

* -----------------------------------------------------------------------------
* 2. Spearman 순위상관(위: rho, 아래: p값)
* -----------------------------------------------------------------------------
local nv : word count `vars'
matrix R = J(`nv', `nv', .)
matrix P = J(`nv', `nv', .)
forvalues i = 1/`nv' {
    forvalues j = 1/`nv' {
        local a : word `i' of `vars'
        local b : word `j' of `vars'
        quietly spearman `a' `b'
        matrix R[`i', `j'] = r(rho)
        matrix P[`i', `j'] = cond(`i' == `j', ., r(p))
        local rho_`a'_`b' = r(rho)
    }
}
matrix list R, format(%5.2f)
local lab_shA "지표 A"
local lab_shB "지표 B"
local lab_shC "지표 C"
local lab_FEL "Felten AIOE"
local lab_ELO "Eloundou β"
local lab_OE  "Observed Exposure"

preserve
clear
matrix RP = R \ P
svmat double RP, names(c)
generate str10 stat = cond(_n <= `nv', "rho", "p값")
generate str20 var = ""
forvalues i = 1/`nv' {
    local a : word `i' of `vars'
    replace var = "`lab_`a''" if inlist(_n, `i', `i' + `nv')
    label variable c`i' "`lab_`a''"
}
label variable stat "통계량"
label variable var  "지표"
order stat var
export excel using "`xl'", sheet("spearman") firstrow(varlabels) replace
restore

* -----------------------------------------------------------------------------
* 3. 노출도별 상위·하위 30과 지표 A·B·C
* -----------------------------------------------------------------------------
foreach x in FEL ELO OE {
    local sh = cond("`x'" == "FEL", "felten30", cond("`x'" == "ELO", "elo30", "oe30"))
    topbot r_`x' ksco3 ksco3_title `x' shA r_shA shB r_shB shC r_shC, key(`x') sheet("`sh'") xl("`xl'") n(`ntop')
}

* -----------------------------------------------------------------------------
* 4. 지표 A·B·C별 상위·하위 30과 노출도 3개
* -----------------------------------------------------------------------------
foreach m in A B C {
    topbot ksco3 ksco3_title sh`m' r_sh`m' FEL r_FEL ELO r_ELO OE r_OE, key(sh`m') sheet("`m'30") xl("`xl'") n(`ntop')
}

* -----------------------------------------------------------------------------
* 5. 노트용 TeX 표
* -----------------------------------------------------------------------------
tempname fh
* (1) Spearman 순위상관(아래 삼각)
file open `fh' using "`out'/35_spearman.tex", write replace
file write `fh' "% 04_18_analysis_kor_share_exposure_rank.do가 생성. 직접 고치지 말 것." _n
forvalues i = 1/`nv' {
    local a : word `i' of `vars'
    local row "`lab_`a''"
    forvalues j = 1/`nv' {
        local b : word `j' of `vars'
        if `j' < `i' {
            fmt `rho_`a'_`b'' %5.2f
            local row "`row' & `r(s)'"
        }
        else if `j' == `i' local row "`row' & 1"
        else local row "`row' & "
    }
    file write `fh' "`row' \\" _n
}
file close `fh'

* (2) 노출도 상위·하위 30이 지표 A·B·C 상위·하위 30과 겹치는 수, 노출도 상위 30의 지표 순위 중앙값
use `k3', clear
file open `fh' using "`out'/35_cross.tex", write replace
file write `fh' "% 04_18_analysis_kor_share_exposure_rank.do가 생성. 직접 고치지 말 것." _n
foreach x in FEL ELO OE {
    local row "`lab_`x''"
    foreach m in A B C {
        quietly count if r_`x' <= `ntop' & r_sh`m' <= `ntop'
        local t = r(N)
        quietly count if r_`x' > _N - `ntop' & r_sh`m' > _N - `ntop'
        local b = r(N)
        quietly summarize r_sh`m' if r_`x' <= `ntop', detail
        fmt r(p50) %5.1f
        local row "`row' & `t' & `b' & `r(s)'"
    }
    file write `fh' "`row' \\" _n
}
file close `fh'

* (3) 지표 A·B·C 상위·하위 30의 노출도 순위 중앙값
file open `fh' using "`out'/35_cross_rev.tex", write replace
file write `fh' "% 04_18_analysis_kor_share_exposure_rank.do가 생성. 직접 고치지 말 것." _n
foreach m in A B C {
    local row "`lab_sh`m''"
    foreach x in FEL ELO OE {
        quietly summarize r_`x' if r_sh`m' <= `ntop', detail
        local t = r(p50)
        quietly summarize r_`x' if r_sh`m' > _N - `ntop', detail
        local b = r(p50)
        fmt `t' %5.1f
        local row "`row' & `r(s)'"
        fmt `b' %5.1f
        local row "`row' & `r(s)'"
    }
    file write `fh' "`row' \\" _n
}
file close `fh'

* (4) 지표 C 상위 10과 노출도 순위
gsort r_shC
file open `fh' using "`out'/35_topC10.tex", write replace
file write `fh' "% 04_18_analysis_kor_share_exposure_rank.do가 생성. 직접 고치지 말 것." _n
forvalues i = 1/10 {
    fmt shC[`i'] %5.2f
    local c "`r(s)'"
    fmt FEL[`i'] %5.2f
    local f "`r(s)'"
    fmt ELO[`i'] %5.2f
    local e "`r(s)'"
    fmt OE[`i'] %5.3f
    local o "`r(s)'"
    texesc `"`=ksco3_title[`i']'"'
    file write `fh' `"`i' & `=ksco3[`i']' `r(s)' & `c' & `f' (`=r_FEL[`i']') & `e' (`=r_ELO[`i']') & `o' (`=r_OE[`i']') \\"' _n
}
file close `fh'

* (5) 읽을 때 주의할 수치
sort ksco3
quietly count if OE == 0
local oe0 = r(N)
quietly count if FEL < 0
local felneg = r(N)
quietly count if n_month_conv == 1
local m1 = r(N)
quietly count if n_month_conv == 1 & r_shC > _N - `ntop'
local m1b = r(N)
quietly duplicates report ELO
local elo_u = r(unique_value)
file open `fh' using "`out'/35_notes.tex", write replace
file write `fh' "% 04_18_analysis_kor_share_exposure_rank.do가 생성. 직접 고치지 말 것." _n
file write `fh' "비교 소분류 수 & `=_N' \\" _n
file write `fh' "Observed Exposure가 0인 소분류 수(하위 순위는 코드 순) & `oe0' \\" _n
file write `fh' "Felten AIOE가 음수인 소분류 수 & `felneg' \\" _n
file write `fh' "Eloundou \$\beta\$의 서로 다른 값 수 & `elo_u' \\" _n
file write `fh' "한 달만 공개된 소분류 수 / 그중 지표 C 하위 `ntop'에 든 수 & `m1' / `m1b' \\" _n
file close `fh'
display "OE=0 `oe0' | FEL<0 `felneg' | ELO unique `elo_u' | one-month `m1' (C bottom `m1b')"
