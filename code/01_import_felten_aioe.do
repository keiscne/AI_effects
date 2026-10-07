* =============================================================================
* 01_import_felten_aioe.do
* Felten, Raj, and Seamans (2023) 언어모델 AIOE: SOC 2010 → SOC 2018 세부 직업(6자리)
*
* 입력:
*   $raw/exposure/felten_aioe/repo_2024_06_03/AIOE-adca5fc2cd0e9a659ff05278b7fa7a53f4f324c1/
*       Language Modeling AIOE and AIIE.xlsx, 시트 "LM AIOE"(A1:C775; 머리글 1행 + 774개 직업)
*       열: SOC Code, Occupation Title, Language Modeling AIOE
*   $raw/exposure/bls_soc_crosswalk/soc_2018/soc_2010_to_2018_crosswalk.xlsx
*       시트 "Sorted by 2010", 9행 머리글, 10~909행 = (2010 코드, 2018 코드) 900쌍
* 출력: $proc/exposure/felten_aioe/
*   felten_lm_aioe_soc2018.{csv,dta}   행 = SOC 2018 세부 직업(soc6)
*
* SOC 버전 확인: Felten 코드를 변환표의 2010 코드 목록, 2018 코드 목록과 각각 대조한다.
*   모두 2010 목록에 있고 2010에만 있는 코드(예: 15-1132)가 있으며 2018에만 있는 코드
*   (예: 15-1252)가 없으면 SOC 2010으로 판정한다.
*   결과: 774개 중 773개가 2010 목록에 있음. 그중 87개는 2010에만 있는 코드(2018 목록에 없음),
*   2018에만 있는 코드는 0개 → SOC 2010.
*   예외 1개: 19-1020 "Biologists"는 SOC 2010 세부 직업이 아니라 O*NET 고유 코드(19-1020.01)라
*   변환표에 없다. 같은 계열 19-1029(Biological Scientists, All Other)는 Felten에 따로 있으므로 변환에서 뺀다.
* 변환(작업자 판단, 고용 가중치 없음):
*   일대다(2010 하나 → 2018 여럿): 같은 값을 각 2018 직업에 복사
*   다대일(2010 여럿 → 2018 하나): Felten에 값이 있는 2010 직업들의 단순평균
*   n_src2010 = 평균에 쓴 2010 코드 수, n_cw2010 = 변환표상 2010 코드 수,
*   partial = 1이면 변환표상 2010 코드 일부가 Felten에 없음(남은 코드로만 평균)
*   split = 1이면 원천 2010 코드 중 하나 이상이 여러 2018 직업으로 나뉨(값 복사)
* 매칭 키: soc6(str7, SOC 2018) = aei_soc6_time_savings의 soc6 = job_exposure occ_code
* 주의: lm_aioe는 Felten 원자료 그대로(774개 SOC 2010 직업 기준 표준화 값). 변환 후 다시 표준화하지 않는다.
*   확인용 마지막 단계는 01_import_aei_soc_time_savings.do 출력(aei_soc6_time_savings.dta)을 읽는다.
* =============================================================================

version 17
clear all
set more off

if `"$root"' == "" global root "d:/research/AI_effects"
if `"$raw"'  == "" global raw  "$root/data/raw"
if `"$proc"' == "" global proc "$root/data/proc"

local fel "$raw/exposure/felten_aioe/repo_2024_06_03/AIOE-adca5fc2cd0e9a659ff05278b7fa7a53f4f324c1"
local cw  "$raw/exposure/bls_soc_crosswalk/soc_2018"
local outf "$proc/exposure/felten_aioe"
capture mkdir "$proc/exposure"
capture mkdir "`outf'"

* -----------------------------------------------------------------------------
* 1. 변환표
* -----------------------------------------------------------------------------
import excel using "`cw'/soc_2010_to_2018_crosswalk.xlsx", sheet("Sorted by 2010") ///
    cellrange(A10:D909) clear allstring
rename (A B C D) (soc2010 soc2010_title soc2018 soc2018_title)
foreach v of varlist _all {
    replace `v' = strtrim(`v')
}
* 명칭 끝의 BLS 각주 표시 " (#)", " (##)" 삭제
foreach v in soc2010_title soc2018_title {
    replace `v' = strtrim(regexr(`v', "\(#+\)$", ""))
}
assert !strpos(soc2010_title, "#") & !strpos(soc2018_title, "#")
count
assert r(N) == 900
assert regexm(soc2010, "^[0-9][0-9]-[0-9][0-9][0-9][0-9]$") & regexm(soc2018, "^[0-9][0-9]-[0-9][0-9][0-9][0-9]$")
isid soc2010 soc2018
bysort soc2010: generate n_cw2018 = _N
bysort soc2018: generate n_cw2010 = _N
tempfile cwalk
save `cwalk'
preserve
keep soc2010
duplicates drop
generate byte in_cw2010 = 1
rename soc2010 code
tempfile c10
save `c10'
restore
keep soc2018
duplicates drop
generate byte in_cw2018 = 1
rename soc2018 code
tempfile c18
save `c18'

* -----------------------------------------------------------------------------
* 2. Felten 언어모델 AIOE와 SOC 버전 확인
* -----------------------------------------------------------------------------
import excel using "`fel'/Language Modeling AIOE and AIIE.xlsx", sheet("LM AIOE") ///
    cellrange(A1:C775) firstrow clear allstring
