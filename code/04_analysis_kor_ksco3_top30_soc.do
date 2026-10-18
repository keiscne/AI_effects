* =============================================================================
* 04_analysis_kor_ksco3_top30_soc.do
* 한국 KSCO 8차 소분류 상위 30개와 그 소분류에 연계된 모든 SOC(기여분)
*   (1) 업무용 대화량 상위 30, (2) 대화량 × 절감 시간 상위 30   (paper 26)
*
* 입력:
*   $proc/merged/kor_ai_usage_ksco3.dta              소분류 C(월평균 대화 수, K = 3), S(월평균 절감 시간), 명칭
*                                                     (03_merge_kor_ksco3_ai_usage.do, paper 25)
*   $proc/merged/kor_soc6_conv_ai_indicators.dta     월 × soc6 conv_k3, saved_hr_k3(SOC 단계 곱), time_saved_min
*                                                     (03_merge_kor_conv_ai_ksco8.do)
*   $proc/exposure/bls_soc_crosswalk/soc2018_ksco8_crosswalk.dta   soc2018 → ksco8, w_alloc
*   $proc/exposure/bls_soc_crosswalk/soc2018_titles.dta            SOC 2018 명칭(BLS)
* 출력: $results/table/
*   26_kor_ksco3_top30_conv_soc.xlsx    시트 ksco(상위 30 소분류), soc(소분류 × 연계 SOC)
*   26_kor_ksco3_top30_saved_soc.xlsx   시트 ksco, soc
*   26_ksco3_top30_conv.tex, 26_ksco3_top30_saved.tex, 26_summary.tex   (paper 26 표)
*
* 계산(03_merge_kor_conv_ai_ksco8.do, 03_merge_kor_ksco3_ai_usage.do와 같은 규칙):
*   w3(s, K)     = Σ_{k∈K} w_alloc(s, k)       SOC s의 대화 중 소분류 K로 가는 몫
*   c(s, K, t)   = conv_k3(s, t) × w3(s, K)     s가 K에 주는 대화 수(공개 SOC만)
*   v(s, K, t)   = saved_hr_k3(s, t) × w3(s, K) s가 K에 주는 절감 시간(절감 시간 있는 SOC만)
*   월평균: 소분류 값과 같게 K에 값이 있는 달 수로 나눈다 → Σ_s 기여 = 소분류 C, S (assert).
*   SOC 자체의 월 대화 수(soc_conv_k3)는 그 SOC가 공개된 달의 평균.
* 소분류에 연계된 SOC: 연계표에서 그 소분류의 세분류 하나 이상과 이어진 SOC 전부.
*   한국 대화량이 공개되지 않은 SOC는 기여가 빈칸(soc_pub = 0).
* 매칭 키: soc6 = soc2018(str7), ksco3 = substr(ksco8, 1, 3)(str3).
* 주의: 소분류 대화량은 연계표 배분 가정(paper 21)에 따른 값이다. AEI 직업은 대화 과업의 직업이다.
* =============================================================================

version 17
clear all
set more off

if `"$root"'    == "" global root    "d:/research/AI_effects"
if `"$proc"'    == "" global proc    "$root/data/proc"
if `"$results"' == "" global results "$root/results"

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

* -----------------------------------------------------------------------------
* 1. 연계표: soc6 × ksco3 몫
* -----------------------------------------------------------------------------
use "$proc/exposure/bls_soc_crosswalk/soc2018_ksco8_crosswalk.dta", clear
keep soc2018 ksco8 ksco8_title w_alloc
rename soc2018 soc6
generate str3 ksco3 = substr(ksco8, 1, 3)
sort soc6 ksco3 ksco8
generate str244 k8 = ksco8 + " " + ksco8_title
by soc6 ksco3: generate str244 ksco8_list = k8 if _n == 1
by soc6 ksco3: replace ksco8_list = ksco8_list[_n-1] + "; " + k8 if _n > 1
by soc6 ksco3: replace ksco8_list = ksco8_list[_N]
collapse (sum) w3 = w_alloc (count) n_ksco8_link = w_alloc, by(soc6 ksco3 ksco8_list)
isid soc6 ksco3
bysort soc6: egen double chk = total(w3)
assert abs(chk - 1) < 1e-9                               // SOC마다 w_alloc 합 1
drop chk
tempfile cw3
save `cw3'

