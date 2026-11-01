* =============================================================================
* 04_20_analysis_kor_share_figures.do
* 점유율 지표 A·B·C와 노출도의 상위·하위 목록 그림 (paper 34~36의 그림)
*
* 입력: $proc/merged/kor_ai_usage_ksco3.dta   (03_05_merge_kor_ksco3_ai_usage.do)
*   shA, shB, shC(%), lm_aioe, elo_gpt4_beta, observed_exposure, ksco1·ksco1_title
* 출력: $results/figure/ (각 그림 .png, .pdf)
*   34_fig_ksco3_top30_C        지표 C 상위 30 소분류 가로 막대(대분류 색)
*   35_fig_rank_scatter_C       지표 C 순위 대 노출도 3개 순위 산점도(3칸, 45도선, 상위·하위 30 경계)
*   36_fig_dumbbell_C_ELO       지표 C × Eloundou β 순위 격차 상위·하위 30 덤벨 그래프
*   36_fig_heatmap_robust       9개 쌍 격차 목록 중 7개 이상에 든 소분류 × 9개 쌍의 순위 격차 히트맵
*
* 순위·격차 정의는 04_18·04_19와 같다: 129개 소분류, 값 내림차순(같은 값은 코드 순),
*   순위 격차 G = r(노출도) − r(사용)(양수 = 사용 > 노출도).
* 색(dataviz 참고 팔레트, 검증기로 확인): 범주 1 파랑 #2a78d6, 2 주황 #eb6834, 3 청록 #1baf7a,
*   그 밖 회색 #9a9893. 발산(격차) 파랑(+) ↔ 빨강(−), 가운데 회색 #f0efec.
*   막대 그림의 범주는 3개까지 색을 주고 나머지는 "기타"로 묶는다.
* 한글 글꼴: 맑은 고딕(Malgun Gothic, graph set window fontface).
* 매칭 키: ksco3(str3).
* =============================================================================

version 17
clear all
set more off

if `"$root"'    == "" global root    "d:/research/AI_effects"
if `"$proc"'    == "" global proc    "$root/data/proc"
if `"$results"' == "" global results "$root/results"

local fig "$results/figure"
capture mkdir "`fig'"
local ntop 30

graph set window fontface "Malgun Gothic"
set scheme s2color

* 색(RGB)
local c_blue   "42 120 214"
local c_orange "235 104 52"
local c_aqua   "27 175 122"
local c_gray   "154 152 147"
local c_light  "200 199 194"
local c_ink    "82 81 78"
local d_n3 "163 34 31"
local d_n2 "227 73 72"
local d_n1 "244 169 168"
local d_0  "240 239 236"
local d_p1 "134 182 239"
local d_p2 "42 120 214"
local d_p3 "16 66 129"
local gopt "graphregion(color(white)) plotregion(color(white))"

* 그림 저장: png(가로 2400px)와 pdf
capture program drop savefig
program define savefig
    args path
    graph export "`path'.png", width(2400) replace
    graph export "`path'.pdf", replace
end

