* =============================================================================
* 04_analysis_soc2018_ksco8_crosswalk_summary.do
* SOC 2018–KSCO 8차(–KECO 2025) 연계표의 구조 요약: 단계별 대응 유형, 1:1이 아닌 경우의 원인·규모
* (report 21: results/paper/21_SOC2018_KSCO8_연계표_구축.tex)
*
* 입력: $proc/exposure/bls_soc_crosswalk/  (01_import_soc2018_ksco8_crosswalk.do 출력)
*   soc2018_ksco8_stages.dta      단계별 연계쌍(4개 표)
*   soc2018_ksco8_paths.dta       연결 경로(soc2018, soc2010, isco08, ksco8)
*   soc2018_ksco8_crosswalk.dta   고유 (soc2018, ksco8) 쌍 + 가중치
*   확인용: $proc/merged/soc6_ai_indicators.dta,
*           $proc/macro/scaling/sensortower_state_of_ai_2026/sensortower_aei_kor_soc6_conversations.dta
* 출력: $results/table/
*   21_sources.tex      단계별 연계쌍 수, 코드 수, 경로에 쓰인 쌍·코드 수
*   21_types.tex        단계별·최종 연계쌍의 대응 유형(1:1, 1:N, N:1, M:N)
*   21_multi.tex        단계별 여러 코드와 대응하는 코드 수와 최대 대응 수
*   21_dist.tex         최종 연계표: SOC 하나당 KSCO 수, KSCO 하나당 SOC 수의 분포
*   21_pattern_soc.tex  SOC 2018이 여러 KSCO로 나뉘는 단계(경로 유형)
*   21_pattern_ksco.tex KSCO가 여러 SOC 2018과 대응하는 단계(경로 유형)
*   21_extreme_soc.tex  KSCO 수가 가장 많은 SOC 2018 10개
*   21_extreme_ksco.tex SOC 2018 수가 가장 많은 KSCO 10개
*   21_examples.tex     단계별 1:1이 아닌 대응 예시
*   21_w_ksco.tex       가중치 예시: KSCO 2223(응용 소프트웨어 개발자)의 w_mean, w_flat
*   21_w_soc.tex        가중치 예시: SOC 15-1252, 13-1082의 w_alloc
*   21_flags.tex        ISCO 3자리 펼침, 대분류 벗어난 연계의 규모
*   21_unlinked.tex     경로에서 빠지는 코드
*   21_coverage.tex     프로젝트 SOC 자료의 SOC 직업을 KSCO 수 구간별로 나눈 분포(한국 대화량 비중 포함)
*   21_top_conv.tex     한국 업무용 대화 비중(2026-05, k = 3) 상위 10개 SOC 직업의 KSCO 배분(w_alloc)
*   21_dilution.tex   observed exposure를 KSCO로 옮겼을 때 분포 변화(값의 희석)
*   21_soc2018_ksco8_crosswalk.xlsx  시트 soc2018(SOC별 대응 수), ksco8(KSCO별 대응 수)
* 대응 유형(쌍 단위): 왼쪽 = SOC 2018에 가까운 쪽, 오른쪽 = KECO에 가까운 쪽.
*   1:1 = 두 코드 모두 이 쌍 하나뿐, 1:N = 왼쪽 코드가 오른쪽 여러 코드와 대응(오른쪽은 이 왼쪽뿐),
*   N:1 = 오른쪽 코드가 왼쪽 여러 코드와 대응(왼쪽은 이 오른쪽뿐), M:N = 두 코드 모두 여러 코드와 대응.
* =============================================================================

version 17
clear all
set more off

if `"$root"'    == "" global root    "d:/research/AI_effects"
if `"$proc"'    == "" global proc    "$root/data/proc"
if `"$results"' == "" global results "$root/results"

local cwd "$proc/exposure/bls_soc_crosswalk"
local out "$results/table"
local xl  "`out'/21_soc2018_ksco8_crosswalk.xlsx"
local hdr "% 04_analysis_soc2018_ksco8_crosswalk_summary.do가 생성. 직접 고치지 말 것."
tempname fh

* LaTeX 특수문자 처리
capture program drop texesc
program define texesc
    syntax varlist
    foreach v of local varlist {
        replace `v' = subinstr(`v', "&", "\&", .)
        replace `v' = subinstr(`v', "%", "\%", .)
        replace `v' = subinstr(`v', "_", "\_", .)
        replace `v' = subinstr(`v', "#", "\#", .)
    }
