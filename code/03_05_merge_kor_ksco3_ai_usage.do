* =============================================================================
* 03_05_merge_kor_ksco3_ai_usage.do
* 한국 직업별 AI 사용 지표: AEI 업무용 대화 비중(분자) + 지역별고용조사(분모) 결합
*   점유율 지표 A~D(paper 27)와 상대 활용도 RU1·RU2(paper 25)
*
* 2026-10-24 재설계(사용자 결정): Sensor Tower 기반 대화 총량을 쓰지 않는다. 분자는 AEI 업무용 대화 비중뿐이고,
*   활용도 1·2(취업자 1인당 대화 수, 근로시간 중 절감 시간 비중)는 전국 평균 대비 상대지수 RU1·RU2로 바꾼다.
*   두 달은 월별 비중의 단순평균으로 합친다. 지표 D(한국 특화도)를 추가한다.
*
* 입력:
*   $proc/merged/kor_ksco3_conv_ai_indicators.dta      월(2026-04·05) × KSCO 8차 소분류. 03_03_merge_kor_conv_ai_ksco8.do 출력.
*       share_work(한국 업무용 대화 비중), saved_w(비중 × 대화당 절감 시간, SOC 단계 곱 후 배분), sw_ts,
*       share_all(모든 use case 비중), share_work_glb(GLOBAL 업무용 비중), 노출도 지표(w_mean 평균)
*   $proc/macro/kostat_lfs_regional/kostat_lfs_regional_ksco3.dta   연도 × ksco3. 01_07_import_kostat_regional_employment.do 출력.
*   $proc/macro/moel_wage_structure/moel_wage_structure_hours_ksco1.dta   연도 × 직업 대분류.
*       01_08_import_moel_wage_structure_hours.do 출력(강건성: 사업체 기준 근로시간).
*   KSCO 대분류·중분류 명칭: 통계청 KSCO–ISCO 연계표 시트 3-1의 A·B열(대분류), C·D열(중분류).
* 출력: $proc/merged/
*   kor_ai_usage_ksco3.{dta,csv}   KSCO 8차 소분류(지역별고용조사에 있는 163개; 군인 제외)
*   kor_ai_usage_ksco2.{dta,csv}   중분류
*   kor_ai_usage_ksco1.{dta,csv}   대분류
*
* 결정(사용자, 2026-10-17·10-24): 분모 = 지역별고용조사 2022년 상반기, 분석 단위 = 소분류(중분류·대분류도 계산),
*   분모 근로시간 = 지역별고용조사(다른 조사는 강건성), 절감 시간 = SOC 단계에서 곱한 뒤 배분, 두 달 = 월별 비중 단순평균.
* 정의(소분류 j, 월 t; 표본 = 한국 비중이 한 달이라도 있는 소분류(지표 표본, 129개), 결측 달은 0):
*   a_jt = share_work_jt / Σ_k share_work_kt        월 t 표본 안 업무용 대화 비중
*   b_jt = saved_w_jt / Σ_k saved_w_kt              월 t 표본 안 절감 시간 비중
*   지표 A  shA_j = 100 × (a_j04 + a_j05) / 2        대화 점유율(%)
*   지표 B  shB_j = 100 × (b_j04 + b_j05) / 2        절감 시간 점유율(%)
*   지표 C  shC_j = 100 × (shB_j / hbar_j) / Σ_k (shB_k / hbar_k),  hbar = H / emp(1인당 월 주업 시간)
*   지표 D  spD_j = shA_j / shA_glb_j                한국 특화도(1 = 전 세계와 같은 몫). shA_glb는 GLOBAL 비중으로 같은 식.
*   (참고) 지표 A0  shA0_j: 모든 use case 비중(share_all)으로 만든 A(업무용 보정의 영향 점검용)
*   상대 활용도 1  ru1_j = shA_j / es_j,  es_j = 100 × emp_j / Σ emp(163개 전체)
*   상대 활용도 2  ru2_j = shB_j / hs_j,  hs_j = 100 × H_j / Σ H(163개 전체)
*     ru = 1이면 그 직업 규모만큼 쓰는 것, 2면 규모 대비 두 배. 전국 취업자(근로시간) 가중 평균 = 1.
*     예전 활용도와의 관계: ru1 = 활용도 1 / 전국 활용도 1, ru2 = 활용도 2 / 전국 활용도 2(월 가중 방식만 다름).
*   tau_eff_j = tbar × shB_j / shA_j   대화당 실효 절감 시간(분). tbar = 두 달 평균의 표본 전체 대화당 평균 절감 시간
*     (= Σ saved_w / Σ share_work). → shB / shA = tau_eff / tbar,  ru2 = ru1 × (tau_eff / tbar) / (hrs_wk / 전국 hrs_wk).
* 강건성(분모만 바꿈, 분자는 같음):
*   ru2_est   : H를 사업체 기준으로 보정. r(대분류) = 고용형태별근로실태조사 2022 임금근로자 월 실근로시간
*               ÷ (지역별고용조사 2022 임금근로자 주당 주업시간 × 4.345). H_est(u) = H(u) × r(대분류(u)).
*               임금·비임금 모두에 같은 r를 적용(장인성 2018 3장 방식).
*   ru2_tot   : H에 부업 시간 포함(주업 + 부업)
*   ru1_b2025, ru2_b2025 : 분모를 2025년 상반기로(대화 비중 시점에 가까운 기준)
*   ru1_m04, ru1_m05, ru2_m04, ru2_m05 : 달별 값(100 × a_jt / es_j 등)
* 플래그:
*   conv_lb = 1   소분류 안 세분류 일부만 한국 비중이 있음(비중 하한값) — 어느 달이든
*   small   = 1   2022 표본 수 < 30
* 매칭 키: ksco3(str3) = 지역별고용조사 3자리_8차직업소분류코드 = 대화 비중 파일 ksco3.
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
* 월별 분자: 한국 업무용 비중(sw), 절감 가중(sv), 모든 use case 비중(sa), GLOBAL 업무용 비중(sg)
local num "sw sv sa sg"

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
* 2. 분자: 업무용 대화 비중(두 달)
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
rename (share_work saved_w share_all share_work_glb) (sw sv sa sg)
keep month ksco3 n_ksco8_conv `num' sw_ts
generate str2 m = substr(month, 6, 2)
drop month
reshape wide n_ksco8_conv `num' sw_ts, i(ksco3) j(m) string
merge 1:1 ksco3 using `aiv', assert(match) nogenerate
* 한국 비중이 있는 달 수와 하한 플래그
generate byte n_month_conv = !missing(sw04) + !missing(sw05)
generate byte conv_lb = (!missing(sw04) & n_ksco8_conv04 < n_ksco8) | (!missing(sw05) & n_ksco8_conv05 < n_ksco8)
tempfile numf
save `numf'

