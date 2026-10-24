* =============================================================================
* 04_08_analysis_kor_soc_top30_tasks.do
* 한국 SOC 세부 직업 상위 30개와 그 직업에 속한 모든 O*NET task
*   (1) SOC 업무용 대화 비중 상위 30, (2) SOC 대화 비중 × 절감 시간 상위 30
*   04_07_analysis_kor_task_top30.do(task를 먼저 고르고 SOC를 붙임)와 반대로, SOC를 먼저 고른다.
*
* 입력:
*   $proc/usage/anthropic_economic_index/aei_soc6_work_share.dta   (03_02_merge_aei_kor_soc_work_share.do)
*       지역 × 월 × soc6 업무용 대화 비중 share_work (KOR만 사용)
*   $proc/usage/anthropic_economic_index/aei_soc6_time_savings.dta
*       soc6 대화당 절감 시간 time_saved_min (GLOBAL, 2026-04·05 합침)
*   $proc/exposure/onet_task_statements/onet_task_soc.dta     Task ID → O*NET-SOC → soc6
*   $proc/merged/kor_task_conv_time_saved.dta                 월 × 한국 task 업무용 대화 비중·절감 시간 가중치
* 출력: $results/table/
*   26_kor_soc_top30_conv_tasks.xlsx    시트 soc(상위 30 직업), tasks(직업 × task)
*   26_kor_soc_top30_saved_tasks.xlsx   시트 soc, tasks
*
* 2026-10-24 재설계: 대화 건수(K = 3) 대신 한국 업무용 대화 비중을 쓴다. 두 달은 월별 비중의 단순평균(미공개 달은 0).
* SOC 순위: 자리표시 행 "NN-XXXX" 제외.
*   (1) soc_sw = SOC 업무용 대화 비중(%, 두 달 단순평균)
*   (2) soc_sv = soc_sw / 100 × time_saved_min (분; 03_03_merge_kor_conv_ai_ksco8.do의 saved_w와 같음)
*       절감 시간이 없는 SOC는 (2)에서 제외.
* 직업에 속한 task: onet_task_soc에서 soc6가 같은 task 전부(그 soc6의 O*NET-SOC 8자리 코드 모두).
*   O*NET 31.0 task(src = 1)는 모두 넣고, Eloundou 보충 task(src = 2, 31.0에서 빠진 task)는
*   한국 대화량이 공개된 경우만 넣는다.
*   task 값(한국 task 업무용 대화 비중, 비중 × 절감 시간)은 kor_task_conv_time_saved의 두 달 단순평균.
*   한국에 공개되지 않은 task는 값이 빈칸(kor_pub = 0; 0이 아니라 미공개).
* 주의: SOC 대화 비중(SOC 분류 pct 기준)과 그 SOC task 비중 합(task 분류 pct 기준)은 다르다.
*   두 값을 모두 둔다(soc_sw, soc_task_sw).
* 매칭 키: soc6(str7) = 대화량 파일 soc6 = aei_soc6_time_savings soc6 = substr(onetsoc, 1, 7); task_id.
* =============================================================================

version 17
clear all
set more off

if `"$root"'    == "" global root    "d:/research/AI_effects"
if `"$proc"'    == "" global proc    "$root/data/proc"
if `"$results"' == "" global results "$root/results"

local out "$results/table"

* -----------------------------------------------------------------------------
* 1. SOC 업무용 대화 비중·절감 시간 가중치(두 달 단순평균)
* -----------------------------------------------------------------------------
use "$proc/usage/anthropic_economic_index/aei_soc6_work_share.dta" if geo_id == "KOR", clear
drop if strpos(soc6, "X")
generate double sw_pct = 100 * share_work
keep month soc6 soc6_title soc_major_title_m sw_pct
merge m:1 soc6 using "$proc/usage/anthropic_economic_index/aei_soc6_time_savings.dta", ///
    keepusing(time_saved_min) keep(master match)
generate byte soc_has_time = _merge == 3
drop _merge
generate double sv = sw_pct / 100 * time_saved_min
generate byte one = 1
collapse (sum) soc_sw = sw_pct soc_sv = sv soc_n_months = one ///
    (first) soc6_title soc_major_title = soc_major_title_m soc_time_saved_min = time_saved_min soc_has_time, by(soc6)
isid soc6
replace soc_sw = soc_sw / 2
replace soc_sv = soc_sv / 2
replace soc_sv = . if !soc_has_time
count
quietly summarize soc_sw
generate double soc_conv_share = 100 * soc_sw / r(sum)
quietly summarize soc_sv
generate double soc_saved_share = 100 * soc_sv / r(sum)
tempfile soc
save `soc'

* -----------------------------------------------------------------------------
* 2. task 목록과 한국 task 값
* -----------------------------------------------------------------------------
use "$proc/merged/kor_task_conv_time_saved.dta", clear
generate byte one = 1
generate double sw_pct = 100 * share_work
collapse (sum) task_sw = sw_pct task_sv = saved_w task_n_months = one ///
    (first) task_has_time = has_time task_time_saved_min = time_saved_min, by(task_id)
