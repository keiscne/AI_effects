* =============================================================================
* 03_merge_kor_ksco3_ai_usage.do
* 한국 직업별 AI 활용도 2개: 대화량(분자) + 지역별고용조사(분모) 결합
* (report 25: results/report/25_직업별AI활용도_자료준비.tex)
*
* 입력:
*   $proc/merged/kor_ksco3_conv_ai_indicators.dta      월(2026-04·05) × KSCO 8차 소분류. 03_merge_kor_conv_ai_ksco8.do 출력.
*       conv_k3(월 업무용 대화 수, K = 3), saved_hr_k3(SOC 단계에서 대화 수 × 절감 시간 / 60 후 배분),
*       conv_ts_k3(절감 시간 있는 대화), 노출도 지표(w_mean 평균)
*   $proc/macro/kostat_lfs_regional/kostat_lfs_regional_ksco3.dta   연도 × ksco3. 01_import_kostat_regional_employment.do 출력.
*   $proc/macro/moel_wage_structure/moel_wage_structure_hours_ksco1.dta   연도 × 직업 대분류.
*       01_import_moel_wage_structure_hours.do 출력(강건성: 사업체 기준 근로시간).
*   KSCO 대분류·중분류 명칭: 통계청 KSCO–ISCO 연계표 시트 3-1의 A·B열(대분류), C·D열(중분류).
* 출력: $proc/merged/
*   kor_ai_usage_ksco3.{dta,csv}   KSCO 8차 소분류(지역별고용조사에 있는 163개; 군인 제외)
*   kor_ai_usage_ksco2.{dta,csv}   중분류
*   kor_ai_usage_ksco1.{dta,csv}   대분류
*
* 결정(사용자, 2026-10-17): 분모 = 지역별고용조사 2022년 상반기, 분석 단위 = 소분류(중분류·대분류도 계산),
*   K = 3, 활용도 2 분모 근로시간 = 지역별고용조사(다른 조사는 강건성), 활용도 2 분자 = SOC 단계 계산.
* 정의(단위 u = 소분류·중분류·대분류):
*   use1(u) = C(u) / E(u)              취업자 1인당 월 업무용 대화 수
*   use2(u) = S(u) / H(u) × 100        월 주업 근로시간 중 AI로 줄어든 시간 비중(%)
*     C = conv_k3, S = saved_hr_k3(시간), E = 2022년 상반기 취업자 수, H = 2022년 상반기 월 총 주업 근로시간
*   월 처리: 두 달(2026-04·05)의 분자를 평균한다. 소분류는 대화량이 있는 달만 평균(n_month_conv에 기록).
*     중분류·대분류는 달마다 소분류 분자를 더한 뒤(대화량 결측 소분류는 0으로 더함) 두 달을 평균한다.
*     미공개 직업의 대화는 이미 공개 직업에 비례 배분되어 있으므로(paper 19의 B2) 상위 분류의 합은 전국 합과 같다.
*   tau_eff = S / C_ts × 60            대화당 실효 절감 시간(분; SOC 대화량 가중). use2 = use1 × tau_eff/60 / (H/E) × 100.
* 강건성(분모만 바꿈):
*   use2_est   : H를 사업체 기준으로 보정. r(대분류) = 고용형태별근로실태조사 2022 임금근로자 월 실근로시간
*                ÷ (지역별고용조사 2022 임금근로자 주당 주업시간 × 4.345). H_est(u) = H(u) × r(대분류(u)).
*                임금·비임금 모두에 같은 r를 적용(장인성 2018 3장 방식: 비임금 시간 = 사업체 기준 시간 × 가구조사 상대비율).
*   use2_tot   : H에 부업 시간 포함(주업 + 부업)
*   use1_b2025, use2_b2025 : 분모를 2025년 상반기로(대화량 시점에 가까운 기준)
*   use1_m04, use1_m05, use2_m04, use2_m05 : 달별 값
* 플래그:
*   conv_lb = 1   소분류 안 세분류 일부만 대화량이 있음(대화량 하한값) — 어느 달이든
*   small   = 1   2022 표본 수 < 30
* 매칭 키: ksco3(str3) = 지역별고용조사 3자리_8차직업소분류코드 = 대화량 파일 ksco3.
*          ksco2 = substr(ksco3, 1, 2), ksco1 = substr(ksco3, 1, 1) = 고용형태별근로실태조사 직업대분류코드.
* =============================================================================

