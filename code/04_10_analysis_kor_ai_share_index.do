* =============================================================================
* 04_10_analysis_kor_ai_share_index.do
* 한국 직업별 AI 점유율 지표 A~C와 한국 특화도 지표 D   (paper 27)
*
* 2026-10-24 재설계: 지표는 03_05_merge_kor_ksco3_ai_usage.do가 AEI 업무용 대화 비중에서 직접 만든다
*   (대화 총량·K 없음, 두 달은 월별 비중 단순평균). 이 파일은 요약표만 만든다. 지표 D를 추가했다.
*
* 입력: $proc/merged/kor_ai_usage_ksco3.dta   (03_05_merge_kor_ksco3_ai_usage.do)
*   shA, shB, shC(%), spD, shA0, shA_glb, es, emp, hbar, ru1, ru2, small, conv_lb
* 출력: $results/table/
*   27_kor_ai_share_index.xlsx   시트 ksco3(지표가 있는 소분류 전부), ksco2(중분류 합), ksco1(대분류 합), top_d
*   27_summary.tex, 27_top_fs.tex, 27_ksco1.tex, 27_dstats.tex, 27_top_d.tex   (paper 27 표)
*
* 지표(소분류 j, 지표 표본 129개; 정의는 03_05 머리말):
*   A 대화 점유율 shA, B 절감 시간 점유율 shB, C 취업자 환산 절감 점유율 shC(= (B / hbar) 정규화)
*   D 한국 특화도 spD = shA / shA_glb(같은 SOC→KSCO 배분을 GLOBAL 비중에 적용한 값과의 비)
*   (참고) A0 = 모든 use case 비중으로 만든 A
*   shC × X / 100 = 전국에서 X명분의 일이 AI로 대체될 때 j에 배분되는 인원(시나리오, 기본 표기 X = 10,000).
*   상한 점검: Xcap_j = emp_j / (shC_j / 100) = j의 배분 인원이 j의 취업자 수와 같아지는 전국 X.
* D 목록(27_top_d): 점유율이 작은 소분류는 D가 크게 흔들리므로 A ≥ 0.1%인 소분류만 순위를 매긴다(작업자 판단).
* 매칭 키: ksco3(str3), ksco2·ksco1 = 소분류의 중분류·대분류(kor_ai_usage_ksco3 변수).
* =============================================================================

version 17
clear all
set more off

if `"$root"'    == "" global root    "d:/research/AI_effects"
if `"$proc"'    == "" global proc    "$root/data/proc"
if `"$results"' == "" global results "$root/results"

local out "$results/table"
local xl  "`out'/27_kor_ai_share_index.xlsx"
local dmin 0.1

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
* 1. 지표
* -----------------------------------------------------------------------------
use "$proc/merged/kor_ai_usage_ksco3.dta", clear
keep ksco1 ksco1_title ksco2 ksco2_title ksco3 ksco3_title emp hbar in_share shA shB shC spD shA0 shA_glb es ///
    ru1 ru2 small conv_lb n_month_conv
count
keep if in_share
assert !missing(shA, shB, shC, spD, emp, hbar) & emp > 0
count
local n3 = r(N)

quietly summarize emp
generate double ES = 100 * emp / r(sum)                 // 같은 129개 안 취업자 비중(비교용)
generate double fs_per10k = shC / 100 * 10000          // 전국 1만 명분일 때 배분 인원
generate double xcap = emp / (shC / 100)               // 배분 인원 = 취업자 수가 되는 전국 X
foreach v in shA shB shC spD shA0 ru1 ru2 {
    egen int r_`v' = rank(-`v'), unique
}

