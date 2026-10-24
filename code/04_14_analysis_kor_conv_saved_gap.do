* =============================================================================
* 04_14_analysis_kor_conv_saved_gap.do
* AI 점유율 지표 A(대화 점유율)와 B(절감 시간 점유율)의 순위 격차가 큰 직업   (paper 31)
*
* 2026-10-24 재설계: A·B는 03_05가 AEI 업무용 대화 비중에서 만든 점유율(shA, shB)을 쓴다(대화 총량·K 없음).
*   SOC 기여는 업무용 대화 비중(share_work)과 비중 × 절감 시간(saved_w)을 월별 표본 합으로 나눠 두 달 평균한 값이다.
*
* 입력:
*   $proc/merged/kor_ai_usage_ksco3.dta              소분류 shA, shB, tau_eff, tbar, tot_sw04·05, tot_sv04·05, emp, 노출도 3개
*                                                     (03_05_merge_kor_ksco3_ai_usage.do)
*   $proc/merged/kor_soc6_conv_ai_indicators.dta     월 × soc6 share_work, saved_w, time_saved_min
*                                                     (03_03_merge_kor_conv_ai_ksco8.do)
*   $proc/exposure/bls_soc_crosswalk/soc2018_ksco8_crosswalk.dta   soc2018 → ksco8, w_alloc
*   $proc/exposure/bls_soc_crosswalk/soc2018_titles.dta            SOC 2018 명칭(BLS)
* 출력: $results/table/
*   31_kor_conv_saved_gap.xlsx   시트 ksco3(지표·격차), top(상위·하위 15), top30A(대화 상위 30),
*                                soc(소분류 × SOC 기여), ksco1, stats
*   31_summary.tex, 31_top_pos.tex, 31_top_neg.tex, 31_top30A.tex, 31_ksco1.tex   (paper 31 표)
*
* 정의(paper 27과 같음, 소분류 129개):
*   A = shA, B = shB(%, 03_05 정의)
*   순위 r(·): 129개 안, 1 = 최상위, 동순위 없음(unique; 같은 값은 ksco3 순)
*   순위 격차 RG = r(A) − r(B)   (양수 = 절감 시간 순위가 대화 순위보다 높음)
*   점유율 차이 DS = B − A(%p, 합 0), 로그 비율 LR = ln(B / A)
*   tau = 대화당 실효 절감 시간(분) = tau_eff = tau_bar × B / A, tau_bar = tbar(표본 전체 대화당 평균 절감 시간)
*   → LR = ln(tau / tau_bar). B/A의 차이는 모두 tau에서 온다.
* SOC 분해: c_sK, v_sK = SOC s가 소분류 K의 A, B에 주는 몫(%p; 04_09_analysis_kor_ksco3_top30_soc.do와 같은 계산,
*   기여 합 = shA, shB assert).
*   기여 dev_s = (v_sK / S_K − c_sK / C_K) × 100(%p): SOC s의 절감 시간 몫 − 대화 몫. 양수 SOC가 tau_K를 올린다.
* 매칭 키: ksco3(str3), soc6 = soc2018(str7), ksco3 = substr(ksco8, 1, 3).
* =============================================================================

version 17
clear all
set more off

if `"$root"'    == "" global root    "d:/research/AI_effects"
if `"$proc"'    == "" global proc    "$root/data/proc"
if `"$results"' == "" global results "$root/results"

local out "$results/table"
local xl  "`out'/31_kor_conv_saved_gap.xlsx"

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

