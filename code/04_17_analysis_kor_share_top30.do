* =============================================================================
* 04_17_analysis_kor_share_top30.do
* 점유율 지표 A·B·C 상위·하위 30개 직업: SOC 세부 직업, KSCO 세분류·소분류·중분류, 대분류 전체   (엑셀만, paper 없음)
*
* 입력:
*   $proc/merged/kor_soc6_conv_ai_indicators.dta     월 × soc6 share_work, saved_w   (03_03_merge_kor_conv_ai_ksco8.do)
*   $proc/exposure/bls_soc_crosswalk/soc2018_ksco8_crosswalk.dta   soc2018 → ksco8, w_alloc, ksco8_title
*   $proc/merged/kor_ai_usage_ksco{3,2,1}.dta        shA, shB, shC, 월별 정규화 분모 tot_sw04·05, tot_sv04·05
*                                                     (03_05_merge_kor_ksco3_ai_usage.do)
* 출력: $results/table/34_kor_share_top30.xlsx    상위 30(값 내림차순)
*       $results/table/34_kor_share_bottom30.xlsx 하위 30(값 오름차순, 하위 순위 1 = 가장 작음). 시트 구성은 같다.
*   시트 soc_A, soc_B         SOC 세부 직업 지표 A·B 상위 30
*        ksco4_A, ksco4_B     KSCO 세분류(4자리) 지표 A·B 상위 30, 기여 1위 SOC
*        ksco3_A, _B, _C      KSCO 소분류 지표 A·B·C 상위 30, 기여 1위 세분류
*        ksco2_A, _B, _C      KSCO 중분류 지표 A·B·C 상위 30, 기여 1위 소분류
*        ksco1                KSCO 대분류 전체(지표 A 순), 지표별 기여 1위 중분류
*   34_sheets.tex, 34_top10_ksco3.tex, 34_ksco1.tex, 34_notes.tex   (paper 34 표: 두 엑셀 파일 설명 노트)
*
* 정의(두 달 2026-04·05 단순평균, 결측 달 = 0; 03_05와 같은 규칙):
*   SOC s: A_s = 100 × ½ Σ_t share_work(s, t)                  한국 업무용 대화 중 비중(%, 45-XXXX 포함 합 100)
*          B_s = 100 × ½ Σ_t saved_w(s, t) / Σ_s' saved_w(s', t)   업무용 비중 × 대화당 절감 시간의 점유율(%)
*          45-XXXX(농림어업 미공개 자리표시)는 순위에서 뺀다.
*   세분류 k: A_k = 100 × ½ Σ_t Σ_s share_work(s, t) × w_alloc(s, k) / tot_sw_t
*             B_k = 100 × ½ Σ_t Σ_s saved_w(s, t)  × w_alloc(s, k) / tot_sv_t
*             tot_*_t = 03_05의 월 t 소분류 표본(129개) 합 → 소분류 안 세분류 합 = shA, shB (assert).
*             지표 C는 분모(1인당 근로시간)가 소분류에만 있어 세분류에서는 만들지 않는다.
*   소분류·중분류·대분류: 03_05의 shA, shB, shC 그대로.
* 기여 1위: 상위 분류 값에 가장 많이 기여한 하위 단위(시트의 기준 지표로 판단)와 그 몫(%).
*   세분류 ← SOC: share_work × w_alloc(A), saved_w × w_alloc(B).
*   소분류 ← 세분류: A_k(A), B_k(B·C; 소분류 안에서는 hbar가 같아 C의 몫 = B의 몫).
*   중분류 ← 소분류, 대분류 ← 중분류: 각 지표 값.
* 순위: 값 내림차순, 같은 값은 코드 순(unique).
* 매칭 키: soc6 = soc2018(str7), ksco3 = substr(ksco8, 1, 3), ksco2 = substr(ksco3, 1, 2), ksco1 = substr(ksco3, 1, 1).
* 주의: KSCO 값은 연계표 배분 가정(paper 21)에 따른 값이다.
* =============================================================================

