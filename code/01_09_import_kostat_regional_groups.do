* =============================================================================
* 01_09_import_kostat_regional_groups.do
* 지역별고용조사 2022년 상반기 마이크로데이터 → KSCO 8차 소분류 × 집단별 취업자 수와 근로시간
* (paper 38: 성별·연령대·교육수준·임금수준 집단, paper 39: 산업 집단의 AI 사용과 노출도 비교)
*
* 입력: $raw/macro/kostat_lfs_regional/data/2022_상반기(B형_전국_소분류)_*.csv  (CP949, 개인 단위)
*   사용 변수(파일설계서 항목번호): 3 성별코드(1 남 2 여), 4 만연령, 5 교육정도_학력구분코드(0 무학 ~ 7 박사),
*     8 교육정도_수학구분코드(1 졸업 2 재학 3 중퇴 4 휴학 5 수료), 12 일시휴직여부, 15 주업근무시간수,
*     20 3자리_11차산업소분류코드(KSIC 11차), 21 3자리_8차직업소분류코드, 22 종사상지위코드(1~3 임금근로자), 26 최근3개월_월평균급여(만 원, 임금근로자만),
*     42 시도전국가중값, 43 경제활동인구상태코드(1 취업자), 45 교육정도변환코드(1 중졸 이하 2 고졸 3 전문대졸 이상; 확인용)
* 출력: $proc/macro/kostat_lfs_regional/kostat_lfs_regional_ksco3_groups.{dta,csv}
*   ksco3 × dim × grp (긴 형식). dim: sex, age, edu, wage_m, wage_h, ind1, ind2
*   emp = Σ w(명), hrs = Σ w × 주업시간 × 4.345(월 총 주업 근로시간), n_obs = 표본 수
*   $proc/macro/kostat_lfs_regional/kostat_lfs_regional_wage_cuts.{dta,csv}   임금 5분위 경계(만 원, 원/시간)
*
* 집단 정의(사용자 결정 2026-11-01: 연령 5구간, 임금은 월평균급여·시간당 임금 둘 다, 임금 집단은 임금근로자만,
*   교차 집단 없음):
*   sex    1 남자, 2 여자                                                  (취업자 전체)
*   age    1 15–29세, 2 30–39세, 3 40–49세, 4 50–59세, 5 60세 이상          (취업자 전체)
*   edu    1 중졸 이하, 2 고졸, 3 전문대졸, 4 대졸, 5 대학원 이상              (취업자 전체; 2026-11-02 5구간으로 변경)
*          졸업은 그 학력, 재학·중퇴·휴학·수료는 한 단계 아래 학력으로 본다. 다만 4년제 대학 미졸업은 고졸
*          (통계청 교육정도변환코드와 같은 규칙), 석사 미졸업은 대졸, 박사 미졸업은 석사(대학원 이상).
*          중졸 이하·고졸·전문대졸 이상의 경계가 변환코드와 일치함을 assert.
*          (이전 3구간의 '고졸 이하'는 고졸을 포함해 변환코드의 '중졸 이하'와 범위가 달랐다.)
*   wage_m 임금근로자 월평균급여 5분위(1 = 가장 낮음), 가중 분위
*   wage_h 임금근로자 시간당 임금 5분위. 시간당 임금 = 월평균급여 × 10,000 / (주업시간 × 4.345)(원).
*          조사 주간에 일하지 않은 임금근로자(주업시간 0, 일시휴직 등)는 시간당 임금이 없어 wage_h에서 빠진다.
*   ind1   KSIC 11차 대분류 A~U(1~21; 소분류 코드 앞 2자리 = 중분류로 판정)               (취업자 전체)
*   ind2   제조업 밖은 KSIC 대분류, 제조업은 국민계정 13개 산업 C01~C13(1 A, 2 B, 3~15 C01~C13, 16~33 D~U)
*          제조업 대응은 한국은행 『우리나라의 국민계정체계(2025)』 <표 Ⅲ-2-6>·<표 Ⅲ-2-7>(2026-11-01 사용자 결정)
*   분위 경계 값과 같은 급여는 아래 분위로 들어간다(xtile). 급여가 만 원 단위로 몰려 있어 분위별 인원이
*   정확히 20%가 되지 않는다(엑셀에 실제 비중을 남김).
* 근로시간·가중치 정의는 01_07과 같다(일시휴직자 0시간, 월 환산 × 4.345).
* 매칭 키: ksco3(str3) = 3자리_8차직업소분류코드.
* =============================================================================