* -----------------------------------------------------------------------------
* 1. SOC × 소분류 기여(04_09_analysis_kor_ksco3_top30_soc.do와 같은 계산)
* -----------------------------------------------------------------------------
use "$proc/exposure/bls_soc_crosswalk/soc2018_ksco8_crosswalk.dta", clear
keep soc2018 ksco8 w_alloc
rename soc2018 soc6
generate str3 ksco3 = substr(ksco8, 1, 3)
collapse (sum) w3 = w_alloc, by(soc6 ksco3)
bysort soc6: egen double chk = total(w3)
assert abs(chk - 1) < 1e-9
drop chk
tempfile cw3
save `cw3'

use "$proc/merged/kor_soc6_conv_ai_indicators.dta", clear
keep if conv_pub
drop if strpos(soc6, "X")                               // 45-XXXX: 연계표에 없음
keep month soc6 share_work saved_w time_saved_min
tempfile socm
save `socm'
collapse (first) tau_s = time_saved_min, by(soc6)
tempfile soctau
save `soctau'

* 월별 정규화 분모(03_05와 같은 값)
use tot_sw04 tot_sw05 tot_sv04 tot_sv05 in 1 using "$proc/merged/kor_ai_usage_ksco3.dta", clear
foreach v in sw04 sw05 sv04 sv05 {
    local T_`v' = tot_`v'[1]
}
use `socm', clear
joinby soc6 using `cw3'
generate double c = 100 * share_work * w3 / cond(month == "2026-04", `T_sw04', `T_sw05') / 2
generate double v = 100 * saved_w * w3 / cond(month == "2026-04", `T_sv04', `T_sv05') / 2
collapse (sum) c v, by(soc6 ksco3)
merge m:1 soc6 using `soctau', assert(match) nogenerate
merge m:1 soc6 using "$proc/exposure/bls_soc_crosswalk/soc2018_titles.dta", keep(master match)
assert _merge == 3
drop _merge
merge m:1 ksco3 using "$proc/merged/kor_ai_usage_ksco3.dta", keepusing(ksco3_title shA shB) keep(match) nogenerate
rename (shA shB) (C S)
keep if !missing(C, S)
bysort ksco3: egen double sc = total(c)
bysort ksco3: egen double sv = total(v)
assert reldif(sc, C) < 1e-9
assert reldif(sv, S) < 1e-9
generate double conv_sh  = 100 * c / C                  // 소분류 대화 중 SOC s 몫(%)
generate double saved_sh = 100 * v / S                  // 소분류 절감 시간 중 SOC s 몫(%)
generate double dev      = saved_sh - conv_sh           // %p
drop sc sv C S
label variable conv_sh  "소분류 대화 중 SOC 몫(%)"
label variable saved_sh "소분류 절감 시간 중 SOC 몫(%)"
label variable dev      "절감 시간 몫 - 대화 몫(%p)"
label variable tau_s    "SOC 대화당 절감 시간(분, AEI)"
gsort ksco3 -c soc6
by ksco3: generate int soc_rank = _n
tempfile soc
save `soc'

* 소분류별 대화 1위 SOC, tau를 가장 올리는(dev 최대)·내리는(dev 최소) SOC
use `soc', clear
keep if soc_rank == 1
keep ksco3 soc6 soc6_title conv_sh tau_s
rename (soc6 soc6_title conv_sh tau_s) (top_soc top_soc_title top_conv_sh top_tau)
tempfile topsoc
save `topsoc'
foreach sd in up dn {
    use `soc', clear
    if "`sd'" == "up" gsort ksco3 -dev soc6
    else              gsort ksco3  dev soc6
    by ksco3: keep if _n == 1
    keep ksco3 soc6 soc6_title dev conv_sh tau_s
    rename (soc6 soc6_title dev conv_sh tau_s) (`sd'_soc `sd'_soc_title `sd'_dev `sd'_conv_sh `sd'_tau)
    tempfile `sd'soc
    save ``sd'soc'
}

* -----------------------------------------------------------------------------
* 2. 소분류 지표와 격차
* -----------------------------------------------------------------------------
use "$proc/merged/kor_ai_usage_ksco3.dta", clear
keep ksco1 ksco1_title ksco3 ksco3_title emp shA shB tau_eff tbar ts_cover observed_exposure lm_aioe elo_gpt4_beta
keep if !missing(shA, shB)
count
assert r(N) == 129
assert abs(ts_cover - 1) < 1e-9
rename (observed_exposure lm_aioe elo_gpt4_beta) (OE FEL ELO)
local tau_bar = tbar[1]
generate double A   = shA
generate double B   = shB
generate double tau = tau_eff
drop shA shB tbar
sort ksco3
egen int r_A = rank(-A), unique
egen int r_B = rank(-B), unique
egen int r_tau = rank(-tau), unique
generate int    RG = r_A - r_B
generate double DS = B - A
generate double LR = ln(B / A)
assert abs(LR - ln(tau / `tau_bar')) < 1e-9
quietly summarize DS
assert abs(r(sum)) < 1e-9
generate double ln_emp = ln(emp)
label variable A   "A 대화 점유율(%)"
label variable B   "B 절감 시간 점유율(%)"
label variable tau "대화당 절감 시간(분)"
label variable r_A "A 순위"
label variable r_B "B 순위"
label variable r_tau "tau 순위"
label variable RG  "순위 격차 r(A) - r(B)"
label variable DS  "점유율 차이 B - A(%p)"
label variable LR  "로그 비율 ln(B/A) = ln(tau/tau_bar)"
display "tau_bar = " %6.2f `tau_bar' " 분"
merge 1:1 ksco3 using `topsoc', keep(master match) nogenerate
merge 1:1 ksco3 using `upsoc',  keep(master match) nogenerate
merge 1:1 ksco3 using `dnsoc',  keep(master match) nogenerate
assert !missing(top_soc, up_soc, dn_soc)
order ksco3 ksco3_title ksco1 ksco1_title emp A B r_A r_B RG DS LR tau r_tau
gsort -RG ksco3
export excel ksco3-r_tau OE FEL ELO top_* up_* dn_* using "`xl'", sheet("ksco3") firstrow(variables) replace
tempfile d
save `d'

* -----------------------------------------------------------------------------
* 3. 요약 통계
* -----------------------------------------------------------------------------
tempname pf fh
tempfile st
postfile `pf' str60 항목 double 값 using `st'
quietly spearman A B
post `pf' ("Spearman A–B") (r(rho))
generate double ln_A = ln(A)
generate double ln_B = ln(B)
quietly correlate ln_A ln_B
post `pf' ("Pearson ln A–ln B") (r(rho))
quietly summarize tau, detail
post `pf' ("tau_bar(전체, 분)") (`tau_bar')
foreach s in p50 min max {
    post `pf' ("tau `s'(소분류, 분)") (r(`s'))
}
post `pf' ("tau p90/p10") (r(p90) / r(p10))
quietly summarize RG
post `pf' ("|RG| 최대") (max(abs(r(min)), r(max)))
generate int aRG = abs(RG)
quietly summarize aRG
post `pf' ("|RG| 평균") (r(mean))
quietly count if aRG >= 20
post `pf' ("|RG| >= 20 소분류 수") (r(N))
generate byte grpA = cond(r_A <= 43, 1, cond(r_A <= 86, 2, 3))
forvalues g = 1/3 {
    quietly summarize aRG if grpA == `g'
    post `pf' ("|RG| 평균, A 순위 그룹 `g'") (r(mean))
}
quietly spearman RG LR
post `pf' ("Spearman RG–LR") (r(rho))
quietly spearman RG ln_emp
post `pf' ("Spearman RG–취업자") (r(rho))
quietly spearman tau ln_emp
post `pf' ("Spearman tau–취업자") (r(rho))
foreach x in OE FEL ELO {
    quietly spearman tau `x'
    post `pf' ("Spearman tau–`x'") (r(rho))
}
postclose `pf'
preserve
use `st', clear
list, noobs clean
export excel using "`xl'", sheet("stats") firstrow(variables) sheetreplace
* TeX: 항목 & 값
file open `fh' using "`out'/31_summary.tex", write replace
file write `fh' "% 04_14_analysis_kor_conv_saved_gap.do가 생성. 직접 고치지 말 것." _n
local tl1  "A와 B의 Spearman 순위상관"
local tl2  "\(\ln\) A와 \(\ln\) B의 Pearson 상관"
local tl3  "전체 대화당 절감 시간 \(\bar\tau\)(분)"
local tl4  "소분류 \(\tau\) 중앙값(분)"
local tl5  "소분류 \(\tau\) 최솟값(분)"
local tl6  "소분류 \(\tau\) 최댓값(분)"
local tl7  "소분류 \(\tau\) 90분위 / 10분위(배)"
local tl8  "\(|\mathrm{RG}|\) 최댓값"
local tl9  "\(|\mathrm{RG}|\) 평균"
local tl10 "\(|\mathrm{RG}| \ge 20\)인 소분류 수"
local tl11 "\(|\mathrm{RG}|\) 평균: A 순위 1\(\sim\)43위"
local tl12 "\(|\mathrm{RG}|\) 평균: A 순위 44\(\sim\)86위"
local tl13 "\(|\mathrm{RG}|\) 평균: A 순위 87\(\sim\)129위"
local tl14 "RG와 LR의 Spearman 순위상관"
local tl15 "RG와 취업자 수의 Spearman 순위상관"
local tl16 "\(\tau\)와 취업자 수의 Spearman 순위상관"
local tl17 "\(\tau\)와 Observed exposure의 Spearman 순위상관"
local tl18 "\(\tau\)와 Felten LM AIOE의 Spearman 순위상관"
local tl19 "\(\tau\)와 Eloundou GPT-4 \(\beta\)의 Spearman 순위상관"
forvalues k = 1/`=_N' {
    local f "%6.2f"
    if inlist(`k', 3, 4, 5, 6, 9, 11, 12, 13) local f "%6.1f"
    if inlist(`k', 8, 10) local f "%4.0f"
    fmt 값[`k'] `f'
    file write `fh' "`tl`k'' & `r(s)' \\" _n
}
file close `fh'
restore

* -----------------------------------------------------------------------------
* 4. 순위 격차 상위·하위 15
* -----------------------------------------------------------------------------
local tops ""
foreach sd in pos neg {
    use `d', clear
    if "`sd'" == "pos" gsort -RG ksco3
    else               gsort  RG ksco3
    keep in 1/15
    generate byte 순위 = _n
    generate str3 방향 = "`sd'"
    tempfile t_`sd'
    save `t_`sd''
    file open `fh' using "`out'/31_top_`sd'.tex", write replace
    file write `fh' "% 04_14_analysis_kor_conv_saved_gap.do가 생성. 직접 고치지 말 것." _n
    forvalues k = 1/15 {
        fmt A[`k'] %5.2f
        local a "`r(s)'"
        fmt B[`k'] %5.2f
        local b "`r(s)'"
        fmt RG[`k'] %4.0f sign
        local g "`r(s)'"
        fmt tau[`k'] %5.0f
        local t "`r(s)'"
        local sx = cond("`sd'" == "pos", "up", "dn")
        fmt `sx'_dev[`k'] %5.1f sign
        local dv "`r(s)'"
        fmt `sx'_tau[`k'] %5.0f
        local st "`r(s)'"
        texesc `"`=`sx'_soc_title[`k']'"'
        local sn `"`r(s)'"'
        file write `fh' "`k' & `=ksco3[`k']' `=ksco3_title[`k']' & `a' & `=r_A[`k']' & `b' & `=r_B[`k']' & `g' & `t' & `=`sx'_soc[`k']' `sn' (`st'분, `dv') \\" _n
    }
    file close `fh'
}
use `t_pos', clear
append using `t_neg'
order 방향 순위
export excel 방향 순위 ksco3 ksco3_title ksco1 emp A r_A B r_B RG DS LR tau r_tau top_* up_* dn_* ///
    using "`xl'", sheet("top") firstrow(variables) sheetreplace

* -----------------------------------------------------------------------------
* 5. 대화량(A) 상위 30의 B 순위
* -----------------------------------------------------------------------------
use `d', clear
keep if r_A <= 30
sort r_A
export excel ksco3 ksco3_title ksco1 A r_A B r_B RG DS tau top_* using "`xl'", sheet("top30A") firstrow(variables) sheetreplace
file open `fh' using "`out'/31_top30A.tex", write replace
file write `fh' "% 04_14_analysis_kor_conv_saved_gap.do가 생성. 직접 고치지 말 것." _n
forvalues k = 1/`=_N' {
    fmt A[`k'] %5.2f
    local a "`r(s)'"
    fmt B[`k'] %5.2f
    local b "`r(s)'"
    fmt RG[`k'] %4.0f sign
    local g "`r(s)'"
    fmt DS[`k'] %5.2f sign
    local ds "`r(s)'"
    fmt tau[`k'] %5.0f
    local t "`r(s)'"
    fmt top_conv_sh[`k'] %4.1f
    local cs "`r(s)'"
    fmt top_tau[`k'] %5.0f
    local tt "`r(s)'"
    texesc `"`=top_soc_title[`k']'"'
    local sn `"`r(s)'"'
    file write `fh' "`=r_A[`k']' & `=ksco3[`k']' `=ksco3_title[`k']' & `a' & `b' & `=r_B[`k']' & `g' & `ds' & `t' & `=top_soc[`k']' `sn' (`cs'\%, `tt'분) \\" _n
}
file close `fh'

* -----------------------------------------------------------------------------
* 6. SOC 기여(상위·하위 15 소분류) 엑셀
* -----------------------------------------------------------------------------
use `t_pos', clear
append using `t_neg'
keep 방향 순위 ksco3 RG tau
merge 1:m ksco3 using `soc', keep(match) nogenerate
gsort 방향 순위 -conv_sh soc6
order 방향 순위 ksco3 ksco3_title RG tau soc_rank soc6 soc6_title conv_sh saved_sh dev tau_s c v
export excel using "`xl'", sheet("soc") firstrow(variables) sheetreplace

* -----------------------------------------------------------------------------
* 7. 대분류
* -----------------------------------------------------------------------------
use `d', clear
generate byte n = 1
generate int pos = RG > 0
collapse (sum) n pos A B DS (mean) RG, by(ksco1 ksco1_title)
generate double tau = `tau_bar' * B / A
sort ksco1
export excel ksco1 ksco1_title n A B DS tau RG pos using "`xl'", sheet("ksco1") firstrow(variables) sheetreplace
file open `fh' using "`out'/31_ksco1.tex", write replace
file write `fh' "% 04_14_analysis_kor_conv_saved_gap.do가 생성. 직접 고치지 말 것." _n
forvalues k = 1/`=_N' {
    fmt A[`k'] %5.1f
    local a "`r(s)'"
    fmt B[`k'] %5.1f
    local b "`r(s)'"
    fmt DS[`k'] %5.2f sign
    local ds "`r(s)'"
    fmt tau[`k'] %5.0f
    local t "`r(s)'"
    fmt RG[`k'] %5.1f sign
    local g "`r(s)'"
    file write `fh' "`=ksco1[`k']' `=ksco1_title[`k']' & `=n[`k']' & `a' & `b' & `ds' & `t' & `g' & `=pos[`k']' \\" _n
}
file close `fh'
list ksco1 n A B DS tau RG pos, noobs abbreviate(10)
