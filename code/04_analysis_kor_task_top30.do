* =============================================================================
* 04_analysis_kor_task_top30.do
* 한국 직업-task 상위 30개: (1) 업무용 대화량, (2) 대화량 × 절감 시간
*
* 입력: $proc/merged/kor_task_conv_time_saved.dta   (03_merge_kor_task_conv_time_saved.do)
* 출력: $results/table/
*   26_kor_task_top30_conv.xlsx    월평균 업무용 대화 수(K = 3) 상위 30개 task
*   26_kor_task_top30_saved.xlsx   월평균 절감 시간(대화 수 × 대화당 절감 시간, K = 3) 상위 30개 task
*
* 기준(paper 25와 같음): 2026-04·05 월평균, task가 공개된 달만 평균(미공개 ≠ 0), K = 3.
*   K는 대화 수를 비례로 바꿀 뿐이라 순위와 비중(%)은 K와 무관하다.
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
collapse (mean) pct conv_k3 saved_hr_k3 (sum) n_months = one ///
    (first) task_title onetsoc onetsoc_title soc6 soc_major soc_major_title has_time time_saved_min, by(task_id)
isid task_id
replace saved_hr_k3 = . if !has_time
count
tempfile avg
save `avg'

* -----------------------------------------------------------------------------
* (1) 대화량 상위 30
* -----------------------------------------------------------------------------
use `avg', clear
quietly summarize conv_k3
generate double conv_share = 100 * conv_k3 / r(sum)
gsort -conv_k3 task_id
generate int rank = _n
generate double conv_share_cum = sum(conv_share)
keep if rank <= 30
keep rank task_id task_title onetsoc onetsoc_title soc6 soc_major_title conv_k3 conv_share conv_share_cum ///
    pct n_months time_saved_min saved_hr_k3
order rank task_id task_title onetsoc onetsoc_title soc6 soc_major_title conv_k3 conv_share conv_share_cum ///
    pct n_months time_saved_min saved_hr_k3
label variable rank           "순위"
label variable task_id        "O*NET Task ID"
label variable task_title     "Task"
label variable onetsoc        "O*NET-SOC 코드"
label variable onetsoc_title  "직업(O*NET-SOC)"
label variable soc6           "SOC 2018 6자리"
label variable soc_major_title "SOC 대분류"
label variable conv_k3        "월평균 업무용 대화 수(K = 3)"
label variable conv_share     "한국 task 대화량 중 비중(%)"
label variable conv_share_cum "누적 비중(%)"
label variable pct            "AEI 한국 task 비중(%, 월평균)"
label variable n_months       "공개된 달 수(2026-04·05)"
label variable time_saved_min "대화당 절감 시간(분, GLOBAL)"
label variable saved_hr_k3    "월평균 절감 시간(시간, K = 3)"
list rank task_id onetsoc conv_k3 conv_share, noobs abbreviate(12)
export excel using "`out'/26_kor_task_top30_conv.xlsx", sheet("top30_conv") firstrow(varlabels) replace

* -----------------------------------------------------------------------------
* (2) 대화량 × 절감 시간 상위 30
* -----------------------------------------------------------------------------
use `avg', clear
keep if has_time
quietly summarize saved_hr_k3
generate double saved_share = 100 * saved_hr_k3 / r(sum)
gsort -saved_hr_k3 task_id
generate int rank = _n
generate double saved_share_cum = sum(saved_share)
keep if rank <= 30
keep rank task_id task_title onetsoc onetsoc_title soc6 soc_major_title saved_hr_k3 saved_share saved_share_cum ///
    conv_k3 time_saved_min pct n_months
order rank task_id task_title onetsoc onetsoc_title soc6 soc_major_title saved_hr_k3 saved_share saved_share_cum ///
    conv_k3 time_saved_min pct n_months
label variable rank            "순위"
label variable task_id         "O*NET Task ID"
label variable task_title      "Task"
label variable onetsoc         "O*NET-SOC 코드"
label variable onetsoc_title   "직업(O*NET-SOC)"
label variable soc6            "SOC 2018 6자리"
label variable soc_major_title "SOC 대분류"
label variable saved_hr_k3     "월평균 절감 시간(시간, K = 3) = 대화 수 × 대화당 절감 시간"
label variable saved_share     "한국 task 절감 시간 중 비중(%)"
label variable saved_share_cum "누적 비중(%)"
label variable conv_k3         "월평균 업무용 대화 수(K = 3)"
label variable time_saved_min  "대화당 절감 시간(분, GLOBAL)"
label variable pct             "AEI 한국 task 비중(%, 월평균)"
label variable n_months        "공개된 달 수(2026-04·05)"
list rank task_id onetsoc saved_hr_k3 time_saved_min, noobs abbreviate(12)
export excel using "`out'/26_kor_task_top30_saved.xlsx", sheet("top30_saved") firstrow(varlabels) replace
