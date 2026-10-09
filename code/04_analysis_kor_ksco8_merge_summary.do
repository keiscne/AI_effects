* =============================================================================
* 04_analysis_kor_ksco8_merge_summary.do
* 한국 대화량 + AI 지표의 SOC 결합과 KSCO 8차 변환 결과 요약(특이사항 정리용)
* (paper 23: results/paper/23_한국대화량_AI지표_KSCO결합.tex)
*
* 입력: $proc/merged/kor_soc6_conv_ai_indicators.dta, kor_ksco8_conv_ai_indicators.dta
*       (03_merge_kor_conv_ai_ksco8.do 출력), $proc/exposure/bls_soc_crosswalk/soc2018_ksco8_crosswalk.dta
* 출력: $results/table/
*   23_soc_merge.tex   월별 SOC 결합 결과와 대화량 SOC의 지표 보유(직업 수, 업무용 대화 비중)
*   23_ksco_conv.tex   월별 KSCO 494개의 대화량 공개 범위(전부·일부·없음)
*   23_ind_cov.tex     지표별 SOC·KSCO 보유 수와 덮개(cov)
*   23_top_ksco.tex    2026-05 업무용 대화 상위 15개 KSCO
*   23_partial.tex     2026-05 대화량 일부 공개 KSCO 중 대화량 상위 10개
*   23_miss_ind.tex    2026-05 대화량은 있으나 observed exposure가 없는 KSCO
*   23_twins.tex       연결된 SOC와 가중치가 같아 모든 값이 같아지는 KSCO 묶음(2026-05 대화 비중은 KSCO 하나당)
*   23_product.tex     2026-05 총 절감 시간: SOC에서 곱한 뒤 배분(A) 대 KSCO 값끼리 곱함(B)
*   23_kor_ksco8_conv_ai.xlsx  시트 ksco8_2026_05(KSCO별 전체 변수)
* =============================================================================

version 17
clear all
set more off

if `"$root"'    == "" global root    "d:/research/AI_effects"
if `"$proc"'    == "" global proc    "$root/data/proc"
if `"$results"' == "" global results "$root/results"

local soc "$proc/merged/kor_soc6_conv_ai_indicators.dta"
local ks  "$proc/merged/kor_ksco8_conv_ai_indicators.dta"
local cw  "$proc/exposure/bls_soc_crosswalk/soc2018_ksco8_crosswalk.dta"
local out "$results/table"
local hdr "% 04_analysis_kor_ksco8_merge_summary.do가 생성. 직접 고치지 말 것."
tempname fh

* 숫자 서식
capture program drop fmt
program define fmt, rclass
    args x f
    local s : display `f' `x'
    return local s = trim("`s'")
end

