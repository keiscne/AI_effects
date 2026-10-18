* =============================================================================
* 04_analysis_kor_ai_share_index.do
* 한국 직업별 AI 점유율 지표 A~C (K 가정 없음, 직업 규모 분모 없음)   (paper 27)
*
* 입력: $proc/merged/kor_ai_usage_ksco3.dta   (03_merge_kor_ksco3_ai_usage.do, paper 25)
*   C = 소분류 월평균 업무용 대화 수(K = 3), S = 월평균 절감 시간(시간, SOC 단계 곱 후 배분),
*   emp = 2022년 상반기 취업자 수, H = 2022년 상반기 월 총 주업 근로시간, use1·use2 = 활용도 1·2
* 출력: $results/table/
*   27_kor_ai_share_index.xlsx   시트 ksco3(지표가 있는 소분류 전부), ksco1(대분류 합)
*   27_summary.tex, 27_top_fs.tex, 27_ksco1.tex   (paper 27 표)
*
* 지표(소분류 j, 합은 지표가 있는 소분류 전체):
*   A 대화 점유율          CS_j = C_j / Σ C
*   B 절감 시간 점유율     SS_j = S_j / Σ S
*   C 취업자 환산 점유율   FS_j = (S_j / hbar_j) / Σ (S / hbar),  hbar_j = H_j / emp_j (1인당 월 주업 시간)
*   C, S는 K에 반비례할 뿐이라 A~C는 K와 무관하다(K = 3 값을 그대로 써도 결과가 같음).
*   hbar는 직업 규모(취업자 수)가 아니라 1인당 시간이라 작은 직업을 키우지 않는다.
*   FS × X = 전국에서 X명분의 일이 AI로 대체될 때 j에 배분되는 인원(시나리오, 기본 표기 X = 10,000).
*   상한 점검: Xcap_j = emp_j / FS_j = j의 배분 인원이 j의 취업자 수와 같아지는 전국 X.
* 결정(작업자 판단): hbar는 paper 25와 같이 2022년 상반기 지역별고용조사, 주업 시간 기준.
* 매칭 키: ksco3(str3), ksco1 = 소분류의 대분류(kor_ai_usage_ksco3 변수).
* =============================================================================

version 17
clear all
set more off

if `"$root"'    == "" global root    "d:/research/AI_effects"
if `"$proc"'    == "" global proc    "$root/data/proc"
if `"$results"' == "" global results "$root/results"

local out "$results/table"
local xl  "`out'/27_kor_ai_share_index.xlsx"

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

* -----------------------------------------------------------------------------
* 1. 지표 계산
* -----------------------------------------------------------------------------
use "$proc/merged/kor_ai_usage_ksco3.dta", clear
keep ksco1 ksco1_title ksco3 ksco3_title emp H C S use1 use2 small conv_lb
count
keep if !missing(C)
assert !missing(S, emp, H) & emp > 0 & H > 0
count
local n3 = r(N)

generate double hbar = H / emp
generate double fte  = S / hbar                          // 절감 시간을 1인당 월 시간으로 나눈 인원 환산(K 비례)
foreach v in C S fte emp {
    quietly summarize `v'
    local tot_`v' = r(sum)
}
generate double CS = 100 * C   / `tot_C'
generate double SS = 100 * S   / `tot_S'
generate double FS = 100 * fte / `tot_fte'
generate double ES = 100 * emp / `tot_emp'               // 같은 129개 안 취업자 비중(비교용)
generate double fs_per10k = FS / 100 * 10000             // 전국 1만 명분일 때 배분 인원
generate double xcap = emp / (FS / 100)                  // 배분 인원 = 취업자 수가 되는 전국 X
foreach v in CS SS FS use1 use2 {
    egen int r_`v' = rank(-`v'), unique
}

* 확인: 점유율 합 100, FS ∝ use2 × emp
foreach v in CS SS FS {
    quietly summarize `v'
    assert abs(r(sum) - 100) < 1e-9
}
generate double chk = use2 * emp
quietly summarize chk
assert reldif(FS, 100 * chk / r(sum)) < 1e-9
drop chk

label variable ksco3      "KSCO 8차 소분류"
label variable ksco3_title "소분류 명칭"
label variable ksco1      "대분류"
label variable ksco1_title "대분류 명칭"
label variable emp        "취업자 수(2022 상반기)"
label variable H          "월 총 주업 근로시간(2022 상반기)"
label variable hbar       "1인당 월 주업 근로시간"
label variable C          "월평균 업무용 대화 수(K = 3, 참고)"
label variable S          "월평균 절감 시간(시간, K = 3, 참고)"
label variable fte        "S / hbar(K = 3, 참고)"
label variable CS         "A 대화 점유율(%)"
label variable SS         "B 절감 시간 점유율(%)"
label variable FS         "C 취업자 환산 절감 점유율(%)"
label variable ES         "취업자 비중(%, 같은 소분류 안)"
label variable fs_per10k  "전국 1만 명분일 때 배분 인원"
label variable xcap       "배분 인원이 취업자 수와 같아지는 전국 인원"
label variable use1       "활용도 1(paper 25)"
label variable use2       "활용도 2(%, paper 25)"
label variable r_CS       "A 순위"
label variable r_SS       "B 순위"
label variable r_FS       "C 순위"
label variable r_use1     "활용도 1 순위"
label variable r_use2     "활용도 2 순위"
label variable small      "1 = 2022 표본 수 < 30"
label variable conv_lb    "1 = 대화량 하한(일부 세분류만 공개)"
order ksco3 ksco3_title ksco1 ksco1_title CS SS FS ES r_CS r_SS r_FS r_use1 r_use2 fs_per10k xcap ///
    emp hbar use1 use2 C S fte H small conv_lb
gsort -FS ksco3
export excel using "`xl'", sheet("ksco3") firstrow(varlabels) replace
tempfile k3
save `k3'

* -----------------------------------------------------------------------------
* 2. 요약: 집중도, 순위상관, 상위 30 겹침, 상한
* -----------------------------------------------------------------------------
foreach v in CS SS FS ES {
    gsort -`v' ksco3
    quietly summarize `v' in 1/10
    local t10_`v' = r(sum)
    quietly summarize `v' in 1/30
    local t30_`v' = r(sum)
}
* 순위상관(Spearman)
local cv "CS SS FS use1 use2"
foreach a of local cv {
    foreach b of local cv {
        quietly spearman `a' `b'
        local rho_`a'_`b' = r(rho)
    }
}
* 상위 30 겹침
foreach a in CS SS use1 use2 {
    quietly count if r_FS <= 30 & r_`a' <= 30
    local ov_`a' = r(N)
}
* 가장 먼저 상한에 닿는 소분류
gsort xcap
local xcap_min = xcap[1]
local xcap_k   = ksco3[1] + " " + ksco3_title[1]
display "Xcap min = `xcap_min' (`xcap_k')"

