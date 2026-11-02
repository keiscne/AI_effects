* =============================================================================
* 04_24_analysis_kor_share_construction.do
* 지표 A·B·C 산출 과정 노트(paper 40)의 표: 단계별 행 수·합계, SOC 예시 추적, 소분류 예시 추적
*
* 입력(모두 앞 단계 출력, 새로 계산하지 않고 단계별 값을 옮겨 적는다):
*   $proc/usage/anthropic_economic_index/aei_soc_work_share_major.dta      (03_02) 지역 × 월 × SOC 대분류
*   $proc/usage/anthropic_economic_index/aei_soc_work_share_detailed.dta   (03_02) 지역 × 월 × O*NET-SOC 8자리
*   $proc/usage/anthropic_economic_index/aei_soc6_work_share.dta           (03_02) 지역 × 월 × soc6
*   $proc/usage/anthropic_economic_index/aei_soc6_time_savings_monthly.dta (01_03) 월 × soc6 절감 시간
*   $proc/usage/anthropic_economic_index/aei_soc6_time_savings.dta         (01_03) soc6 절감 시간(두 달 통합)
*   $proc/merged/kor_soc6_conv_ai_indicators.dta    (03_03) 월 × soc6, saved_w
*   $proc/merged/kor_ksco8_conv_ai_indicators.dta   (03_03) 월 × ksco8
*   $proc/merged/kor_ksco3_conv_ai_indicators.dta   (03_03) 월 × ksco3
*   $proc/exposure/bls_soc_crosswalk/soc2018_ksco8_crosswalk.dta  (01_06) w_alloc
*   $proc/merged/kor_ai_usage_ksco3.dta             (03_05) 지표 A·B·C
* 출력: $results/table/
*   40_counts.tex   단계별 행 수와 합계(2026-04, 2026-05)
*   40_soc.tex      SOC 예시 2개(15-1252 소프트웨어 개발자, 27-3043 작가)의 대분류 → 세부 직업 → saved_w
*   40_cw.tex       예시 SOC의 연계표 배분 가중치 w_alloc
*   40_ksco3_a.tex  지표 A 상위 5개 소분류의 월별 원값 → 월별 점유율 → A
*   40_ksco3_bc.tex 같은 5개 소분류의 절감 시간 원값 → 월별 점유율 → B, 1인당 월 시간, B/hbar → C
* 매칭 키: month, soc6(str7), ksco8(str4), ksco3(str3). 각 파일의 키를 그대로 쓴다.
* =============================================================================

version 17
clear all
set more off

if `"$root"'    == "" global root    "d:/research/AI_effects"
if `"$proc"'    == "" global proc    "$root/data/proc"
if `"$results"' == "" global results "$root/results"

local aei "$proc/usage/anthropic_economic_index"
local out "$results/table"
local hdr "% 04_24_analysis_kor_share_construction.do가 생성. 직접 고치지 말 것."
local ex  "15-1252 27-3043"

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

tempname fh

* -----------------------------------------------------------------------------
* 1. 단계별 행 수와 합계(한국, 월별)
* -----------------------------------------------------------------------------
* 각 항목을 (이름, 04 값, 05 값, 형식)으로 모은다
tempname pf
tempfile cnt
postfile `pf' byte ord str120 item double(v04 v05) str8 f using `cnt'

