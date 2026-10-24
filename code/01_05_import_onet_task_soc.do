* =============================================================================
* 01_05_import_onet_task_soc.do
* O*NET task(Task ID) → O*NET-SOC 8자리 → SOC 2018 세부 직업(6자리) 연계표
*
* 입력:
*   $raw/exposure/onet_task_statements/db_31_0/Task Statements.xlsx   (O*NET 31.0, 기본)
*       열: O*NET-SOC Code, Title, Task ID, Task, Task Type, Incumbents Responding, Date, Domain Source
*       18,838개 task, O*NET-SOC 923개
*   $raw/exposure/eloundou_gpts_are_gpts/repo_2025_10_04/GPTs-are-GPTs-0471612fef3cc22b74fb884d27bff9dbd3770582/
*       data/full_onet_data.tsv   (보충: 31.0에 없는 task만)
*       열: (행 번호), O*NET-SOC Code, Task ID, Task, Task Type, Title, coreweight, equalweight
*       Eloundou et al.가 쓴 구버전 O*NET task 목록. 직업 분류는 31.0과 같은 O*NET-SOC(SOC 2018 기반).
* 출력: $proc/exposure/onet_task_statements/
*   onet_task_soc.{csv,dta}   행 = Task ID(유일)
*
* 원칙(작업자 판단):
*   - O*NET 31.0을 기본으로 하고, 31.0에서 빠진 task는 Eloundou 목록에서 보충(src = 2).
*     AEI release_2026_06_26의 task 3,319개 가운데 3개(예: 21000)가 31.0에 없고 Eloundou에만 있다.
*   - 두 자료가 겹치는 Task ID는 O*NET-SOC 코드가 모두 같은지 확인한다(assert).
*   - AEI release_2025_09_15의 onet_task_statements.csv는 쓰지 않는다. 구분류(O*NET-SOC 2010 기반)라
*     31.0과 겹치는 Task ID 가운데 1,979개의 O*NET-SOC 코드가 다르다.
*   - Task ID 하나는 O*NET-SOC 코드 하나에만 속한다(isid task_id). 반대로 같은 task 문장이
*     여러 직업에 다른 Task ID로 있을 수 있으므로 연결은 문장이 아닌 Task ID로 한다.
* 매칭 키: task_id(long) = AEI node_external_id(category "onet", hierarchy_level 0)의 숫자값
*          soc6(str7, XX-XXXX) = aei_soc6_time_savings의 soc6 = job_exposure occ_code
* =============================================================================

version 17
clear all
set more off

if `"$root"' == "" global root "d:/research/AI_effects"
if `"$raw"'  == "" global raw  "$root/data/raw"
if `"$proc"' == "" global proc "$root/data/proc"

local onet "$raw/exposure/onet_task_statements/db_31_0"
local elo  "$raw/exposure/eloundou_gpts_are_gpts/repo_2025_10_04/GPTs-are-GPTs-0471612fef3cc22b74fb884d27bff9dbd3770582/data"
local outf "$proc/exposure/onet_task_statements"
capture mkdir "$proc/exposure"
capture mkdir "`outf'"

* -----------------------------------------------------------------------------
* 1. O*NET 31.0 Task Statements
* -----------------------------------------------------------------------------
import excel using "`onet'/Task Statements.xlsx", firstrow clear allstring
describe, short
keep ONETSOCCode Title TaskID Task TaskType
rename (ONETSOCCode Title TaskID Task TaskType) (onetsoc onetsoc_title task_id_s task task_type)
foreach v of varlist _all {
    replace `v' = strtrim(`v')
}
generate long task_id = real(task_id_s)
assert !missing(task_id) & string(task_id, "%12.0f") == task_id_s
drop task_id_s
count
assert r(N) == 18838
assert regexm(onetsoc, "^[0-9][0-9]-[0-9][0-9][0-9][0-9]\.[0-9][0-9]$")
isid task_id
generate byte src = 1
tempfile o31
save `o31'

* -----------------------------------------------------------------------------
* 2. Eloundou O*NET task 목록(보충용)
* -----------------------------------------------------------------------------
import delimited using "`elo'/full_onet_data.tsv", delimiter(tab) varnames(1) ///
    stringcols(_all) bindquote(nobind) encoding("utf-8") clear
describe, short
rename (onetsoccode taskid task tasktype title) (onetsoc task_id_s task task_type onetsoc_title)
keep onetsoc task_id_s task task_type onetsoc_title
foreach v of varlist _all {
    replace `v' = strtrim(`v')
}
generate long task_id = real(task_id_s)                 // "8823.0" 형식
assert !missing(task_id) & task_id == floor(task_id)
drop task_id_s
assert regexm(onetsoc, "^[0-9][0-9]-[0-9][0-9][0-9][0-9]\.[0-9][0-9]$")
isid task_id

* 겹치는 Task ID의 O*NET-SOC 코드 일치 확인
rename onetsoc onetsoc_e
merge 1:1 task_id using `o31', keepusing(onetsoc) generate(_m31)
tabulate _m31
count if _m31 == 3 & onetsoc_e != onetsoc
assert r(N) == 0
count if _m31 == 1                                       // 31.0에 없는 task
assert r(N) == 530
keep if _m31 == 1
drop onetsoc _m31
rename onetsoc_e onetsoc
generate byte src = 2
tempfile elo_add
save `elo_add'

* -----------------------------------------------------------------------------
* 3. 결합과 SOC 6자리
* -----------------------------------------------------------------------------
use `o31', clear
append using `elo_add'
isid task_id
generate str7 soc6 = substr(onetsoc, 1, 7)
assert regexm(soc6, "^[0-9][0-9]-[0-9][0-9][0-9][0-9]$")
generate byte onet_suffix00 = substr(onetsoc, 9, 2) == "00"

label define src 1 "O*NET 31.0" 2 "Eloundou(구버전 O*NET, 31.0에 없음)"
label values src src
label variable task_id        "O*NET Task ID"
label variable onetsoc        "O*NET-SOC 8자리(XX-XXXX.XX)"
label variable onetsoc_title  "O*NET-SOC 직업 명칭"
label variable soc6           "SOC 2018 세부 직업 6자리(XX-XXXX)"
label variable onet_suffix00  "1 = O*NET-SOC 코드가 .00(SOC 세부 직업과 같은 단위)"
label variable task           "Task 문장"
label variable task_type      "Task Type(Core/Supplemental, 31.0 또는 Eloundou 원자료)"
label variable src            "출처"
order task_id onetsoc soc6 onetsoc_title onet_suffix00 task task_type src
sort task_id
compress

count
assert r(N) == 18838 + 530
tabulate src
quietly levelsof onetsoc
display "O*NET-SOC 수: " r(r)
quietly levelsof soc6
display "SOC 6자리 수: " r(r)

save "`outf'/onet_task_soc.dta", replace
export delimited using "`outf'/onet_task_soc.csv", replace