* -----------------------------------------------------------------------------
* 2. 월 × soc6 × ksco3 기여
* -----------------------------------------------------------------------------
use "$proc/merged/kor_soc6_conv_ai_indicators.dta", clear
keep if conv_pub
drop if strpos(soc6, "X")                               // 45-XXXX: 연계표에 없어 KSCO로 가지 않음
keep month soc6 conv_k3 saved_hr_k3 time_saved_min
tempfile socm
save `socm'

* SOC 자체 월평균(공개된 달)
collapse (mean) soc_conv_k3 = conv_k3 soc_saved_hr = saved_hr_k3 (first) soc_time_saved_min = time_saved_min ///
    (count) soc_n_months = conv_k3, by(soc6)
tempfile socavg
save `socavg'

use `socm', clear
joinby soc6 using `cw3'
generate double c = conv_k3 * w3
generate double v = saved_hr_k3 * w3
* 소분류 월 합계와 값이 있는 달 수
preserve
collapse (sum) kc = c kv = v (count) nc = c nv = v, by(month ksco3)
replace kv = . if nv == 0
generate byte has_c = 1
generate byte has_v = !missing(kv)
collapse (sum) n_c = has_c n_v = has_v (sum) kc kv, by(ksco3)
tempfile kn
save `kn'
restore
collapse (sum) c v (count) nv = v, by(soc6 ksco3)
replace v = . if nv == 0
drop nv
merge m:1 ksco3 using `kn', keepusing(n_c n_v) assert(match) nogenerate
replace c = c / n_c
replace v = v / n_v
drop n_c n_v
rename (c v) (contrib_conv contrib_saved)
tempfile contrib
save `contrib'

* 소분류 값 확인: 기여 합 = kor_ai_usage_ksco3의 C, S
collapse (sum) sc = contrib_conv sv = contrib_saved (count) nsv = contrib_saved, by(ksco3)
replace sv = . if nsv == 0
merge 1:1 ksco3 using "$proc/merged/kor_ai_usage_ksco3.dta", keepusing(ksco3_title C S)
tabulate _merge
assert _merge != 1                                      // 기여가 있는 소분류는 모두 활용도 파일에 있음(군인 제외)
assert missing(C) if _merge == 2
keep if _merge == 3
assert reldif(sc, C) < 1e-9
assert reldif(sv, S) < 1e-9 | (missing(sv) & missing(S))
drop _merge sc sv nsv

* -----------------------------------------------------------------------------
* 3. 소분류 순위표
* -----------------------------------------------------------------------------
quietly summarize C
generate double C_share = 100 * C / r(sum)
quietly summarize S
generate double S_share = 100 * S / r(sum)
tempfile ksco
save `ksco'
quietly count
local n_ksco = r(N)
quietly summarize C
local C_tot = r(sum)
quietly summarize S
local S_tot = r(sum)

