* =============================================================================
* 03_merge_kor_conv_ai_ksco8.do
* 한국 직업별 업무용 AI 대화량 + SOC 2018 AI 지표 결합 → SOC 2018–KSCO 8차 연계표로 KSCO 8차(KECO 2025) 변환
* (paper 23: results/paper/23_한국대화량_AI지표_KSCO결합.tex)
*
* 입력:
*   $proc/macro/scaling/sensortower_state_of_ai_2026/sensortower_aei_kor_soc6_conversations.dta
*       월 × soc6(2026-04 337행, 2026-05 365행). 03_merge_sensortower_aei_kor_soc_conversations.do 출력.
*       2026-04의 "45-XXXX"는 농림어업 세부 직업 미공개 몫(자리표시 행)이다.
*   $proc/merged/soc6_ai_indicators.dta    soc6 808개. 03_merge_soc6_ai_indicators.do 출력.
*   $proc/exposure/bls_soc_crosswalk/soc2018_ksco8_crosswalk.dta   01_import_soc2018_ksco8_crosswalk.do 출력.
*   $raw/exposure/bls_soc_crosswalk/isco08_ksco08/한국표준직업분류(KSCO 8차)-국제표준직업분류(ISCO-08) 연계표_20260127034430.xlsx
*       시트 "3-1. (연계표) KSCO(8차)-ISCO(08)"의 E·F열 = KSCO 소분류 코드·명칭(167개, 군인 4개 포함). (3)의 명칭에만 쓴다.
* 출력: $proc/merged/
*   (1) kor_soc6_conv_ai_indicators.{csv,dta}   월 × soc6. AI 지표 808개 직업 × 2개월 + 45-XXXX 1행 = 1,617행.
*       대화량이 공개되지 않은 직업은 대화량 변수가 결측(0이 아님), conv_pub = 0.
*   (2) kor_ksco8_conv_ai_indicators.{csv,dta}  월 × ksco8. 연계표의 KSCO 494개 × 2개월 = 988행.
*   (3) kor_ksco3_conv_ai_indicators.{csv,dta}  월 × ksco3(KSCO 8차 소분류). 167개 × 2개월 = 334행.
*       지역별고용조사(KSCO 8차 소분류) 결합용. 연계표는 세분류 판을 그대로 쓰고, SOC 단계에서 다시 계산한다
*       (세분류 결과를 평균하지 않음). 군인 소분류 A01~A09 4개도 남겨 둔다(지역별고용조사에는 없음).
* 변환 규칙(paper 21, 7절):
*   양(pct, share_work, conv_k*)     : KSCO 값 = Σ_s w_alloc(s,k) × 값_s (공개된 SOC만). 연결된 SOC 중 공개된 것이
*                                      하나도 없으면 결측. 일부만 공개되면 공개된 SOC 몫만 더한 값(과소 가능).
*   비율 지표(시간 절감, 노출도 등) : KSCO 값 = Σ_s w_mean(s,k) × 값_s / Σ_s w_mean(s,k), 값이 있는 SOC만.
*                                      cov_* = 값이 있는 SOC의 w_mean 합(0~1, 1이면 연결된 SOC 모두 값 있음).
*   AI 지표는 월과 무관(시간 절감은 2026-04·05 통합값)하므로 두 달에 같은 값이 들어간다.
* 소분류(3) 가중치(작업자 판단, 고용 가중 없음):
*   양      : w_alloc 그대로(세분류 배분을 소분류 안에서 더한 것). 세분류 결과의 합과 정확히 같다.
*   비율 지표: w_mean3(s, K) = Σ_{k∈K} w_mean(s, k) / n_ksco8(K). 소분류 안 세분류를 균등하게 본 것(K 안 합 1).
*             모든 SOC에 값이 있으면 세분류 값의 단순평균과 같고, 값이 빠진 SOC가 있으면 SOC 단계에서
*             다시 나누므로 세분류 평균과 조금 다를 수 있다. 세분류 고용 비중을 구하면 1/n_ksco8을 그것으로 바꾼다.
*   대화 수 × 절감 시간 같은 곱은 이 파일 값끼리 곱하지 말고 SOC 단계(1)에서 곱한 뒤 w_alloc로 더해야 한다(paper 23).
* 매칭 키: (1) month + soc6(str7, SOC 2018).  (2) soc6 = 연계표 soc2018 → ksco8(str4), keco2025(str4).
*          (3) ksco3(str3) = substr(ksco8, 1, 3) = 지역별고용조사 직업 소분류 코드(문자 3자리로 맞춰 결합).
* 주의: 45-XXXX는 연계표에 없어 KSCO로 배분되지 않는다(2026-04 업무용 대화의 share_work 만큼 빠짐).
* =============================================================================