* 확인: 점유율 합 100
foreach v in shA shB shC shA0 shA_glb {
    quietly summarize `v'
    assert abs(r(sum) - 100) < 1e-9
}

label variable ksco3      "KSCO 8차 소분류"
label variable ksco3_title "소분류 명칭"
label variable ksco1      "대분류"
label variable ksco1_title "대분류 명칭"
label variable ksco2      "중분류"
label variable ksco2_title "중분류 명칭"
label variable emp        "취업자 수(2022 상반기)"
label variable hbar       "1인당 월 주업 근로시간"
label variable shA        "A 대화 점유율(%)"
label variable shB        "B 절감 시간 점유율(%)"
label variable shC        "C 취업자 환산 절감 점유율(%)"
label variable spD        "D 한국 특화도(A / GLOBAL A)"
label variable shA0       "(참고) A0 모든 use case 대화 점유율(%)"
label variable shA_glb    "GLOBAL 대화 점유율(%)"
label variable ES         "취업자 비중(%, 같은 소분류 안)"
label variable es         "취업자 비중(%, 163개 전체)"
label variable fs_per10k  "전국 1만 명분일 때 배분 인원"
label variable xcap       "배분 인원이 취업자 수와 같아지는 전국 인원"
label variable ru1        "상대 활용도 1(paper 25)"
label variable ru2        "상대 활용도 2(paper 25)"
label variable r_shA      "A 순위"
label variable r_shB      "B 순위"
label variable r_shC      "C 순위"
label variable r_spD      "D 순위"
label variable r_shA0     "A0 순위"
label variable r_ru1      "RU1 순위"
label variable r_ru2      "RU2 순위"
label variable small      "1 = 2022 표본 수 < 30"
label variable conv_lb    "1 = 대화 비중 하한(일부 세분류만 공개)"
label variable n_month_conv "한국 비중이 있는 달 수"
order ksco3 ksco3_title ksco2 ksco2_title ksco1 ksco1_title shA shB shC spD shA_glb shA0 ES r_shA r_shB r_shC r_spD r_shA0 ///
    r_ru1 r_ru2 fs_per10k xcap emp hbar ru1 ru2 small conv_lb n_month_conv
drop in_share es
gsort -shC ksco3
export excel using "`xl'", sheet("ksco3") firstrow(varlabels) replace
tempfile k3
save `k3'

* -----------------------------------------------------------------------------
* 2. 요약: 집중도, 순위상관, 상위 30 겹침, 상한
* -----------------------------------------------------------------------------
foreach v in shA shB shC shA0 ES {
    gsort -`v' ksco3
    quietly summarize `v' in 1/10
    local t10_`v' = r(sum)
    quietly summarize `v' in 1/30
    local t30_`v' = r(sum)
}
* 순위상관(Spearman)
local cv "shA shB shC shA0 ru1 ru2 spD"
foreach a of local cv {
    foreach b of local cv {
        quietly spearman `a' `b'
        local rho_`a'_`b' = r(rho)
    }
}
* 상위 30 겹침
foreach a in shA shB shA0 ru1 ru2 {
    quietly count if r_shC <= 30 & r_`a' <= 30
    local ov_`a' = r(N)
}
quietly count if r_shA <= 30 & r_shA0 <= 30
local ov_A_A0 = r(N)
* 가장 먼저 상한에 닿는 소분류
gsort xcap
local xcap_min = xcap[1]
local xcap_k   = ksco3[1] + " " + ksco3_title[1]
display "Xcap min = `xcap_min' (`xcap_k')"

