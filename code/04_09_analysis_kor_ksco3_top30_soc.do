* =============================================================================
* 04_09_analysis_kor_ksco3_top30_soc.do
* 한국 KSCO 8차 소분류 상위 30개와 그 소분류에 연계된 모든 SOC(기여분)
*   (1) 지표 A(업무용 대화 점유율) 상위 30, (2) 지표 B(절감 시간 점유율) 상위 30   (paper 26)
*
* 2026-10-24 재설계: 대화 건수(K = 3) 대신 지표 A·B(점유율, %)와 SOC 업무용 대화 비중을 쓴다.
*
* 입력:
*   $proc/merged/kor_ai_usage_ksco3.dta              소분류 shA, shB(%), 월별 정규화 분모 tot_sw04·05, tot_sv04·05, 명칭
*                                                     (03_05_merge_kor_ksco3_ai_usage.do)
*   $proc/merged/kor_soc6_conv_ai_indicators.dta     월 × soc6 share_work, saved_w(SOC 단계 곱), time_saved_min
*                                                     (03_03_merge_kor_conv_ai_ksco8.do)
*   $proc/exposure/bls_soc_crosswalk/soc2018_ksco8_crosswalk.dta   soc2018 → ksco8, w_alloc
*   $proc/exposure/bls_soc_crosswalk/soc2018_titles.dta            SOC 2018 명칭(BLS)
* 출력: $results/table/
*   26_kor_ksco3_top30_conv_soc.xlsx    시트 ksco(상위 30 소분류), soc(소분류 × 연계 SOC)
*   26_kor_ksco3_top30_saved_soc.xlsx   시트 ksco, soc
*   26_ksco3_top30_conv.tex, 26_ksco3_top30_saved.tex, 26_summary.tex   (paper 26 표)
*
* 계산(03_03_merge_kor_conv_ai_ksco8.do, 03_05_merge_kor_ksco3_ai_usage.do와 같은 규칙):
*   w3(s, K)     = Σ_{k∈K} w_alloc(s, k)       SOC s의 대화 중 소분류 K로 가는 몫
*   c(s, K)      = 100 × ½ Σ_t share_work(s, t) × w3(s, K) / tot_sw_t   s가 K의 지표 A에 주는 몫(%p, 공개 SOC만)
*   v(s, K)      = 100 × ½ Σ_t saved_w(s, t) × w3(s, K) / tot_sv_t      s가 K의 지표 B에 주는 몫(%p)
*   tot_*_t는 03_05에서 쓴 월 t 표본 합계(정규화 분모) → Σ_s 기여 = 소분류 shA, shB (assert).
*   SOC 자체의 업무용 대화 비중(soc_sw, %)은 두 달 단순평균(미공개 달은 0).
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
keep month soc6 share_work saved_w time_saved_min
tempfile socm
save `socm'

* SOC 자체 두 달 단순평균(미공개 달은 0)
generate double sw_pct = 100 * share_work
collapse (sum) soc_sw = sw_pct soc_sv = saved_w (first) soc_time_saved_min = time_saved_min ///
    (count) soc_n_months = sw_pct, by(soc6)
replace soc_sw = soc_sw / 2
replace soc_sv = soc_sv / 2
tempfile socavg
save `socavg'