use "`aei'/aei_soc_work_share_major.dta" if geo_id == "KOR", clear
foreach m in 04 05 {
    quietly count if month == "2026-`m'"
    local n`m' = r(N)
    quietly summarize pct_sum if month == "2026-`m'"
    local ps`m' = r(mean)
    quietly summarize work_pct_geo if month == "2026-`m'"
    local wg`m' = r(mean)
}
post `pf' (1) ("SOC 대분류 수") (`n04') (`n05') ("%9.0fc")
post `pf' (2) ("공개된 대분류 \texttt{pct} 합(\%)") (`ps04') (`ps05') ("%9.2f")
post `pf' (3) ("함의된 업무용 비중 \(\sum_g p_{gt} u_{gt} / \sum_g p_{gt}\)(\%)") (`wg04') (`wg05') ("%9.2f")

use "`aei'/aei_soc_work_share_detailed.dta" if geo_id == "KOR", clear
foreach m in 04 05 {
    quietly count if month == "2026-`m'" & !detail_missing
    local n`m' = r(N)
    quietly count if month == "2026-`m'" & detail_missing
    local d`m' = r(N)
}
post `pf' (4) ("공개된 O*NET-SOC 8자리 세부 직업 수") (`n04') (`n05') ("%9.0fc")
post `pf' (5) ("세부 직업이 하나도 공개되지 않은 대분류 수(자리표시 행)") (`d04') (`d05') ("%9.0fc")

use "`aei'/aei_soc6_work_share.dta" if geo_id == "KOR", clear
foreach m in 04 05 {
    quietly count if month == "2026-`m'"
    local n`m' = r(N)
}
post `pf' (6) ("한국 SOC 2018 6자리 행 수(자리표시 포함)") (`n04') (`n05') ("%9.0fc")

use "`aei'/aei_soc6_time_savings_monthly.dta", clear
foreach m in 04 05 {
    quietly count if month == "2026-`m'"
    local n`m' = r(N)
}
post `pf' (7) ("GLOBAL 절감 시간이 있는 6자리 직업 수(월별)") (`n04') (`n05') ("%9.0fc")
use "`aei'/aei_soc6_time_savings.dta", clear
quietly count
post `pf' (8) ("GLOBAL 절감 시간이 있는 6자리 직업 수(두 달 통합, 사용값)") (r(N)) (r(N)) ("%9.0fc")

use "$proc/merged/kor_soc6_conv_ai_indicators.dta", clear
foreach m in 04 05 {
    quietly count if month == "2026-`m'" & conv_pub
    local n`m' = r(N)
    quietly summarize share_work if month == "2026-`m'" & soc6 == "45-XXXX"
    local x`m' = cond(r(N) == 0, 0, r(sum))
    quietly summarize saved_w if month == "2026-`m'"
    local s`m' = r(sum)
}
post `pf' (9)  ("한국 비중이 공개된 6자리 직업 수") (`n04') (`n05') ("%9.0fc")
post `pf' (10) ("연계표에 없는 자리표시 행(45-XXXX)의 \(s_{ot}\)") (`x04') (`x05') ("%9.5f")
post `pf' (11) ("\(\sum_o v_{ot}\) = 한국 업무용 대화 1건당 평균 절감 시간(분)") (`s04') (`s05') ("%9.2f")

use "$proc/merged/kor_ksco8_conv_ai_indicators.dta", clear
foreach m in 04 05 {
    quietly count if month == "2026-`m'" & !missing(share_work)
    local n`m' = r(N)
}
post `pf' (12) ("값이 있는 KSCO 8차 세분류 수(494개 중)") (`n04') (`n05') ("%9.0fc")

use "$proc/merged/kor_ksco3_conv_ai_indicators.dta", clear
foreach m in 04 05 {
    quietly count if month == "2026-`m'" & !missing(share_work) & substr(ksco3, 1, 1) != "A"
    local n`m' = r(N)
}
post `pf' (13) ("값이 있는 KSCO 소분류 수(163개 중)") (`n04') (`n05') ("%9.0fc")

use "$proc/merged/kor_ai_usage_ksco3.dta", clear
foreach m in 04 05 {
    local sw`m' = tot_sw`m'[1]
    local sv`m' = tot_sv`m'[1]
}
post `pf' (14) ("정규화 분모 \(S^a_t = \sum_j s_{jt}\)") (`sw04') (`sw05') ("%9.5f")
post `pf' (15) ("정규화 분모 \(S^b_t = \sum_j v_{jt}\)(분)") (`sv04') (`sv05') ("%9.2f")
postclose `pf'

use `cnt', clear
sort ord
file open `fh' using "`out'/40_counts.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/`=_N' {
    local f = f[`i']
    fmt v04[`i'] `f'
    local a "`r(s)'"
    fmt v05[`i'] `f'
    file write `fh' `"`=item[`i']' & `a' & `r(s)' \\"' _n
}
file close `fh'

* -----------------------------------------------------------------------------
* 2. SOC 예시: 대분류 → 세부 직업 → 6자리 → saved_w
* -----------------------------------------------------------------------------
use "`aei'/aei_soc_work_share_major.dta" if geo_id == "KOR" & inlist(soc_major, "15", "27"), clear
keep month soc_major pct work_pct work_w share_work
rename (pct work_pct work_w share_work) (pM wM wwM swM)
tempfile mj
save `mj'
use "`aei'/aei_soc6_work_share.dta" if geo_id == "KOR" & inlist(soc6, "15-1252", "27-3043"), clear
keep month soc6 soc_major pct pct_major_sum share_in_major share_work
merge m:1 month soc_major using `mj', keep(match) nogenerate
merge 1:1 month soc6 using "$proc/merged/kor_soc6_conv_ai_indicators.dta", keep(match) nogenerate ///
    keepusing(time_saved_min human_only_min human_with_ai_min saved_w)
sort soc6 month
assert _N == 4
local rows "pM wM swM pct pct_major_sum share_in_major share_work human_only_min human_with_ai_min time_saved_min saved_w"
local fm "%9.2f %9.2f %9.4f %9.2f %9.2f %9.4f %9.5f %9.2f %9.2f %9.2f %9.4f"
local lab1  "(1) 대분류 \(p_{gt}\)(\%)"
local lab2  "(2) 대분류 \(u_{gt}\)(업무용 비중, \%)"
local lab3  "(3) 대분류 \(s_{gt}\)"
local lab4  "(4) 세부 직업 \(p_{dt}\)(\%, 8자리 합)"
local lab5  "(5) 같은 대분류 공개 세부 직업 \(\sum_{d'} p_{d't}\)(\%)"
local lab6  "(6) 대분류 안 비중 \(\pi_{dt}\) = (4)/(5)"
local lab7  "(7) 6자리 \(s_{ot}\) = (3) \(\times\) (6)"
local lab8  "(8) \(T^{0}_o\) 사람만(분, 두 달 통합)"
local lab9  "(9) \(T^{AI}_o\) AI와 함께(분)"
local lab10 "(10) \(\tau_o\) = (8) \(-\) (9)(분)"
local lab11 "(11) \(v_{ot}\) = (7) \(\times\) (10)(분)"
file open `fh' using "`out'/40_soc.tex", write replace
file write `fh' "`hdr'" _n
local k = 0
foreach v of local rows {
    local ++k
    local row "`lab`k''"
    forvalues i = 1/4 {
        fmt `v'[`i'] `: word `k' of `fm''
        local row "`row' & `r(s)'"
    }
    file write `fh' "`row' \\" _n
}
file close `fh'

* 연계표 배분 가중치(예시 SOC)
use "$proc/exposure/bls_soc_crosswalk/soc2018_ksco8_crosswalk.dta" if inlist(soc2018, "15-1252", "27-3043"), clear
sort soc2018 ksco8
file open `fh' using "`out'/40_cw.tex", write replace
file write `fh' "`hdr'" _n
forvalues i = 1/`=_N' {
    fmt w_alloc[`i'] %9.4f
    local a "`r(s)'"
    fmt w_mean[`i'] %9.4f
    file write `fh' `"`=soc2018[`i']' & `=ksco8[`i']' `=ksco8_title[`i']' & `=substr(ksco8[`i'], 1, 3)' & `a' & `r(s)' \\"' _n
}
file close `fh'