replace task_sw = task_sw / 2
replace task_sv = task_sv / 2
replace task_sv = . if !task_has_time
generate byte kor_pub = 1
tempfile ktask
save `ktask'

use "$proc/exposure/onet_task_statements/onet_task_soc.dta", clear
keep task_id onetsoc onetsoc_title soc6 task task_type src
merge 1:1 task_id using `ktask', keep(master match) nogenerate
replace kor_pub = 0 if missing(kor_pub)
drop if src == 2 & !kor_pub
tempfile tasks
save `tasks'

* -----------------------------------------------------------------------------
* 3. 상위 30 SOC × task
* -----------------------------------------------------------------------------
foreach m in conv saved {
    use `soc', clear
    if "`m'" == "conv" local key soc_sw
    else {
        local key soc_sv
        keep if soc_has_time
    }
    gsort -`key' soc6
    generate int soc_rank = _n
    keep if soc_rank <= 30

    merge 1:m soc6 using `tasks', keep(master match)
    assert _merge == 3                                   // 상위 직업마다 task가 있음
    drop _merge
    bysort soc6: generate int soc_n_tasks = _N
    bysort soc6: egen int soc_n_tasks_kor = total(kor_pub)
    bysort soc6: egen double soc_task_sw = total(task_sw)
    bysort soc6: egen double soc_task_sv = total(task_sv)
    generate double task_share_in_soc = 100 * task_sw / soc_task_sw
    generate double task_saved_share_in_soc = 100 * task_sv / soc_task_sv
    if "`m'" == "conv" gsort soc_rank -task_sw task_id
    else               gsort soc_rank -task_sv -task_sw task_id
    * gsort 내림차순은 결측을 맨 뒤에 둔다 → 값이 있는 task만 순위
    if "`m'" == "conv" local rkv task_sw
    else               local rkv task_sv
    by soc_rank: generate int task_rank_in_soc = _n if !missing(`rkv')

    label variable soc_rank            "SOC 순위"
    label variable soc6                "SOC 2018 6자리"
    label variable soc6_title          "SOC 직업"
    label variable soc_major_title     "SOC 대분류"
    label variable soc_sw         "SOC 업무용 대화 비중(%, 두 달 단순평균)"
    label variable soc_conv_share      "SOC 대화 비중(%, 공개 SOC 합 = 100)"
    label variable soc_time_saved_min  "SOC 대화당 절감 시간(분, GLOBAL)"
    label variable soc_sv        "SOC 비중 × 대화당 절감 시간(분)"
    label variable soc_saved_share     "SOC 절감 시간 비중(%, 한국 SOC 합)"
    label variable soc_n_months        "SOC 공개 달 수"
    label variable soc_n_tasks         "SOC의 O*NET task 수"
    label variable soc_n_tasks_kor     "그중 한국 공개 task 수"
    label variable soc_task_sw    "SOC task 대화 비중 합(%, task 분류 기준)"
    label variable soc_task_sv   "SOC task 비중 × 절감 시간 합(task 분류 기준)"
    label variable task_rank_in_soc    "SOC 안 task 순위"
    label variable task_id             "O*NET Task ID"
    label variable onetsoc             "O*NET-SOC 코드"
    label variable onetsoc_title       "O*NET-SOC 직업"
    label variable task                "Task(O*NET)"
    label variable task_type           "Task Type"
    label variable src                 "연계표 출처(1 = O*NET 31.0, 2 = Eloundou 보충)"
    label variable kor_pub             "1 = 한국 공개 task"
    label variable task_n_months       "task 공개 달 수"
    label variable task_sw        "task 업무용 대화 비중(%, 두 달 단순평균)"
    label variable task_share_in_soc   "SOC task 대화 비중 중 몫(%)"
    label variable task_time_saved_min "task 대화당 절감 시간(분, GLOBAL)"
    label variable task_sv       "task 비중 × 대화당 절감 시간(분)"
    label variable task_saved_share_in_soc "SOC task 절감 시간 중 비중(%)"

    if "`m'" == "conv" {
        local socv  soc_rank soc6 soc6_title soc_major_title soc_sw soc_conv_share soc_time_saved_min ///
                    soc_sv soc_n_months soc_n_tasks soc_n_tasks_kor soc_task_sw
        local taskv task_rank_in_soc task_id onetsoc onetsoc_title task task_type src kor_pub task_n_months ///
                    task_sw task_share_in_soc task_time_saved_min task_sv
    }
    else {
        local socv  soc_rank soc6 soc6_title soc_major_title soc_sv soc_saved_share soc_sw ///
                    soc_time_saved_min soc_n_months soc_n_tasks soc_n_tasks_kor soc_task_sv
        local taskv task_rank_in_soc task_id onetsoc onetsoc_title task task_type src kor_pub task_n_months ///
                    task_sv task_saved_share_in_soc task_sw task_time_saved_min
    }
    keep `socv' `taskv'
    order `socv' `taskv'
    count
    tabulate kor_pub

    local f "`out'/26_kor_soc_top30_`m'_tasks.xlsx"
    export excel using "`f'", sheet("tasks") firstrow(varlabels) replace
    preserve
    bysort soc_rank: keep if _n == 1
    keep `socv'
    list soc_rank soc6 soc6_title soc_n_tasks soc_n_tasks_kor, noobs abbreviate(14)
    export excel using "`f'", sheet("soc") firstrow(varlabels) sheetreplace
    restore
}
