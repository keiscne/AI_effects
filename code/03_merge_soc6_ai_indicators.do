* =============================================================================
* 03_merge_soc6_ai_indicators.do
* SOC 2018 세부 직업(6자리, soc6)별 AI 지표 4종 결합
*
* 입력:
*   1. $proc/usage/anthropic_economic_index/aei_soc6_time_savings.dta   (01_import_aei_soc_time_savings.do)
*        AEI Claude.ai 전 세계 2026-04·05, 과업 소요 시간과 AI로 줄어든 시간(분). 613개
*   2. $raw/usage/anthropic_economic_index/labor_market_impacts/job_exposure.csv
*        observed exposure(Massenkoff & McCrory 2026). occ_code = SOC 2018 세부 직업. 756개
*   3. $raw/exposure/eloundou_gpts_are_gpts/repo_2025_10_04/GPTs-are-GPTs-0471612fef3cc22b74fb884d27bff9dbd3770582/
*        data/occ_level.csv: Eloundou et al. GPT 노출도. O*NET-SOC 8자리 923개(SOC 2018 기반)
*        dv_rating_* = GPT-4 평가, human_rating_* = 사람 평가.
*        alpha = E1, beta = E1 + 0.5 × E2, gamma = E1 + E2
*   4. $proc/exposure/felten_aioe/felten_lm_aioe_soc2018.dta            (01_import_felten_aioe.do)
*        Felten et al.(2023) 언어모델 AIOE, SOC 2010 → 2018 변환. 800개
*
* 출력: $proc/merged/soc6_ai_indicators.{csv,dta}
*   행 = soc6(네 자료 중 하나라도 있는 SOC 2018 세부 직업, 합집합). 없는 지표는 결측.
*   in_aei, in_obs, in_eloundou, in_felten = 각 자료에 있는지(0/1), n_sources = 합계
*
* 매칭 키: soc6(str7, XX-XXXX, SOC 2018 세부 직업)
*   AEI: soc6(O*NET-SOC 앞 7자리, 01_import_aei_soc_time_savings.do에서 집계)
*   observed exposure: occ_code 그대로
*   Eloundou: O*NET-SOC Code 앞 7자리. 한 soc6에 8자리 코드가 여럿이면 단순평균(작업자 판단, 가중치 없음).
*             n_onet_eloundou = 평균에 쓴 8자리 코드 수
*   Felten: soc6 그대로(이미 SOC 2018로 변환)
*
* 직업 명칭(soc6_title): observed exposure title → Felten(BLS 2018 명칭) → Eloundou(.00 코드 명칭 우선) → AEI 순.
*
* 주의:
*   - AEI 시간 지표는 Claude 대화 과업 기준 추정치(전 세계), observed exposure도 Claude 자료에서 온다.
*   - Felten lm_aioe는 SOC 2010 774개 기준 표준화 값(변환 후 재표준화 안 함). Eloundou는 0~1 비율.
*   - 결측 = 그 자료에 해당 직업이 없음(0이 아님).
* =============================================================================

version 17
clear all
set more off

if `"$root"' == "" global root "d:/research/AI_effects"
if `"$raw"'  == "" global raw  "$root/data/raw"
if `"$proc"' == "" global proc "$root/data/proc"

local aei  "$proc/usage/anthropic_economic_index/aei_soc6_time_savings.dta"
local obs  "$raw/usage/anthropic_economic_index/labor_market_impacts/job_exposure.csv"
local elo  "$raw/exposure/eloundou_gpts_are_gpts/repo_2025_10_04/GPTs-are-GPTs-0471612fef3cc22b74fb884d27bff9dbd3770582/data/occ_level.csv"
local fel  "$proc/exposure/felten_aioe/felten_lm_aioe_soc2018.dta"
local out  "$proc/merged"
capture mkdir "`out'"

local soc6re "^[0-9][0-9]-[0-9][0-9][0-9][0-9]$"

* -----------------------------------------------------------------------------
* 1. AEI 시간 절감
* -----------------------------------------------------------------------------
use "`aei'", clear
isid soc6
assert regexm(soc6, "`soc6re'")
keep soc6 soc6_title weight n_months human_only_min human_with_ai_min time_saved_min time_saved_hr
rename (soc6_title weight n_months) (title_aei aei_weight aei_n_months)
generate byte in_aei = 1
tempfile t_aei
save `t_aei'

* -----------------------------------------------------------------------------
* 2. observed exposure
* -----------------------------------------------------------------------------
import delimited using "`obs'", varnames(1) encoding("utf-8") bindquote(strict) ///
    stringcols(1 2) asdouble clear
rename (occ_code title) (soc6 title_obs)
replace soc6 = strtrim(soc6)
isid soc6
assert regexm(soc6, "`soc6re'")
assert !missing(observed_exposure)
count
assert r(N) == 756
generate byte in_obs = 1
tempfile t_obs
save `t_obs'

* -----------------------------------------------------------------------------
* 3. Eloundou: O*NET-SOC 8자리 → soc6 단순평균
* -----------------------------------------------------------------------------
import delimited using "`elo'", varnames(1) encoding("utf-8") bindquote(strict) ///
    stringcols(1 2) asdouble clear
