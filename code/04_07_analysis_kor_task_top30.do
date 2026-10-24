* =============================================================================
* 04_07_analysis_kor_task_top30.do
* 한국 직업-task 상위 30개: (1) 업무용 대화 비중, (2) 대화 비중 × 절감 시간
*
* 입력: $proc/merged/kor_task_conv_time_saved.dta   (03_04_merge_kor_task_conv_time_saved.do)
* 출력: $results/table/
*   26_kor_task_top30_conv.xlsx    업무용 대화 비중 상위 30개 task
*   26_kor_task_top30_saved.xlsx   비중 × 대화당 절감 시간 상위 30개 task
*
* 2026-10-24 재설계: 대화 건수(K = 3) 대신 한국 업무용 대화 중 task 비중(share_work)을 쓴다.
*   두 달은 월별 비중의 단순평균(미공개 달은 0; paper 25·27과 같음). 순위는 예전 건수 기준과 거의 같다.
*   (2)는 GLOBAL 절감 시간이 있는 task만 대상. 비중(%)의 분모는 같은 기준 전체 task 합.
* =============================================================================

version 17
clear all
set more off

if `"$root"'    == "" global root    "d:/research/AI_effects"
if `"$proc"'    == "" global proc    "$root/data/proc"
if `"$results"' == "" global results "$root/results"

local out "$results/table"

use "$proc/merged/kor_task_conv_time_saved.dta", clear
generate byte one = 1
collapse (mean) pct (sum) sw = share_work saved_w n_months = one ///
    (first) task_title onetsoc onetsoc_title soc6 soc_major soc_major_title has_time time_saved_min, by(task_id)
isid task_id
replace sw = 100 * sw / 2                      // 두 달 단순평균(%, 한국 업무용 대화 중)
replace saved_w = saved_w / 2
replace saved_w = . if !has_time
count
tempfile avg
save `avg'

* -----------------------------------------------------------------------------
* (1) 대화량 상위 30
* -----------------------------------------------------------------------------
use `avg', clear
quietly summarize sw
generate double conv_share = 100 * sw / r(sum)
gsort -sw task_id
generate int rank = _n
generate double conv_share_cum = sum(conv_share)
keep if rank <= 30
keep rank task_id task_title onetsoc onetsoc_title soc6 soc_major_title sw conv_share conv_share_cum ///
    pct n_months time_saved_min saved_w
order rank task_id task_title onetsoc onetsoc_title soc6 soc_major_title sw conv_share conv_share_cum ///
    pct n_months time_saved_min saved_w
label variable rank           "순위"
label variable task_id        "O*NET Task ID"
label variable task_title     "Task"
label variable onetsoc        "O*NET-SOC 코드"
label variable onetsoc_title  "직업(O*NET-SOC)"
label variable soc6           "SOC 2018 6자리"
label variable soc_major_title "SOC 대분류"
label variable sw        "한국 업무용 대화 중 비중(%, 두 달 단순평균)"
label variable conv_share     "공개 task 대화 비중 합 중 비중(%)"
label variable conv_share_cum "누적 비중(%)"
label variable pct            "AEI 한국 task 비중(%, 월평균)"
label variable n_months       "공개된 달 수(2026-04·05)"
label variable time_saved_min "대화당 절감 시간(분, GLOBAL)"
label variable saved_w    "비중 × 대화당 절감 시간(분, 두 달 평균)"
list rank task_id onetsoc sw conv_share, noobs abbreviate(12)
export excel using "`out'/26_kor_task_top30_conv.xlsx", sheet("top30_conv") firstrow(varlabels) replace

* -----------------------------------------------------------------------------
* (2) 대화량 × 절감 시간 상위 30
* -----------------------------------------------------------------------------
use `avg', clear
keep if has_time
quietly summarize saved_w
generate double saved_share = 100 * saved_w / r(sum)
gsort -saved_w task_id
generate int rank = _n
generate double saved_share_cum = sum(saved_share)
keep if rank <= 30
keep rank task_id task_title onetsoc onetsoc_title soc6 soc_major_title saved_w saved_share saved_share_cum ///
    sw time_saved_min pct n_months
order rank task_id task_title onetsoc onetsoc_title soc6 soc_major_title saved_w saved_share saved_share_cum ///
    sw time_saved_min pct n_months
label variable rank            "순위"
label variable task_id         "O*NET Task ID"
label variable task_title      "Task"
label variable onetsoc         "O*NET-SOC 코드"
label variable onetsoc_title   "직업(O*NET-SOC)"
label variable soc6            "SOC 2018 6자리"
label variable soc_major_title "SOC 대분류"
label variable saved_w     "비중 × 대화당 절감 시간(분, 두 달 평균)"
label variable saved_share     "한국 task 절감 시간 중 비중(%)"
label variable saved_share_cum "누적 비중(%)"
label variable sw         "한국 업무용 대화 중 비중(%, 두 달 단순평균)"
label variable time_saved_min  "대화당 절감 시간(분, GLOBAL)"
label variable pct             "AEI 한국 task 비중(%, 월평균)"
label variable n_months        "공개된 달 수(2026-04·05)"
list rank task_id onetsoc saved_w time_saved_min, noobs abbreviate(12)
export excel using "`out'/26_kor_task_top30_saved.xlsx", sheet("top30_saved") firstrow(varlabels) replace
