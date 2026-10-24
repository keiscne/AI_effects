* =============================================================================
* 04_15_analysis_kor_use_vs_share.do
* 분모가 있는 상대 활용도 RU1·RU2(paper 25)와 분모가 없는 AI 점유율 지표 A·B(paper 27)의 순위 비교   (paper 32)
*
* 2026-10-24 재설계: 활용도 1·2(대화 총량 필요) 대신 상대 활용도 RU1 = A / 취업자 비중, RU2 = B / 근로시간 비중을 쓴다.
*   항등식이 상수 없이 ln A = ln RU1 + ln es, ln B = ln RU2 + ln hs로 바뀔 뿐 순위 비교의 구조는 같다.
*   코드 안 변수 이름 use1·use2는 RU1·RU2를 뜻한다(출력 파일 이름 유지).
*
* 입력: $proc/merged/kor_ai_usage_ksco3.dta   (03_05_merge_kor_ksco3_ai_usage.do)
*   shA, shB, es, hs, emp(E), H, hrs_wk, ru1, ru2, n_obs, small
* 출력: $results/table/
*   32_kor_use_vs_share.xlsx   시트 ksco3(지표·순위·격차), stats, top(격차 상위·하위 15), topuse(활용도 상위 20), ksco1
*   32_summary.tex, 32_g1_pos.tex, 32_g1_neg.tex, 32_g2_pos.tex, 32_g2_neg.tex,
*   32_top_use1.tex, 32_top_use2.tex, 32_ksco1.tex   (paper 32 표)
*
* 정의(소분류 129개, 2026-04·05 월별 비중 단순평균):
*   상대 활용도 1  use1 = ru1 = A / es      es = 취업자 비중(%, 163개 전체)
*   상대 활용도 2  use2 = ru2 = B / hs      hs = 총 주업 근로시간 비중(%)
*   지표 A    A = shA,  지표 B  B = shB  (%)
*   → ln A = ln use1 + ln es,  ln B = ln use2 + ln hs   (assert)
*     두 쌍의 순위 차이는 모두 직업 규모(E, H)에서 온다.
*   순위 r(·): 129개 안, 1 = 최상위, 동순위 없음(unique; 같은 값은 ksco3 순)
*   격차 G1 = r(use1) − r(A),  G2 = r(use2) − r(B)   (양수 = 점유율 순위가 활용도 순위보다 높음 = 큰 직업)
*   분산 분해: var(ln A) = var(ln use1) + var(ln E) + 2 cov(ln use1, ln E)   (B도 같은 방식, use2·H)
* 플래그: small = 1   지역별고용조사 2022 표본 수 < 30(분모 E, H가 불안정; 표에 † 표시)
* 매칭 키: ksco3(str3), ksco1(str1).
* =============================================================================

version 17
clear all
set more off

if `"$root"'    == "" global root    "d:/research/AI_effects"
if `"$proc"'    == "" global proc    "$root/data/proc"
if `"$results"' == "" global results "$root/results"

local out "$results/table"
local xl  "`out'/32_kor_use_vs_share.xlsx"