* -----------------------------------------------------------------------------
* 0. 지표, 순위, 격차, 짧은 이름
* -----------------------------------------------------------------------------
use "$proc/merged/kor_ai_usage_ksco3.dta", clear
keep ksco1 ksco1_title ksco3 ksco3_title shA shB shC lm_aioe elo_gpt4_beta observed_exposure
keep if !missing(shA, shB, shC, lm_aioe, elo_gpt4_beta, observed_exposure)
count
assert r(N) == 129
local N = r(N)
rename (shA shB shC lm_aioe elo_gpt4_beta observed_exposure) (A B C FEL ELO OE)
foreach v in A B C FEL ELO OE {
    gsort -`v' ksco3
    generate int r_`v' = _n
}
foreach m in A B C {
    foreach x in FEL ELO OE {
        generate int g_`m'_`x' = r_`x' - r_`m'
    }
}
* 그림 라벨: 코드 + 이름(16자 넘으면 줄임)
generate str80 lab = ksco3 + " " + cond(ustrlen(ksco3_title) > 16, usubstr(ksco3_title, 1, 15) + "…", ksco3_title)
sort ksco3
tempfile k3
save `k3'

* -----------------------------------------------------------------------------
* 1. (paper 34) 지표 C 상위 30 소분류 가로 막대, 대분류 색
* -----------------------------------------------------------------------------
use `k3', clear
keep if r_C <= `ntop'
* 상위 30 안에서 소분류가 많은 대분류 3개에 색, 나머지는 기타
bysort ksco1: generate int nk = _N
preserve
keep ksco1 ksco1_title nk
duplicates drop
gsort -nk ksco1
generate byte grp = cond(_n <= 3, _n, 4)
forvalues g = 1/3 {
    local gname`g' = ksco1_title[`g']
}
keep ksco1 grp
tempfile gmap
save `gmap'
restore
merge m:1 ksco1 using `gmap', nogenerate
generate int pos = r_C
forvalues i = 1/`ntop' {
    quietly levelsof lab if pos == `i', local(l) clean
    label define poslab `i' `"`l'"', modify
}
label values pos poslab
* 그룹마다 막대 레이어 하나, 범례 번호 = 실제로 그린 레이어 순서
local bars ""
local legspec ""
local nl = 0
local cols "c_blue c_orange c_aqua c_gray"
forvalues g = 1/4 {
    local cc : word `g' of `cols'
    quietly count if grp == `g'
    if r(N) > 0 {
        local bars `"`bars' (bar C pos if grp == `g', horizontal barwidth(0.72) color("``cc''") lwidth(none))"'
        local ++nl
        local legname = cond(`g' <= 3, "`gname`g''", "기타")
        local legspec `"`legspec' `nl' "`legname'""'
    }
}
twoway `bars', ///
    yscale(reverse) ylabel(1/`ntop', valuelabel angle(0) labsize(tiny) noticks nogrid) ytitle("") ///
    xlabel(, labsize(small) grid glcolor("`c_light'") glwidth(vthin)) ///
    xtitle("지표 C: 취업자 환산 절감 점유율(%)", size(small) margin(t=3)) ///
    legend(order(`legspec') cols(1) size(vsmall) symxsize(3) keygap(1) position(4) ring(0) region(lcolor(white) fcolor(white))) ///
    title("지표 C 상위 30 소분류", size(medium) color("`c_ink'")) ///
    note("KSCO 8차 소분류 129개 중." "색 = 대분류(상위 30 안에서 소분류가 많은 3개, 나머지는 기타).", size(vsmall) span) ///
    `gopt' graphregion(margin(l=20 r=4)) xsize(10) ysize(9)
savefig "`fig'/34_fig_ksco3_top30_C"

* -----------------------------------------------------------------------------
* 2. (paper 35) 지표 C 순위 대 노출도 순위 산점도, 3칸
* -----------------------------------------------------------------------------
use `k3', clear
keep ksco3 r_C r_FEL r_ELO r_OE
rename (r_FEL r_ELO r_OE) (rx1 rx2 rx3)
reshape long rx, i(ksco3) j(xi)
label define xilab 1 "Felten AIOE" 2 "Eloundou β" 3 "Observed Exposure"
label values xi xilab
generate int G = rx - r_C
generate byte hi = cond(G >= 60, 1, cond(G <= -60, 2, 0))
generate str3 code = ksco3 if hi > 0
quietly count if hi > 0
display "산점도 라벨 수(|G| >= 60): " r(N)
* 같은 칸에서 라벨이 겹치는 점(가로 8, 세로 5순위 안): 코드가 큰 쪽의 라벨을 왼쪽(9시)에 붙인다
generate byte lpos = 3
preserve
keep if hi > 0
keep xi ksco3 rx r_C
tempfile hp
save `hp'
rename (ksco3 rx r_C) (k2 rx2 rc2)
joinby xi using `hp'
keep if k2 < ksco3 & abs(rx2 - rx) <= 8 & abs(rc2 - r_C) <= 5
keep xi ksco3
duplicates drop
generate byte flip = 1
tempfile fl
save `fl'
restore
merge m:1 xi ksco3 using `fl', nogenerate keep(master match)
replace lpos = 9 if flip == 1
list xi ksco3 rx r_C if flip == 1, noobs clean
twoway (line rx rx, sort lcolor("`c_light'") lwidth(thin)) ///
    (scatter r_C rx if hi == 0, msymbol(O) msize(small) mcolor("`c_gray'%60") mlwidth(none)) ///
    (scatter r_C rx if hi == 1, msymbol(O) msize(small) mcolor("`c_blue'") mlwidth(none) ///
        mlabel(code) mlabsize(vsmall) mlabcolor("`c_ink'") mlabvposition(lpos)) ///
    (scatter r_C rx if hi == 2, msymbol(O) msize(small) mcolor("`c_orange'") mlwidth(none) ///
        mlabel(code) mlabsize(vsmall) mlabcolor("`c_ink'") mlabvposition(lpos)), ///
    by(xi, rows(1) note("") title("지표 C 순위와 노출도 순위(소분류 129개)", size(medium) color("`c_ink'")) ///
        graphregion(color(white)) plotregion(color(white))) ///
    subtitle(, size(small) fcolor(white) lcolor(white)) ///
    xscale(reverse range(1 `N')) yscale(reverse range(1 `N')) ///
    xlabel(1 30 60 90 129, labsize(small) grid glcolor("`c_light'") glwidth(vthin)) ///
    ylabel(1 30 60 90 129, labsize(small) angle(0) grid glcolor("`c_light'") glwidth(vthin)) ///
    xline(30.5 99.5, lpattern(dash) lcolor("`c_light'") lwidth(vthin)) ///
    yline(30.5 99.5, lpattern(dash) lcolor("`c_light'") lwidth(vthin)) ///
    xtitle("노출도 순위(1 = 가장 높음)", size(small)) ytitle("지표 C 순위(1 = 가장 높음)", size(small)) ///
    legend(order(3 "사용 > 노출도(격차 60계단 이상)" 4 "노출도 > 사용(격차 60계단 이상)" 2 "그 밖") ///
        rows(1) size(small) region(lcolor(white))) ///
    aspectratio(1) xsize(10) ysize(4.4)
savefig "`fig'/35_fig_rank_scatter_C"

* -----------------------------------------------------------------------------
* 3. (paper 36) 지표 C × Eloundou β 격차 상위·하위 30 덤벨 그래프
* -----------------------------------------------------------------------------
foreach side in pos neg {
    use `k3', clear
    if "`side'" == "pos" gsort -g_C_ELO ksco3
    else                 gsort  g_C_ELO ksco3
    keep in 1/`ntop'
    generate int pos = _n
    capture label drop dlab`side'
    forvalues i = 1/`ntop' {
        local l = lab[`i'] + " (" + cond(g_C_ELO[`i'] > 0, "+", "") + string(g_C_ELO[`i']) + ")"
        label define dlab`side' `i' `"`l'"', add
    }
    label values pos dlab`side'
    local ttl = cond("`side'" == "pos", "사용 > 노출도: 격차 상위 30", "노출도 > 사용: 격차 하위 30")
    local lg  = cond("`side'" == "pos", "on", "off")
    twoway (rspike r_C r_ELO pos, horizontal lcolor("`c_light'") lwidth(medthick)) ///
        (scatter pos r_C, msymbol(O) msize(medsmall) mcolor("`c_blue'") mlwidth(none)) ///
        (scatter pos r_ELO, msymbol(O) msize(medsmall) mcolor("`c_orange'") mlwidth(none)), ///
        yscale(reverse) ylabel(1/`ntop', valuelabel angle(0) labsize(vsmall) noticks nogrid) ytitle("") ///
        xscale(range(1 `N')) xlabel(1 30 60 90 129, labsize(small) grid glcolor("`c_light'") glwidth(vthin)) ///
        xtitle("순위(1 = 가장 높음)", size(small) margin(t=3)) ///
        title("`ttl'", size(medsmall) color("`c_ink'")) ///
        legend(`lg' order(2 "지표 C 순위" 3 "Eloundou β 순위") rows(1) size(small) region(lcolor(white))) ///
        `gopt' name(d_`side', replace) nodraw
}
graph combine d_pos d_neg, cols(2) ///
    title("지표 C와 Eloundou β의 순위 격차(괄호 = 격차 G)", size(medium) color("`c_ink'")) ///
    note("G = Eloundou β 순위 − 지표 C 순위. 양수 = 사용 순위가 노출도 순위보다 높음.", size(vsmall)) ///
    graphregion(color(white)) xsize(12) ysize(8)
savefig "`fig'/36_fig_dumbbell_C_ELO"

* -----------------------------------------------------------------------------
* 4. (paper 36) 반복 소분류 × 9개 쌍 격차 히트맵
* -----------------------------------------------------------------------------
* 쌍별 상위·하위 30 목록에 몇 번 드는지(04_19와 같은 기준)
use `k3', clear
local pairs ""
foreach m in A B C {
    foreach x in FEL ELO OE {
        local pairs "`pairs' `m'_`x'"
        gsort -g_`m'_`x' ksco3
        generate byte inpos_`m'_`x' = _n <= `ntop'
        gsort g_`m'_`x' ksco3
        generate byte inneg_`m'_`x' = _n <= `ntop'
    }
}
egen byte kpos = rowtotal(inpos_*)
egen byte kneg = rowtotal(inneg_*)
egen double gbar = rowmean(g_*)
keep if kpos >= 7 | kneg >= 7
assert !(kpos >= 7 & kneg >= 7)
generate byte side = cond(kpos >= 7, 1, 2)
* 순서: 사용 > 노출도 쪽 평균 격차 큰 순, 그다음 노출도 > 사용 쪽 평균 격차 작은 순
replace gbar = -gbar if side == 2
gsort side -gbar ksco3
generate int row = _n
quietly count if side == 1
local nsep = r(N) + 0.5
local nrow = _N
forvalues i = 1/`nrow' {
    label define hlab `i' `"`=lab[`i']'"', add
}
keep ksco3 row side g_*
reshape long g_, i(ksco3 row side) j(pair) string
rename g_ G
generate byte col = .
local j = 0
local xl ""
foreach p of local pairs {
    local ++j
    replace col = `j' if pair == "`p'"
    local mm = substr("`p'", 1, 1)
    local xx = substr("`p'", 3, .)
    local xn = cond("`xx'" == "FEL", "Felten", cond("`xx'" == "ELO", "Eloundou", "Observed"))
    local xl `"`xl' `j' "`mm' × `xn'""'
}
label values row hlab
generate byte bin = cond(G <= -60, 1, cond(G <= -30, 2, cond(G <= -10, 3, cond(G < 10, 4, cond(G < 30, 5, cond(G < 60, 6, 7))))))
generate double x0 = col - 0.48
generate double x1 = col + 0.48
local bincols "d_n3 d_n2 d_n1 d_0 d_p1 d_p2 d_p3"
local binlab `""−60 이하" "−59~−30" "−29~−10" "−9~+9" "+10~+29" "+30~+59" "+60 이상""'
local layers ""
local legspec ""
local k = 0
forvalues b = 1/7 {
    local cc : word `b' of `bincols'
    local bl : word `b' of `binlab'
    local layers `"`layers' (rbar x0 x1 row if bin == `b', horizontal barwidth(0.94) color("``cc''") lwidth(none))"'
    local ++k
    local legspec `"`legspec' `k' "`bl'""'
}
generate str4 gtxt = cond(G > 0, "+", "") + string(G)
twoway `layers' ///
    (scatter row col if inlist(bin, 1, 7), msymbol(none) mlabel(gtxt) mlabposition(0) mlabsize(tiny) mlabcolor(white)) ///
    (scatter row col if !inlist(bin, 1, 7), msymbol(none) mlabel(gtxt) mlabposition(0) mlabsize(tiny) mlabcolor("`c_ink'")), ///
    yscale(reverse range(0.5 `=`nrow'+0.5')) ylabel(1/`nrow', valuelabel angle(0) labsize(tiny) noticks nogrid) ytitle("") ///
    yline(`nsep', lcolor("`c_ink'") lwidth(thin)) ///
    xscale(range(0.5 9.5)) xlabel(`xl', labsize(tiny) angle(45) noticks nogrid) xtitle("") ///
    legend(order(`legspec') cols(1) size(vsmall) symxsize(3) keygap(1) position(3) region(lcolor(white)) ///
        title("순위 격차 G", size(vsmall))) ///
    title("9개 쌍에서 반복되는 순위 격차", size(medsmall) color("`c_ink'")) ///
    subtitle("격차 목록 9개 중 7개 이상에 든 소분류", size(small) color("`c_ink'")) ///
    note("위: 사용 > 노출도(평균 격차 큰 순), 아래: 노출도 > 사용(평균 격차 작은 순)." ///
        "G = 노출도 순위 − 사용 순위.", size(vsmall) span) ///
    `gopt' graphregion(margin(l=22 r=4)) xsize(10) ysize(11)
savefig "`fig'/36_fig_heatmap_robust"