version 17
clear all
set more off

if `"$root"' == "" global root "d:/research/AI_effects"
if `"$raw"'  == "" global raw  "$root/data/raw"
if `"$proc"' == "" global proc "$root/data/proc"

local ind  "$raw/macro/kostat_lfs_regional/data"
local outd "$proc/macro/kostat_lfs_regional"
capture mkdir "`outd'"
local wk2mo = 52.143 / 12

* -----------------------------------------------------------------------------
* 1. 읽기(01_07과 같은 방식: 열 위치로 이름을 붙이고 원래 이름으로 확인)
* -----------------------------------------------------------------------------
local f : dir "`ind'" files "2022_상반기(B형_전국_소분류)_*.csv"
assert `: word count `f'' == 1
local f `f'
import delimited using "`ind'/`f'", varnames(1) encoding("cp949") stringcols(_all) clear
unab allv : _all
assert `: word count `allv'' == 45
local pos  "1 3 4 5 8 12 15 20 21 22 26 42 43 45"
local new  "yyyymm sex agey edul edus absent h_main ksic ksco3 status wage w ecst educ3"
local chk  "조사연월 성별코드 만연령 학력구분코드 수학구분코드 일시휴직여부 주업근무시간수 11차산업소분류코드 8차직업소분류코드 종사상지위코드 월평균급여 시도전국가중값 경제활동인구상태코드 교육정도변환코드"
forvalues i = 1/14 {
    local v : word `: word `i' of `pos'' of `allv'
    local lab : variable label `v'
    assert strpos(`"`v' `lab'"', "`: word `i' of `chk''") > 0
    rename `v' `: word `i' of `new''
}
keep `new'
destring sex agey edul edus absent h_main status wage w ecst educ3, replace
assert yyyymm == "202204"
keep if ecst == 1
replace ksco3 = strtrim(ksco3)
assert strlen(ksco3) == 3
replace ksic = strtrim(ksic)
assert strlen(ksic) == 3 & regexm(ksic, "^[0-9]+$")
assert inrange(status, 1, 6)
assert inlist(sex, 1, 2) & agey >= 15 & !missing(agey) & inrange(edul, 0, 7)
* 근로시간: 일시휴직자만 비어 있음 → 0시간(01_07과 같음)
assert absent == 1 if missing(h_main)
replace h_main = 0 if absent == 1
assert !missing(h_main, w)
* 급여는 임금근로자에게만 있음
assert !missing(wage) & wage > 0 if status <= 3
assert missing(wage) if status > 3
count
count if status <= 3

* -----------------------------------------------------------------------------
* 2. 집단 변수
* -----------------------------------------------------------------------------
generate byte g_sex = sex
generate byte g_age = cond(agey < 30, 1, cond(agey < 40, 2, cond(agey < 50, 3, cond(agey < 60, 4, 5))))
* 학력: 졸업이면 그 단계, 아니면 한 단계 아래
*   lev 0 무학 1 초졸 2 중졸 3 고졸 4 전문대졸 5 대졸 6 석사 7 박사
generate byte lev = edul
replace lev = edul - 1 if edus != 1 & inlist(edul, 1, 2, 3, 4, 6, 7)
replace lev = 3 if edus != 1 & edul == 5                // 4년제 미졸업 = 고졸(통계청 변환코드와 같음)
generate byte g_edu = cond(lev <= 2, 1, cond(lev == 3, 2, cond(lev == 4, 3, cond(lev == 5, 4, 5))))
* 통계청 변환코드(1 중졸 이하 2 고졸 3 전문대졸 이상)와 일치하는지 확인
assert (lev <= 2) == (educ3 == 1)
assert (lev == 3) == (educ3 == 2)
assert (lev >= 4) == (educ3 == 3)
drop lev
* 산업: KSIC 11차 중분류(소분류 코드 앞 2자리) → 대분류 A~U(ind1, 1~21)
generate byte kdiv = real(substr(ksic, 1, 2))
generate byte g_ind1 = .
local s = 0
foreach r in "1 3" "5 8" "10 34" "35 35" "36 39" "41 42" "45 47" "49 52" "55 56" "58 63" "64 66" "68 68" ///
    "70 73" "74 76" "84 84" "85 85" "86 87" "90 91" "94 96" "97 98" "99 99" {
    local ++s
    replace g_ind1 = `s' if inrange(kdiv, `: word 1 of `r'', `: word 2 of `r'')
}
assert !missing(g_ind1)
* ind2: 제조업 밖은 KSIC 대분류, 제조업(C)은 국민계정 13개 산업 C01~C13
*   (한국은행 『우리나라의 국민계정체계(2025)』 <표 Ⅲ-2-6>·<표 Ⅲ-2-7>의 KSIC 중분류 대응)
*   C01 10~12, C02 13~15, C03 16~18, C04 19, C05 20~22, C06 23, C07 24, C08 25, C09 26~27,
*   C10 28, C11 29, C12 30~31, C13 32~34. 번호: A 1, B 2, C01~C13 3~15, D~U 16~33
generate byte g_ind2 = cond(g_ind1 <= 2, g_ind1, g_ind1 + 12)
local s = 2
foreach r in "10 12" "13 15" "16 18" "19 19" "20 22" "23 23" "24 24" "25 25" "26 27" "28 28" "29 29" "30 31" "32 34" {
    local ++s
    replace g_ind2 = `s' if inrange(kdiv, `: word 1 of `r'', `: word 2 of `r'')
}
assert inrange(g_ind2, 3, 15) == (g_ind1 == 3)
drop kdiv
* 임금: 임금근로자 가중 5분위
generate double wage_h = wage * 10000 / (h_main * `wk2mo') if status <= 3 & h_main > 0
xtile g_wage_m = wage   if status <= 3 [aw = w], nquantiles(5)
xtile g_wage_h = wage_h if status <= 3 & !missing(wage_h) [aw = w], nquantiles(5)
assert !missing(g_wage_m) if status <= 3
count if status <= 3 & missing(g_wage_h)
* 분위 경계(만 원, 원/시간)
tempname pf
tempfile cuts
postfile `pf' str8 dim byte grp double(lo hi share) using `cuts'
quietly summarize w if status <= 3
local tw_m = r(sum)
quietly summarize w if !missing(g_wage_h)
local tw_h = r(sum)
foreach d in m h {
    local v = cond("`d'" == "m", "wage", "wage_h")
    forvalues q = 1/5 {
        quietly summarize `v' if g_wage_`d' == `q'
        local lo = r(min)
        local hi = r(max)
        quietly summarize w if g_wage_`d' == `q'
        post `pf' ("wage_`d'") (`q') (`lo') (`hi') (100 * r(sum) / `tw_`d'')
    }
}
postclose `pf'

* -----------------------------------------------------------------------------
* 3. 소분류 × 집단 집계(긴 형식)
* -----------------------------------------------------------------------------
generate double wh = w * h_main * `wk2mo'
generate byte one = 1
tempfile micro long
save `micro'
local first 1
foreach d in sex age edu wage_m wage_h ind1 ind2 {
    use `micro', clear
    keep if !missing(g_`d')
    collapse (sum) emp = w hrs = wh n_obs = one, by(ksco3 g_`d')
    rename g_`d' grp
    generate str8 dim = "`d'"
    if !`first' append using `long'
    save `long', replace
    local first 0
}

* 집단 이름
use `long', clear
generate str60 grp_lab = ""
replace grp_lab = cond(grp == 1, "남자", "여자") if dim == "sex"
replace grp_lab = word("15–29세 30–39세 40–49세 50–59세 60세이상", grp) if dim == "age"
replace grp_lab = "60세 이상" if dim == "age" & grp == 5
replace grp_lab = word("중졸이하 고졸 전문대졸 대졸 대학원이상", grp) if dim == "edu"
replace grp_lab = "중졸 이하" if dim == "edu" & grp == 1
replace grp_lab = "대학원 이상" if dim == "edu" & grp == 5
replace grp_lab = string(grp) + "분위" if inlist(dim, "wage_m", "wage_h")
* 산업 이름: KSIC 11차 대분류, 국민계정 제조업 13개 산업
local i1 `""A 농업, 임업 및 어업" "B 광업" "C 제조업" "D 전기, 가스, 증기 및 공기 조절 공급업" "E 수도, 하수 및 폐기물 처리, 원료 재생업" "F 건설업" "G 도매 및 소매업" "H 운수 및 창고업" "I 숙박 및 음식점업" "J 정보통신업" "K 금융 및 보험업" "L 부동산업" "M 전문, 과학 및 기술 서비스업" "N 사업시설 관리, 사업 지원 및 임대 서비스업" "O 공공 행정, 국방 및 사회보장 행정" "P 교육 서비스업" "Q 보건업 및 사회복지 서비스업" "R 예술, 스포츠 및 여가관련 서비스업" "S 협회 및 단체, 수리 및 기타 개인 서비스업" "T 가구 내 고용활동 및 자가 소비 생산활동" "U 국제 및 외국기관""'
local c13 `""C01 음식료품" "C02 섬유 및 가죽제품" "C03 목재, 종이, 인쇄 및 복제" "C04 코크스 및 석유정제품" "C05 화학물질 및 화학제품" "C06 비금속광물제품" "C07 1차금속" "C08 금속가공제품" "C09 컴퓨터, 전자 및 광학기기" "C10 전기장비" "C11 기계 및 장비" "C12 운송장비" "C13 기타 제조업 및 산업용 장비 수리""'
forvalues g = 1/21 {
    replace grp_lab = `"`: word `g' of `i1''"' if dim == "ind1" & grp == `g'
    if `g' != 3 replace grp_lab = `"`: word `g' of `i1''"' if dim == "ind2" & grp == cond(`g' <= 2, `g', `g' + 12)
}
forvalues g = 1/13 {
    replace grp_lab = `"`: word `g' of `c13''"' if dim == "ind2" & grp == `g' + 2
}
assert grp_lab != ""
generate byte dim_o = cond(dim == "sex", 1, cond(dim == "age", 2, cond(dim == "edu", 3, cond(dim == "wage_m", 4, cond(dim == "wage_h", 5, cond(dim == "ind1", 6, 7))))))
sort dim_o grp ksco3
drop dim_o
isid dim grp ksco3

* 확인: 성별·연령·교육 집계의 소분류 합 = 01_07의 2022년 취업자·근로시간, 월급 집계의 합 = 임금근로자
tempfile all
save `all'
use "$proc/macro/kostat_lfs_regional/kostat_lfs_regional_ksco3.dta", clear
keep if year == 2022
keep ksco3 emp emp_wage hrs_main_mo
rename (emp emp_wage hrs_main_mo) (e22 ew22 h22)
tempfile k22
save `k22'
foreach d in sex age edu wage_m ind1 ind2 {
    use `all', clear
    keep if dim == "`d'"
    collapse (sum) e = emp h = hrs, by(ksco3)
    merge 1:1 ksco3 using `k22', assert(match using) nogenerate
    replace e = 0 if missing(e)                           // 임금근로자가 없는 소분류
    replace h = 0 if missing(h)
    if "`d'" == "wage_m" assert reldif(e, ew22) < 1e-9
    else assert reldif(e, e22) < 1e-9 & reldif(h, h22) < 1e-6
}
use `all', clear

label variable ksco3   "KSCO 8차 소분류(3자리)"
label variable dim     "집단 구분(sex, age, edu, wage_m, wage_h, ind1, ind2)"
label variable grp     "집단 번호"
label variable grp_lab "집단 이름"
label variable emp     "취업자 수(명, 시도전국가중값 합)"
label variable hrs     "월 총 주업 근로시간(시간)"
label variable n_obs   "표본 수(가중치 없음)"
order ksco3 dim grp grp_lab n_obs emp hrs
compress
save "`outd'/kostat_lfs_regional_ksco3_groups.dta", replace
export delimited using "`outd'/kostat_lfs_regional_ksco3_groups.csv", replace

use `cuts', clear
label variable dim   "임금 기준(wage_m 월평균급여 만 원, wage_h 시간당 임금 원)"
label variable grp   "분위"
label variable lo    "분위 최솟값"
label variable hi    "분위 최댓값"
label variable share "임금근로자 중 비중(%, 가중)"
save "`outd'/kostat_lfs_regional_wage_cuts.dta", replace
export delimited using "`outd'/kostat_lfs_regional_wage_cuts.csv", replace
list, noobs clean

* 집단별 요약
use "`outd'/kostat_lfs_regional_ksco3_groups.dta", clear
collapse (sum) emp n_obs (count) n_ksco3 = emp, by(dim grp grp_lab)
bysort dim: egen double tot = total(emp)
generate double pct = 100 * emp / tot
format emp tot %14.0fc
list dim grp grp_lab n_obs n_ksco3 emp pct, noobs sepby(dim)
