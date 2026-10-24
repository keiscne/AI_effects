* =============================================================================
* 03_04_merge_kor_task_conv_time_saved.do
* 한국 O*NET task(직업-task)별 업무용 대화 비중과 AI 절감 시간 가중치
*
* 2026-10-24 재설계: Sensor Tower 기반 대분류 대화 건수 대신 AEI 대분류 업무용 대화 비중을 task로 나눈다.
*   task 순위·점유율은 예전 건수 기준과 같다(건수 = 한국 총량 × 비중).
*
* 입력:
*   $raw/usage/anthropic_economic_index/release_2026_06_26/data/aei_claude_ai_2026-06-26.csv
*     (a) geo_id == "KOR", category_name == "onet", hierarchy_level == 0(task): pct만 공개
*     (b) geo_id == "GLOBAL", category_name == "onet", hierarchy_level == 0:
*         pct, human_only_time_mean(시간), human_with_ai_time_mean(분)
*         task 단위 시간 지표는 GLOBAL에만 공개된다(국가는 GWA 단위만, data_documentation.md).
*   $proc/exposure/onet_task_statements/onet_task_soc.dta   (01_05_import_onet_task_soc.do)
*     Task ID → O*NET-SOC 8자리(task 하나 = 직업 하나), soc6
*   $proc/usage/anthropic_economic_index/aei_soc_work_share_major.dta
*     (03_02_merge_aei_kor_soc_work_share.do) 지역 × 월 × SOC 대분류 업무용 대화 비중 share_work(KOR만 사용)
* 출력: $proc/merged/
*   kor_task_conv_time_saved.{csv,dta}   월 × task(task_id)
*
* 정의(03_02_merge_aei_kor_soc_work_share.do의 세부 직업 계산과 같은 구조):
*   task d는 Task ID로 대분류 g(O*NET-SOC 앞 2자리)에 속한다.
*   w(d,t)             = 한국 task pct, 0.00은 0.0025(구간 중점, 01_03_import_aei_soc_time_savings.do와 같음)
*   share_in_major(d,t) = w(d,t) / Σ_{d'∈g} w(d',t)
*   share_work(d,t)     = share_work_major(g,t) × share_in_major(d,t)   한국 업무용 대화 중 task d의 비중
*   time_saved_min(d)   = GLOBAL task의 (human_only_time_mean × 60 − human_with_ai_time_mean),
*                         두 달을 GLOBAL pct(0.00은 0.0025)로 가중평균(두 달 전체 대화 수가 같다고 가정)
*   saved_w(d,t)        = share_work(d,t) × time_saved_min(d)   (분; 업무용 대화 1건 평균 기준 절감 시간 가중치)
*
* 가정:
*   (T1) 대분류 안에서 업무용 대화의 task 구성 = 모든 use case 대화의 task 구성
*        (task는 pct만 공개, 업무용 비중은 대분류 값을 그대로 씀; 세부 직업 계산의 B3과 같음).
*   (T2) 공개되지 않은 task 몫(한국 task pct 합 2026-04 78.5%, 05 81.3%)은 같은 대분류의
*        공개 task와 같은 비율로 나뉜다(대분류 안에서 다시 정규화).
*   (T3) 한국 task의 절감 시간 = 전 세계(GLOBAL) 같은 task의 절감 시간.
*
* 매칭 키:
*   AEI node_external_id(onet, level 0)의 숫자값 = onet_task_soc의 task_id(long)
*   soc_major = substr(onetsoc, 1, 2) = 대분류 파일의 soc_major,  month = date_start 앞 7자리
*
* 주의:
*   - AEI의 직업은 사용자 직업이 아니라 대화 과업이 속한 직업이다.
*   - 절감 시간은 Claude가 대화별로 추정한 값의 평균이다(실측 아님).
*   - 공개 task가 없는 대분류(45 농림어업)의 비중은 task로 나뉘지 않아 월 비중 합이 1보다 조금 작다.
* =============================================================================

version 17
clear all
set more off

if `"$root"' == "" global root "d:/research/AI_effects"
if `"$raw"'  == "" global raw  "$root/data/raw"
if `"$proc"' == "" global proc "$root/data/proc"

local aei  "$raw/usage/anthropic_economic_index/release_2026_06_26/data"
local shr  "$proc/usage/anthropic_economic_index/aei_soc_work_share_major.dta"
local cw   "$proc/exposure/onet_task_statements/onet_task_soc.dta"
local out  "$proc/merged"
capture mkdir "`out'"

import delimited using "`aei'/aei_claude_ai_2026-06-26.csv", ///
    varnames(1) encoding("utf-8") bindquote(strict) stringcols(1/7 9 10) asdouble clear