* 월별 정규화 분모(03_05와 같은 값)
use tot_sw04 tot_sw05 tot_sv04 tot_sv05 in 1 using "$proc/merged/kor_ai_usage_ksco3.dta", clear
foreach v in sw04 sw05 sv04 sv05 {
    local T_`v' = tot_`v'[1]
}
use `socm', clear
joinby soc6 using `cw3'
generate double c = 100 * share_work * w3 / cond(month == "2026-04", `T_sw04', `T_sw05') / 2
generate double v = 100 * saved_w * w3 / cond(month == "2026-04", `T_sv04', `T_sv05') / 2
collapse (sum) c v (count) nv = v, by(soc6 ksco3)
replace v = . if nv == 0
drop nv
rename (c v) (contrib_conv contrib_saved)
tempfile contrib
save `contrib'

* 소분류 값 확인: 기여 합 = kor_ai_usage_ksco3의 shA, shB
collapse (sum) sc = contrib_conv sv = contrib_saved (count) nsv = contrib_saved, by(ksco3)
replace sv = . if nsv == 0
merge 1:1 ksco3 using "$proc/merged/kor_ai_usage_ksco3.dta", keepusing(ksco3_title shA shB)
rename (shA shB) (C S)
tabulate _merge
assert _merge != 1                                      // 기여가 있는 소분류는 모두 지표 파일에 있음(군인 제외)
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
assert soc_pub == !missing(soc_sw)
generate double contrib_conv_share  = 100 * contrib_conv / C
generate double contrib_saved_share = 100 * contrib_saved / S
bysort ksco3: generate int n_soc_link = _N
bysort ksco3: egen int n_soc_pub = total(soc_pub)
tempfile pairs
save `pairs'

* -----------------------------------------------------------------------------
* 4. 출력: (1) 지표 A, (2) 지표 B
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
    label variable C                   "지표 A: 대화 점유율(%)"
    label variable C_share             "지표 A: 대화 점유율(%, 같은 값)"
    label variable S                   "지표 B: 절감 시간 점유율(%)"
    label variable S_share             "지표 B: 절감 시간 점유율(%, 같은 값)"
    label variable n_soc_link          "연계 SOC 수(연계표)"
    label variable n_soc_pub           "그중 한국 대화 비중 공개 SOC 수"
    label variable n_soc_val           "그중 기여 값이 있는 SOC 수"
    label variable top_soc             "기여 1위 SOC"
    label variable top_soc_share       "기여 1위 SOC 비중(%)"
    label variable soc_rank_in_ksco    "소분류 안 SOC 순위"
    label variable soc6                "SOC 2018 6자리"
    label variable soc6_title          "SOC 직업(BLS)"
    label variable ksco8_list          "이 소분류에서 연결된 세분류"
    label variable n_ksco8_link        "연결된 세분류 수"
    label variable w3                  "SOC 대화 중 이 소분류로 가는 몫(w_alloc 합)"
    label variable soc_pub             "1 = 한국 대화 비중 공개 SOC"
    label variable soc_n_months        "SOC 공개 달 수"
    label variable soc_sw              "SOC 업무용 대화 비중(%, 한국 전체 중, 두 달 단순평균)"
    label variable soc_time_saved_min  "SOC 대화당 절감 시간(분, GLOBAL)"
    label variable soc_sv              "SOC 비중 × 대화당 절감 시간(분)"
    label variable contrib_conv        "이 SOC가 소분류 지표 A에 준 몫(%p)"
    label variable contrib_conv_share  "소분류 지표 A 중 비중(%)"
    label variable contrib_saved       "이 SOC가 소분류 지표 B에 준 몫(%p)"
    label variable contrib_saved_share "소분류 지표 B 중 비중(%)"

    if "`m'" == "conv" {
        local kv  ksco_rank ksco3 ksco3_title C C_share S n_soc_link n_soc_pub top_soc top_soc_share
        local sv  soc_rank_in_ksco soc6 soc6_title ksco8_list w3 soc_pub soc_n_months soc_sw ///
                  contrib_conv contrib_conv_share soc_time_saved_min contrib_saved
    }
    else {
        local kv  ksco_rank ksco3 ksco3_title S S_share C n_soc_link n_soc_pub n_soc_val top_soc top_soc_share
        local sv  soc_rank_in_ksco soc6 soc6_title ksco8_list w3 soc_pub soc_n_months soc_time_saved_min ///
                  soc_sv contrib_saved contrib_saved_share soc_sw contrib_conv
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
    file write `fh' "% 04_09_analysis_kor_ksco3_top30_soc.do가 생성. 직접 고치지 말 것." _n
    forvalues i = 1/30 {
        * 열 a = 기준 지표 점유율, b = 다른 지표 점유율
        if "`m'" == "conv" {
            fmt C[`i'] %5.2f
            local a "`r(s)'"
            fmt S[`i'] %5.2f
            local b "`r(s)'"
        }
        else {
            fmt S[`i'] %5.2f
            local a "`r(s)'"
            fmt C[`i'] %5.2f
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
file write `fh' "% 04_09_analysis_kor_ksco3_top30_soc.do가 생성. 직접 고치지 말 것." _n
file write `fh' "값이 있는 소분류 수 & `n_ksco' & `n_ksco' \\" _n
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
