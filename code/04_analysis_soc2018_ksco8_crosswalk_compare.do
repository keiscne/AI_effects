* =============================================================================
* 04_analysis_soc2018_ksco8_crosswalk_compare.do
* 이 저장소의 SOC 2018–KSCO 8차 연계표(01_import_soc2018_ksco8_crosswalk.do)와
* 별도 과정으로 만든 연계표(SOC2018_ISCO08_KSCO8_crosswalk.xlsx)의 비교
* (report 22: results/report/22_SOC2018_KSCO8_연계표_비교.tex)
*
* 입력:
*   $raw/exposure/bls_soc_crosswalk/isco08_ksco08/SOC2018_ISCO08_KSCO8_crosswalk.xlsx  (사용자 제공, 이하 "외부 파일")
*     시트 SOC18_SOC10(900행), SOC10_ISCO08(1,125행), ISCO08_KSCO8(701행), SOC18_ISCO_KSCO(2,541행),
*          3digit_ISCO_Expanded(9행), SOC18_Summary(867행), KSCO_Exceptions(10행), README
*   $proc/exposure/bls_soc_crosswalk/soc2018_ksco8_{stages,paths,crosswalk}.dta  (이 저장소)
* 출력: $results/table/
*   22_stages.tex     단계별·경로별·쌍별 비교: 외부 파일, 이 저장소, 일치, 한쪽에만
*   22_diff.tex       한쪽에만 있는 연계(3자리 처리 제외)
*   22_soccount.tex   SOC 2018별 SOC 2010·ISCO·KSCO 수의 일치 여부
*   22_socdiff.tex    KSCO 수가 다른 SOC 2018 목록
*   22_complexity.tex 외부 파일 Path_Complexity × 이 저장소 경로 유형(21_pattern_soc와 같은 분류)
*   22_exceptions.tex 외부 파일 KSCO_Exceptions 10행과 이 저장소의 처리
* 비교 키: 코드는 외부 파일에 적힌 그대로 쓴다(공백 제거 안 함). 공백 등으로 키가 달라지는 경우를 드러내기 위함.
* =============================================================================

version 17
clear all
set more off

if `"$root"'    == "" global root    "d:/research/AI_effects"
if `"$raw"'     == "" global raw     "$root/data/raw"
if `"$proc"'    == "" global proc    "$root/data/proc"
if `"$results"' == "" global results "$root/results"

local ext "$raw/exposure/bls_soc_crosswalk/isco08_ksco08/SOC2018_ISCO08_KSCO8_crosswalk.xlsx"
local cwd "$proc/exposure/bls_soc_crosswalk"
local out "$results/table"
local hdr "% 04_analysis_soc2018_ksco8_crosswalk_compare.do가 생성. 직접 고치지 말 것."
tempname fh

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

