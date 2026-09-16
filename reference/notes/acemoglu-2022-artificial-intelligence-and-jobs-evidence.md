---
title: "Artificial Intelligence and Jobs: Evidence from Online Vacancies"
authors: Daron Acemoglu, David Autor, Jonathon Hazell, Pascual Restrepo
institution: ""
year: 2022
doi: "10.1086/718327"
category: [labor_economics]
source_tier: 1
pdf_path: papers/local/acemoglu-2022-artificial-intelligence-and-jobs-evidence.pdf
pdf_filename: acemoglu-2022-artificial-intelligence-and-jobs-evidence.pdf
verified_date: 2026-06-23
datasets_used: []
---

## One-line Summary

Burning Glass의 미국 온라인 채용공고 거의 전수 데이터(2010~2018)를 사업장 단위로 분석해, AI 노출 측정값(Felten et al., Webb, SML)이 사업장 단위 AI 채용 급증·스킬 변화·비AI 채용 감소를 예측하지만, 산업·직종 단위 고용·임금에는 아직 탐지 가능한 영향이 없음을 보인다.

## Document Information

- 저자: Daron Acemoglu (MIT, NBER), David Autor (MIT, NBER), Jonathon Hazell (London School of Economics), Pascual Restrepo (Boston University, NBER)
- 게재지: *Journal of Labor Economics*, Vol. 40, No. S1 (2022년 4월), pp. S293–S340
- DOI: 10.1086/718327
- 투고일 2020-12-15 / 게재확정 2021-11-24

## Key Contributions

- Burning Glass의 미국 온라인 채용공고 거의 전수 데이터(2007년 일부, 2010~2018년)를 사업장(establishment) 단위로 결합해 AI 도입의 "흔적"(AI 직무 채용)을 식별하는 실증 전략을 제시 (Section III.A, p.S303-305).
- 과업기반 모형(Cobb-Douglas 과업 결합 + 과업 내 노동-AI CES 대체)으로 사업장의 "AI 노출(exposure to AI)"을 정의(식 4)하고, 비AI 고용 변화를 전치효과(−1항)와 생산성효과(ε·ρ−1 항)로 분해하는 식(식 5, Proposition 2)을 도출 (Section II, p.S298-302).
- Felten et al., Webb, Brynjolfsson-Mitchell-Rock(SML)의 세 가지 독립적 AI 노출지수를 동시에 사용해 결과의 강건성을 비교·검증 (Section III.B, p.S306-308).
- 사업장 단위에서는 AI 고용·스킬변화에 강한 효과가 나타나지만 산업·직종 단위 고용·임금에서는 탐지 가능한 효과가 없다는 "표면적으로는 보이나 집계 시 사라지는" 패턴을 실증 (Section VII, p.S332-336).

## Methodology and Data

- Burning Glass Technologies(BG)의 온라인 채용공고 데이터: 약 4만 개 기업 웹사이트·잡보드에서 수집(단일 출처 비중 5% 이하), 2010~2018년 거의 전수 + 2007년 일부 데이터 (Section III.A, p.S303-304).
- AI 노출 측정 3종(모두 6자리 SOC 직업 단위): Felten, Raj, and Seamans(2019)의 AI occupational impact(Electronic Frontier Foundation의 AI 응용 9개×O*NET 52개 능력, mTurk 크라우드소싱), Webb(2020)의 AI exposure score(AI 특허와 O*NET 과업 텍스트의 중첩), Brynjolfsson, Mitchell, and Rock(2019)의 SML 지수(23개 항목 루브릭으로 머신러닝 적합성 평가) (Section III.B, p.S306-307).
- AI 공급 산업인 정보(NAICS 51)·전문/사업서비스(NAICS 54)를 제외하고 AI 사용 사업장에 초점 (p.S304-306).
- 핵심 회귀식(식 6): Δy_{e,t2-t0} = β·AI_{e,t0} + x'_{e,t0}γ + ε. 사업장 e의 2010~12년 대비 2016~18년 변화량을 2010년 AI 노출(가중표준편차로 표준화)에 회귀하며, 산업·기업규모십분위·통근권(CZ) 고정효과를 포함하고 일부 모형은 기업 고정효과를 추가. 표준오차는 기업 단위로 클러스터링 (Section IV, p.S308-309).
- 산업·직종 단위 분석: County Business Patterns(CBP, 2000–2016)으로 산업×CZ 고용을, BLS Occupational Employment Statistics(OES, 2004~2018)로 직종별 고용·임금을 측정 (Section VII.B-C, p.S332-336).

## Key Results