version 17
clear all
set more off

if `"$root"' == "" global root "d:/research/AI_effects"
if `"$raw"'  == "" global raw  "$root/data/raw"
if `"$proc"' == "" global proc "$root/data/proc"

local conv "$proc/merged/kor_ksco3_conv_ai_indicators.dta"
local emp  "$proc/macro/kostat_lfs_regional/kostat_lfs_regional_ksco3.dta"
local est  "$proc/macro/moel_wage_structure/moel_wage_structure_hours_ksco1.dta"
local kxls "$raw/exposure/bls_soc_crosswalk/isco08_ksco08/한국표준직업분류(KSCO 8차)-국제표준직업분류(ISCO-08) 연계표_20260127034430.xlsx"
local outd "$proc/merged"
local base 2022
local alt  2025
local wk2mo = 52.143 / 12
local expo "observed_exposure lm_aioe elo_gpt4_beta time_saved_min"

* -----------------------------------------------------------------------------
* 0. 분류 명칭(대분류·중분류)
* -----------------------------------------------------------------------------
import excel using "`kxls'", sheet("3-1. (연계표) KSCO(8차)-ISCO(08)") clear allstring
preserve
keep A B
rename (A B) (ksco1 ksco1_title)
replace ksco1 = strtrim(ksco1)
replace ksco1_title = strtrim(ksco1_title)
* 셀 안 줄바꿈 제거
replace ksco1_title = stritrim(subinstr(subinstr(ksco1_title, char(10), " ", .), char(13), " ", .))
keep if regexm(ksco1, "^[0-9A]$") & ksco1_title != ""
duplicates drop
isid ksco1
tempfile t1
save `t1'
restore
keep C D
rename (C D) (ksco2 ksco2_title)
replace ksco2 = strtrim(ksco2)
replace ksco2_title = strtrim(ksco2_title)
replace ksco2_title = stritrim(subinstr(subinstr(ksco2_title, char(10), " ", .), char(13), " ", .))
keep if regexm(ksco2, "^[0-9A][0-9]$") & ksco2_title != ""
duplicates drop
isid ksco2
tempfile t2
save `t2'