version 17
clear all
set more off

if `"$root"'    == "" global root    "d:/research/AI_effects"
if `"$proc"'    == "" global proc    "$root/data/proc"
if `"$results"' == "" global results "$root/results"

local xl "$results/table/34_kor_share_top30.xlsx"
local xlb "$results/table/34_kor_share_bottom30.xlsx"
local ntop 30
local out "$results/table"

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

* 상위 단위(by) 안에서 v가 가장 큰 하위 단위의 이름(lab)과 몫(%) → gen, gen_sh (by 안 모든 행에 같은 값)
capture program drop top1
program define top1
    syntax varname, by(varname) lab(varname) gen(name)
    tempvar tot
    bysort `by': egen double `tot' = total(`varlist')
    gsort `by' -`varlist' `lab'
    by `by': generate str244 `gen' = `lab'[1]
    by `by': generate double `gen'_sh = 100 * `varlist'[1] / `tot'
end

* key 내림차순(같은 값은 code 순) 상위 n개를 xl에, 오름차순 하위 n개를 xlb에 같은 시트 이름으로 내보냄.
*   vars = 순위 뒤에 놓을 열(첫 변수 = code). 하위 순위 1 = 값이 가장 작은 직업.
*   시트 요약(대상 수, 상위·하위 n개 합)을 postfile sheetpost에 남긴다.
capture program drop putsheet
program define putsheet
    syntax varlist, key(varname) sheet(string) xl(string) xlb(string) keylab(string) level(string) ///
        [n(integer 30) first]
    local code : word 1 of `varlist'
    local how = cond("`first'" != "", "replace", "sheetreplace")
    quietly count if !missing(`key')
    local nall = r(N)
    foreach side in top bot {
        preserve
        keep if !missing(`key')
        if "`side'" == "top" {
            gsort -`key' `code'
            local f "`xl'"
            local rl "순위(`keylab')"
        }
        else {
            gsort `key' `code'
            local f "`xlb'"
            local rl "하위 순위(`keylab', 1 = 가장 작음)"
        }
        generate int rank = _n
        label variable rank "`rl'"
        keep if rank <= `n'
        quietly summarize `key'
        local sum_`side' = r(sum)
        export excel rank `varlist' using "`f'", sheet("`sheet'") firstrow(varlabels) `how'
        list rank `varlist' in 1/3, noobs abbreviate(12)
        restore
    }
    post sheetpost ("`sheet'") ("`level'") ("`keylab'") (`nall') (`n') (`sum_top') (`sum_bot')
end

tempfile sheets
postfile sheetpost str10 sheet str24 level str10 ind int(nall n) double(sum_top sum_bot) using `sheets'

* -----------------------------------------------------------------------------
* 0. 소분류 표본과 월별 정규화 분모(03_05)
* -----------------------------------------------------------------------------
use "$proc/merged/kor_ai_usage_ksco3.dta", clear
foreach v in sw04 sw05 sv04 sv05 {
    local T_`v' = tot_`v'[1]
}
keep if in_share
keep ksco1 ksco1_title ksco2 ksco2_title ksco3 ksco3_title shA shB shC n_month_conv
isid ksco3
tempfile k3
save `k3'

* -----------------------------------------------------------------------------
* 1. SOC 세부 직업
* -----------------------------------------------------------------------------
use "$proc/merged/kor_soc6_conv_ai_indicators.dta", clear
keep if conv_pub
keep month soc6 soc6_title share_work saved_w
bysort month: egen double tsv = total(saved_w)
generate double a = 100 * share_work / 2
generate double b = 100 * saved_w / tsv / 2
collapse (sum) A = a B = b, by(soc6 soc6_title)
quietly summarize A
assert abs(r(sum) - 100) < 1e-9
quietly summarize B
assert abs(r(sum) - 100) < 1e-9
drop if soc6 == "45-XXXX"
count
label variable soc6       "SOC 코드(2018)"
label variable soc6_title "SOC 직업명(BLS)"
label variable A          "지표 A: 업무용 대화 점유율(%)"
label variable B          "지표 B: 절감 시간 점유율(%, 업무용 비중 × 대화당 절감 시간)"
putsheet soc6 soc6_title A B, key(A) keylab(지표 A) level(SOC 세부 직업) sheet("soc_A") xl("`xl'") xlb("`xlb'") n(`ntop') first
putsheet soc6 soc6_title B A, key(B) keylab(지표 B) level(SOC 세부 직업) sheet("soc_B") xl("`xl'") xlb("`xlb'") n(`ntop')
* 노트용: 지표 A 최솟값과 그 값을 가진 SOC 수(하위권 동점)
quietly summarize A
local soc_min = r(min)
quietly count if reldif(A, `soc_min') < 1e-9
local soc_nmin = r(N)
quietly summarize B
local soc_bmin = r(min)
quietly count if reldif(B, `soc_bmin') < 1e-9
local soc_nbmin = r(N)

* -----------------------------------------------------------------------------
* 2. KSCO 세분류(4자리): SOC 배분
* -----------------------------------------------------------------------------
use "$proc/exposure/bls_soc_crosswalk/soc2018_ksco8_crosswalk.dta", clear
keep soc2018 ksco8 ksco8_title w_alloc
rename soc2018 soc6
tempfile cw
save `cw'

use "$proc/merged/kor_soc6_conv_ai_indicators.dta", clear
keep if conv_pub
drop if soc6 == "45-XXXX"                               // 연계표에 없음
keep month soc6 soc6_title share_work saved_w
joinby soc6 using `cw'
generate str3 ksco3 = substr(ksco8, 1, 3)
merge m:1 ksco3 using `k3', keep(match) keepusing(ksco3) nogenerate   // 지표 표본 소분류만(군인·지역별고용조사 밖 제외)
generate double ca = 100 * share_work * w_alloc / cond(month == "2026-04", `T_sw04', `T_sw05') / 2
generate double cb = 100 * saved_w    * w_alloc / cond(month == "2026-04", `T_sv04', `T_sv05') / 2
collapse (sum) ca cb, by(soc6 soc6_title ksco8 ksco8_title ksco3)
isid soc6 ksco8
generate str244 soc_lab = soc6 + " " + soc6_title
top1 ca, by(ksco8) lab(soc_lab) gen(topA)
top1 cb, by(ksco8) lab(soc_lab) gen(topB)
collapse (sum) A = ca B = cb (first) topA topA_sh topB topB_sh, by(ksco8 ksco8_title ksco3)
isid ksco8
tempfile k8
save `k8'

* 확인: 소분류 안 세분류 합 = 03_05 shA, shB
collapse (sum) A B, by(ksco3)
merge 1:1 ksco3 using `k3', assert(match) nogenerate
assert reldif(A, shA) < 1e-9 & reldif(B, shB) < 1e-9

use `k8', clear
count
label variable ksco8       "KSCO 코드(8차 세분류)"
label variable ksco8_title "KSCO 직업명(세분류)"
label variable A           "지표 A: 업무용 대화 점유율(%)"
label variable B           "지표 B: 절감 시간 점유율(%, 업무용 비중 × 대화당 절감 시간)"
label variable topA        "기여 1위 SOC(지표 A)"
label variable topA_sh     "기여 1위 SOC 몫(%, 지표 A 중)"
label variable topB        "기여 1위 SOC(지표 B)"
label variable topB_sh     "기여 1위 SOC 몫(%, 지표 B 중)"
putsheet ksco8 ksco8_title A B topA topA_sh, key(A) keylab(지표 A) level(KSCO 세분류) sheet("ksco4_A") xl("`xl'") xlb("`xlb'") n(`ntop')
putsheet ksco8 ksco8_title B A topB topB_sh, key(B) keylab(지표 B) level(KSCO 세분류) sheet("ksco4_B") xl("`xl'") xlb("`xlb'") n(`ntop')
* 노트용: 기여 1위 SOC 몫이 50% 이상(상위 30)·100%(하위 30)인 세분류 수
gsort -A ksco8
quietly count in 1/`ntop' if topA_sh >= 50
local k4_top50 = r(N)
gsort A ksco8
quietly count in 1/`ntop' if topA_sh > 100 - 1e-9
local k4_bot100 = r(N)
quietly count if topA_sh > 100 - 1e-9
local k4_all100 = r(N)
local k4_n = _N

* -----------------------------------------------------------------------------
* 3. KSCO 소분류: 기여 1위 세분류
* -----------------------------------------------------------------------------
use `k8', clear
drop top*
generate str244 k8_lab = ksco8 + " " + ksco8_title
top1 A, by(ksco3) lab(k8_lab) gen(topA)
top1 B, by(ksco3) lab(k8_lab) gen(topB)
collapse (first) topA topA_sh topB topB_sh, by(ksco3)
merge 1:1 ksco3 using `k3', assert(match) nogenerate
* 소분류 안에서 hbar가 같으므로 C의 기여 1위·몫 = B의 것
generate str244 topC = topB
generate double topC_sh = topB_sh
count
label variable ksco3       "KSCO 코드(8차 소분류)"
label variable ksco3_title "KSCO 직업명(소분류)"
label variable shA         "지표 A: 업무용 대화 점유율(%)"
label variable shB         "지표 B: 절감 시간 점유율(%, 업무용 비중 × 대화당 절감 시간)"
label variable shC         "지표 C: 취업자 환산 절감 점유율(%)"
foreach m in A B C {
    label variable top`m'    "기여 1위 세분류(지표 `m')"
    label variable top`m'_sh "기여 1위 세분류 몫(%, 지표 `m' 중)"
}
putsheet ksco3 ksco3_title shA shB shC topA topA_sh, key(shA) keylab(지표 A) level(KSCO 소분류) sheet("ksco3_A") xl("`xl'") xlb("`xlb'") n(`ntop')
putsheet ksco3 ksco3_title shB shA shC topB topB_sh, key(shB) keylab(지표 B) level(KSCO 소분류) sheet("ksco3_B") xl("`xl'") xlb("`xlb'") n(`ntop')
putsheet ksco3 ksco3_title shC shA shB topC topC_sh, key(shC) keylab(지표 C) level(KSCO 소분류) sheet("ksco3_C") xl("`xl'") xlb("`xlb'") n(`ntop')
* 노트용: 상위 30 겹침, 하위 30 안 한 달만 공개된 소분류 수
foreach m in A B C {
    egen int r_`m' = rank(-sh`m'), unique
    gsort sh`m' ksco3
    quietly count in 1/`ntop' if n_month_conv == 1
    local k3_bot1m_`m' = r(N)
}
quietly count if n_month_conv == 1
local k3_1m = r(N)
quietly count if r_A <= `ntop' & r_B <= `ntop'
local k3_ovAB = r(N)
quietly count if r_A <= `ntop' & r_C <= `ntop'
local k3_ovAC = r(N)
tempfile k3x
save `k3x'

* -----------------------------------------------------------------------------
* 4. KSCO 중분류: 기여 1위 소분류
* -----------------------------------------------------------------------------
use `k3', clear
generate str244 k3_lab = ksco3 + " " + ksco3_title
foreach m in A B C {
    top1 sh`m', by(ksco2) lab(k3_lab) gen(top`m')
}
collapse (first) topA topA_sh topB topB_sh topC topC_sh, by(ksco2)
merge 1:1 ksco2 using "$proc/merged/kor_ai_usage_ksco2.dta", keepusing(ksco2_title shA shB shC) assert(match using)
assert missing(shA) if _merge == 2                      // 지표 표본 소분류가 없는 중분류
keep if _merge == 3
drop _merge
foreach m in A B C {
    quietly summarize sh`m'
    assert abs(r(sum) - 100) < 1e-9
}
count
label variable ksco2       "KSCO 코드(8차 중분류)"
label variable ksco2_title "KSCO 직업명(중분류)"
label variable shA         "지표 A: 업무용 대화 점유율(%)"
label variable shB         "지표 B: 절감 시간 점유율(%, 업무용 비중 × 대화당 절감 시간)"
label variable shC         "지표 C: 취업자 환산 절감 점유율(%)"
foreach m in A B C {
    label variable top`m'    "기여 1위 소분류(지표 `m')"
    label variable top`m'_sh "기여 1위 소분류 몫(%, 지표 `m' 중)"
}
putsheet ksco2 ksco2_title shA shB shC topA topA_sh, key(shA) keylab(지표 A) level(KSCO 중분류) sheet("ksco2_A") xl("`xl'") xlb("`xlb'") n(`ntop')
putsheet ksco2 ksco2_title shB shA shC topB topB_sh, key(shB) keylab(지표 B) level(KSCO 중분류) sheet("ksco2_B") xl("`xl'") xlb("`xlb'") n(`ntop')
putsheet ksco2 ksco2_title shC shA shB topC topC_sh, key(shC) keylab(지표 C) level(KSCO 중분류) sheet("ksco2_C") xl("`xl'") xlb("`xlb'") n(`ntop')
tempfile k2
save `k2'

* -----------------------------------------------------------------------------
* 5. KSCO 대분류 전체: 지표별 기여 1위 중분류
* -----------------------------------------------------------------------------
use `k2', clear
drop top*
generate str1 ksco1 = substr(ksco2, 1, 1)
generate str244 k2_lab = ksco2 + " " + ksco2_title
foreach m in A B C {
    top1 sh`m', by(ksco1) lab(k2_lab) gen(top`m')
}
collapse (first) topA topA_sh topB topB_sh topC topC_sh, by(ksco1)
merge 1:1 ksco1 using "$proc/merged/kor_ai_usage_ksco1.dta", keepusing(ksco1_title shA shB shC) assert(match using)
assert missing(shA) if _merge == 2
keep if _merge == 3
drop _merge
foreach m in A B C {
    egen int r_`m' = rank(-sh`m'), unique
}
label variable ksco1       "KSCO 코드(8차 대분류)"
label variable ksco1_title "KSCO 직업명(대분류)"
label variable shA         "지표 A: 업무용 대화 점유율(%)"
label variable shB         "지표 B: 절감 시간 점유율(%, 업무용 비중 × 대화당 절감 시간)"
label variable shC         "지표 C: 취업자 환산 절감 점유율(%)"
label variable r_B         "순위(지표 B)"
label variable r_C         "순위(지표 C)"
foreach m in A B C {
    label variable top`m'    "기여 1위 중분류(지표 `m')"
    label variable top`m'_sh "기여 1위 중분류 몫(%, 지표 `m' 중)"
}
putsheet ksco1 ksco1_title shA shB shC r_B r_C topA topA_sh topB topB_sh topC topC_sh, ///
    key(shA) keylab(지표 A) level(KSCO 대분류) sheet("ksco1") xl("`xl'") xlb("`xlb'") n(`=_N')
list ksco1 ksco1_title shA shB shC topA_sh topB_sh topC_sh, noobs abbreviate(12)
postclose sheetpost

* -----------------------------------------------------------------------------
* 6. 노트용 TeX 표
* -----------------------------------------------------------------------------
tempname fh
* (1) 대분류
gsort -shA ksco1
quietly count if topA == topB & topB == topC
local k1_same = r(N)
local k1_n = _N
file open `fh' using "`out'/34_ksco1.tex", write replace
file write `fh' "% 04_17_analysis_kor_share_top30.do가 생성. 직접 고치지 말 것." _n
forvalues i = 1/`=_N' {
    fmt shA[`i'] %5.2f
    local a "`r(s)'"
    fmt shB[`i'] %5.2f
    local b "`r(s)'"
    fmt shC[`i'] %5.2f
    local c "`r(s)'"
    fmt topA_sh[`i'] %5.1f
    local d "`r(s)'"
    texesc `"`=topA[`i']'"'
    file write `fh' `"`i' & `=ksco1[`i']' `=ksco1_title[`i']' & `a' & `b' (`=r_B[`i']') & `c' (`=r_C[`i']') & `r(s)' (`d') \\"' _n
}
file close `fh'

* (2) 소분류 A·B·C 상위 10
use `k3x', clear
forvalues i = 1/10 {
    foreach m in A B C {
        quietly levelsof ksco3 if r_`m' == `i', local(k) clean
        quietly summarize sh`m' if r_`m' == `i'
        local mv = r(mean)
        fmt `mv' %5.2f
        local v "`r(s)'"
        quietly levelsof ksco3_title if r_`m' == `i', local(t) clean
        texesc `"`t'"'
        local c`m' `"`k' `r(s)' & `v'"'
    }
    local row`i' `"`i' & `cA' & `cB' & `cC' \\"'
}
file open `fh' using "`out'/34_top10_ksco3.tex", write replace
file write `fh' "% 04_17_analysis_kor_share_top30.do가 생성. 직접 고치지 말 것." _n
forvalues i = 1/10 {
    file write `fh' `"`row`i''"' _n
}
file close `fh'

* (3) 시트 요약
use `sheets', clear
file open `fh' using "`out'/34_sheets.tex", write replace
file write `fh' "% 04_17_analysis_kor_share_top30.do가 생성. 직접 고치지 말 것." _n
forvalues i = 1/`=_N' {
    texesc `"`=sheet[`i']'"'
    local s `"`r(s)'"'
    fmt sum_top[`i'] %5.1f
    local a "`r(s)'"
    fmt sum_bot[`i'] %6.2f
    local b "`r(s)'"
    file write `fh' `"\texttt{`s'} & `=level[`i']' & `=ind[`i']' & `=nall[`i']' & `=n[`i']' & `a' & `b' \\"' _n
}
file close `fh'
list, noobs clean

* (4) 읽을 때 주의할 수치
file open `fh' using "`out'/34_notes.tex", write replace
file write `fh' "% 04_17_analysis_kor_share_top30.do가 생성. 직접 고치지 말 것." _n
fmt `soc_min' %7.5f
file write `fh' "SOC 지표 A 최솟값(\%) / 그 값을 가진 SOC 수 & `r(s)' / `soc_nmin' \\" _n
fmt `soc_bmin' %7.5f
file write `fh' "SOC 지표 B 최솟값(\%) / 그 값을 가진 SOC 수 & `r(s)' / `soc_nbmin' \\" _n
file write `fh' "세분류 지표 A 상위 `ntop' 중 기여 1위 SOC 몫이 50\% 이상인 수 & `k4_top50' \\" _n
file write `fh' "세분류 지표 A 하위 `ntop' 중 기여 1위 SOC 몫이 100\%(SOC 하나)인 수 & `k4_bot100' \\" _n
file write `fh' "세분류 전체 중 기여 1위 SOC 몫이 100\%인 수 & `k4_all100' / `k4_n' \\" _n
file write `fh' "소분류 중 한 달만 공개된 수 & `k3_1m' \\" _n
file write `fh' "소분류 하위 `ntop' 중 한 달만 공개된 수(A / B / C) & `k3_bot1m_A' / `k3_bot1m_B' / `k3_bot1m_C' \\" _n
file write `fh' "소분류 상위 `ntop' 겹침(A와 B / A와 C) & `k3_ovAB' / `k3_ovAC' \\" _n
file write `fh' "대분류 중 A·B·C 기여 1위 중분류가 모두 같은 수 & `k1_same' / `k1_n' \\" _n
file close `fh'
display "soc min A `soc_min' n=`soc_nmin' | k4 top50 `k4_top50' bot100 `k4_bot100' all100 `k4_all100'/`k4_n' | k3 1m `k3_1m' bot1m `k3_bot1m_A' `k3_bot1m_B' `k3_bot1m_C' | ov `k3_ovAB' `k3_ovAC' | k1 same `k1_same'"