version 17
clear all
set more off

if `"$root"' == "" global root "d:/research/AI_effects"
if `"$raw"'  == "" global raw  "$root/data/raw"
if `"$proc"' == "" global proc "$root/data/proc"

local conv "$proc/macro/scaling/sensortower_state_of_ai_2026/sensortower_aei_kor_soc6_conversations.dta"
local ind  "$proc/merged/soc6_ai_indicators.dta"
local cw   "$proc/exposure/bls_soc_crosswalk/soc2018_ksco8_crosswalk.dta"
local kxls "$raw/exposure/bls_soc_crosswalk/isco08_ksco08/한국표준직업분류(KSCO 8차)-국제표준직업분류(ISCO-08) 연계표_20260127034430.xlsx"
local outd "$proc/merged"

local amt  "pct share_work conv_k1p5 conv_k3 conv_k5 conv_k7 conv_k10"
local rate "time_saved_min time_saved_hr human_only_min human_with_ai_min observed_exposure elo_gpt4_alpha elo_gpt4_beta elo_gpt4_gamma elo_human_alpha elo_human_beta elo_human_gamma lm_aioe"
local kor  "kor_work_messages kor_conv_k1p5 kor_conv_k3 kor_conv_k5 kor_conv_k7 kor_conv_k10"

* (월, SOC, KSCO) 쌍 → KSCO 집계. 입력 변수: w_mean(KSCO 안 합 1), w_alloc(SOC 안 합 1), conv_pub, 양·비율 지표.
*   extra() = collapse에 더 넣을 통계(예: "(max) n18_perk").
capture program drop ksco_agg
program define ksco_agg
    syntax , by(varlist) amt(namelist) rate(namelist) [extra(string)]
    * 양: w_alloc 배분(공개된 SOC만)
    foreach v of local amt {
        generate double a_`v' = w_alloc * `v' if conv_pub
    }
    drop `amt'
    generate byte one_pub = conv_pub
    generate byte one = 1
    generate double wpub = w_mean * conv_pub
    * 비율 지표: w_mean 가중평균(값 있는 SOC만), 덮개(cov) = 값 있는 SOC의 w_mean 합
    foreach v of local rate {
        generate double n_`v' = w_mean * `v' if !missing(`v')
        generate double d_`v' = w_mean if !missing(`v')
    }
    local sumlist ""
    foreach v of local amt {
        local sumlist "`sumlist' `v'=a_`v'"
    }
    foreach v of local rate {
        local sumlist "`sumlist' n_`v' d_`v'"
    }
    collapse (sum) `sumlist' n_soc_conv = one_pub n_soc_link = one conv_cover = wpub `extra', by(`by')
    * 공개된 SOC가 없으면 양은 결측
    foreach v of local amt {
        replace `v' = . if n_soc_conv == 0
    }
    foreach v of local rate {
        generate double `v' = n_`v' / d_`v' if d_`v' > 0
        drop n_`v'
    }
    rename (d_time_saved_min d_observed_exposure d_elo_gpt4_beta d_lm_aioe) (cov_aei cov_obs cov_elo cov_felten)
    drop d_*
end

* -----------------------------------------------------------------------------
* 1. 대화량 + AI 지표 (월 × soc6)
* -----------------------------------------------------------------------------
use "`conv'", clear
isid month soc6
rename soc6_title soc6_title_aei
keep month soc6 soc6_title_aei has00 n_onet detail_missing `amt' `kor'
tempfile cv
save `cv'
* 월별 한국 총량(모든 행에 붙이기 위해)
keep month `kor'
duplicates drop
isid month
tempfile kt
save `kt'
levelsof month, local(months)

* AI 지표 808개 × 월 뼈대
use "`ind'", clear
isid soc6
tempfile id
save `id'
local first = 1
foreach m of local months {
    use `id', clear
    generate str7 month = "`m'"
    if !`first' append using `sk'
    tempfile sk
    save `sk'
    local first = 0
}
use `sk', clear
merge 1:1 month soc6 using `cv', keepusing(soc6_title_aei has00 n_onet detail_missing `amt')
* _merge == 2: 대화량에만 있는 행 → 45-XXXX(자리표시)뿐이어야 함
tabulate month _merge
assert soc6 == "45-XXXX" if _merge == 2
generate byte conv_pub = _merge != 1
drop _merge
replace soc6_title = soc6_title_aei if missing(soc6_title)
merge m:1 month using `kt', nogenerate assert(match)
generate byte in_ind = !missing(n_sources)
replace soc_major = substr(soc6, 1, 2) if missing(soc_major)
* 대화량 합계 확인: 월별 share_work 합 = 1
bysort month: egen double chk = total(share_work)
assert abs(chk - 1) < 1e-6
drop chk

label variable month          "월(YYYY-MM)"
label variable soc6_title_aei "AEI 직업 명칭(.00 코드 우선; soc6_title과 다를 수 있음)"
label variable conv_pub       "1 = 이 달 한국 대화량 공개(대화량 변수 있음), 0 = 미공개(결측, 0 아님)"
label variable in_ind         "1 = soc6_ai_indicators에 있음(45-XXXX만 0)"
order month soc6 soc6_title soc6_title_aei soc_major conv_pub in_ind `amt' n_onet has00 detail_missing
sort month soc6
compress
save "`outd'/kor_soc6_conv_ai_indicators.dta", replace
export delimited using "`outd'/kor_soc6_conv_ai_indicators.csv", replace
tabulate month conv_pub

* -----------------------------------------------------------------------------
* 2. 연계표 결합 → 월 × ksco8
* -----------------------------------------------------------------------------
use "`cw'", clear
keep soc2018 ksco8 ksco8_title keco2025 keco2025_title w_mean w_alloc n18_perk
rename soc2018 soc6
tempfile cwk
save `cwk'

use "`outd'/kor_soc6_conv_ai_indicators.dta", clear
drop if soc6 == "45-XXXX"                    // 연계표 없음(자리표시)
* 연계표에 없는 soc6가 없어야 함(AI 지표 808개는 모두 SOC 2018 세부 직업)
joinby soc6 using `cwk', unmatched(both) _merge(_mcw)
tabulate _mcw
assert _mcw == 3 | _mcw == 2
* _mcw == 2: 연계표에는 있으나 AI 지표 808개에 없는 SOC(값 없음). KSCO 쪽 가중치 분모에는 포함되도록 남긴다.
levelsof month if _mcw == 3, local(months)
preserve
keep if _mcw == 2
drop month
tempfile nomatch
save `nomatch'
restore
drop if _mcw == 2
local j = 0
foreach m of local months {
    local ++j
    preserve
    use `nomatch', clear
    generate str7 month = "`m'"
    replace conv_pub = 0
    tempfile nm`j'
    save `nm`j''
    restore
    append using `nm`j''
}
drop _mcw
isid month soc6 ksco8
* (월, SOC, 세분류) 쌍: 3절(소분류)에서 다시 씀
tempfile pairs
save `pairs'

ksco_agg, by(month ksco8 ksco8_title keco2025 keco2025_title) amt(`amt') rate(`rate') extra("(max) n18_perk")
assert n_soc_link == n18_perk
drop n18_perk
merge m:1 month using `kt', nogenerate assert(match)

* 확인: 월별 KSCO 대화량 합 = SOC 대화량 합 - 45-XXXX
preserve
use "`outd'/kor_soc6_conv_ai_indicators.dta", clear
keep if conv_pub & soc6 != "45-XXXX"
collapse (sum) s_conv = conv_k3 s_share = share_work, by(month)
tempfile sc
save `sc'
restore
preserve
collapse (sum) k_conv = conv_k3 k_share = share_work, by(month)
merge 1:1 month using `sc', nogenerate assert(match)
list, noobs clean
assert abs(k_conv - s_conv) < 1 & abs(k_share - s_share) < 1e-9
restore

label variable month       "월(YYYY-MM)"
label variable ksco8       "KSCO 8차 세분류(4자리)"
label variable ksco8_title "KSCO 8차 명칭"
label variable keco2025    "KECO 2025 세분류(KSCO와 1:1)"
label variable keco2025_title "KECO 2025 명칭"
label variable pct         "AEI 한국 대화 비중(%, 모든 use case; w_alloc 배분, 공개 SOC만)"
label variable share_work  "한국 업무용 대화 비중(w_alloc 배분, 공개 SOC만)"
foreach k in 1p5 3 5 7 10 {
    label variable conv_k`k' "월간 업무용 대화 수(대화당 메시지 `=subinstr("`k'", "p", ".", 1)'개; w_alloc 배분)"
}
label variable n_soc_link  "연계표상 연결된 SOC 2018 수"
label variable n_soc_conv  "그중 이 달 대화량이 공개된 SOC 수(0이면 대화량 결측)"
label variable conv_cover  "대화량 공개 SOC의 w_mean 합(0~1)"
label variable cov_aei     "시간 절감 값이 있는 SOC의 w_mean 합(0~1)"
label variable cov_obs     "observed exposure 값이 있는 SOC의 w_mean 합(0~1)"
label variable cov_elo     "Eloundou 값이 있는 SOC의 w_mean 합(0~1)"
label variable cov_felten  "Felten AIOE 값이 있는 SOC의 w_mean 합(0~1)"
label variable time_saved_min    "AEI 시간 절감(분; w_mean 가중평균, 전 세계 값)"
label variable time_saved_hr     "AEI 시간 절감(시간; w_mean 가중평균)"
label variable human_only_min    "AEI AI 없이 걸리는 시간(분; w_mean 가중평균)"
label variable human_with_ai_min "AEI AI와 함께 걸리는 시간(분; w_mean 가중평균)"
label variable observed_exposure "Observed exposure(w_mean 가중평균)"
label variable lm_aioe           "Felten 언어모델 AIOE(w_mean 가중평균)"
foreach e in gpt4 human {
    foreach g in alpha beta gamma {
        label variable elo_`e'_`g' "Eloundou `e' `g'(w_mean 가중평균)"
    }
}
order month ksco8 ksco8_title keco2025 keco2025_title n_soc_link n_soc_conv conv_cover `amt' ///
    `rate' cov_aei cov_obs cov_elo cov_felten
sort month ksco8
compress
isid month ksco8
save "`outd'/kor_ksco8_conv_ai_indicators.dta", replace
export delimited using "`outd'/kor_ksco8_conv_ai_indicators.csv", replace
tabulate month
summarize conv_k3 time_saved_min observed_exposure if month == "2026-05"
* 3절에서 같은 변수 설명을 쓰기 위해 보관
foreach v of varlist conv_cover `amt' `rate' cov_* {
    local lab_`v' : variable label `v'
}
* 세분류별 대화량 공개 여부(소분류 안 결측 세분류 수 확인용)
generate str3 ksco3 = substr(ksco8, 1, 3)
generate byte k8_conv = n_soc_conv > 0
collapse (sum) n_ksco8_conv = k8_conv, by(month ksco3)
tempfile k8c
save `k8c'

* -----------------------------------------------------------------------------
* 3. 월 × ksco3(KSCO 8차 소분류) — 지역별고용조사 결합용
* -----------------------------------------------------------------------------
* 소분류 명칭(통계청 KSCO–ISCO 연계표 시트 3-1의 E·F열; 소분류 첫 행에만 적혀 있음)
import excel using "`kxls'", sheet("3-1. (연계표) KSCO(8차)-ISCO(08)") clear allstring
keep E F
rename (E F) (ksco3 ksco3_title)
replace ksco3 = strtrim(ksco3)
replace ksco3_title = strtrim(ksco3_title)
keep if regexm(ksco3, "^[0-9A][0-9][0-9]$")
duplicates drop
isid ksco3
count
assert r(N) == 167
tempfile k3t
save `k3t'

* 소분류당 세분류 수(연계표 기준)
use `cwk', clear
keep ksco8
duplicates drop
generate str3 ksco3 = substr(ksco8, 1, 3)
bysort ksco3: generate n_ksco8 = _N
keep ksco3 n_ksco8
duplicates drop
tempfile nk
save `nk'

use `pairs', clear
generate str3 ksco3 = substr(ksco8, 1, 3)
merge m:1 ksco3 using `nk', nogenerate assert(match)
generate double w_mean3 = w_mean / n_ksco8
bysort month ksco3: egen double chk = total(w_mean3)
assert abs(chk - 1) < 1e-9
drop chk
* (월, SOC, 소분류)로 접기: 같은 SOC가 한 소분류의 세분류 여러 개에 이어지면 가중치를 더함(SOC 값은 같음)
collapse (sum) w_alloc w_mean = w_mean3 (max) conv_pub `amt' `rate', by(month soc6 ksco3 n_ksco8)
isid month soc6 ksco3
bysort month soc6: egen double chk = total(w_alloc)
assert abs(chk - 1) < 1e-9
drop chk
ksco_agg, by(month ksco3 n_ksco8) amt(`amt') rate(`rate')
merge m:1 ksco3 using `k3t', nogenerate assert(match)
merge 1:1 month ksco3 using `k8c', nogenerate assert(match)
merge m:1 month using `kt', nogenerate assert(match)

* 확인: 월별 소분류 대화량 합 = 세분류 대화량 합
preserve
use "`outd'/kor_ksco8_conv_ai_indicators.dta", clear
collapse (sum) s_conv = conv_k3 s_share = share_work, by(month)
tempfile s8
save `s8'
restore
preserve
collapse (sum) k_conv = conv_k3 k_share = share_work, by(month)
merge 1:1 month using `s8', nogenerate assert(match)
list, noobs clean
assert abs(k_conv - s_conv) < 1 & abs(k_share - s_share) < 1e-9
restore

foreach v of varlist conv_cover `amt' `rate' cov_* {
    label variable `v' `"`lab_`v''"'
}
label variable month        "월(YYYY-MM)"
label variable ksco3        "KSCO 8차 소분류(3자리) = substr(ksco8, 1, 3)"
label variable ksco3_title  "KSCO 8차 소분류 명칭"
label variable n_ksco8      "소분류에 속한 세분류 수(연계표 기준; w_mean = 세분류 균등)"
label variable n_ksco8_conv "그중 이 달 대화량이 있는 세분류 수(< n_ksco8이면 대화량은 하한값)"
label variable n_soc_link   "연계표상 연결된 SOC 2018 수(서로 다른 SOC)"
label variable n_soc_conv   "그중 이 달 대화량이 공개된 SOC 수(0이면 대화량 결측)"
order month ksco3 ksco3_title n_ksco8 n_ksco8_conv n_soc_link n_soc_conv conv_cover `amt' ///
    `rate' cov_aei cov_obs cov_elo cov_felten
sort month ksco3
compress
isid month ksco3
save "`outd'/kor_ksco3_conv_ai_indicators.dta", replace
export delimited using "`outd'/kor_ksco3_conv_ai_indicators.csv", replace
tabulate month
tabulate n_ksco8_conv if month == "2026-05" & n_ksco8_conv < n_ksco8
summarize conv_k3 time_saved_min observed_exposure if month == "2026-05"
