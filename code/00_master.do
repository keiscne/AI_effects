* =============================================================================
* 00_master.do
* AI-effects 전체 파이프라인: raw → proc → results/table 을 실행 순서대로 돌린다.
*
* 파일 이름 = 단계(01 import, 02 clean, 03 merge, 04 analysis)_단계 안 실행 순서_내용.
*   02 단계(clean)는 2026-10-24 재설계로 Sensor Tower 파일을 archive/로 옮겨 현재 비어 있다.
*   archive/의 do 파일(Sensor Tower·ChatGPT 기준값으로 대화 총량을 추정하던 경로)은 실행하지 않는다.
*
* 2026-10-24 재설계: 한국 생성형 AI 총 메시지·대화 수를 추정하지 않는다. AEI 업무용 대화 비중만으로
*   직업별 점유율 지표 A~D와 상대 활용도 RU1·RU2를 만든다(03_02, 03_05).
* =============================================================================

version 17
clear all
set more off

global root    "d:/research/AI_effects"
global raw     "$root/data/raw"
global proc    "$root/data/proc"
global results "$root/results"
global code    "$root/code"

* -----------------------------------------------------------------------------
* 01 import: 원자료 최소 가공
* -----------------------------------------------------------------------------
do "$code/01_01_import_soc2018_titles.do"               // BLS SOC 2018 6자리 명칭
do "$code/01_02_import_aei_country_usage.do"            // AEI 국가별 사용 지표(한국 업무용 비중 검증용)
do "$code/01_03_import_aei_soc_time_savings.do"         // AEI SOC 대화당 절감 시간(GLOBAL) ← 01_01
do "$code/01_04_import_felten_aioe.do"                  // Felten AIOE → SOC 2018 ← 01_03
do "$code/01_05_import_onet_task_soc.do"                // O*NET Task ID → SOC
do "$code/01_06_import_soc2018_ksco8_crosswalk.do"      // SOC 2018–KSCO 8차 연계표
do "$code/01_07_import_kostat_regional_employment.do"   // 지역별고용조사 소분류 취업자·근로시간
do "$code/01_08_import_moel_wage_structure_hours.do"    // 고용형태별근로실태조사 대분류 근로시간

* -----------------------------------------------------------------------------
* 03 merge: 결합
* -----------------------------------------------------------------------------
do "$code/03_01_merge_soc6_ai_indicators.do"            // SOC 2018 AI 지표(노출도, 절감 시간) ← 01_01, 01_03, 01_04
do "$code/03_02_merge_aei_kor_soc_work_share.do"        // AEI 한국·GLOBAL SOC 업무용 대화 비중 ← 01_01
do "$code/03_03_merge_kor_conv_ai_ksco8.do"             // SOC → KSCO 세분류·소분류 배분 ← 01_06, 03_01, 03_02
do "$code/03_04_merge_kor_task_conv_time_saved.do"      // 한국 task 업무용 대화 비중·절감 시간 ← 01_05, 03_02
do "$code/03_05_merge_kor_ksco3_ai_usage.do"            // 지표 A~D, RU1·RU2 ← 01_07, 01_08, 03_03

* -----------------------------------------------------------------------------
* 04 analysis: 표(results/table) — 번호 순서는 paper 번호 순
* -----------------------------------------------------------------------------
do "$code/04_01_analysis_kor_soc_work_share_summary.do"      // paper 19
do "$code/04_02_analysis_kor_soc_exposure_coverage.do"       // paper 20
do "$code/04_03_analysis_soc2018_ksco8_crosswalk_summary.do" // paper 21
do "$code/04_04_analysis_soc2018_ksco8_crosswalk_compare.do" // report 22
do "$code/04_05_analysis_kor_ksco8_merge_summary.do"         // paper 23
do "$code/04_06_analysis_kor_ai_usage_index.do"              // paper 25
do "$code/04_07_analysis_kor_task_top30.do"                  // paper 26(엑셀)
do "$code/04_08_analysis_kor_soc_top30_tasks.do"             // paper 26(엑셀)
do "$code/04_09_analysis_kor_ksco3_top30_soc.do"             // paper 26
do "$code/04_10_analysis_kor_ai_share_index.do"              // paper 27
do "$code/04_11_analysis_kor_share_vs_exposure.do"           // paper 28
do "$code/04_12_analysis_kor_share_exposure_gap.do"          // paper 29
do "$code/04_13_analysis_aei_v6_structure.do"                // paper 30
do "$code/04_14_analysis_kor_conv_saved_gap.do"              // paper 31
do "$code/04_15_analysis_kor_use_vs_share.do"                // paper 32