* 두 키 집합 비교: 현재 자료(외부, 키 변수 `keys')와 tempfile `ours'(같은 키) → 지역 매크로 반환
capture program drop cmpkeys
program define cmpkeys, rclass
    syntax, keys(string) ours(string)
    duplicates drop `keys', force
    quietly count
    return scalar n_ext = r(N)
    merge 1:1 `keys' using `ours'
    quietly count if _merge != 1
    return scalar n_our = r(N)
    quietly count if _merge == 3
    return scalar n_both = r(N)
    quietly count if _merge == 1
    return scalar n_eonly = r(N)
    quietly count if _merge == 2
    return scalar n_oonly = r(N)
end

* -----------------------------------------------------------------------------
* 1. 외부 파일 읽기
* -----------------------------------------------------------------------------
import excel using "`ext'", sheet("SOC18_ISCO_KSCO") firstrow clear allstring
count
assert r(N) == 2541
generate byte xsheet = 0
tempfile emain
save `emain'
import excel using "`ext'", sheet("3digit_ISCO_Expanded") firstrow clear allstring
count
assert r(N) == 9
generate byte xsheet = 1
append using `emain'
rename (SOC2018_Code SOC2010_Code ISCO08_Code KSCO8_4digit_Code) (soc2018 soc2010 isco08 ksco8)
tempfile epaths
save `epaths'

* -----------------------------------------------------------------------------
* 2. 단계별 비교 (22_stages)
* -----------------------------------------------------------------------------
use "`cwd'/soc2018_ksco8_stages.dta", clear
forvalues s = 1/3 {
    preserve
    keep if stage == `s'
    keep left right
    tempfile os`s'
    save `os`s''
    restore
}
local r = 0
* 1단계
import excel using "`ext'", sheet("SOC18_SOC10") firstrow clear allstring
rename (SOC2018_Code SOC2010_Code) (left right)
keep left right
cmpkeys, keys(left right) ours(`os1')
local ++r
local lab`r' "1. SOC 2018–SOC 2010"
foreach x in n_ext n_our n_both n_eonly n_oonly {
    local `x'`r' = r(`x')
}
* 2단계
import excel using "`ext'", sheet("SOC10_ISCO08") firstrow clear allstring
rename (SOC2010_Code ISCO08_Code) (left right)
keep left right
cmpkeys, keys(left right) ours(`os2')
local ++r
local lab`r' "2. SOC 2010–ISCO-08"
foreach x in n_ext n_our n_both n_eonly n_oonly {
    local `x'`r' = r(`x')
}
display as text "2단계 한쪽에만 있는 쌍"
list left right _merge if _merge != 3, noobs clean
* 3단계
import excel using "`ext'", sheet("ISCO08_KSCO8") firstrow clear allstring
count
assert r(N) == 701
rename (ISCO08_Code KSCO8_4digit_Code) (left right)
generate int len_left = strlen(left)
display as text "3단계: ISCO 코드 길이가 4가 아닌 행(끝 공백 등)"
list left right len_left if len_left != 4, noobs clean
keep left right
cmpkeys, keys(left right) ours(`os3')
local ++r
local lab`r' "3. ISCO-08–KSCO 8차"
foreach x in n_ext n_our n_both n_eonly n_oonly {
    local `x'`r' = r(`x')
}
display as text "3단계 한쪽에만 있는 쌍"
list left right _merge if _merge != 3, noobs clean
generate str60 dleft = left
generate str7 dright = right
generate str24 dside = cond(_merge == 1, "외부 파일에만", "이 저장소에만")
keep if _merge != 3
generate str14 dlev = "3단계 쌍"
keep dlev dleft dright dside
tempfile d3
save `d3'

* 경로(SOC 2018, SOC 2010, ISCO, KSCO)
use "`cwd'/soc2018_ksco8_paths.dta", clear
keep soc2018 soc2010 isco08 ksco8
tempfile opaths
save `opaths'
foreach v in main all {
    use `epaths', clear
    keep if ksco8 != ""
    if "`v'" == "main" keep if xsheet == 0
    keep soc2018 soc2010 isco08 ksco8
    cmpkeys, keys(soc2018 soc2010 isco08 ksco8) ours(`opaths')
    local ++r
    local lab`r' = cond("`v'" == "main", "경로: SOC18\_ISCO\_KSCO 시트", "경로: 위 + 3digit\_ISCO\_Expanded 시트")
    foreach x in n_ext n_our n_both n_eonly n_oonly {
        local `x'`r' = r(`x')
    }
    if "`v'" == "all" {
        display as text "경로: 한쪽에만 있는 것(3자리 펼침 포함)"
        list soc2018 soc2010 isco08 ksco8 _merge if _merge != 3, noobs clean
        keep if _merge != 3
        generate str60 dleft = soc2018 + " → " + soc2010 + " → " + isco08
        generate str7 dright = ksco8
        generate str24 dside = cond(_merge == 1, "외부 파일에만", "이 저장소에만")
        generate str14 dlev = "경로"
        keep dlev dleft dright dside
        tempfile dp
        save `dp'
    }
}

* (SOC 2018, KSCO) 쌍
use "`cwd'/soc2018_ksco8_crosswalk.dta", clear
keep soc2018 ksco8
tempfile opairs
save `opairs'
foreach v in main all {
    use `epaths', clear
    keep if ksco8 != ""
    if "`v'" == "main" keep if xsheet == 0
    keep soc2018 ksco8
    cmpkeys, keys(soc2018 ksco8) ours(`opairs')
    local ++r
    local lab`r' = cond("`v'" == "main", "(SOC 2018, KSCO) 쌍: SOC18\_ISCO\_KSCO 시트", "(SOC 2018, KSCO) 쌍: 3자리 펼침 포함")
    foreach x in n_ext n_our n_both n_eonly n_oonly {
        local `x'`r' = r(`x')
    }
    if "`v'" == "all" {
        display as text "쌍: 한쪽에만 있는 것"
        list soc2018 ksco8 _merge if _merge != 3, noobs clean
        keep if _merge != 3
        generate str60 dleft = soc2018
        generate str7 dright = ksco8
        generate str24 dside = cond(_merge == 1, "외부 파일에만", "이 저장소에만")
        generate str14 dlev = "쌍"
        keep dlev dleft dright dside
        tempfile dq
        save `dq'
    }
}

file open `fh' using "`out'/22_stages.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/`r' {
    if `i' == 4 | `i' == 6 file write `fh' "\midrule" _n
    file write `fh' "`lab`i'' & `n_ext`i'' & `n_our`i'' & `n_both`i'' & `n_eonly`i'' & `n_oonly`i'' \\" _n
}
file close `fh'

* 한쪽에만 있는 연계 목록 (22_diff): 명칭 붙이기
use `d3', clear
append using `dp'
append using `dq'
generate str5 kk = dright
preserve
use "`cwd'/soc2018_ksco8_crosswalk.dta", clear
keep ksco8 ksco8_title
duplicates drop
rename ksco8 kk
tempfile kt
save `kt'
restore
merge m:1 kk using `kt', keep(master match) nogenerate
generate str10 lord = cond(dlev == "3단계 쌍", "1", cond(dlev == "경로", "2", "3"))
sort lord dside dleft dright
* 끝에 공백이 붙은 코드 표시(외부 파일 ISCO08_Code "3314 ": 국제코드2 "*3314 "에서 *만 뗀 것으로 보임)
replace dleft = strtrim(dleft) + " + 끝 공백 1자" if dlev == "3단계 쌍" & dleft != strtrim(dleft)
file open `fh' using "`out'/22_diff.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/`=_N' {
    file write `fh' "`=dlev[`i']' & `=dleft[`i']' & `=dright[`i']' `=ksco8_title[`i']' & `=dside[`i']' \\" _n
}
file close `fh'

* -----------------------------------------------------------------------------
* 3. SOC 2018별 대응 수 (22_soccount, 22_socdiff)
* -----------------------------------------------------------------------------
use "`cwd'/soc2018_ksco8_paths.dta", clear
foreach x in soc2010 isco08 ksco8 {
    egen byte t_`x' = tag(soc2018 `x')
    bysort soc2018: egen o_`x' = total(t_`x')
}
bysort soc2018: keep if _n == 1
keep soc2018 soc2018_title o_soc2010 o_isco08 o_ksco8
generate byte pat = 1 if o_soc2010 == 1 & o_isco08 == 1 & o_ksco8 == 1
replace pat = 2 if o_soc2010 == 1 & o_isco08 == 1 & o_ksco8 > 1
replace pat = 3 if o_soc2010 == 1 & o_isco08 > 1
replace pat = 4 if o_soc2010 > 1
tempfile osum
save `osum'

import excel using "`ext'", sheet("SOC18_Summary") firstrow clear allstring
count
assert r(N) == 867
rename (SOC2018_Code SOC2010_Count ISCO08_Count KSCO8_4digit_Count) (soc2018 e_soc2010 e_isco08 e_ksco8)
destring e_soc2010 e_isco08 e_ksco8, replace
keep soc2018 e_soc2010 e_isco08 e_ksco8 Any_KSCO_Mapping ThreeDigit_ISCO_Flag Path_Complexity
merge 1:1 soc2018 using `osum'
assert _merge == 3
drop _merge

local cl1 "SOC 2010 수"
local cl2 "ISCO-08 수"
local cl3 "KSCO 8차 수"
file open `fh' using "`out'/22_soccount.tex", write replace
file write `fh' "`hdr'" _n
local i = 0
foreach x in soc2010 isco08 ksco8 {
    local ++i
    quietly count if e_`x' == o_`x'
    local eq = r(N)
    quietly count if e_`x' > o_`x'
    local gt = r(N)
    quietly count if e_`x' < o_`x'
    local lt = r(N)
    quietly summarize e_`x'
    local me : display %4.2f r(mean)
    quietly summarize o_`x'
    local mo : display %4.2f r(mean)
    file write `fh' "`cl`i'' & `eq' & `gt' & `lt' & `=trim("`me'")' & `=trim("`mo'")' \\" _n
}
file close `fh'
display as text "ISCO 수가 다른 SOC"
list soc2018 e_isco08 o_isco08 if e_isco08 != o_isco08, noobs clean

generate str200 tt = soc2018_title
texesc tt
generate str80 why = ""
replace why = "3자리 ISCO: 외부 파일 주 시트에 KSCO 없음(별도 시트에 후보)" if ThreeDigit_ISCO_Flag == "1"
replace why = "ISCO 3314–KSCO 2133 연계 누락(외부 파일)" if why == "" & inlist(soc2018, "15-2051", "15-2099", "19-4061", "43-9111")
sort soc2018
file open `fh' using "`out'/22_socdiff.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/`=_N' {
    if e_ksco8[`i'] != o_ksco8[`i'] {
        file write `fh' "`=soc2018[`i']' & `=tt[`i']' & `=e_ksco8[`i']' & `=o_ksco8[`i']' & `=why[`i']' \\" _n
    }
}
file close `fh'
count if e_ksco8 != o_ksco8 & why == ""
assert r(N) == 0

* Path_Complexity × 이 저장소 경로 유형 (22_complexity)
local pl1 "SOC 2010 1개 → ISCO 1개 → KSCO 1개"
local pl2 "ISCO 1개 → KSCO 여러 개"
local pl3 "SOC 2010 1개 → ISCO 여러 개"
local pl4 "SOC 2010 여러 개"
tabulate pat Path_Complexity
file open `fh' using "`out'/22_complexity.tex", write replace
file write `fh' "`hdr'" _n
forvalues p = 1/4 {
    local line "`pl`p''"
    foreach c in "1:1" "1:N" "N:M" {
        quietly count if pat == `p' & Path_Complexity == "`c'"
        local line "`line' & `r(N)'"
    }
    quietly count if pat == `p'
    file write `fh' "`line' & `r(N)' \\" _n
}
file write `fh' "\midrule" _n
local line "합계"
foreach c in "1:1" "1:N" "N:M" {
    quietly count if Path_Complexity == "`c'"
    local line "`line' & `r(N)'"
}
file write `fh' "`line' & `=_N' \\" _n
file close `fh'
* 외부 파일 Path_Complexity의 정의 확인(작업자 추정): 1:1 = ISCO 1개 & KSCO 1개, N:M = SOC 2010 2개 이상
count if Path_Complexity == "1:1" & !(e_isco08 == 1 & e_ksco8 == 1)
count if Path_Complexity == "N:M" & e_soc2010 == 1
count if Path_Complexity != "N:M" & e_soc2010 > 1
*   추정 규칙: N:M = SOC 2010 2개 이상, 1:1 = SOC 2010 1개 & ISCO 1개 & KSCO 1개 이하, 나머지 1:N
generate str3 rule = cond(e_soc2010 > 1, "N:M", cond(e_isco08 == 1 & e_ksco8 <= 1, "1:1", "1:N"))
assert rule == Path_Complexity

* -----------------------------------------------------------------------------
* 4. KSCO_Exceptions (22_exceptions)
* -----------------------------------------------------------------------------
import excel using "`ext'", sheet("KSCO_Exceptions") firstrow clear allstring
count
assert r(N) == 10
rename (SOC2018_Code SOC2010_Code ISCO08_Code) (soc2018 soc2010 isco08)
* 이 저장소 처리: 3자리는 4자리로 펼쳐 연결, 나머지는 KSCO 표에 없는 ISCO라 경로에서 빠짐
merge m:1 soc2018 using `osum', keepusing(o_ksco8) keep(master match) nogenerate
generate str60 how = cond(strlen(isco08) == 3, "4자리로 펼쳐 연결(isco3\_link = 1)", "경로에서 제외")
generate str200 tt = ISCO_Title_EN
texesc tt
replace soc2018 = soc2018 + " (" + soc2010 + ")" if soc2010 != soc2018
sort isco08 soc2018
file open `fh' using "`out'/22_exceptions.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/`=_N' {
    file write `fh' "`=soc2018[`i']' & `=isco08[`i']' `=tt[`i']' & `=how[`i']' & `=o_ksco8[`i']' \\" _n
}
file close `fh'