rename (onetsoccode title) (onet_code title_elo)
replace onet_code = strtrim(onet_code)
count
assert r(N) == 923
isid onet_code
assert regexm(onet_code, "^[0-9][0-9]-[0-9][0-9][0-9][0-9]\.[0-9][0-9]$")
foreach v in dv_rating_alpha dv_rating_beta dv_rating_gamma human_rating_alpha human_rating_beta human_rating_gamma {
    assert !missing(`v')
}
generate str7 soc6 = substr(onet_code, 1, 7)
generate byte is00 = substr(onet_code, 9, 2) == "00"
* 명칭: .00 코드 우선, 없으면 코드 순서상 첫 번째
gsort soc6 -is00 onet_code
by soc6: replace title_elo = title_elo[1]
collapse (mean) dv_rating_alpha dv_rating_beta dv_rating_gamma ///
    human_rating_alpha human_rating_beta human_rating_gamma ///
    (count) n_onet_eloundou = dv_rating_alpha, by(soc6 title_elo)
isid soc6
count
assert r(N) == 798
rename (dv_rating_* human_rating_*) (elo_gpt4_* elo_human_*)
generate byte in_eloundou = 1
tempfile t_elo
save `t_elo'

* -----------------------------------------------------------------------------
* 4. Felten 언어모델 AIOE(SOC 2018 변환)
* -----------------------------------------------------------------------------
use "`fel'", clear
isid soc6
assert regexm(soc6, "`soc6re'")
keep soc6 soc6_title lm_aioe n_src2010 split partial
rename (soc6_title n_src2010 split partial) (title_felten felten_n_src2010 felten_split felten_partial)
generate byte in_felten = 1
tempfile t_fel
save `t_fel'

* -----------------------------------------------------------------------------
* 5. 결합(합집합)
* -----------------------------------------------------------------------------
use `t_obs', clear
merge 1:1 soc6 using `t_aei', nogenerate
merge 1:1 soc6 using `t_elo', nogenerate
merge 1:1 soc6 using `t_fel', nogenerate
isid soc6
foreach s in aei obs eloundou felten {
    replace in_`s' = 0 if missing(in_`s')
}
generate byte n_sources = in_aei + in_obs + in_eloundou + in_felten

generate str244 soc6_title = title_obs
replace soc6_title = title_felten if soc6_title == ""
replace soc6_title = title_elo    if soc6_title == ""
replace soc6_title = title_aei    if soc6_title == ""
assert soc6_title != ""
drop title_*
generate str2 soc_major = substr(soc6, 1, 2)

label variable soc6              "SOC 2018 세부 직업 6자리(XX-XXXX)"
label variable soc6_title        "직업 명칭(observed exposure → Felten → Eloundou → AEI 순)"
label variable soc_major         "SOC 대분류(앞 2자리)"
label variable in_aei            "1 = AEI 시간 절감 있음"
label variable in_obs            "1 = observed exposure 있음"
label variable in_eloundou       "1 = Eloundou 노출도 있음"
label variable in_felten         "1 = Felten 언어모델 AIOE 있음"
label variable n_sources         "지표가 있는 자료 수(0~4)"
label variable human_only_min    "AEI: AI 없이 걸리는 시간(분)"
label variable human_with_ai_min "AEI: AI와 함께 걸리는 시간(분)"
label variable time_saved_min    "AEI: human_only − human_with_ai (분)"
label variable time_saved_hr     "AEI: human_only − human_with_ai (시간)"
label variable aei_weight        "AEI: soc6 집계 가중치 합계(pct)"
label variable aei_n_months      "AEI: 값이 있는 달 수(2026-04·05)"
label variable observed_exposure "Observed exposure(Massenkoff & McCrory 2026)"
label variable elo_gpt4_alpha    "Eloundou GPT-4 평가 alpha(E1)"
label variable elo_gpt4_beta     "Eloundou GPT-4 평가 beta(E1 + 0.5 E2)"
label variable elo_gpt4_gamma    "Eloundou GPT-4 평가 gamma(E1 + E2)"
label variable elo_human_alpha   "Eloundou 사람 평가 alpha(E1)"
label variable elo_human_beta    "Eloundou 사람 평가 beta(E1 + 0.5 E2)"
label variable elo_human_gamma   "Eloundou 사람 평가 gamma(E1 + E2)"
label variable n_onet_eloundou   "Eloundou: 평균에 쓴 O*NET-SOC 8자리 코드 수"
label variable lm_aioe           "Felten et al.(2023) 언어모델 AIOE(SOC 2010 → 2018 변환)"
label variable felten_n_src2010  "Felten: 평균에 쓴 SOC 2010 코드 수"
label variable felten_split      "Felten: 1 = 원천 2010 직업이 나뉨(값 복사)"
label variable felten_partial    "Felten: 1 = 대응 2010 코드 일부 없음"

order soc6 soc6_title soc_major in_aei in_obs in_eloundou in_felten n_sources ///
    time_saved_min time_saved_hr human_only_min human_with_ai_min aei_weight aei_n_months ///
    observed_exposure ///
    elo_gpt4_alpha elo_gpt4_beta elo_gpt4_gamma elo_human_alpha elo_human_beta elo_human_gamma n_onet_eloundou ///
    lm_aioe felten_n_src2010 felten_split felten_partial
sort soc6
compress
save "`out'/soc6_ai_indicators.dta", replace
export delimited using "`out'/soc6_ai_indicators.csv", replace

* -----------------------------------------------------------------------------
* 6. 확인용: 범위와 상관
* -----------------------------------------------------------------------------
count
tabulate n_sources
tabulate in_aei in_obs
foreach s in aei obs eloundou felten {
    quietly count if in_`s'
    display "in_`s' = " r(N)
}
count if n_sources == 4
* 네 자료 모두 있는 직업에서 지표 간 상관
correlate time_saved_min observed_exposure elo_gpt4_beta elo_human_beta lm_aioe if n_sources == 4
spearman time_saved_min observed_exposure elo_gpt4_beta lm_aioe if n_sources == 4
* AEI에 있으나 다른 자료에 없는 직업
list soc6 soc6_title in_obs in_eloundou in_felten if in_aei & n_sources < 4, noobs abbreviate(20)