* -----------------------------------------------------------------------------
* 3. 소분류 결합과 지표
* -----------------------------------------------------------------------------
use `den', clear
merge 1:1 ksco3 using `numf'
* _merge == 2: 대화 비중 파일에만 있는 소분류 = 군인(A01~A09)뿐이어야 함(지역별고용조사에 없음)
tabulate _merge
assert substr(ksco3, 1, 1) == "A" if _merge == 2
assert _merge != 1
drop if _merge == 2
drop _merge
merge m:1 ksco1 using `t1', keep(master match) nogenerate
merge m:1 ksco2 using `t2', keep(master match) nogenerate
assert !missing(ksco1_title, ksco2_title)

* 지표 표본: 한국 비중이 한 달이라도 있는 소분류
generate byte in_share = n_month_conv > 0
* 결측 달은 0(미공개 셀의 몫은 이미 공개 셀에 비례 배분되어 있음, paper 19의 B2)
foreach v of local num {
    foreach mm in 04 05 {
        generate double z_`v'`mm' = cond(in_share, cond(missing(`v'`mm'), 0, `v'`mm'), .)
        quietly summarize z_`v'`mm'
        local T_`v'`mm' = r(sum)
        generate double tot_`v'`mm' = `T_`v'`mm''
        generate double p_`v'`mm' = 100 * z_`v'`mm' / tot_`v'`mm'
    }
}
generate double shA     = (p_sw04 + p_sw05) / 2
generate double shB     = (p_sv04 + p_sv05) / 2
generate double shA0    = (p_sa04 + p_sa05) / 2
generate double shA_glb = (p_sg04 + p_sg05) / 2
generate double spD     = shA / shA_glb
* 지표 C: 절감 시간 점유율을 1인당 월 시간으로 나눠 인원 환산
generate double hbar = H / emp
generate double fte  = shB / hbar
quietly summarize fte
generate double shC  = 100 * fte / r(sum)
drop fte
* 분모 비중(163개 전체)
foreach d in emp H H_est H_tot emp_b`alt' H_b`alt' {
    quietly summarize `d'
    generate double s_`d' = 100 * `d' / r(sum)
}
rename (s_emp s_H) (es hs)
generate double ru1       = shA / es
generate double ru2       = shB / hs
generate double ru2_est   = shB / s_H_est
generate double ru2_tot   = shB / s_H_tot
generate double ru1_b`alt' = shA / s_emp_b`alt'
generate double ru2_b`alt' = shB / s_H_b`alt'
foreach mm in 04 05 {
    generate double ru1_m`mm' = p_sw`mm' / es
    generate double ru2_m`mm' = p_sv`mm' / hs
}
drop s_H_est s_H_tot s_emp_b`alt' s_H_b`alt'
* 대화당 실효 절감 시간: tbar = 두 달 평균 Σ saved_w / Σ share_work
local tbar = ((`T_sv04' / `T_sw04') + (`T_sv05' / `T_sw05')) / 2
generate double tbar    = `tbar'
generate double tau_eff = tbar * shB / shA
generate double hrs_wk  = H / emp / `wk2mo'
generate double ts_cover = (cond(missing(sw_ts04), 0, sw_ts04) + cond(missing(sw_ts05), 0, sw_ts05)) / ///
    (cond(missing(sw04), 0, sw04) + cond(missing(sw05), 0, sw05)) if in_share
generate byte small = n_obs < 30
display as text "tbar(대화당 평균 절감 시간, 분) = " %6.2f `tbar'
* 확인: 점유율 합 100, 비중이 있으면 절감 시간 덮개 1, D의 GLOBAL 가중 평균 1, RU의 규모 가중 평균 1
foreach v in shA shB shC shA0 shA_glb {
    quietly summarize `v'
    assert abs(r(sum) - 100) < 1e-9
}
assert abs(ts_cover - 1) < 1e-9 if in_share
assert !missing(spD) if in_share
generate double chk1 = ru1 * es
generate double chk2 = ru2 * hs
quietly summarize chk1
assert abs(r(sum) - 100) < 1e-9
quietly summarize chk2
assert abs(r(sum) - 100) < 1e-9
drop chk1 chk2
drop z_* p_sa* p_sg*

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
label variable in_share     "1 = 지표 표본(한국 업무용 대화 비중이 한 달이라도 있음)"
label variable n_month_conv "한국 비중이 있는 달 수(0~2)"
label variable conv_lb      "1 = 세분류 일부만 한국 비중 있음(하한값)"
foreach mm in 04 05 {
    label variable sw`mm'     "2026-`mm' 한국 업무용 대화 비중(배분 원값, 표본 정규화 전)"
    label variable sv`mm'     "2026-`mm' 비중 × 대화당 절감 시간(분, 배분 원값)"
    label variable sa`mm'     "2026-`mm' 한국 대화 비중(모든 use case, 배분 원값)"
    label variable sg`mm'     "2026-`mm' GLOBAL 업무용 대화 비중(배분 원값)"
    label variable sw_ts`mm'  "2026-`mm' 절감 시간이 있는 SOC의 비중(배분 원값)"
    label variable n_ksco8_conv`mm' "2026-`mm' 한국 비중이 있는 세분류 수"
    label variable p_sw`mm'   "2026-`mm' 대화 점유율(%, 표본 안)"
    label variable p_sv`mm'   "2026-`mm' 절감 시간 점유율(%, 표본 안)"
    label variable ru1_m`mm'  "상대 활용도 1(2026-`mm'만)"
    label variable ru2_m`mm'  "상대 활용도 2(2026-`mm'만)"
}
foreach v in sw sv sa sg {
    foreach mm in 04 05 {
        label variable tot_`v'`mm' "표본 합계(정규화 분모): `v'`mm'"
    }
}
label variable shA          "지표 A: 대화 점유율(%, 두 달 단순평균)"
label variable shB          "지표 B: 절감 시간 점유율(%, 두 달 단순평균)"
label variable shC          "지표 C: 취업자 환산 절감 점유율(%)"
label variable spD          "지표 D: 한국 특화도 = shA / shA_glb"
label variable shA0         "(참고) 지표 A0: 모든 use case 대화 점유율(%)"
label variable shA_glb      "GLOBAL 대화 점유율(%, 같은 표본·같은 방식)"
label variable hbar         "1인당 월 주업 근로시간(`base')"
label variable es           "취업자 비중(%, 163개 전체)"
label variable hs           "총 주업 근로시간 비중(%, 163개 전체)"
label variable ru1          "상대 활용도 1 = A / 취업자 비중"
label variable ru2          "상대 활용도 2 = B / 근로시간 비중"
label variable ru2_est      "상대 활용도 2(분모 사업체 기준 보정)"
label variable ru2_tot      "상대 활용도 2(분모 주업+부업)"
label variable ru1_b`alt'   "상대 활용도 1(분모 `alt' 상반기)"
label variable ru2_b`alt'   "상대 활용도 2(분모 `alt' 상반기)"
label variable tbar         "표본 전체 대화당 평균 절감 시간(분, 두 달 평균)"
label variable tau_eff      "대화당 실효 절감 시간(분) = tbar × B / A"
label variable hrs_wk       "취업자 1인당 주당 주업 근로시간(`base')"
label variable ts_cover     "절감 시간 덮개(절감 시간 있는 SOC 비중 / 전체 비중)"
label variable small        "1 = 지역별고용조사 표본 수 30 미만"
label variable time_saved_min    "AEI 대화당 절감 시간(분; SOC w_mean 평균, 참고용)"
label variable observed_exposure "Observed exposure(w_mean 평균)"
label variable lm_aioe           "Felten 언어모델 AIOE(w_mean 평균)"
label variable elo_gpt4_beta     "Eloundou GPT-4 β(w_mean 평균)"
order ksco1 ksco1_title ksco2 ksco2_title ksco3 ksco3_title n_obs small emp emp_wage H H_tot H_est r_est ///
    in_share n_month_conv conv_lb n_ksco8 shA shB shC spD shA0 shA_glb es hs ru1 ru2 ru2_est ru2_tot ///
    ru1_b`alt' ru2_b`alt' ru1_m04 ru1_m05 ru2_m04 ru2_m05 tau_eff tbar hbar hrs_wk ts_cover `expo'
sort ksco3
isid ksco3
compress
save "`outd'/kor_ai_usage_ksco3.dta", replace
export delimited using "`outd'/kor_ai_usage_ksco3.csv", replace
count
count if in_share
summarize shA shB shC spD ru1 ru2 ru2_est tau_eff hrs_wk, detail

* -----------------------------------------------------------------------------
* 4. 중분류·대분류: 소분류 점유율과 분모 비중을 더한 뒤 지표 계산
* -----------------------------------------------------------------------------
foreach lv in 2 1 {
    use "`outd'/kor_ai_usage_ksco3.dta", clear
    generate double emp_conv = emp * in_share
    foreach v in H_est H_tot emp_b`alt' H_b`alt' {
        quietly summarize `v'
        generate double s_`v' = 100 * `v' / r(sum)
    }
    * 노출도 지표: 2022 취업자 가중 평균(값 있는 소분류만)
    local nd ""
    foreach v of local expo {
        generate double n_`v' = `v' * emp if !missing(`v')
        generate double d_`v' = emp if !missing(`v')
        local nd "`nd' n_`v' d_`v'"
    }
    local up = cond(`lv' == 2, "ksco1 ksco1_title", "")
    collapse (sum) emp emp_wage H H_tot H_est emp_b`alt' H_b`alt' shA shB shC shA0 shA_glb p_sw04 p_sw05 p_sv04 p_sv05 ///
        es hs s_* emp_conv n_obs `nd' (first) tbar ///
        (count) n_ksco3 = emp (sum) n_ksco3_conv = in_share n_ksco3_lb = conv_lb, by(ksco`lv' ksco`lv'_title `up')
    foreach v of local expo {
        generate double `v' = n_`v' / d_`v' if d_`v' > 0
        drop n_`v' d_`v'
    }
    foreach v in shA shB shC shA0 shA_glb p_sw04 p_sw05 p_sv04 p_sv05 {
        replace `v' = . if n_ksco3_conv == 0
    }
    generate double spD       = shA / shA_glb
    generate double ru1       = shA / es
    generate double ru2       = shB / hs
    generate double ru2_est   = shB / s_H_est
    generate double ru2_tot   = shB / s_H_tot
    generate double ru1_b`alt' = shA / s_emp_b`alt'
    generate double ru2_b`alt' = shB / s_H_b`alt'
    foreach mm in 04 05 {
        generate double ru1_m`mm' = p_sw`mm' / es
        generate double ru2_m`mm' = p_sv`mm' / hs
    }
    drop s_* p_*
    generate double tau_eff  = tbar * shB / shA
    generate double hrs_wk   = H / emp / `wk2mo'
    generate double emp_cover = emp_conv / emp
    drop emp_conv
    label variable n_ksco3      "소분류 수(지역별고용조사 2022에 있는 것)"
    label variable n_ksco3_conv "그중 지표 표본 소분류 수"
    label variable n_ksco3_lb   "그중 비중이 하한값인 소분류 수"
    label variable emp_cover    "지표 표본 소분류의 취업자 비중"
    label variable shA          "지표 A: 대화 점유율(%, 소분류 합)"
    label variable shB          "지표 B: 절감 시간 점유율(%, 소분류 합)"
    label variable shC          "지표 C: 취업자 환산 절감 점유율(%, 소분류 합)"
    label variable spD          "지표 D: 한국 특화도 = shA / shA_glb"
    label variable shA0         "(참고) 지표 A0: 모든 use case 대화 점유율(%)"
    label variable shA_glb      "GLOBAL 대화 점유율(%)"
    label variable es           "취업자 비중(%)"
    label variable hs           "총 주업 근로시간 비중(%)"
    label variable ru1          "상대 활용도 1 = A / 취업자 비중"
    label variable ru2          "상대 활용도 2 = B / 근로시간 비중"
    label variable ru2_est      "상대 활용도 2(분모 사업체 기준 보정)"
    label variable ru2_tot      "상대 활용도 2(분모 주업+부업)"
    label variable tau_eff      "대화당 실효 절감 시간(분)"
    label variable hrs_wk       "취업자 1인당 주당 주업 근로시간(`base')"
    order ksco`lv' ksco`lv'_title n_ksco3 n_ksco3_conv n_ksco3_lb emp_cover emp H shA shB shC spD shA0 shA_glb es hs ///
        ru1 ru2 ru2_est ru2_tot ru1_b`alt' ru2_b`alt' ru1_m04 ru1_m05 ru2_m04 ru2_m05 tau_eff tbar hrs_wk `expo'
    sort ksco`lv'
    isid ksco`lv'
    compress
    save "`outd'/kor_ai_usage_ksco`lv'.dta", replace
    export delimited using "`outd'/kor_ai_usage_ksco`lv'.csv", replace
    * 확인: 상위 분류 점유율 합 = 100, 취업자 가중 RU1 평균 = 1
    quietly summarize shA
    assert abs(r(sum) - 100) < 1e-9
    generate double chk = ru1 * es
    quietly summarize chk
    assert abs(r(sum) - 100) < 1e-9
    drop chk
}
use "`outd'/kor_ai_usage_ksco1.dta", clear
list ksco1 ksco1_title n_ksco3 n_ksco3_conv emp_cover shA shB spD ru1 ru2 tau_eff hrs_wk, noobs abbrev(12)