rename (SOCCode OccupationTitle) (soc2010 felten_title)
rename LanguageModeling* lm_aioe_s
replace soc2010 = strtrim(soc2010)
generate double lm_aioe = real(lm_aioe_s)
drop lm_aioe_s
count
assert r(N) == 774
assert !missing(lm_aioe)
assert regexm(soc2010, "^[0-9][0-9]-[0-9][0-9][0-9][0-9]$")
isid soc2010
summarize lm_aioe

generate code = soc2010
merge 1:1 code using `c10', keep(master match) nogenerate
merge 1:1 code using `c18', keep(master match) nogenerate
replace in_cw2010 = 0 if missing(in_cw2010)
replace in_cw2018 = 0 if missing(in_cw2018)
drop code
tabulate in_cw2010 in_cw2018
* SOC 2010에만 있는 코드 / SOC 2018에만 있는 코드
list soc2010 felten_title if in_cw2010 & !in_cw2018, noobs abbreviate(20)
list soc2010 felten_title if !in_cw2010, noobs abbreviate(20)
count if in_cw2018 & !in_cw2010                    // 2018에만 있는 코드
assert r(N) == 0
count if in_cw2010 & !in_cw2018                    // 2010에만 있는 코드
assert r(N) == 87
assert !in_cw2010 == (soc2010 == "19-1020")        // 변환표에 없는 코드는 O*NET 고유 코드 1개뿐
drop if soc2010 == "19-1020"
tempfile felten
save `felten'

* -----------------------------------------------------------------------------
* 3. SOC 2018로 변환
* -----------------------------------------------------------------------------
use `cwalk', clear
merge m:1 soc2010 using `felten', keepusing(lm_aioe felten_title)
* _merge == 1: Felten에 없는 2010 직업(대개 "All Other"), _merge == 2: 변환표에 없는 Felten 직업(19-1020 제외 후 0)
tabulate _merge
assert _merge != 2
list soc2010 soc2010_title soc2018 if _merge == 1, noobs abbreviate(20)
generate byte has_val = _merge == 3
drop _merge

* 원천 2010 코드 목록(값이 있는 것만, 확인용)
sort soc2018 soc2010
generate str7 s_i = cond(has_val, soc2010, "")
by soc2018: generate str244 src2010 = s_i if _n == 1
by soc2018: replace src2010 = src2010[_n-1] + cond(src2010[_n-1] != "" & s_i != "", ";", "") + s_i if _n > 1
by soc2018: replace src2010 = src2010[_N]
drop s_i
generate byte split_i = n_cw2018 > 1 & has_val

collapse (mean) lm_aioe (sum) n_src2010 = has_val (max) n_cw2010 split = split_i, ///
    by(soc2018 soc2018_title src2010)
isid soc2018
generate byte partial = n_src2010 < n_cw2010 & n_src2010 > 0
count if n_src2010 == 0
list soc2018 soc2018_title if n_src2010 == 0, noobs abbreviate(20)
drop if n_src2010 == 0
assert !missing(lm_aioe)
tabulate n_src2010
tabulate split partial

rename (soc2018 soc2018_title) (soc6 soc6_title)
label variable soc6        "SOC 2018 세부 직업 6자리(XX-XXXX)"
label variable soc6_title  "SOC 2018 직업 명칭(BLS 변환표)"
label variable lm_aioe     "언어모델 AIOE(Felten et al. 2023; SOC 2010 값의 단순평균)"
label variable n_src2010   "평균에 쓴 SOC 2010 코드 수"
label variable n_cw2010    "변환표상 대응 SOC 2010 코드 수"
label variable src2010     "평균에 쓴 SOC 2010 코드(;로 구분)"
label variable split       "1 = 원천 2010 직업이 여러 2018 직업으로 나뉨(값 복사)"
label variable partial     "1 = 대응 2010 코드 일부가 Felten에 없음"
order soc6 soc6_title lm_aioe n_src2010 n_cw2010 split partial src2010
sort soc6
compress
save "`outf'/felten_lm_aioe_soc2018.dta", replace
export delimited using "`outf'/felten_lm_aioe_soc2018.csv", replace
summarize lm_aioe

* 확인용: AEI 시간 절감(soc6, 01_import_aei_soc_time_savings.do)과 매칭되는 직업 수(결합 파일은 만들지 않음)
local aeit "$proc/usage/anthropic_economic_index/aei_soc6_time_savings.dta"
capture confirm file "`aeit'"
if _rc == 0 {
    merge 1:1 soc6 using "`aeit'", keepusing(soc6) generate(_m_aei)
    tabulate _m_aei
    list soc6 soc6_title if _m_aei == 2, noobs abbreviate(20)
}