* -----------------------------------------------------------------------------
* 1. SOC 결합 (23_soc_merge)
* -----------------------------------------------------------------------------
use "`soc'", clear
local m1 "2026-04"
local m2 "2026-05"
forvalues j = 1/2 {
    preserve
    keep if month == "`m`j''"
    quietly count if conv_pub
    local a1_`j' = r(N)
    local b1_`j' "100.00"
    quietly count if conv_pub & in_ind
    local a2_`j' = r(N)
    quietly summarize share_work if conv_pub & in_ind
    fmt 100*r(sum) %6.2f
    local b2_`j' "`r(s)'"
    quietly count if conv_pub & !in_ind
    local a3_`j' = r(N)
    quietly summarize share_work if conv_pub & !in_ind
    fmt 100*r(sum) %6.2f
    local b3_`j' "`r(s)'"
    local k = 3
    foreach v in time_saved_min observed_exposure elo_gpt4_beta lm_aioe {
        local ++k
        quietly count if conv_pub & in_ind & !missing(`v')
        local a`k'_`j' = r(N)
        quietly summarize share_work if conv_pub & in_ind & !missing(`v')
        fmt 100*r(sum) %6.2f
        local b`k'_`j' "`r(s)'"
    }
    quietly count if !conv_pub & in_ind
    local a8_`j' = r(N)
    local b8_`j' "--"
    restore
}
local l1 "대화량 공개 SOC 행"
local l2 "\quad AI 지표 파일과 매칭"
local l3 "\quad 매칭 안 됨(45-XXXX 자리표시)"
local l4 "\quad\quad 시간 절감(AEI) 있음"
local l5 "\quad\quad observed exposure 있음"
local l6 "\quad\quad Eloundou 노출도 있음"
local l7 "\quad\quad Felten AIOE 있음"
local l8 "AI 지표 808개 중 대화량 미공개"
file open `fh' using "`out'/23_soc_merge.tex", write replace
file write `fh' "`hdr'" _n
forvalues k = 1/8 {
    if `k' == 8 file write `fh' "\midrule" _n
    file write `fh' "`l`k'' & `a`k'_1' & `b`k'_1' & `a`k'_2' & `b`k'_2' \\" _n
}
file close `fh'

* -----------------------------------------------------------------------------
* 2. KSCO 대화량 공개 범위 (23_ksco_conv)
* -----------------------------------------------------------------------------
use "`ks'", clear
generate byte grp = cond(n_soc_conv == 0, 3, cond(n_soc_conv == n_soc_link, 1, 2))
local g1 "연결된 SOC 모두 공개"
local g2 "일부만 공개"
local g3 "공개된 SOC 없음(대화량 결측)"
file open `fh' using "`out'/23_ksco_conv.tex", write replace
file write `fh' "`hdr'" _n
forvalues g = 1/3 {
    local line "`g`g''"
    forvalues j = 1/2 {
        quietly count if grp == `g' & month == "`m`j''"
        local n = r(N)
        quietly summarize share_work if grp == `g' & month == "`m`j''"
        fmt 100*r(sum) %6.2f
        local s = cond(`g' == 3, "--", "`r(s)'")
        quietly summarize conv_cover if grp == `g' & month == "`m`j''"
        fmt r(mean) %5.3f
        local c "`r(s)'"
        local line "`line' & `n' & `s' & `c'"
    }
    file write `fh' "`line' \\" _n
}
file write `fh' "\midrule" _n
local line "합계"
forvalues j = 1/2 {
    quietly count if month == "`m`j''"
    local n = r(N)
    quietly summarize share_work if month == "`m`j''"
    fmt 100*r(sum) %6.2f
    local s "`r(s)'"
    quietly summarize conv_cover if month == "`m`j''"
    fmt r(mean) %5.3f
    local line "`line' & `n' & `s' & `r(s)'"
}
file write `fh' "`line' \\" _n
file close `fh'

* -----------------------------------------------------------------------------
* 3. 지표별 덮개 (23_ind_cov), 2026-05 기준(지표는 월과 무관, 대화 비중만 5월)
* -----------------------------------------------------------------------------
use "`soc'" if month == "2026-05", clear
local il1 "시간 절감(AEI, 분)"
local il2 "observed exposure"
local il3 "Eloundou GPT-4 beta"
local il4 "Felten 언어모델 AIOE"
local i = 0
foreach v in time_saved_min observed_exposure elo_gpt4_beta lm_aioe {
    local ++i
    quietly count if in_ind & !missing(`v')
    local s`i' = r(N)
}
use "`ks'" if month == "2026-05", clear
file open `fh' using "`out'/23_ind_cov.tex", write replace
file write `fh' "`hdr'" _n
local i = 0
foreach p in "time_saved_min cov_aei" "observed_exposure cov_obs" "elo_gpt4_beta cov_elo" "lm_aioe cov_felten" {
    local ++i
    tokenize `p'
    quietly count if !missing(`1')
    local kv = r(N)
    quietly count if `2' > 1 - 1e-9 & !missing(`1')
    local kf = r(N)
    quietly count if `2' < 1 - 1e-9 & !missing(`1')
    local kp = r(N)
    quietly summarize `2' if !missing(`1')
    fmt r(mean) %5.3f
    local cm "`r(s)'"
    quietly count if missing(`1')
    local km = r(N)
    quietly summarize share_work if missing(`1')
    fmt 100*r(sum) %5.2f
    local sm "`r(s)'"
    file write `fh' "`il`i'' & `s`i'' & `kv' & `kf' & `kp' & `cm' & `km' & `sm' \\" _n
}
file close `fh'

* -----------------------------------------------------------------------------
* 4. 2026-05 대화량 상위 KSCO (23_top_ksco), 일부 공개 KSCO (23_partial), 지표 결측 KSCO (23_miss_ind)
* -----------------------------------------------------------------------------
use "`ks'" if month == "2026-05", clear
gsort -conv_k3
file open `fh' using "`out'/23_top_ksco.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/15 {
    fmt 100*share_work[`i'] %5.2f
    local a "`r(s)'"
    fmt conv_k3[`i']/10000 %9.0fc
    local b "`r(s)'"
    fmt time_saved_min[`i'] %5.0f
    local c "`r(s)'"
    fmt observed_exposure[`i'] %5.3f
    local d "`r(s)'"
    file write `fh' "`=ksco8[`i']' `=ksco8_title[`i']' & `a' & `b' & `=n_soc_conv[`i']'/`=n_soc_link[`i']' & `c' & `d' \\" _n
}
file close `fh'

preserve
keep if n_soc_conv > 0 & n_soc_conv < n_soc_link
gsort -conv_k3
file open `fh' using "`out'/23_partial.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/10 {
    fmt 100*share_work[`i'] %5.2f
    local a "`r(s)'"
    fmt conv_cover[`i'] %5.3f
    local c "`r(s)'"
    file write `fh' "`=ksco8[`i']' `=ksco8_title[`i']' & `a' & `=n_soc_conv[`i']'/`=n_soc_link[`i']' & `c' \\" _n
}
file close `fh'
restore

preserve
keep if !missing(conv_k3) & missing(observed_exposure)
gsort -conv_k3
file open `fh' using "`out'/23_miss_ind.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/`=_N' {
    fmt 100*share_work[`i'] %6.3f
    local a "`r(s)'"
    local t = cond(missing(time_saved_min[`i']), "--", string(time_saved_min[`i'], "%5.0f"))
    file write `fh' "`=ksco8[`i']' `=ksco8_title[`i']' & `a' & `=n_soc_conv[`i']'/`=n_soc_link[`i']' & `t' \\" _n
}
file close `fh'
display as text "대화량은 있으나 observed exposure가 없는 KSCO: " _N
restore

* -----------------------------------------------------------------------------
* 5. 값이 같아지는 KSCO 묶음 (23_twins): 연결된 SOC와 w_mean·w_alloc이 모두 같은 KSCO
* -----------------------------------------------------------------------------
preserve
use "`cw'", clear
sort ksco8 soc2018
generate str40 tok = soc2018 + ":" + strofreal(w_mean, "%9.6f") + ":" + strofreal(w_alloc, "%9.6f")
by ksco8: generate strL sig = tok if _n == 1
by ksco8: replace sig = sig[_n-1] + "|" + tok if _n > 1
by ksco8: keep if _n == _N
keep ksco8 sig
bysort sig: generate ng = _N
egen gid = group(sig) if ng > 1
keep ksco8 ng gid
tempfile tw
save `tw'
restore
merge 1:1 ksco8 using `tw', nogenerate assert(match)
quietly count if ng > 1
local ntw = r(N)
quietly levelsof gid
local ngr : word count `r(levels)'
display as text "값이 같아지는 KSCO: `ntw'개, 묶음 `ngr'개"
* 묶음별로 대화량 합(5월) 순서
bysort gid: egen double gconv = total(conv_k3) if ng > 1
sort gid ksco8
generate str244 members = ""
by gid: replace members = cond(_n == 1, "", members[_n-1] + "; ") + ksco8 + " " + ksco8_title if ng > 1
by gid: keep if _n == _N | ng == 1
keep if ng > 1
gsort -gconv
file open `fh' using "`out'/23_twins.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/`=min(12, _N)' {
    local a = cond(missing(conv_k3[`i']), "--", trim(string(100*share_work[`i'], "%5.2f")))
    file write `fh' "`=members[`i']' & `=ng[`i']' & `a' \\" _n
}
file write `fh' "\midrule" _n
file write `fh' "합계(묶음 `ngr'개) & `ntw' & \\" _n
file close `fh'

* -----------------------------------------------------------------------------
* 6. 곱한 양은 SOC에서 계산해야 함 (23_product): 2026-05 총 절감 시간 = Σ 대화 수 × 대화당 절감 시간
*    (A) SOC에서 곱한 뒤 합산  (B) KSCO에서 배분된 대화 수 × KSCO 평균 절감 시간
* -----------------------------------------------------------------------------
use "`soc'" if month == "2026-05" & conv_pub, clear
generate double ts = conv_k3 * time_saved_min / 60
quietly summarize ts
local A = r(sum)
use "`soc'" if month == "2026-05" & conv_pub, clear
keep soc6 conv_k3 time_saved_min
rename soc6 soc2018
joinby soc2018 using "`cw'"
generate double ts = w_alloc * conv_k3 * time_saved_min / 60
collapse (sum) tsA = ts, by(ksco8)
tempfile ka
save `ka'
use "`ks'" if month == "2026-05", clear
merge 1:1 ksco8 using `ka', nogenerate
generate double tsB = conv_k3 * time_saved_min / 60
quietly summarize tsA
local A2 = r(sum)
quietly summarize tsB
local B = r(sum)
quietly correlate tsA tsB
local rho = r(rho)
generate double rel = abs(tsB / tsA - 1) if tsA > 0
quietly count if rel > 0.1 & !missing(rel)
local n10 = r(N)
quietly count if !missing(rel)
local nr = r(N)
display as text "A(SOC) = `A', A2(KSCO 합) = `A2', B(KSCO 곱) = `B'"
assert abs(`A2' / `A' - 1) < 1e-9
file open `fh' using "`out'/23_product.tex", write replace
file write `fh' "`hdr'" _n
fmt `A'/1e6 %9.2f
file write `fh' "(A) SOC에서 곱한 뒤 \texttt{w\_alloc}으로 배분해 합산 & `r(s)' & 100.0 \\" _n
fmt `B'/1e6 %9.2f
local b "`r(s)'"
fmt 100*`B'/`A' %5.1f
file write `fh' "(B) KSCO 대화 수 × KSCO 평균 절감 시간(\texttt{w\_mean}) & `b' & `r(s)' \\" _n
file write `fh' "\midrule" _n
fmt `rho' %5.3f
file write `fh' "KSCO별 (A)와 (B)의 상관계수 & `r(s)' & \\" _n
file write `fh' "KSCO별 차이가 10\% 넘는 KSCO 수 / 값이 있는 KSCO 수 & `n10' / `nr' & \\" _n
file close `fh'

use "`ks'" if month == "2026-05", clear
sort ksco8
export excel using "`out'/23_kor_ksco8_conv_ai.xlsx", sheet("ksco8_2026_05") firstrow(variables) replace