tempname fh
file open `fh' using "`out'/27_summary.tex", write replace
file write `fh' "% 04_analysis_kor_ai_share_index.do가 생성. 직접 고치지 말 것." _n
local lab_CS "A 대화 점유율"
local lab_SS "B 절감 시간 점유율"
local lab_FS "C 취업자 환산 점유율"
local lab_ES "(참고) 취업자 비중"
foreach v in CS SS FS ES {
    fmt `t10_`v'' %5.1f
    local a "`r(s)'"
    fmt `t30_`v'' %5.1f
    local b "`r(s)'"
    if "`v'" == "ES" {
        local c "--"
        local d "--"
    }
    else {
        fmt `rho_`v'_use1' %5.2f
        local c "`r(s)'"
        fmt `rho_`v'_use2' %5.2f
        local d "`r(s)'"
    }
    file write `fh' "`lab_`v'' & `a' & `b' & `c' & `d' \\" _n
}
file close `fh'

* -----------------------------------------------------------------------------
* 3. 지표 C 상위 20 소분류
* -----------------------------------------------------------------------------
use `k3', clear
gsort -FS ksco3
file open `fh' using "`out'/27_top_fs.tex", write replace
file write `fh' "% 04_analysis_kor_ai_share_index.do가 생성. 직접 고치지 말 것." _n
forvalues i = 1/20 {
    fmt FS[`i'] %5.2f
    local a "`r(s)'"
    fmt fs_per10k[`i'] %6.0fc
    local b "`r(s)'"
    fmt CS[`i'] %5.2f
    local c "`r(s)'"
    fmt SS[`i'] %5.2f
    local d "`r(s)'"
    fmt emp[`i']/1000 %6.0fc
    local e "`r(s)'"
    file write `fh' "`i' & `=ksco3[`i']' `=ksco3_title[`i']' & `a' & `b' & `c' (`=r_CS[`i']') & `d' (`=r_SS[`i']') & `e' & `=r_use2[`i']' \\" _n
}
file close `fh'
list ksco3 ksco3_title FS CS SS r_CS r_SS r_use2 in 1/20, noobs abbreviate(12)

* -----------------------------------------------------------------------------
* 4. 대분류 합
* -----------------------------------------------------------------------------
collapse (sum) CS SS FS ES (count) n_ksco3 = CS, by(ksco1 ksco1_title)
label variable n_ksco3 "지표가 있는 소분류 수"
gsort -FS
export excel using "`xl'", sheet("ksco1") firstrow(varlabels) sheetreplace
sort ksco1
file open `fh' using "`out'/27_ksco1.tex", write replace
file write `fh' "% 04_analysis_kor_ai_share_index.do가 생성. 직접 고치지 말 것." _n
forvalues i = 1/`=_N' {
    fmt CS[`i'] %5.1f
    local a "`r(s)'"
    fmt SS[`i'] %5.1f
    local b "`r(s)'"
    fmt FS[`i'] %5.1f
    local c "`r(s)'"
    fmt ES[`i'] %5.1f
    local d "`r(s)'"
    file write `fh' "`=ksco1[`i']' `=ksco1_title[`i']' & `=n_ksco3[`i']' & `a' & `b' & `c' & `d' \\" _n
}
file close `fh'
list ksco1 ksco1_title n_ksco3 CS SS FS ES, noobs abbreviate(12)

display "n3=`n3' | top10 CS/SS/FS/ES = `t10_CS' `t10_SS' `t10_FS' `t10_ES' | top30 = `t30_CS' `t30_SS' `t30_FS' `t30_ES'"
display "rho CS-SS `rho_CS_SS' CS-FS `rho_CS_FS' SS-FS `rho_SS_FS' FS-use1 `rho_FS_use1' FS-use2 `rho_FS_use2'"
display "overlap top30 FS with CS `ov_CS' SS `ov_SS' use1 `ov_use1' use2 `ov_use2'"