* -----------------------------------------------------------------------------
* 3. 소분류 예시: 지표 A 상위 5개
* -----------------------------------------------------------------------------
* 마지막 줄 = 163개 합계(원값 합 = 정규화 분모, 점유율 합 = 100). hbar 열의 합계 칸은
*   B 가중 조화평균 100 / Σ(B/hbar): 이보다 1인당 시간이 짧은 소분류는 C > B, 긴 소분류는 C < B.
use "$proc/merged/kor_ai_usage_ksco3.dta", clear
assert _N == 163
generate double fte = shB / hbar
quietly summarize fte
local sfte = r(sum)
local tot_a "`: display %9.5f tot_sw04[1]' & `: display %9.5f tot_sw05[1]' & 100 & 100 & 100"
local tot_bc "`: display %9.3f tot_sv04[1]' & `: display %9.3f tot_sv05[1]' & 100 & 100 & 100 & `: display %9.1f 100 / `sfte'' & `: display %9.4f `sfte'' & 100"
gsort -shA ksco3
keep in 1/5
foreach t in a bc {
    if "`t'" == "a" {
        local cols "sw04 sw05 p_sw04 p_sw05 shA"
        local fm   "%9.5f %9.5f %9.3f %9.3f %9.3f"
    }
    else {
        local cols "sv04 sv05 p_sv04 p_sv05 shB hbar fte shC"
        local fm   "%9.3f %9.3f %9.3f %9.3f %9.3f %9.1f %9.4f %9.3f"
    }
    file open `fh' using "`out'/40_ksco3_`t'.tex", write replace
    file write `fh' "`hdr'" _n
    forvalues i = 1/5 {
        local row "`=ksco3[`i']' `=ksco3_title[`i']'"
        local k = 0
        foreach v of local cols {
            local ++k
            fmt `v'[`i'] `: word `k' of `fm''
            local row "`row' & `r(s)'"
        }
        file write `fh' "`row' \\" _n
    }
    file write `fh' "\midrule" _n
    local tt = stritrim("`tot_`t''")
    file write `fh' "163개 합계 & `tt' \\" _n
    file close `fh'
}
display "done"
