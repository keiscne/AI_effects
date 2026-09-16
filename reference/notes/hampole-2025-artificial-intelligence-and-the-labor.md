---
title: "Artificial Intelligence and the Labor Market"
authors: Menaka Hampole, Dimitris Papanikolaou, Lawrence D. W. Schmidt, Bryan Seegmiller
institution: ""
year: 2025
doi: ""
category: [labor_economics]
source_tier: 1
pdf_path: papers/local/hampole-2025-artificial-intelligence-and-the-labor.pdf
pdf_filename: hampole-2025-artificial-intelligence-and-the-labor.pdf
verified_date: 2026-06-23
datasets_used: []
---

## One-line Summary

Revelio Labs의 이력서·채용공고 데이터에 LLM 기반 텍스트 임베딩을 적용해 기업×과업 단위 AI 노출도(평균노출·집중도)를 구축하고, 대학 채용네트워크 shift-share 도구변수로 평균노출은 직종 고용을 줄이지만 노출의 집중도와 기업성장 효과가 이를 상쇄해 전체 순효과는 미미함을 보인다.

## Document Information

- 저자: Menaka Hampole (Yale School of Management), Dimitris Papanikolaou (Northwestern Kellogg School of Management, NBER), Lawrence D. W. Schmidt (MIT Sloan School of Management), Bryan Seegmiller (Northwestern Kellogg School of Management)
- 워킹페이퍼, 2025년 9월 15일 (NBER 워킹페이퍼 번호 없음)

## Key Contributions

- 이력서의 "AI 통합자(AI integrator)" 직무기술을 LLM(Llama 3.1 70B)으로 파싱해 기업별로 실제 도입한 AI 응용(약 100만 건)을 식별하고, 텍스트 임베딩(GTE-Large)의 코사인 유사도로 이를 O*NET 과업(약 2만 개)에 연결하는 방법론을 제시 (Section 1.1-1.3, p.7-13).
- 노동수요에 대한 AI의 영향을 직접효과(과업평균노출, m(δ))와 간접 재배치효과(노출의 집중도, C(δ))로 분해하는 모형을 제시하고, 동일한 두 충분통계량이 Acemoglu and Restrepo(2018) 모형에서도 도출됨을 보임 (Section 2.1, 식 13-17, p.18-20).
- 대학별 AI 졸업생 비중(2014-18년 "shift")과 기업의 2005-09년 대학별 채용비중("share")을 결합한 shift-share 도구변수를 구축해 AI 도입의 인과효과를 식별 (Section 3.1, p.23-26).
- 직접효과·재배치효과·기업성장효과를 분리해, 직접대체효과는 강하지만(고임금 직종 약 -7%~-15%) 집중도효과와 기업성장효과가 상쇄해 전체 순효과는 미미함(고임금 직종 순효과 약 +3%)을 정량화 (Section 3.5, p.32-35).

## Methodology and Data

- Revelio Labs의 LinkedIn 기반 이력서(약 5,800만 건)·채용공고(약 1,400만 건) 데이터(주분석 2014-2023년, shift-share 도구변수 구축 시 2005년부터), O*NET 28.3(2024년 5월) 과업 기술 데이터, Compustat(상장기업 재무) 결합. 상장기업으로 표본 제한 (Section 1.1, p.7-8).
- AI 응용 추출: 이력서 직무기술에서 AI 키워드 탐지 → Llama 3.1 70B로 구체적 AI 응용 문구 추출·정제 → 약 50만 개 직무에서 100만 건 이상의 AI 활용사례 도출 (Section 1.2, p.8-9).
- 검증: 자체 측정과 BTOS 설문 AI 활용률 간 상관 0.90(레벨, Figure 2 Panel A); 신규 AI 이력서와 AI 채용공고 간 partial correlation 0.67; AI 특허(USPTO AI Patent Dataset)와의 partial correlation 0.36 (p.10).
- 과업노출 측정(식 1-2): AI응용-과업 텍스트임베딩 코사인유사도가 전체 분포 상위 95백분위를 초과할 때만 노출로 인정(희소성 제약); 과업노출×log(1+기업 AI응용수)로 도입강도를 반영.
- 직종 단위 집계(식 21-24): O*NET 과업중요도로 가중평균한 평균노출(m̄)과 분산으로 측정한 집중도(c)를 산출하고, 각각 기업 AI도입강도로 추가 조정.
- 식별전략: (1) 대학×기업의 사전기간(2005-09) 채용비중과 대학별 AI졸업생비중(2014-18)을 결합한 shift-share 도구변수로 기업단위 AI도입의 외생적 변동을 추출 (식 25-26, p.24-25); (2) 직종단위 노출의 자기선택을 통제하기 위해 동일 직종의 "다른 모든 기업" 평균노출을 도구변수로 사용 (식 27-29, p.26).
- 강건성: 대학-기업 채용비중의 페르시스턴스 회귀계수 약 0.5(t-값 30 초과); shift-share 도구변수의 1단계 회귀계수 0.54(t=7.5) (Appendix Table A.3, p.25).

## Key Results