end

* 쌍 단위 대응 유형: 변수 l(왼쪽), r(오른쪽) → nr, nl, ptype(1=1:1, 2=1:N, 3=N:1, 4=M:N)
capture program drop ptypes
program define ptypes
    args l r
    bysort `l': generate nr = _N
    bysort `r': generate nl = _N
    generate byte ptype = cond(nr == 1 & nl == 1, 1, cond(nl == 1, 2, cond(nr == 1, 3, 4)))
end

* -----------------------------------------------------------------------------
* 0. 경로에 쓰인 단계별 쌍
* -----------------------------------------------------------------------------
use "`cwd'/soc2018_ksco8_paths.dta", clear
local s1 "soc2018 soc2010"
local s2 "soc2010 isco08"
local s3 "isco08 ksco8"
local s4 "ksco8 keco2025"
forvalues s = 1/4 {
    preserve
    keep `s`s''
    duplicates drop
    drop if missing(`: word 2 of `s`s''')
    rename (`s`s'') (left right)
    generate byte stage = `s'
    generate byte used = 1
    tempfile u`s'
    save `u`s''
    restore
}
use `u1', clear
forvalues s = 2/4 {
    append using `u`s''
}
tempfile used
save `used'

use "`cwd'/soc2018_ksco8_stages.dta", clear
merge 1:1 stage left right using `used'
assert _merge != 2
replace used = 0 if missing(used)
drop _merge
tempfile st
save `st'

* -----------------------------------------------------------------------------
* 1. 단계별 연계쌍 수와 코드 수 (21_sources) / 대응 유형 (21_types) / 여러 대응 (21_multi)
* -----------------------------------------------------------------------------
local sname1 "1. SOC 2018–SOC 2010 (BLS)"
local sname2 "2. SOC 2010–ISCO-08 (BLS)"
local sname3 "3. ISCO-08–KSCO 8차 (통계청)"
local sname4 "4. KSCO 8차–KECO 2025 (통계청)"
local sname5 "최종: SOC 2018–KSCO 8차"

forvalues s = 1/5 {
    if `s' <= 4 {
        use `st' if stage == `s', clear
    }
    else {
        use "`cwd'/soc2018_ksco8_crosswalk.dta", clear
        rename (soc2018 ksco8) (left right)
        generate byte used = 1
    }
    quietly count
    local np`s' = r(N)
    quietly levelsof left
    local nl`s' : word count `r(levels)'
    quietly levelsof right
    local nr`s' : word count `r(levels)'
    quietly count if used
    local up`s' = r(N)
    quietly levelsof left if used
    local ul`s' : word count `r(levels)'
    quietly levelsof right if used
    local ur`s' : word count `r(levels)'
    * 유형은 경로에 쓰인 쌍 기준(1~4단계 모두 원 표와 거의 같음; 차이는 21_sources)
    keep if used
    ptypes left right
    forvalues t = 1/4 {
        quietly count if ptype == `t'
        local t`t'_`s' = r(N)
    }
    local p11_`s' : display %4.1f 100 * `t1_`s'' / `up`s''
    * 여러 코드와 대응하는 코드 수, 최대 대응 수
    preserve
    bysort left: keep if _n == 1
    quietly count if nr > 1
    local ml`s' = r(N)
    quietly summarize nr
    local mxl`s' = r(max)
    restore
    bysort right: keep if _n == 1
    quietly count if nl > 1
    local mr`s' = r(N)
    quietly summarize nl
    local mxr`s' = r(max)
}

file open `fh' using "`out'/21_sources.tex", write replace
file write `fh' "`hdr'" _n
forvalues s = 1/5 {
    if `s' == 5 file write `fh' "\midrule" _n
    file write `fh' "`sname`s'' & `np`s'' & `nl`s'' & `nr`s'' & `up`s'' & `ul`s'' & `ur`s'' \\" _n
}
file close `fh'

file open `fh' using "`out'/21_types.tex", write replace
file write `fh' "`hdr'" _n
forvalues s = 1/5 {
    if `s' == 5 file write `fh' "\midrule" _n
    file write `fh' "`sname`s'' & `t1_`s'' & `t2_`s'' & `t3_`s'' & `t4_`s'' & `up`s'' & `=trim("`p11_`s''")' \\" _n
}
file close `fh'

file open `fh' using "`out'/21_multi.tex", write replace
file write `fh' "`hdr'" _n
forvalues s = 1/5 {
    if `s' == 5 file write `fh' "\midrule" _n
    file write `fh' "`sname`s'' & `ul`s'' & `ml`s'' & `mxl`s'' & `ur`s'' & `mr`s'' & `mxr`s'' \\" _n
}
file close `fh'

* -----------------------------------------------------------------------------
* 2. 최종 연계표의 분포 (21_dist)
* -----------------------------------------------------------------------------
capture program drop binit
program define binit
    args v
    generate byte bin = 1 if `v' == 1
    replace bin = 2 if `v' == 2
    replace bin = 3 if `v' == 3
    replace bin = 4 if inrange(`v', 4, 5)
    replace bin = 5 if inrange(`v', 6, 10)
    replace bin = 6 if inrange(`v', 11, 20)
    replace bin = 7 if `v' >= 21 & !missing(`v')
end
local bl1 "1개"
local bl2 "2개"
local bl3 "3개"
local bl4 "4~5개"
local bl5 "6~10개"
local bl6 "11~20개"
local bl7 "21개 이상"

use "`cwd'/soc2018_ksco8_crosswalk.dta", clear
bysort soc2018: keep if _n == 1
binit nk_per18
quietly count
local nsoc = r(N)
forvalues b = 1/7 {
    quietly count if bin == `b'
    local ds`b' = r(N)
}
quietly summarize nk_per18, detail
local soc_mean : display %4.2f r(mean)
local soc_med = r(p50)
local soc_max = r(max)
use "`cwd'/soc2018_ksco8_crosswalk.dta", clear
bysort ksco8: keep if _n == 1
binit n18_perk
quietly count
local nks = r(N)
forvalues b = 1/7 {
    quietly count if bin == `b'
    local dk`b' = r(N)
}
quietly summarize n18_perk, detail
local ks_mean : display %4.2f r(mean)
local ks_med = r(p50)
local ks_max = r(max)

file open `fh' using "`out'/21_dist.tex", write replace
file write `fh' "`hdr'" _n
forvalues b = 1/7 {
    local a : display %4.1f 100 * `ds`b'' / `nsoc'
    local c : display %4.1f 100 * `dk`b'' / `nks'
    file write `fh' "`bl`b'' & `ds`b'' & `=trim("`a'")' & `dk`b'' & `=trim("`c'")' \\" _n
}
file write `fh' "\midrule" _n
file write `fh' "합계 & `nsoc' & 100.0 & `nks' & 100.0 \\" _n
file write `fh' "평균 & `=trim("`soc_mean'")' & & `=trim("`ks_mean'")' & \\" _n
file write `fh' "중앙값 / 최댓값 & `soc_med' / `soc_max' & & `ks_med' / `ks_max' & \\" _n
file close `fh'

* -----------------------------------------------------------------------------
* 3. 1:N이 생기는 단계 (21_pattern_soc, 21_pattern_ksco), 극단 사례 (21_extreme_*)
* -----------------------------------------------------------------------------
use "`cwd'/soc2018_ksco8_paths.dta", clear
foreach x in soc2010 isco08 ksco8 {
    egen byte t_`x' = tag(soc2018 `x')
    bysort soc2018: egen n_`x' = total(t_`x')
}
bysort soc2018: keep if _n == 1
keep soc2018 soc2018_title n_soc2010 n_isco08 n_ksco8
generate byte pat = 1 if n_soc2010 == 1 & n_isco08 == 1 & n_ksco8 == 1
replace pat = 2 if n_soc2010 == 1 & n_isco08 == 1 & n_ksco8 > 1
replace pat = 3 if n_soc2010 == 1 & n_isco08 > 1
replace pat = 4 if n_soc2010 > 1
assert !missing(pat)
tempfile psoc
save `psoc'
local pl1 "SOC 2010 1개 → ISCO 1개 → KSCO 1개"
local pl2 "SOC 2010 1개 → ISCO 1개 → KSCO 여러 개 (3단계에서 분할)"
local pl3 "SOC 2010 1개 → ISCO 여러 개 (2단계에서 분할)"
local pl4 "SOC 2010 여러 개 (1단계에서 통합된 SOC 2018)"
file open `fh' using "`out'/21_pattern_soc.tex", write replace
file write `fh' "`hdr'" _n
forvalues p = 1/4 {
    quietly count if pat == `p'
    local n = r(N)
    local sh : display %4.1f 100 * `n' / _N
    quietly summarize n_isco08 if pat == `p'
    local mi : display %4.2f r(mean)
    quietly summarize n_ksco8 if pat == `p'
    local mk : display %4.2f r(mean)
    local xk = r(max)
    file write `fh' "`pl`p'' & `n' & `=trim("`sh'")' & `=trim("`mi'")' & `=trim("`mk'")' & `xk' \\" _n
}
file write `fh' "\midrule" _n
quietly summarize n_isco08
local mi : display %4.2f r(mean)
quietly summarize n_ksco8
local mk : display %4.2f r(mean)
file write `fh' "합계 & `=_N' & 100.0 & `=trim("`mi'")' & `=trim("`mk'")' & `r(max)' \\" _n
file close `fh'

gsort -n_ksco8 soc2018
generate str200 tt = soc2018_title
texesc tt
file open `fh' using "`out'/21_extreme_soc.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/10 {
    file write `fh' "`=soc2018[`i']' & `=tt[`i']' & `=n_soc2010[`i']' & `=n_isco08[`i']' & `=n_ksco8[`i']' \\" _n
}
file close `fh'
drop tt
tempfile xsoc
save `xsoc'

use "`cwd'/soc2018_ksco8_paths.dta", clear
foreach x in isco08 soc2010 soc2018 {
    egen byte t_`x' = tag(ksco8 `x')
    bysort ksco8: egen n_`x' = total(t_`x')
}
bysort ksco8: keep if _n == 1
keep ksco8 ksco8_title keco2025 n_isco08 n_soc2010 n_soc2018
generate byte pat = 1 if n_isco08 == 1 & n_soc2010 == 1 & n_soc2018 == 1
replace pat = 2 if n_isco08 == 1 & n_soc2010 == 1 & n_soc2018 > 1
replace pat = 3 if n_isco08 == 1 & n_soc2010 > 1
replace pat = 4 if n_isco08 > 1
assert !missing(pat)
local kl1 "ISCO 1개 ← SOC 2010 1개 ← SOC 2018 1개"
local kl2 "ISCO 1개 ← SOC 2010 1개 ← SOC 2018 여러 개 (1단계에서 분할된 SOC 2010)"
local kl3 "ISCO 1개 ← SOC 2010 여러 개 (2단계에서 통합)"
local kl4 "ISCO 여러 개 (3단계에서 통합)"
file open `fh' using "`out'/21_pattern_ksco.tex", write replace
file write `fh' "`hdr'" _n
forvalues p = 1/4 {
    quietly count if pat == `p'
    local n = r(N)
    local sh : display %4.1f 100 * `n' / _N
    quietly summarize n_isco08 if pat == `p'
    local mi : display %4.2f r(mean)
    quietly summarize n_soc2018 if pat == `p'
    local mk : display %4.2f r(mean)
    local xk = r(max)
    file write `fh' "`kl`p'' & `n' & `=trim("`sh'")' & `=trim("`mi'")' & `=trim("`mk'")' & `xk' \\" _n
}
file write `fh' "\midrule" _n
quietly summarize n_isco08
local mi : display %4.2f r(mean)
quietly summarize n_soc2018
local mk : display %4.2f r(mean)
file write `fh' "합계 & `=_N' & 100.0 & `=trim("`mi'")' & `=trim("`mk'")' & `r(max)' \\" _n
file close `fh'

gsort -n_soc2018 ksco8
file open `fh' using "`out'/21_extreme_ksco.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/10 {
    file write `fh' "`=ksco8[`i']' & `=ksco8_title[`i']' & `=n_isco08[`i']' & `=n_soc2010[`i']' & `=n_soc2018[`i']' \\" _n
}
file close `fh'
tempfile xks
save `xks'

* -----------------------------------------------------------------------------
* 4. 단계별 예시 (21_examples)
* -----------------------------------------------------------------------------
use `st', clear
generate byte pick = 0
* 1단계: SOC 2010 하나가 SOC 2018 여럿으로 분할(Surgeons), SOC 2018 하나로 통합(43-2099), 복합(소프트웨어)
replace pick = 1 if stage == 1 & right == "29-1067"
replace pick = 2 if stage == 1 & left == "43-2099"
replace pick = 3 if stage == 1 & inlist(right, "15-1132", "15-1133")
* 2단계: SOC 하나가 ISCO 여럿(Chief Executives), ISCO 하나가 SOC 여럿(2512), ISCO 3자리 펼침(19-2099)
replace pick = 4 if stage == 2 & left == "11-1011"
replace pick = 5 if stage == 2 & right == "2512"
replace pick = 6 if stage == 2 & left == "19-2099"
* 3단계: ISCO 하나가 KSCO 여럿(5311 보육 종사자, 대분류 벗어난 연계 포함), KSCO 하나가 ISCO 여럿(1212)
replace pick = 7 if stage == 3 & left == "5311"
replace pick = 8 if stage == 3 & right == "1212"
* 유형은 단계 전체에서 계산
bysort stage left: generate nr = _N
bysort stage right: generate nl = _N
generate str4 ty = cond(nr == 1 & nl == 1, "1:1", cond(nl == 1, "1:N", cond(nr == 1, "N:1", "M:N")))
keep if pick
sort pick left right
generate str200 lt = left_title
generate str200 rt = right_title
texesc lt rt
file open `fh' using "`out'/21_examples.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/`=_N' {
    if `i' > 1 {
        if pick[`i'] != pick[`i'-1] file write `fh' "\midrule" _n
    }
    local fl = cond(isco3_link[`i'] == 1, " (3자리 펼침)", cond(ksco_cross_major[`i'] == 1, " (대분류 벗어남)", ""))
    file write `fh' "`=stage[`i']' & `=left[`i']' `=lt[`i']' & `=right[`i']' `=rt[`i']'`fl' & `=ty[`i']' \\" _n
}
file close `fh'

* -----------------------------------------------------------------------------
* 5. 가중치 예시 (21_w_ksco, 21_w_soc)
* -----------------------------------------------------------------------------
use "`cwd'/soc2018_ksco8_crosswalk.dta", clear
keep if ksco8 == "2223"
sort soc2018
generate str200 tt = soc2018_title
texesc tt
file open `fh' using "`out'/21_w_ksco.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/`=_N' {
    local a : display %5.3f w_mean[`i']
    local b : display %5.3f w_flat[`i']
    file write `fh' "`=soc2018[`i']' `=tt[`i']' & `=via_soc2010[`i']' & `=via_isco08[`i']' & `=trim("`a'")' & `=trim("`b'")' \\" _n
}
quietly summarize w_mean
local a : display %5.3f r(sum)
quietly summarize w_flat
local b : display %5.3f r(sum)
file write `fh' "\midrule" _n
file write `fh' "합계 & & & `=trim("`a'")' & `=trim("`b'")' \\" _n
file close `fh'

use "`cwd'/soc2018_ksco8_crosswalk.dta", clear
keep if inlist(soc2018, "15-1252", "13-1082")
gsort -soc2018 ksco8
file open `fh' using "`out'/21_w_soc.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/`=_N' {
    if `i' > 1 {
        if soc2018[`i'] != soc2018[`i'-1] file write `fh' "\midrule" _n
    }
    local a : display %5.3f w_alloc[`i']
    local b : display %5.3f w_mean[`i']
    file write `fh' "`=soc2018[`i']' & `=ksco8[`i']' `=ksco8_title[`i']' & `=via_soc2010[`i']' & `=via_isco08[`i']' & `=trim("`a'")' & `=trim("`b'")' \\" _n
}
file close `fh'

* -----------------------------------------------------------------------------
* 6. ISCO 3자리 펼침, 대분류 벗어난 연계 (21_flags)
* -----------------------------------------------------------------------------
use `st', clear
quietly count if stage == 2 & isco3_link == 1
local f1s = r(N)
quietly count if stage == 3 & ksco_cross_major == 1
local f2s = r(N)
use "`cwd'/soc2018_ksco8_crosswalk.dta", clear
foreach f in isco3_link ksco_cross_major {
    quietly count if `f' == 1
    local `f'_p = r(N)
    quietly levelsof soc2018 if `f' == 1
    local `f'_s : word count `r(levels)'
    quietly levelsof ksco8 if `f' == 1
    local `f'_k : word count `r(levels)'
    * 이 연결만으로 KSCO와 이어지는 SOC 수(다른 경로가 없는 SOC)
    bysort soc2018: egen byte all_ = min(`f')
    quietly levelsof soc2018 if all_ == 1
    local `f'_only : word count `r(levels)'
    drop all_
}
file open `fh' using "`out'/21_flags.tex", write replace
file write `fh' "`hdr'" _n
file write `fh' "ISCO 3자리 연결을 4자리로 펼침(2단계) & `f1s' & `isco3_link_p' & `isco3_link_s' & `isco3_link_only' & `isco3_link_k' \\" _n
file write `fh' "대분류 벗어난 연계(3단계) & `f2s' & `ksco_cross_major_p' & `ksco_cross_major_s' & `ksco_cross_major_only' & `ksco_cross_major_k' \\" _n
file close `fh'

* -----------------------------------------------------------------------------
* 7. 경로에서 빠지는 코드 (21_unlinked)
* -----------------------------------------------------------------------------
* 2단계: BLS 표에만 있는 ISCO(KSCO와 이어지지 않음) → 해당 SOC 2010이 다른 ISCO로 이어지는지
use `st' if stage == 2, clear
bysort right: egen byte anyused = max(used)
keep if !anyused
bysort left: generate k_ = _n
preserve
use `st' if stage == 2 & used, clear
keep left
duplicates drop
generate byte left_ok = 1
tempfile lok
save `lok'
restore
merge m:1 left using `lok', keep(master match) nogenerate
replace left_ok = 0 if missing(left_ok)
sort right left
generate str200 rt = right_title
texesc rt
file open `fh' using "`out'/21_unlinked.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/`=_N' {
    local ok = cond(left_ok[`i'] == 1, "다른 ISCO로 연결", "연결 끊김")
    file write `fh' "ISCO-08(BLS 표에만 있음) & `=right[`i']' `=rt[`i']' & SOC 2010 `=left[`i']' & `ok' \\" _n
}
* 4단계: KECO 표에만 있는 KSCO
use `st' if stage == 4 & !used, clear
forvalues i = 1/`=_N' {
    file write `fh' "KSCO 8차(KECO 표에만 있음) & `=left[`i']' `=left_title[`i']' & KECO `=right[`i']' & SOC와 연결 없음 \\" _n
}
file close `fh'

* -----------------------------------------------------------------------------
* 8. 프로젝트 SOC 자료 기준 분포 (21_coverage)
* -----------------------------------------------------------------------------
use `psoc', clear
rename n_ksco8 nk
binit nk
keep soc2018 nk bin
tempfile sb
save `sb'

use soc6 using "$proc/merged/soc6_ai_indicators.dta", clear
rename soc6 soc2018
merge 1:1 soc2018 using `sb', keep(match) nogenerate
forvalues b = 1/7 {
    quietly count if bin == `b'
    local ai`b' = r(N)
}
quietly count
local ain = r(N)

use if month == "2026-05" using "$proc/macro/scaling/sensortower_state_of_ai_2026/sensortower_aei_kor_soc6_conversations.dta", clear
keep soc6 conv_k3
rename soc6 soc2018
merge 1:1 soc2018 using `sb', keep(master match)
quietly summarize conv_k3
local ctot = r(sum)
quietly summarize conv_k3 if _merge == 1
local cmiss = r(sum)
keep if _merge == 3
forvalues b = 1/7 {
    quietly count if bin == `b'
    local kc`b' = r(N)
    quietly summarize conv_k3 if bin == `b'
    local kv`b' : display %5.1f 100 * r(sum) / `ctot'
}
quietly count
local kcn = r(N)
local kvm : display %5.1f 100 * `cmiss' / `ctot'

file open `fh' using "`out'/21_coverage.tex", write replace
file write `fh' "`hdr'" _n
forvalues b = 1/7 {
    file write `fh' "`bl`b'' & `ds`b'' & `ai`b'' & `kc`b'' & `=trim("`kv`b''")' \\" _n
}
file write `fh' "연계표 없음(45-XXXX) & -- & -- & -- & `=trim("`kvm'")' \\" _n
file write `fh' "\midrule" _n
file write `fh' "합계 & `nsoc' & `ain' & `kcn' & 100.0 \\" _n
file close `fh'

* 한국 대화 비중 상위 10개 SOC 직업의 KSCO 배분(w_alloc)
use if month == "2026-05" using "$proc/macro/scaling/sensortower_state_of_ai_2026/sensortower_aei_kor_soc6_conversations.dta", clear
keep soc6 conv_k3
rename soc6 soc2018
generate double sh = 100 * conv_k3 / `ctot'
gsort -sh
keep in 1/10
generate int rank = _n
merge 1:m soc2018 using "`cwd'/soc2018_ksco8_crosswalk.dta", keep(match) nogenerate ///
    keepusing(soc2018_title ksco8 ksco8_title w_alloc nk_per18)
gsort rank -w_alloc ksco8
by rank: generate str244 klist = ""
by rank: replace klist = cond(_n == 1, "", klist[_n-1] + "; ") + ksco8 + " " + ksco8_title + " (" + strtrim(string(w_alloc, "%5.3f")) + ")"
by rank: keep if _n == _N
generate str200 tt = soc2018_title
texesc tt
file open `fh' using "`out'/21_top_conv.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/`=_N' {
    local a : display %4.1f sh[`i']
    file write `fh' "`=soc2018[`i']' `=tt[`i']' & `=trim("`a'")' & `=nk_per18[`i']' & `=klist[`i']' \\" _n
}
file close `fh'

* -----------------------------------------------------------------------------
* 9. 값의 희석: observed exposure를 KSCO로 옮긴 결과 (21_dilution)
* -----------------------------------------------------------------------------
use soc6 observed_exposure using "$proc/merged/soc6_ai_indicators.dta", clear
keep if !missing(observed_exposure)
rename soc6 soc2018
tempfile oe
save `oe'
quietly summarize observed_exposure, detail
local d1 "`r(N)' `r(mean)' `r(sd)' `r(p50)' `r(p90)' `r(max)'"
quietly count if observed_exposure == 0
local z1 = r(N)

use "`cwd'/soc2018_ksco8_crosswalk.dta", clear
merge m:1 soc2018 using `oe', keep(master match) nogenerate
keep if !missing(observed_exposure)
* 값이 있는 SOC만으로 가중치를 다시 나눔(ksco8 안 합 1)
foreach w in w_mean w_flat {
    bysort ksco8: egen double s_ = total(`w')
    generate double `w'_r = `w' / s_
    drop s_
    generate double v_`w' = `w'_r * observed_exposure
}
collapse (sum) oe_mean = v_w_mean oe_flat = v_w_flat (max) oe_max = observed_exposure, by(ksco8)
foreach v in oe_mean oe_flat oe_max {
    quietly summarize `v', detail
    local d_`v' "`r(N)' `r(mean)' `r(sd)' `r(p50)' `r(p90)' `r(max)'"
    quietly count if `v' == 0
    local z_`v' = r(N)
}
local lab1 "SOC 2018 세부 직업(원 값)"
local lab2 "KSCO: w\_mean 가중평균"
local lab3 "KSCO: w\_flat 단순평균"
local lab4 "KSCO: 연결된 SOC의 최댓값(참고)"
file open `fh' using "`out'/21_dilution.tex", write replace
file write `fh' "`hdr'" _n
local k = 0
foreach d in d1 d_oe_mean d_oe_flat d_oe_max {
    local ++k
    local z = cond(`k' == 1, `z1', cond(`k' == 2, `z_oe_mean', cond(`k' == 3, `z_oe_flat', `z_oe_max')))
    tokenize ``d''
    local line "`lab`k'' & `1'"
    forvalues j = 2/6 {
        local s : display %5.3f ``j''
        local line "`line' & `=trim("`s'")'"
    }
    file write `fh' "`line' & `z' \\" _n
}
file close `fh'

* -----------------------------------------------------------------------------
* 10. 엑셀: SOC별·KSCO별 대응 수
* -----------------------------------------------------------------------------
use `xsoc', clear
merge 1:1 soc2018 using `psoc', keepusing(pat) nogenerate
sort soc2018
export excel using "`xl'", sheet("soc2018") firstrow(variables) replace
use `xks', clear
sort ksco8
export excel using "`xl'", sheet("ksco8") firstrow(variables)