capture program drop fmt
program define fmt, rclass
    args x f
    if missing(`x') {
        return local s "--"
        exit
    }
    local s : display `f' `x'
    local s = trim("`s'")
    if "`s'" == "-0.00" local s "0.00"
    if "`3'" == "sign" & `x' > 0 local s "+`s'"
    return local s "`s'"
end

* -----------------------------------------------------------------------------
* 1. 지표, 순위, 격차
* -----------------------------------------------------------------------------
use "$proc/merged/kor_ai_usage_ksco3.dta", clear
keep ksco1 ksco1_title ksco3 ksco3_title n_obs small emp H hrs_wk shA shB es hs ru1 ru2 in_share
keep if in_share
drop in_share
count
assert r(N) == 129
generate double A = shA
generate double B = shB
rename (ru1 ru2) (use1 use2)                           // 아래 코드의 use1·use2 = RU1·RU2
assert abs(ln(A) - (ln(use1) + ln(es))) < 1e-9
assert abs(ln(B) - (ln(use2) + ln(hs))) < 1e-9
drop shA shB es hs
quietly summarize emp
local t_E = r(sum)
quietly summarize H
local t_H = r(sum)
generate double emp_sh = 100 * emp / `t_E'
generate double H_sh   = 100 * H / `t_H'
sort ksco3
foreach v in use1 use2 A B emp H {
    egen int r_`v' = rank(-`v'), unique
}
generate int G1 = r_use1 - r_A
generate int G2 = r_use2 - r_B
label variable A      "A 대화 점유율(%)"
label variable B      "B 절감 시간 점유율(%)"
label variable emp_sh "취업자 비중(%)"
label variable H_sh   "총 주업 근로시간 비중(%)"
label variable G1     "격차 r(use1) - r(A)"
label variable G2     "격차 r(use2) - r(B)"
foreach v in use1 use2 A B emp H {
    generate double ln_`v' = ln(`v')
}
order ksco3 ksco3_title ksco1 ksco1_title n_obs small emp emp_sh r_emp H H_sh r_H hrs_wk ///
    use1 r_use1 A r_A G1 use2 r_use2 B r_B G2
gsort -G1 ksco3
export excel ksco3-G2 using "`xl'", sheet("ksco3") firstrow(variables) replace
tempfile d
save `d'

* -----------------------------------------------------------------------------
* 2. 요약 통계
* -----------------------------------------------------------------------------
tempname pf fh
tempfile st
postfile `pf' str60 항목 double 값 using `st'
foreach p in "use1 A" "use2 B" "use1 use2" "A B" {
    local a : word 1 of `p'
    local b : word 2 of `p'
    quietly spearman `a' `b'
    post `pf' ("Spearman `a'–`b'") (r(rho))
}
foreach p in "use1 A" "use2 B" {
    local a : word 1 of `p'
    local b : word 2 of `p'
    foreach k in 10 30 {
        quietly count if r_`a' <= `k' & r_`b' <= `k'
        post `pf' ("상위 `k' 겹침 `a'–`b'") (r(N))
    }
}
foreach g in G1 G2 {
    generate int a`g' = abs(`g')
    quietly summarize a`g'
    post `pf' ("|`g'| 평균") (r(mean))
    post `pf' ("|`g'| 최대") (r(max))
    quietly count if a`g' >= 20
    post `pf' ("|`g'| >= 20 수") (r(N))
}
quietly spearman G1 ln_emp
post `pf' ("Spearman G1–취업자") (r(rho))
quietly spearman G2 ln_H
post `pf' ("Spearman G2–총근로시간") (r(rho))
quietly spearman G1 G2
post `pf' ("Spearman G1–G2") (r(rho))
* 분산 분해(로그 점유율 = 로그 활용도 + 로그 규모 + 상수)
foreach p in "A use1 emp" "B use2 H" {
    local s : word 1 of `p'
    local u : word 2 of `p'
    local z : word 3 of `p'
    quietly correlate ln_`u' ln_`z', covariance
    local vu = r(Var_1)
    local vz = r(Var_2)
    local cv = r(cov_12)
    quietly summarize ln_`s'
    local vs = r(Var)
    assert abs(`vs' - (`vu' + `vz' + 2 * `cv')) < 1e-6
    post `pf' ("var(ln `s')") (`vs')
    post `pf' ("몫 var(ln `u')") (`vu' / `vs')
    post `pf' ("몫 var(ln `z')") (`vz' / `vs')
    post `pf' ("몫 2cov") (2 * `cv' / `vs')
    quietly correlate ln_`u' ln_`z'
    post `pf' ("Pearson ln `u'–ln `z'") (r(rho))
    * ln 점유율의 규모 탄력성: 1 + cov(ln u, ln z) / var(ln z). 1이면 활용도가 규모와 무관, 0이면 점유율이 규모와 무관
    quietly regress ln_`s' ln_`z'
    post `pf' ("기울기 ln `s' on ln `z'") (_b[ln_`z'])
    post `pf' ("R2 ln `s' on ln `z'") (e(r2))
    assert abs(_b[ln_`z'] - (1 + `cv' / `vz')) < 1e-6
}
foreach v in use1 A use2 B {
    quietly count if r_`v' <= 10 & small
    post `pf' ("표본 30 미만, `v' 상위 10") (r(N))
}
quietly count if small
post `pf' ("표본 30 미만 소분류") (r(N))
quietly summarize emp
post `pf' ("취업자 최대/최소(배)") (r(max) / r(min))
foreach v in use1 A use2 B {
    quietly spearman `v' emp
    post `pf' ("Spearman `v'–취업자") (r(rho))
}
postclose `pf'
preserve
use `st', clear
list, noobs clean
export excel using "`xl'", sheet("stats") firstrow(variables) sheetreplace
* TeX
local i = 0
foreach t in ///
    "RU1과 지표 A의 Spearman 순위상관" ///
    "RU2와 지표 B의 Spearman 순위상관" ///
    "(참고) RU1과 RU2" ///
    "(참고) 지표 A와 지표 B" ///
    "상위 10 겹침: RU1 -- A" ///
    "상위 30 겹침: RU1 -- A" ///
    "상위 10 겹침: RU2 -- B" ///
    "상위 30 겹침: RU2 -- B" ///
    "\(|G_1|\) 평균" "\(|G_1|\) 최댓값" "\(|G_1| \ge 20\)인 소분류 수" ///
    "\(|G_2|\) 평균" "\(|G_2|\) 최댓값" "\(|G_2| \ge 20\)인 소분류 수" ///
    "\(G_1\)과 취업자 수의 Spearman 순위상관" ///
    "\(G_2\)와 총 주업 근로시간의 Spearman 순위상관" ///
    "\(G_1\)과 \(G_2\)의 Spearman 순위상관" ///
    "\(\mathrm{var}(\ln \mathrm{A})\)" ///
    "\quad RU1 분산의 몫" ///
    "\quad 취업자 수 분산의 몫" ///
    "\quad 공분산(\(2\,\mathrm{cov}\))의 몫" ///
    "\(\ln\) RU1과 \(\ln E\)의 Pearson 상관" ///
    "\(\ln \mathrm{A}\)를 \(\ln E\)에 회귀한 기울기(규모 탄력성)" ///
    "\quad 같은 회귀의 \(R^2\)" ///
    "\(\mathrm{var}(\ln \mathrm{B})\)" ///
    "\quad RU2 분산의 몫" ///
    "\quad 총 주업 근로시간 분산의 몫" ///
    "\quad 공분산(\(2\,\mathrm{cov}\))의 몫" ///
    "\(\ln\) RU2와 \(\ln H\)의 Pearson 상관" ///
    "\(\ln \mathrm{B}\)를 \(\ln H\)에 회귀한 기울기(규모 탄력성)" ///
    "\quad 같은 회귀의 \(R^2\)" ///
    "표본 30 미만 소분류 수: RU1 상위 10 중" ///
    "표본 30 미만 소분류 수: 지표 A 상위 10 중" ///
    "표본 30 미만 소분류 수: RU2 상위 10 중" ///
    "표본 30 미만 소분류 수: 지표 B 상위 10 중" ///
    "표본 30 미만 소분류 수(129개 중)" ///
    "취업자 수 최댓값 / 최솟값(배)" ///
    "RU1과 취업자 수의 Spearman 순위상관" ///
    "지표 A와 취업자 수의 Spearman 순위상관" ///
    "RU2와 취업자 수의 Spearman 순위상관" ///
    "지표 B와 취업자 수의 Spearman 순위상관" {
    local ++i
    local tl`i' "`t'"
}
assert `i' == _N
file open `fh' using "`out'/32_summary.tex", write replace
file write `fh' "% 04_15_analysis_kor_use_vs_share.do가 생성. 직접 고치지 말 것." _n
forvalues k = 1/`=_N' {
    local f "%6.2f"
    if inlist(`k', 5, 6, 7, 8, 10, 11, 13, 14) | inrange(`k', 32, 37) local f "%6.0fc"
    if inlist(`k', 9, 12) local f "%6.1f"
    fmt 값[`k'] `f'
    file write `fh' "`tl`k'' & `r(s)' \\" _n
}
file close `fh'
restore

* -----------------------------------------------------------------------------
* 3. 격차 상위·하위 15
* -----------------------------------------------------------------------------
tempfile tops
local first = 1
foreach g in G1 G2 {
    if "`g'" == "G1" {
        local u use1
        local s A
        local uf %6.2f
    }
    else {
        local u use2
        local s B
        local uf %6.2f
    }
    foreach sd in pos neg {
        use `d', clear
        if "`sd'" == "pos" gsort -`g' ksco3
        else               gsort  `g' ksco3
        keep in 1/15
        generate byte 순위 = _n
        generate str2 격차 = "`g'"
        generate str3 방향 = "`sd'"
        file open `fh' using "`out'/32_`=lower("`g'")'_`sd'.tex", write replace
        file write `fh' "% 04_15_analysis_kor_use_vs_share.do가 생성. 직접 고치지 말 것." _n
        forvalues k = 1/15 {
            fmt `u'[`k'] `uf'
            local a "`r(s)'"
            fmt `s'[`k'] %5.2f
            local b "`r(s)'"
            fmt `g'[`k'] %4.0f sign
            local gg "`r(s)'"
            fmt emp[`k']/1000 %6.0fc
            local e "`r(s)'"
            fmt hrs_wk[`k'] %4.1f
            local h "`r(s)'"
            local dag = cond(small[`k'], "\$^\dagger\$", "")
            if "`g'" == "G1" file write `fh' "`k' & `=ksco3[`k']' `=ksco3_title[`k']'`dag' & `a' & `=r_`u'[`k']' & `b' & `=r_`s'[`k']' & `gg' & `e' & `=r_emp[`k']' \\" _n
            else             file write `fh' "`k' & `=ksco3[`k']' `=ksco3_title[`k']'`dag' & `a' & `=r_`u'[`k']' & `b' & `=r_`s'[`k']' & `gg' & `e' & `h' & `=r_H[`k']' \\" _n
        }
        file close `fh'
        if !`first' append using `tops'
        save `tops', replace
        local first = 0
    }
}
use `tops', clear
order 격차 방향 순위
sort 격차 방향 순위
export excel 격차 방향 순위 ksco3-G2 using "`xl'", sheet("top") firstrow(variables) sheetreplace

* -----------------------------------------------------------------------------
* 4. 활용도 상위 20의 점유율 순위
* -----------------------------------------------------------------------------
local first = 1
foreach u in use1 use2 {
    local s = cond("`u'" == "use1", "A", "B")
    local g = cond("`u'" == "use1", "G1", "G2")
    local uf "%6.2f"
    use `d', clear
    keep if r_`u' <= 20
    sort r_`u'
    generate str4 기준 = "`u'"
    file open `fh' using "`out'/32_top_`u'.tex", write replace
    file write `fh' "% 04_15_analysis_kor_use_vs_share.do가 생성. 직접 고치지 말 것." _n
    forvalues k = 1/`=_N' {
        fmt `u'[`k'] `uf'
        local a "`r(s)'"
        fmt `s'[`k'] %5.2f
        local b "`r(s)'"
        fmt `g'[`k'] %4.0f sign
        local gg "`r(s)'"
        fmt emp[`k']/1000 %6.0fc
        local e "`r(s)'"
        fmt emp_sh[`k'] %5.2f
        local es "`r(s)'"
        local dag = cond(small[`k'], "\$^\dagger\$", "")
        file write `fh' "`=r_`u'[`k']' & `=ksco3[`k']' `=ksco3_title[`k']'`dag' & `a' & `b' & `=r_`s'[`k']' & `gg' & `e' & `es' & `=n_obs[`k']' \\" _n
    }
    file close `fh'
    if !`first' append using `tops'
    save `tops', replace
    local first = 0
}
use `tops', clear
keep if !missing(기준)
order 기준
export excel 기준 ksco3-G2 using "`xl'", sheet("topuse") firstrow(variables) sheetreplace

* -----------------------------------------------------------------------------
* 5. 대분류: 소분류 순위 격차 평균, 점유율 합, 상위 30 수
* -----------------------------------------------------------------------------
use `d', clear
generate byte n = 1
foreach v in use1 A use2 B {
    generate byte t30_`v' = r_`v' <= 30
}
collapse (sum) n emp_sh H_sh A B t30_* (mean) G1 G2, by(ksco1 ksco1_title)
sort ksco1
export excel using "`xl'", sheet("ksco1") firstrow(variables) sheetreplace
file open `fh' using "`out'/32_ksco1.tex", write replace
file write `fh' "% 04_15_analysis_kor_use_vs_share.do가 생성. 직접 고치지 말 것." _n
forvalues k = 1/`=_N' {
    fmt emp_sh[`k'] %5.1f
    local e "`r(s)'"
    fmt A[`k'] %5.1f
    local a "`r(s)'"
    fmt B[`k'] %5.1f
    local b "`r(s)'"
    fmt G1[`k'] %5.1f sign
    local g1 "`r(s)'"
    fmt G2[`k'] %5.1f sign
    local g2 "`r(s)'"
    file write `fh' "`=ksco1[`k']' `=ksco1_title[`k']' & `=n[`k']' & `e' & `=t30_use1[`k']' & `=t30_A[`k']' & `=t30_use2[`k']' & `=t30_B[`k']' & `a' & `b' & `g1' & `g2' \\" _n
}
file close `fh'
list ksco1 n emp_sh A B t30_* G1 G2, noobs abbreviate(10)