- 과업단위: 가장 엄격한 명세(기업×직종×연도 + 과업×연도 고정효과, Table 3 col.4, p.49)에서 과업노출 1표준편차 증가는 해당 과업 관련 스킬의 채용공고 내 상대수요를 5년간 약 2% 감소시킴(coef=-1.91, t=-19.21); 모든 명세에서 계수가 -1.91~-2.09로 안정적.
- 기업성장: AI 도입강도(log(1+AI응용수)) 1표준편차 증가는 5년간 매출 9.71%p(IV, t=3.89), 고용 6.84%p(t=3.75), 이윤 8.22%p(t=3.20), TFP 7.53%p(t=5.11) 증가와 연관 (Table 4, p.50). IV 추정치가 OLS 대비 약 30% 더 커, 대기업·고수익 기업의 선택적 도입에 따른 하향편의를 시사.
- 직종×기업 고용(Table 5, IV 선호 명세 col.5, p.51): 평균노출 1표준편차 증가 → 5년간 직종-기업 고용비중 약 14.5~15.6% 감소(coef=-15.6, t=-10.26); 집중도 1표준편차 증가 → 약 7.5~9.1% 증가(coef=9.07, t=6.54); 기업 AI도입강도 1표준편차 증가 → 약 19.7~19.8% 증가(coef=19.8, t=18.31). 대응 OLS 추정치는 각각 -5.7~-8.7%, 1.3~1.9%, 10~11%로 더 작음.
- 급여분위별 순효과(Section 3.5, Figure 8, p.32-33): 상위 임금분위 직종은 직접효과로 5년간 고용비중 약 7% 감소하지만, 집중도·기업효과가 상쇄해 전체 순효과는 오히려 약 +3% 증가. 기업 내(within-firm) 분석에서는 90백분위 직종이 직접효과로 약 -2.8% 감소했다가 집중도효과로 -1.5%까지 완화.
- 직종군별 5년 상대고용성장(Table 6, p.52, 전체 가중평균은 0으로 정규화): Business and Financial -2.17%, Architecture and Engineering -1.29%, Food Preparation and Serving -4.56%, Legal +7.58%.
- 전체 설명력: AI노출 관련 변수들이 직종별 고용성장 변동의 약 16%를 설명하며, 이 중 최소 45%는 과업 단위 직접노출에서 기인 (Section 3.5, p.34-35; Figure 9, p.46).

## Limitations and Future Work

- 저자가 명시한 한계: (1) 분석 표본이 Compustat 상장기업으로 제한되어, 대기업이 AI를 더 많이 도입하는 경향과 결합되면 AI의 경제적 영향을 과대추정할 수 있음 (Section 3.5 말미, p.35); (2) Revelio 이력서 데이터는 화이트칼라·젊은층·디지털 친화적 근로자를 과대표집하는 자기선택 표본 (Section 1.1, p.9); (3) 측정한 AI 도입은 2023년까지로 생성형 AI(2022년 말 이후) 확산은 대부분 포함하지 못하며, 경제적 메커니즘은 유사할 것으로 예상하나 노출되는 과업 집합 자체는 다를 수 있음 (Conclusion, p.35).

## Related Work

- [[acemoglu-2022-artificial-intelligence-and-jobs-evidence]] — 사업장 단위로 AI 노출과 비AI 채용 감소를 보였으나 집계 시 효과가 사라진다는 본 논문의 핵심 비교대상. 본 논문은 직접대체효과를 상쇄하는 재배치·기업성장효과로 이 현상을 분해해 설명 (Introduction, p.4, p.32).
- [[acemoglu-2024-the-simple-macroeconomics-of-ai]] — Hulten 정리로 생성형 AI의 거시생산성효과가 완만할 것이라 추정한 논문. 본 논문이 발견한 메커니즘(직접대체·과업재배치·기업성장)이 생성형 AI 확산에도 유사하게 작동할 것이라는 전망의 근거로 인용 (p.5).
- [[eloundou-2023-gpts-are-gpts-an-early]] — 직종 단위 노출지수를 구축한 선행연구. 본 논문은 이를 기업×과업 단위로 세분화해 발전시킴 (p.13).
- Felten, Raj, and Seamans(2018)의 직종단위 AI 노출 측정 — [[felten-2021-occupational-industry-and-geographic-exposure]]가 다루는 AIOE와 같은 연구계열. 본 논문은 직종-내 이질성을 포착하지 못한다는 점을 지적하며 발전시키는 선행 노출지수 중 하나로 인용 (p.13).
- Babina, Fedyk, He, and Hodson(2024) — 이력서 기반 AI 도입 측정의 선행연구. 본 논문은 AI 응용을 구체적 과업에 매핑한다는 점에서 차별화됨 (p.13).

## Glossary

- **AI 통합자(AI integrator)**: 이력서에 자신의 직무를 기업의 AI 응용 개발·도입으로 명시한 근로자 (p.7).
- **평균노출(mean exposure), m(δ)**: 직종이 수행하는 과업들의 평균 기술개선 정도로, 노동수요를 직접 낮추는 항 (식 14, p.18-19).
- **집중도(concentration), C(δ)**: 기술개선이 일부 과업에 쏠려있는 정도로, 과업 재배치를 통해 평균노출에 따른 노동수요 감소를 상쇄하는 항 (식 15, p.19).
- **shift-share 도구변수**: 대학별 AI졸업생 비중 증가("shift")와 기업의 사전기간(2005-09) 대학별 채용비중("share")을 결합해 기업단위 AI 도입비용의 외생적 변동을 추출하는 식별전략 (Section 3.1, p.23-24).