tempname fh
file open `fh' using "`out'/27_summary.tex", write replace
file write `fh' "% 04_10_analysis_kor_ai_share_index.do가 생성. 직접 고치지 말 것." _n
local lab_shA  "A 대화 점유율"
local lab_shB  "B 절감 시간 점유율"
local lab_shC  "C 취업자 환산 점유율"
local lab_shA0 "(참고) A0 모든 use case 대화 점유율"
local lab_ES   "(참고) 취업자 비중"
foreach v in shA shB shC shA0 ES {
    fmt `t10_`v'' %5.1f
    local a "`r(s)'"
    fmt `t30_`v'' %5.1f
    local b "`r(s)'"
    if "`v'" == "ES" {
        local c "--"
        local d "--"
    }
    else {
        fmt `rho_`v'_ru1' %5.2f
        local c "`r(s)'"
        fmt `rho_`v'_ru2' %5.2f
        local d "`r(s)'"
    }
    file write `fh' "`lab_`v'' & `a' & `b' & `c' & `d' \\" _n
}
file close `fh'

* -----------------------------------------------------------------------------
* 3. 지표 C 상위 20 소분류
* -----------------------------------------------------------------------------
use `k3', clear
gsort -shC ksco3
file open `fh' using "`out'/27_top_fs.tex", write replace
file write `fh' "% 04_10_analysis_kor_ai_share_index.do가 생성. 직접 고치지 말 것." _n
forvalues i = 1/20 {
    fmt shC[`i'] %5.2f
    local a "`r(s)'"
    fmt fs_per10k[`i'] %6.0fc
    local b "`r(s)'"
    fmt shA[`i'] %5.2f
    local c "`r(s)'"
    fmt shB[`i'] %5.2f
    local d "`r(s)'"
    fmt emp[`i']/1000 %6.0fc
    local e "`r(s)'"
    fmt spD[`i'] %5.2f
    local g "`r(s)'"
    file write `fh' "`i' & `=ksco3[`i']' `=ksco3_title[`i']' & `a' & `b' & `c' (`=r_shA[`i']') & `d' (`=r_shB[`i']') & `e' & `=r_ru2[`i']' & `g' \\" _n
}
file close `fh'
list ksco3 ksco3_title shC shA shB r_shA r_shB r_ru2 spD in 1/20, noobs abbreviate(12)

* -----------------------------------------------------------------------------
* 4. 지표 D: 분포와 목록(A ≥ dmin%)
* -----------------------------------------------------------------------------
use `k3', clear
quietly summarize spD, detail
local d_p10 = r(p10)
local d_p50 = r(p50)
local d_p90 = r(p90)
local d_min = r(min)
local d_max = r(max)
* 한국 A 가중 평균(= Σ shA × D / 100), GLOBAL A 가중 평균은 정의상 1
generate double wD = shA * spD
quietly summarize wD
local d_wA = r(sum) / 100
drop wD
quietly count if spD > 1
local d_gt1 = r(N)
quietly summarize shA if spD > 1
local d_gt1A = r(sum)
quietly count if shA >= `dmin'
local d_n = r(N)
quietly summarize spD if shA >= `dmin', detail
local d_p10b = r(p10)
local d_p90b = r(p90)
file open `fh' using "`out'/27_dstats.tex", write replace
file write `fh' "% 04_10_analysis_kor_ai_share_index.do가 생성. 직접 고치지 말 것." _n
fmt `d_p50' %5.2f
file write `fh' "D 중앙값(129개) & `r(s)' \\" _n
fmt `d_p10' %5.2f
local a "`r(s)'"
fmt `d_p90' %5.2f
file write `fh' "D 10분위 / 90분위(129개) & `a' / `r(s)' \\" _n
fmt `d_min' %5.2f
local a "`r(s)'"
fmt `d_max' %5.2f
file write `fh' "D 최솟값 / 최댓값(129개) & `a' / `r(s)' \\" _n
fmt `d_p10b' %5.2f
local a "`r(s)'"
fmt `d_p90b' %5.2f
file write `fh' "D 10분위 / 90분위(A \$\ge\$ `dmin'\% 소분류 `d_n'개) & `a' / `r(s)' \\" _n
fmt `d_gt1A' %5.1f
file write `fh' "D \$>\$ 1인 소분류 수(한국 A 합, \%) & `d_gt1' (`r(s)') \\" _n
fmt `d_wA' %5.2f
file write `fh' "한국 A로 가중한 D 평균 & `r(s)' \\" _n
fmt `rho_shA_spD' %5.2f
file write `fh' "D와 A의 Spearman 순위상관 & `r(s)' \\" _n
fmt `rho_ru1_spD' %5.2f
file write `fh' "D와 RU1의 Spearman 순위상관 & `r(s)' \\" _n
fmt `rho_shA_shA0' %5.3f
file write `fh' "A와 A0의 Spearman 순위상관 & `r(s)' \\" _n
file write `fh' "A와 A0의 상위 30 겹침(개) & `ov_A_A0' \\" _n
file close `fh'

keep if shA >= `dmin'
egen int r_d_sub = rank(-spD), unique
generate byte side = .
quietly count
local nd = r(N)
replace side = 1 if r_d_sub <= 15
replace side = 2 if r_d_sub > `nd' - 15
keep if !missing(side)
gsort side -spD ksco3
export excel ksco3 ksco3_title side spD shA r_shA shA_glb emp using "`xl'", sheet("top_d") firstrow(varlabels) sheetreplace
file open `fh' using "`out'/27_top_d.tex", write replace
file write `fh' "% 04_10_analysis_kor_ai_share_index.do가 생성. 직접 고치지 말 것." _n
forvalues i = 1/`=_N' {
    if `i' > 1 & side[`i'] != side[`i'-1] file write `fh' "\midrule" _n
    fmt spD[`i'] %5.2f
    local a "`r(s)'"
    fmt shA[`i'] %5.2f
    local b "`r(s)'"
    fmt shA_glb[`i'] %5.2f
    local c "`r(s)'"
    fmt emp[`i']/1000 %6.0fc
    local e "`r(s)'"
    file write `fh' "`=ksco3[`i']' `=ksco3_title[`i']' & `a' & `b' (`=r_shA[`i']') & `c' & `e' \\" _n
}
file close `fh'
list ksco3 ksco3_title side spD shA shA_glb, noobs abbreviate(12)

* -----------------------------------------------------------------------------
* 5. 중분류 합(엑셀 시트만)
* -----------------------------------------------------------------------------
use `k3', clear
preserve
collapse (sum) shA shB shC shA_glb ES (count) n_ksco3 = shA, by(ksco2 ksco2_title ksco1 ksco1_title)
isid ksco2
generate double spD = shA / shA_glb
foreach v in shA shB shC {
    egen int r_`v' = rank(-`v'), unique
}
label variable ksco2       "중분류"
label variable ksco2_title "중분류 명칭"
label variable ksco1       "대분류"
label variable ksco1_title "대분류 명칭"
label variable shA         "A 대화 점유율(%)"
label variable shB         "B 절감 시간 점유율(%)"
label variable shC         "C 취업자 환산 절감 점유율(%)"
label variable spD         "D 한국 특화도"
label variable shA_glb     "GLOBAL 대화 점유율(%)"
label variable ES          "취업자 비중(%, 지표가 있는 소분류 안)"
label variable n_ksco3     "지표가 있는 소분류 수"
label variable r_shA       "A 순위"
label variable r_shB       "B 순위"
label variable r_shC       "C 순위"
order ksco2 ksco2_title ksco1 ksco1_title shA shB shC spD shA_glb ES r_shA r_shB r_shC n_ksco3
gsort -shC
export excel using "`xl'", sheet("ksco2") firstrow(varlabels) sheetreplace
count
list ksco2 ksco2_title shA shB shC spD ES in 1/10, noobs abbreviate(12)
restore

* -----------------------------------------------------------------------------
* 6. 대분류 합
* -----------------------------------------------------------------------------
collapse (sum) shA shB shC shA_glb ES (count) n_ksco3 = shA, by(ksco1 ksco1_title)
generate double spD = shA / shA_glb
label variable n_ksco3 "지표가 있는 소분류 수"
label variable spD     "D 한국 특화도"
gsort -shC
export excel using "`xl'", sheet("ksco1") firstrow(varlabels) sheetreplace
sort ksco1
file open `fh' using "`out'/27_ksco1.tex", write replace
file write `fh' "% 04_10_analysis_kor_ai_share_index.do가 생성. 직접 고치지 말 것." _n
forvalues i = 1/`=_N' {
    fmt shA[`i'] %5.1f
    local a "`r(s)'"
    fmt shB[`i'] %5.1f
    local b "`r(s)'"
    fmt shC[`i'] %5.1f
    local c "`r(s)'"
    fmt ES[`i'] %5.1f
    local d "`r(s)'"
    fmt spD[`i'] %5.2f
    local e "`r(s)'"
    file write `fh' "`=ksco1[`i']' `=ksco1_title[`i']' & `=n_ksco3[`i']' & `a' & `b' & `c' & `d' & `e' \\" _n
}
file close `fh'
list ksco1 ksco1_title n_ksco3 shA shB shC ES spD, noobs abbreviate(12)

display "n3=`n3' | top10 A/B/C/A0/ES = `t10_shA' `t10_shB' `t10_shC' `t10_shA0' `t10_ES' | top30 = `t30_shA' `t30_shB' `t30_shC' `t30_shA0' `t30_ES'"
display "rho A-B `rho_shA_shB' A-C `rho_shA_shC' B-C `rho_shB_shC' C-ru1 `rho_shC_ru1' C-ru2 `rho_shC_ru2' A-A0 `rho_shA_shA0'"
display "overlap top30 C with A `ov_shA' B `ov_shB' ru1 `ov_ru1' ru2 `ov_ru2' | A-A0 `ov_A_A0'"
display "D: p50 `d_p50' wA `d_wA' n(A>=`dmin') `d_n' D>1 `d_gt1' (A sum `d_gt1A')"
display "Xcap min = `xcap_min' (`xcap_k')"