- AI 노출과 AI 채용공고 증가(Table 1, p.S312, Panel A, Felten et al. 측정): 무통제 β=15.96(s.e. 1.73, N=1,075,474); 기업규모·CZ 통제 시 13.82(1.43); 3단위 산업 고정효과 추가 시 9.19(1.21, N=954,519); 기업 고정효과 포함 시 16.53(1.89). 본문 해석: "AI 노출 1표준편차 증가(금융업과 광업/석유추출업의 평균 노출 차이에 해당)는 AI 채용공고 약 16% 증가와 연관" (p.S295, S310-311).
- Felten et al. 측정의 수정 R²=0.0256, 2010~12년 직종구성을 회귀자로 쓴 모형의 R²=0.10 → AI 노출지수가 기준연도 직종구성에 따른 AI 도입의 4분의 1 이상을 설명 (p.S312-313).
- 비AI 채용 변화(Table 5, p.S324-326, Felten et al. 측정): 무통제 β=−13.80(s.e. 4.22, N=1,075,474) → "AI 노출 1표준편차 증가는 비AI 채용공고 약 14% 감소와 연관"; 기업 고정효과 포함 시 −4.81(1.44). 2014~2018년 하위기간에서 효과가 집중: β=−11.94(3.80) (p.S330-332).
- 누적고용(2010~18년 채용공고를 적치해 추정) 회귀(부록 Table A11): β=−7.24(s.e. 4.66) → AI 노출 1표준편차 증가는 비AI 고용 7.2% 감소와 연관 (p.S326).
- 스킬 변화(Table 3-4, p.S319-320, Felten et al. 측정): 음의 스킬변화 β=0.83(s.e. 0.09, 표본평균 4.70 대비 큰 변화); 양의 스킬변화 β=0.95(s.e. 0.08, 표본평균 6.30 대비 큰 변화) — AI 노출이 기존 스킬 퇴장과 신규 스킬 등장을 동시에 예측.
- 산업×CZ 고용(Table 8, p.S333-336, CBP 2010-16): β=−0.05(s.e. 0.08), 통계적으로 무의미. 직종별 OES 고용·임금(2010-18)에서도 일관된 효과가 탐지되지 않음.
- Wald 추정(각주 24, p.S326-327): Table 1·Table 5의 기업 고정효과 계수(16.53, −4.81)를 결합하면 탄력성 −0.3(AI 도입 10% 증가 → 비AI 채용 3% 감소). 2010~2018년 AI 채용공고 증가폭은 금융업 218 로그포인트~제조업 198 로그포인트였고, 이 중 1.6%(AI노출 측정의 partial R²)가 과업 대체에 기인한다고 가정하면 금융업 비AI채용 1% 감소, 제조업 0.92% 감소로 환산.

## Limitations and Future Work

- 저자가 명시한 한계: (1) 사업장 단위의 음의 효과와 산업·직종 단위의 무효과가 병존(juxtaposition)하는 이유를 더 깊이 이해할 필요가 있음 (Section VIII, p.S337); (2) 과업구조 기반 AI 노출 측정은 신제품·신사업모델을 통한 AI 영향을 놓칠 수 있음 (p.S337); (3) 현 세대 AI 기술의 결과이므로, 다음 세대 AI 기술이 인간 능력과 더 보완적일지 대체적일지는 예측할 수 없음 (p.S337).

## Related Work

- [[acemoglu-2019-automation-and-new-tasks-how]] (Acemoglu and Restrepo 2019, *Journal of Economic Perspectives*) — 본 논문 식(5)의 전치효과(−1항)·생산성효과(ε·ρ−1 항) 분해가 직접 의거하는 과업기반 이론적 토대 (References, p.S337).
- Felten, Raj, and Seamans(2018, 2019)의 AI occupational impact 지수 — [[felten-2021-occupational-industry-and-geographic-exposure]]가 다루는 AIOE와 같은 연구계열(EFF 응용×O*NET 52개 능력×mTurk 크라우드소싱 방법론이 일치)이며, 본 논문이 사용하는 3개 노출지수 중 가장 안정적인 측정으로 채택됨 (Section III.B, p.S306-307).
- Babina, Fedyk, He, and Hodson(2020) — 기업단위 관측된 AI 투자와 고용·매출의 관계를 분석한 가장 밀접한 선행연구. 본 논문은 직무구조 기반 노출 측정을 사용한다는 점에서 차별화되며, 이 차이가 고용 결과의 차이를 설명할 수 있다고 논의 (p.S297).

## Glossary

- **AI 노출(exposure to AI)**: 사업장이 2010~12년 기준 수행하던 과업 중, AI 발전으로 새롭게 알고리즘이 수행 가능해진 과업이 차지하는 비중(고용가중) (식 4, p.S299).
- **Burning Glass(BG)**: 온라인 채용공고를 수집·표준화해 직업·산업·스킬 정보를 코딩하는 민간 데이터 제공업체 (p.S303).
- **좁은/넓은 AI 측정(narrow/broad AI vacancy measure)**: 채용공고에 명시된 스킬을 기준으로 AI 관련 직무를 좁게(핵심 AI 스킬 목록) 또는 넓게(머신러닝·자연어처리·데이터과학 스킬 클러스터 포함) 정의한 두 측정 (p.S305).