* -----------------------------------------------------------------------------
* 1. 분모: 지역별고용조사(2022 기준, 2025 비교)
* -----------------------------------------------------------------------------
use "`emp'", clear
keep if inlist(year, `base', `alt')
keep year ksco3 n_obs emp emp_wage hrs_main_wk_wage hrs_main_mo hrs_tot_mo
reshape wide n_obs emp emp_wage hrs_main_wk_wage hrs_main_mo hrs_tot_mo, i(ksco3) j(year)
rename (n_obs`base' emp`base' emp_wage`base' hrs_main_wk_wage`base' hrs_main_mo`base' hrs_tot_mo`base') ///
       (n_obs emp emp_wage hrs_wk_wage H H_tot)
rename (emp`alt' hrs_main_mo`alt') (emp_b`alt' H_b`alt')
drop n_obs`alt' emp_wage`alt' hrs_main_wk_wage`alt' hrs_tot_mo`alt'
assert !missing(emp, H)
generate str1 ksco1 = substr(ksco3, 1, 1)
generate str2 ksco2 = substr(ksco3, 1, 2)

* 사업체 기준 보정 비율 r(대분류): 고용형태별 월 실근로시간 / (지역별 임금근로자 주당 주업시간 × 4.345)
preserve
use "`est'", clear
keep if year == `base'
keep ksco1 hrs_mo_est
tempfile e1
save `e1'
restore
preserve
generate double sh = hrs_wk_wage * emp_wage
collapse (sum) sh emp_wage, by(ksco1)
generate double hrs_mo_hh_wage = sh / emp_wage * `wk2mo'
keep ksco1 hrs_mo_hh_wage
merge 1:1 ksco1 using `e1', assert(match) nogenerate
generate double r_est = hrs_mo_est / hrs_mo_hh_wage
list ksco1 hrs_mo_hh_wage hrs_mo_est r_est, noobs clean
keep ksco1 r_est hrs_mo_est hrs_mo_hh_wage
tempfile rr
save `rr'
restore
merge m:1 ksco1 using `rr', assert(match) nogenerate
generate double H_est = H * r_est
drop hrs_wk_wage
tempfile den
save `den'

* -----------------------------------------------------------------------------
* 2. 분자: 대화량(두 달)
* -----------------------------------------------------------------------------
use "`conv'", clear
* AI 지표는 월과 무관(두 달 값이 부동소수점 오차 안에서 같음) → 2026-05 값을 쓴다
local ai "`expo' cov_aei cov_obs cov_elo cov_felten"
foreach v of local ai {
    bysort ksco3 (month): assert abs(`v'[1] - `v'[2]) < 1e-9 | (missing(`v'[1]) & missing(`v'[2]))
}
preserve
keep if month == "2026-05"
keep ksco3 ksco3_title n_ksco8 `ai'
tempfile aiv
save `aiv'
restore
keep month ksco3 n_ksco8_conv conv_k3 saved_hr_k3 conv_ts_k3
generate str2 m = substr(month, 6, 2)
drop month
reshape wide n_ksco8_conv conv_k3 saved_hr_k3 conv_ts_k3, i(ksco3) j(m) string
merge 1:1 ksco3 using `aiv', assert(match) nogenerate
* 대화량이 있는 달 수와 하한 플래그
generate byte n_month_conv = !missing(conv_k304) + !missing(conv_k305)
generate byte conv_lb = (!missing(conv_k304) & n_ksco8_conv04 < n_ksco8) | (!missing(conv_k305) & n_ksco8_conv05 < n_ksco8)
egen double C    = rowmean(conv_k304 conv_k305)
egen double S    = rowmean(saved_hr_k304 saved_hr_k305)
egen double C_ts = rowmean(conv_ts_k304 conv_ts_k305)
tempfile num
save `num'

* -----------------------------------------------------------------------------
* 3. 소분류 결합과 지표
* -----------------------------------------------------------------------------
use `den', clear
merge 1:1 ksco3 using `num'
* _merge == 2: 대화량 파일에만 있는 소분류 = 군인(A01~A09)뿐이어야 함(지역별고용조사에 없음)
tabulate _merge
assert substr(ksco3, 1, 1) == "A" if _merge == 2
assert _merge != 1
drop if _merge == 2
drop _merge
merge m:1 ksco1 using `t1', keep(master match) nogenerate
merge m:1 ksco2 using `t2', keep(master match) nogenerate
assert !missing(ksco1_title, ksco2_title)

generate double use1      = C / emp
generate double use2      = S / H * 100
generate double use2_est  = S / H_est * 100
generate double use2_tot  = S / H_tot * 100
generate double use1_b`alt' = C / emp_b`alt'
generate double use2_b`alt' = S / H_b`alt' * 100
foreach mm in 04 05 {
    generate double use1_m`mm' = conv_k3`mm' / emp
    generate double use2_m`mm' = saved_hr_k3`mm' / H * 100
}
generate double tau_eff = S / C_ts * 60
generate double hrs_wk  = H / emp / `wk2mo'
generate double ts_cover = C_ts / C
generate byte small = n_obs < 30
* 확인: 대화량이 있으면 절감 시간 덮개는 1(SOC 단계 확인 결과, 45-XXXX 제외)
assert abs(ts_cover - 1) < 1e-9 if !missing(C)

label variable ksco3        "KSCO 8차 소분류"
label variable ksco3_title  "소분류 명칭"
label variable ksco2        "KSCO 8차 중분류"
label variable ksco2_title  "중분류 명칭"
label variable ksco1        "KSCO 8차 대분류"
label variable ksco1_title  "대분류 명칭"
label variable n_obs        "지역별고용조사 `base' 표본 수"
label variable emp          "취업자 수(`base' 상반기)"
label variable emp_wage     "임금근로자 수(`base' 상반기)"
label variable H            "월 총 주업 근로시간(시간, `base' 상반기)"
label variable H_tot        "월 총 근로시간(주업+부업, `base')"
label variable H_est        "월 총 근로시간, 사업체 기준 보정(H × r_est)"
label variable r_est        "보정 비율: 고용형태별 월 실근로시간 / 지역별 임금근로자 월 주업시간(대분류)"
label variable hrs_mo_est   "고용형태별근로실태조사 `base' 임금근로자 월 실근로시간(대분류)"
label variable hrs_mo_hh_wage "지역별고용조사 `base' 임금근로자 월 주업시간(대분류, 주당 × 4.345)"
label variable emp_b`alt'   "취업자 수(`alt' 상반기)"
label variable H_b`alt'     "월 총 주업 근로시간(`alt' 상반기)"
label variable C            "월 업무용 대화 수(K = 3, 2026-04·05 평균; 있는 달만)"
label variable S            "월 AI 절감 시간(시간; SOC 단계 계산, 2026-04·05 평균)"
label variable C_ts         "절감 시간이 있는 대화 수(평균)"
label variable n_month_conv "대화량이 있는 달 수(0~2)"
label variable conv_lb      "1 = 세분류 일부만 대화량 있음(하한값)"
label variable use1         "활용도 1: 취업자 1인당 월 업무용 대화 수"
label variable use2         "활용도 2: 월 주업 근로시간 중 AI 절감 시간 비중(%)"
label variable use2_est     "활용도 2(분모 사업체 기준 보정, %)"
label variable use2_tot     "활용도 2(분모 주업+부업, %)"
label variable use1_b`alt'  "활용도 1(분모 `alt' 상반기)"
label variable use2_b`alt'  "활용도 2(분모 `alt' 상반기, %)"
label variable tau_eff      "대화당 실효 절감 시간(분, SOC 대화량 가중)"
label variable hrs_wk       "취업자 1인당 주당 주업 근로시간(`base')"
label variable ts_cover     "절감 시간 덮개(C_ts / C)"
label variable small        "1 = 지역별고용조사 표본 수 30 미만"
label variable time_saved_min    "AEI 대화당 절감 시간(분; SOC w_mean 평균, 참고용)"
label variable observed_exposure "Observed exposure(w_mean 평균)"
label variable lm_aioe           "Felten 언어모델 AIOE(w_mean 평균)"
label variable elo_gpt4_beta     "Eloundou GPT-4 β(w_mean 평균)"
order ksco1 ksco1_title ksco2 ksco2_title ksco3 ksco3_title n_obs small emp emp_wage H H_tot H_est r_est ///
    C S C_ts n_month_conv conv_lb n_ksco8 use1 use2 use2_est use2_tot use1_b`alt' use2_b`alt' ///
    use1_m04 use1_m05 use2_m04 use2_m05 tau_eff hrs_wk ts_cover `expo'
sort ksco3
isid ksco3
compress
save "`outd'/kor_ai_usage_ksco3.dta", replace
export delimited using "`outd'/kor_ai_usage_ksco3.csv", replace
count
count if !missing(use1)
summarize use1 use2 use2_est tau_eff hrs_wk, detail

* -----------------------------------------------------------------------------
* 4. 중분류·대분류: 분자(달별)와 분모를 더한 뒤 지표 계산
* -----------------------------------------------------------------------------
foreach lv in 2 1 {
    use "`outd'/kor_ai_usage_ksco3.dta", clear
    generate byte has_conv = !missing(C)
    generate double emp_conv = emp * has_conv
    * 노출도 지표: 2022 취업자 가중 평균(값 있는 소분류만)
    local nd ""
    foreach v of local expo {
        generate double n_`v' = `v' * emp if !missing(`v')
        generate double d_`v' = emp if !missing(`v')
        local nd "`nd' n_`v' d_`v'"
    }
    local up = cond(`lv' == 2, "ksco1 ksco1_title", "")
    collapse (sum) emp emp_wage H H_tot H_est emp_b`alt' H_b`alt' conv_k304 conv_k305 saved_hr_k304 saved_hr_k305 ///
        conv_ts_k304 conv_ts_k305 emp_conv n_obs `nd' ///
        (count) n_ksco3 = emp (sum) n_ksco3_conv = has_conv n_ksco3_lb = conv_lb, by(ksco`lv' ksco`lv'_title `up')
    foreach v of local expo {
        generate double `v' = n_`v' / d_`v' if d_`v' > 0
        drop n_`v' d_`v'
    }
    * 두 달 평균(달마다 소분류 합; 대화량 결측 소분류는 0)
    generate double C    = (conv_k304 + conv_k305) / 2
    generate double S    = (saved_hr_k304 + saved_hr_k305) / 2
    generate double C_ts = (conv_ts_k304 + conv_ts_k305) / 2
    foreach v in C S C_ts {
        replace `v' = . if n_ksco3_conv == 0
    }
    generate double use1      = C / emp
    generate double use2      = S / H * 100
    generate double use2_est  = S / H_est * 100
    generate double use2_tot  = S / H_tot * 100
    generate double use1_b`alt' = C / emp_b`alt'
    generate double use2_b`alt' = S / H_b`alt' * 100
    foreach mm in 04 05 {
        generate double use1_m`mm' = conv_k3`mm' / emp if n_ksco3_conv > 0
        generate double use2_m`mm' = saved_hr_k3`mm' / H * 100 if n_ksco3_conv > 0
    }
    generate double tau_eff  = S / C_ts * 60
    generate double hrs_wk   = H / emp / `wk2mo'
    generate double emp_cover = emp_conv / emp
    drop emp_conv
    label variable n_ksco3      "소분류 수(지역별고용조사 2022에 있는 것)"
    label variable n_ksco3_conv "그중 대화량이 있는 소분류 수"
    label variable n_ksco3_lb   "그중 대화량이 하한값인 소분류 수"
    label variable emp_cover    "대화량이 있는 소분류의 취업자 비중"
    label variable C            "월 업무용 대화 수(K = 3, 두 달 평균; 결측 소분류는 0)"
    label variable S            "월 AI 절감 시간(시간, 두 달 평균)"
    label variable use1         "활용도 1: 취업자 1인당 월 업무용 대화 수"
    label variable use2         "활용도 2: 월 주업 근로시간 중 AI 절감 시간 비중(%)"
    label variable use2_est     "활용도 2(분모 사업체 기준 보정, %)"
    label variable use2_tot     "활용도 2(분모 주업+부업, %)"
    label variable tau_eff      "대화당 실효 절감 시간(분)"
    label variable hrs_wk       "취업자 1인당 주당 주업 근로시간(`base')"
    order ksco`lv' ksco`lv'_title n_ksco3 n_ksco3_conv n_ksco3_lb emp_cover emp H C S use1 use2 use2_est use2_tot ///
        use1_b`alt' use2_b`alt' use1_m04 use1_m05 use2_m04 use2_m05 tau_eff hrs_wk `expo'
    sort ksco`lv'
    isid ksco`lv'
    compress
    save "`outd'/kor_ai_usage_ksco`lv'.dta", replace
    export delimited using "`outd'/kor_ai_usage_ksco`lv'.csv", replace
    * 확인: 상위 분류 분자 합 = 소분류 분자 합(달별)
    quietly summarize conv_k305
    local s_up = r(sum)
    preserve
    use "`outd'/kor_ai_usage_ksco3.dta", clear
    quietly summarize conv_k305
    assert abs(r(sum) / `s_up' - 1) < 1e-9
    restore
}
use "`outd'/kor_ai_usage_ksco1.dta", clear
list ksco1 ksco1_title n_ksco3 n_ksco3_conv emp_cover use1 use2 use2_est tau_eff hrs_wk, noobs abbrev(12)