keep if category_name == "onet" & hierarchy_level == "0" & inlist(geo_id, "KOR", "GLOBAL")
generate str7 month = substr(date_start, 1, 7)
generate long task_id = real(node_external_id)
assert !missing(task_id)
keep geo_id month task_id node_name metric_id value
tempfile raw
save `raw'

* -----------------------------------------------------------------------------
* 1. GLOBAL task 절감 시간(두 달 합침)
* -----------------------------------------------------------------------------
use `raw', clear
keep if geo_id == "GLOBAL" & inlist(metric_id, "pct", "human_only_time_mean", "human_with_ai_time_mean")
drop geo_id node_name
reshape wide value, i(month task_id) j(metric_id) string
rename (valuepct valuehuman_only_time_mean valuehuman_with_ai_time_mean) (g_pct human_only_hr human_with_ai_min)
assert !missing(g_pct)
count if missing(human_only_hr) | missing(human_with_ai_min)     // 시간이 공개되지 않은 task-월
drop if missing(human_only_hr) | missing(human_with_ai_min)
generate double human_only_min = 60 * human_only_hr
generate double time_saved_min = human_only_min - human_with_ai_min
generate double w = cond(g_pct == 0, 0.0025, g_pct)
foreach v in human_only_min human_with_ai_min time_saved_min {
    generate double w_`v' = w * `v'
}
collapse (sum) w w_* (count) n_months_time = w, by(task_id)
foreach v in human_only_min human_with_ai_min time_saved_min {
    generate double `v' = w_`v' / w
}
assert abs(time_saved_min - (human_only_min - human_with_ai_min)) < 1e-9
drop w w_*
summarize time_saved_min, detail
tempfile gtime
save `gtime'

* -----------------------------------------------------------------------------
* 2. 한국 task pct → 대분류 안 비중
* -----------------------------------------------------------------------------
use `raw', clear
keep if geo_id == "KOR" & metric_id == "pct"
drop geo_id metric_id
rename (value node_name) (pct task_title)
isid month task_id
tabstat pct, by(month) statistics(count sum) format(%9.2f)

merge m:1 task_id using "`cw'", keepusing(onetsoc soc6 onetsoc_title src) keep(master match)
assert _merge == 3                                       // 한국 task 전부 연계표에 있음
drop _merge
generate str2 soc_major = substr(onetsoc, 1, 2)
generate double w = cond(pct == 0, 0.0025, pct)
bysort month soc_major: egen double w_major = total(w)
generate double share_in_major = w / w_major
bysort month soc_major: egen double chk = total(share_in_major)
assert abs(chk - 1) < 1e-9
drop chk

* -----------------------------------------------------------------------------
* 3. 대분류 업무용 대화 비중 배분, 절감 시간
* -----------------------------------------------------------------------------
preserve
use "`shr'" if geo_id == "KOR", clear
keep month soc_major soc_major_title work_pct share_work
tempfile major
save `major'
restore
merge m:1 month soc_major using `major'
tabulate _merge
* _merge == 2: 공개된 task가 하나도 없는 대분류-월(그 비중은 task로 나뉘지 않음)
list month soc_major soc_major_title share_work if _merge == 2, noobs abbreviate(20)
assert _merge != 1
drop if _merge == 2
drop _merge

rename share_work share_work_major
generate double share_work = share_work_major * share_in_major

merge m:1 task_id using `gtime', keep(master match)
tabulate month _merge
generate byte has_time = _merge == 3
drop _merge
generate double saved_w = share_work * time_saved_min

* 대분류별 합계 확인: 배분된 task 비중 합 = 대분류 비중
preserve
collapse (sum) share_work (first) share_work_major, by(month soc_major)
assert reldif(share_work, share_work_major) < 1e-9
restore
tabstat share_work, by(month) statistics(sum) format(%9.6f)

label variable month           "월(YYYY-MM)"
label variable task_id         "O*NET Task ID"
label variable task_title      "Task 문장(AEI node_name)"
label variable onetsoc         "O*NET-SOC 8자리(task가 속한 직업)"
label variable onetsoc_title   "O*NET-SOC 직업 명칭(O*NET)"
label variable soc6            "SOC 2018 세부 직업 6자리"
label variable soc_major       "SOC 대분류 2자리"
label variable soc_major_title "SOC 대분류 명칭"
label variable src             "연계표 출처(1 = O*NET 31.0, 2 = Eloundou 보충)"
label variable pct             "AEI 한국 Claude.ai 대화 중 task 비중(%, 모든 use case)"
label variable w               "가중치(pct, 0.00은 0.0025)"
label variable w_major         "대분류 안 가중치 합"
label variable share_in_major  "대분류 안 task 비중"
label variable work_pct        "대분류 업무용 비중(%, AEI 한국)"
label variable has_time        "1 = GLOBAL task 절감 시간 있음"
label variable n_months_time   "절감 시간 평균에 쓴 GLOBAL 월 수"
label variable human_only_min    "AI 없이 걸리는 시간(분, GLOBAL, 두 달 pct 가중평균)"
label variable human_with_ai_min "AI와 함께 걸리는 시간(분, GLOBAL, 두 달 pct 가중평균)"
label variable time_saved_min    "대화당 절감 시간(분, GLOBAL)"
label variable share_work_major "대분류 업무용 대화 비중(AEI 한국)"
label variable share_work      "한국 업무용 대화 중 task 비중 = share_work_major × share_in_major"
label variable saved_w         "task 비중 × 대화당 절감 시간(분)"
order month task_id task_title onetsoc onetsoc_title soc6 soc_major soc_major_title src ///
    pct w w_major share_in_major work_pct share_work_major share_work has_time n_months_time ///
    human_only_min human_with_ai_min time_saved_min saved_w
sort month task_id
compress
tabulate month has_time
save "`out'/kor_task_conv_time_saved.dta", replace
export delimited using "`out'/kor_task_conv_time_saved.csv", replace