* 연계 SOC 전부(연계표 기준)와 기여
use `cw3', clear
merge m:1 ksco3 using `ksco', keep(match) nogenerate     // 대화량 있는 소분류만
merge 1:1 soc6 ksco3 using `contrib', keep(master match)
assert _merge != 2
generate byte soc_pub = _merge == 3
drop _merge
merge m:1 soc6 using `socavg', keep(master match) nogenerate
merge m:1 soc6 using "$proc/exposure/bls_soc_crosswalk/soc2018_titles.dta", keep(master match)
assert _merge == 3
drop _merge
assert soc_pub == !missing(soc_conv_k3)
generate double contrib_conv_share  = 100 * contrib_conv / C
generate double contrib_saved_share = 100 * contrib_saved / S
bysort ksco3: generate int n_soc_link = _N
bysort ksco3: egen int n_soc_pub = total(soc_pub)
tempfile pairs
save `pairs'

* -----------------------------------------------------------------------------
* 4. 출력: (1) 대화량, (2) 대화량 × 절감 시간
* -----------------------------------------------------------------------------
foreach m in conv saved {
    if "`m'" == "conv" {
        local key C
        local ckey contrib_conv
    }
    else {
        local key S
        local ckey contrib_saved
    }
    use `pairs', clear
    keep if !missing(`key')
    * 소분류 순위
    preserve
    keep ksco3 `key'
    duplicates drop
    gsort -`key' ksco3
    generate int ksco_rank = _n
    keep ksco3 ksco_rank
    tempfile rk
    save `rk'
    restore
    merge m:1 ksco3 using `rk', nogenerate
    keep if ksco_rank <= 30
    gsort ksco_rank -`ckey' -contrib_conv soc6
    by ksco_rank: generate int soc_rank_in_ksco = _n if !missing(`ckey')
    * 소분류 1위 SOC
    by ksco_rank: generate str244 top_soc = soc6 + " " + soc6_title if _n == 1
    by ksco_rank: generate double top_soc_share = cond("`m'" == "conv", contrib_conv_share, contrib_saved_share) if _n == 1
    by ksco_rank: replace top_soc = top_soc[1]
    by ksco_rank: replace top_soc_share = top_soc_share[1]
    by ksco_rank: egen int n_soc_val = count(`ckey')

    label variable ksco_rank           "소분류 순위"
    label variable ksco3               "KSCO 8차 소분류"
    label variable ksco3_title         "소분류 명칭"
    label variable C                   "소분류 월평균 업무용 대화 수(K = 3)"
    label variable C_share             "소분류 대화량 비중(%)"
    label variable S                   "소분류 월평균 절감 시간(시간, K = 3)"
    label variable S_share             "소분류 절감 시간 비중(%)"
    label variable n_soc_link          "연계 SOC 수(연계표)"
    label variable n_soc_pub           "그중 한국 대화량 공개 SOC 수"
    label variable n_soc_val           "그중 기여 값이 있는 SOC 수"
    label variable top_soc             "기여 1위 SOC"
    label variable top_soc_share       "기여 1위 SOC 비중(%)"
    label variable soc_rank_in_ksco    "소분류 안 SOC 순위"
    label variable soc6                "SOC 2018 6자리"
    label variable soc6_title          "SOC 직업(BLS)"
    label variable ksco8_list          "이 소분류에서 연결된 세분류"
    label variable n_ksco8_link        "연결된 세분류 수"
    label variable w3                  "SOC 대화 중 이 소분류로 가는 몫(w_alloc 합)"
    label variable soc_pub             "1 = 한국 대화량 공개 SOC"
    label variable soc_n_months        "SOC 공개 달 수"
    label variable soc_conv_k3         "SOC 월평균 업무용 대화 수(전체, K = 3)"
    label variable soc_time_saved_min  "SOC 대화당 절감 시간(분, GLOBAL)"
    label variable soc_saved_hr        "SOC 월평균 절감 시간(전체, 시간)"
    label variable contrib_conv        "이 소분류로 온 대화 수(월평균)"
    label variable contrib_conv_share  "소분류 대화량 중 비중(%)"
    label variable contrib_saved       "이 소분류로 온 절감 시간(시간, 월평균)"
    label variable contrib_saved_share "소분류 절감 시간 중 비중(%)"

    if "`m'" == "conv" {
        local kv  ksco_rank ksco3 ksco3_title C C_share S n_soc_link n_soc_pub top_soc top_soc_share
        local sv  soc_rank_in_ksco soc6 soc6_title ksco8_list w3 soc_pub soc_n_months soc_conv_k3 ///
                  contrib_conv contrib_conv_share soc_time_saved_min contrib_saved
    }
    else {
        local kv  ksco_rank ksco3 ksco3_title S S_share C n_soc_link n_soc_pub n_soc_val top_soc top_soc_share
        local sv  soc_rank_in_ksco soc6 soc6_title ksco8_list w3 soc_pub soc_n_months soc_time_saved_min ///
                  soc_saved_hr contrib_saved contrib_saved_share soc_conv_k3 contrib_conv
    }
    keep `kv' `sv'
    order `kv' `sv'
    count
    local f "`out'/26_kor_ksco3_top30_`m'_soc.xlsx"
    export excel using "`f'", sheet("soc") firstrow(varlabels) replace

    * 소분류 시트와 TeX 표
    bysort ksco_rank: keep if _n == 1
    keep `kv'
    export excel using "`f'", sheet("ksco") firstrow(varlabels) sheetreplace
    list ksco_rank ksco3 `key' n_soc_link n_soc_pub top_soc_share, noobs abbreviate(14)

    quietly summarize `key'
    local top30_`m' = 100 * r(sum) / cond("`m'" == "conv", `C_tot', `S_tot')
    quietly count if top_soc_share >= 50
    local dom_`m' = r(N)
    quietly summarize n_soc_pub
    local npub_`m' = r(mean)

    tempname fh
    file open `fh' using "`out'/26_ksco3_top30_`m'.tex", write replace
    file write `fh' "% 04_analysis_kor_ksco3_top30_soc.do가 생성. 직접 고치지 말 것." _n
    forvalues i = 1/30 {
        if "`m'" == "conv" {
            fmt C[`i']/10000 %7.0fc
            local a "`r(s)'"
            fmt C_share[`i'] %5.2f
            local b "`r(s)'"
        }
        else {
            fmt S[`i']/10000 %7.0fc
            local a "`r(s)'"
            fmt S_share[`i'] %5.2f
            local b "`r(s)'"
        }
        fmt top_soc_share[`i'] %5.1f
        local d "`r(s)'"
        texesc `"`=ksco3_title[`i']'"'
        local kt `"`r(s)'"'
        texesc `"`=top_soc[`i']'"'
        local ts `"`r(s)'"'
        file write `fh' `"`=ksco_rank[`i']' & `=ksco3[`i']' `kt' & `a' & `b' & `=n_soc_pub[`i']'/`=n_soc_link[`i']' & `ts' & `d' \\"' _n
    }
    file close `fh'
}

* 요약표
tempname fh
file open `fh' using "`out'/26_summary.tex", write replace
file write `fh' "% 04_analysis_kor_ksco3_top30_soc.do가 생성. 직접 고치지 말 것." _n
fmt `C_tot'/10000 %9.0fc
local a "`r(s)'"
fmt `S_tot'/10000 %9.0fc
local b "`r(s)'"
file write `fh' "값이 있는 소분류 수 & `n_ksco' & `n_ksco' \\" _n
file write `fh' "소분류 합계(만 건, 만 시간) & `a' & `b' \\" _n
fmt `top30_conv' %5.1f
local a "`r(s)'"
fmt `top30_saved' %5.1f
local b "`r(s)'"
file write `fh' "상위 30개 비중(\%) & `a' & `b' \\" _n
fmt `npub_conv' %4.1f
local a "`r(s)'"
fmt `npub_saved' %4.1f
local b "`r(s)'"
file write `fh' "상위 30개 평균 기여 SOC 수 & `a' & `b' \\" _n
file write `fh' "1위 SOC 기여 50\% 이상인 소분류 수 & `dom_conv' & `dom_saved' \\" _n
file close `fh'
display "n_ksco=`n_ksco' top30 conv=`top30_conv' saved=`top30_saved' dom=`dom_conv'/`dom_saved'"
