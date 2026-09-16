---
title: "Occupational, Industry, and Geographic Exposure to Artificial Intelligence: A Novel Dataset and Its Potential Uses"
authors: Edward Felten, Manav Raj, Robert Seamans
institution: ""
year: 2021
doi: ""
category: [labor_economics]
source_tier: 1
pdf_path: papers/local/felten-2021-occupational-industry-and-geographic-exposure.pdf
pdf_filename: felten-2021-occupational-industry-and-geographic-exposure.pdf
verified_date: 2026-06-22
datasets_used: []
---

## One-line Summary

AI의 일반적 응용(이미지 인식, 언어 모델링 등 10개 EFF 분류)을 O*NET의 52개 직무능력에 크라우드소싱 방식으로 연결해 직업별 AI 노출지수(AIOE)를 구축하고, 이를 산업(AIIE)·지역(AIGE) 단위로 집계한 새로운 데이터셋을 제시한다.

## Document Information

- 저자: Edward Felten (Princeton University), Manav Raj (NYU Stern School of Business), Robert Seamans (NYU Stern School of Business, corresponding author) (p.1).
- 출판 정보: 본문에 게재 학술지명·공식 출판연도가 명시되어 있지 않음. 본문 풋노트(p.1)에 발표 이력으로 "2018 American Economic Association Annual meeting, 2019 Temple University Conference on AI, ML, and Business Analytics, 2019 Munich Summer Institute, 2019 EMAEE conference and the 2021 AI & Strategy Consortium"이 언급되어 있으며, 참고문헌 목록에서 가장 최근 연도의 인용은 Georgieff & Milanez (2021)임. 데이터 구성은 O*NET 24.3(2020년 5월 출시, p.9), NAICS 산업고용(2019년, "작성 시점 최신 자료", p.11), Burning Glass 직무공고 데이터(2018년 1월~7월, "작성 시점 접근 가능한 최신 데이터", p.50)를 사용. 이상의 단서를 근거로 연도를 2021로 기록함.
- SSRN 식별자: abstract=3822412 (각주 2, p.3; 데이터는 https://github.com/AIOE-Data/AIOE 에서 공개).
- 키워드: artificial intelligence, industry, innovation, occupation, technology (p.1).

## Key Contributions

- Felten, Raj, and Seamans (2018)의 방법론을 수정해 전진적(forward-looking) AI 직업노출지수 AI Occupational Exposure(AIOE)를 구축 (p.2, p.5, 각주 1).
- AIOE를 4자리 NAICS 산업 고용(2019년)으로 가중평균해 AI Industry Exposure(AIIE), 카운티 단위 고용(2019년, FIPS 코드 기준)으로 집계해 AI Geographic Exposure(AIGE)를 구축 (p.11-12).
- AI가 노동을 대체하는지 보완하는지에 대해 불가지론적(agnostic) 입장을 취하는 점, 자동화·로봇 전반이 아니라 AI 응용 자체에 특화된 점, 현재 직업 정의에 기반한 스냅숏(snapshot)이라는 점에서 기존 노출지수(Frey & Osborne 2017; Brynjolfsson et al. 2018, 2020; Webb 2020)와 구별됨 (p.18-19, Appendix D).
- AIOE를 기업 단위로 집계하는 방법을 제시(직업별 고용 비중으로 가중)하고, 이미 Acemoglu, Autor, Hazell, and Restrepo(2020)가 Burning Glass 기업 데이터와 결합해 사용한 사례를 소개 (p.21-22).

## Methodology and Data

- AI 응용 10개 선정: abstract strategy games, real-time video games, image recognition, visual question answering, image generation, reading comprehension, language modeling, translation, speech recognition, instrumental track recognition — Electronic Frontier Foundation(EFF)의 AI Progress Measurement 프로젝트가 2010년 이후 과학적 진보를 기록한 응용 분야 (p.6-7, Table 1, p.34).
- O*NET 직무능력 52개 항목(중요도 1–5, 수준 1–7 척도)을 사용 (p.7).
- Amazon Mechanical Turk(mTurk) 설문(약 2,000명, 응용당 약 200명)을 통해 "이 AI 응용이 이 직무능력과 관련있는가"를 Yes/No로 응답받아 응용-능력 연관성 매트릭스(0~1) 구축 (p.7-8, Appendix A, p.38-39).
- 능력 수준 노출지수: $A_{ij} = \sum_{i=1}^{10} x_{ij}$ (식 1, p.8) — i는 AI 응용, j는 직무능력.
- 직업 수준 AIOE: $AIOE_k = \frac{\sum_{j=1}^{52} A_{ij} \times L_{jk} \times I_{jk}}{\sum_{j=1}^{52} L_{jk} \times I_{jk}}$ (식 2, p.9) — 능력별 노출지수를 해당 직업 내 능력의 prevalence(L)와 importance(I)로 가중하고, 그 가중합으로 다시 나눠 상대적 노출(relative exposure)을 측정. Felten et al.(2018) 방법론에 대한 수정사항으로, 직업이 요구하는 능력의 폭(breadth)으로 정규화함 (p.9-10).
- O*NET 24.3(2020년 5월 출시) 데이터 사용. 8자리 SOC 직업 832개를 6자리 SOC 774개로 집계(평균), 이후 평균 0·표준편차 1로 표준화 (p.11).
- AIIE: AIOE를 4자리 NAICS 산업별 2019년 고용으로 가중평균 (p.11). AIGE: AIIE를 카운티별 2019년 산업 고용으로 가중평균, FIPS 코드 사용 (p.11-12).
- 데이터 부록: Data Appendix A(직업별 AIOE), B(4자리 NAICS 산업별 AIIE), C(AIGE), D(응용-능력 매트릭스), E(표준화된 능력 수준 AI 노출) — 모두 GitHub(https://github.com/AIOE-Data/AIOE)에서 공개 (p.12).
- 검증 방법 4가지(3.3절, Appendix C): (1) 응용-능력 매트릭스의 견고성 — 대학원 학위자 표본과의 상관 0.98(응용 수준)·0.97(능력 수준), 컴퓨터과학·공학 전공자 표본과의 상관 0.94(응용 수준)·0.92(능력 수준) (p.18, Appendix Table C1-C2, p.61-62); 컴퓨터과학자 4인 포커스그룹으로 구축한 대안 매트릭스와의 상관 ρ=0.987, p<0.001 (p.46). (2) 응용 선택에 대한 민감도 — 10개 응용 중 하나씩 제외한 대안 AIOE와의 상관계수 모두 0.99 초과(p<0.001, Appendix Table C3, p.63); 5개 핵심 응용(image recognition, language modeling, reading comprehension, speech recognition, translation)만 사용한 대안과의 상관 r=0.996, p<0.001 (p.47). (3) Burning Glass Technologies의 Labor Insight 직무공고 데이터(2018년 1~7월)에서 AI 스킬(Artificial Intelligence/Machine Learning/Natural Language Processing 클러스터) 사용과 AIOE의 상관 — 직무공고당 평균 AI 스킬 개수 r=0.263(p<0.001), AI 스킬 비율 r=0.234(p<0.001), AI 스킬 1개 이상 요구 비율 r=0.297(p<0.001) (p.50-51). (4) O*NET 과거 버전(2005, 2010, 2015) 입력자료로 구성한 과거 AIOE와 2020년 AIOE의 상관 — 2005년 0.911, 2010년 0.982, 2015년 0.995(모두 p<0.001) (p.52).

## Key Results

- AIOE 최고 점수 직업(상위 20개, Table 2, p.35): Genetic Counselors, Financial Examiners, Actuaries, Purchasing Agents, Budget Analysts, Judges/Magistrate Judges, Procurement Clerks, Accountants and Auditors, Mathematicians, Judicial Law Clerks 등 — 고학력 화이트칼라 직종 중심.
- AIOE 최저 점수 직업(하위 20개, Table 2, p.35): Dancers, Fitness Trainers and Aerobics Instructors, Helpers(Painters/Plasterers/Stucco Masons), Reinforcing Iron and Rebar Workers, Pressers(Textile/Garment), Slaughterers and Meat Packers 등 — 신체노동 중심 직종.
- AIIE 최고 점수 산업(Table 3, p.36): Securities, Commodity Contracts, and Other Financial Investments and Related Activities(1위), Accounting/Tax Preparation/Bookkeeping/Payroll Services(2위), Insurance and Employee Benefit Funds(3위), Legal Services(4위), Software Publishers(9위) 등.
- AIIE 최저 점수 산업(Table 3, p.36): Support Activities for Crop Production(1위), Services to Buildings and Dwellings(2위), Foundation/Structure/Building Exterior Contractors(3위), Animal Slaughtering and Processing(4위), Warehousing and Storage(6위) 등.
- 외과의사(surgeons)의 AIOE는 전체 표본 중 52번째 백분위, 도축업자(slaughterers)는 2번째 백분위(하위 10번째)로, 유사한 신체능력(손기술 등)을 요구함에도 인지능력(문제 감지, 연역·귀납적 추론, 정보 정렬) 비중 차이가 노출도 격차의 원인 (p.15-16).
- 수학기술자(mathematical technicians)와 회계사·감사인(accountants and auditors)은 모두 인지능력 비중이 80.0%로 유사(중위 직업은 56.8%)하나, AIOE는 각각 68번째·99번째 백분위로 격차가 큼 — 비인지능력 중 감각능력(sensory) 비중이 회계사·감사인 90.6% vs 수학기술자 52.6%로 차이가 나며, 감각능력이 신체·정신운동능력보다 AI에 더 많이 노출되어 있어 발생 (p.16-17).
- 장거리 화물트럭 운전자의 AIOE는 14번째 백분위, 택시운전사·쇼퍼는 34번째 백분위로 모두 낮은 수준 — AIOE가 로봇공학(자율주행의 물리적 구동부)을 포착하지 못하고 AI 응용 자체만 측정하기 때문으로 해석 (Appendix B, p.42-43).
- 외과의사는 조정 전 표본 내 3위(평균 대비 3.28 표준편차), 물리학자는 4위(3.14 표준편차)였으나, 능력 폭으로 정규화(식 2) 후 물리학자는 61위(1.35 표준편차, 여전히 고노출)인 반면 외과의사는 387위(평균 대비 0.05 표준편차 낮음, 고노출 분류에서 제외)로 순위가 크게 변동 (p.10-11).
- 8자리 SOC 832개 직업을 6자리 SOC 774개로 집계 (p.11).
- Figure 1(p.33)의 AIGE 미국 본토 카운티 지도: 색상 척도는 1·99 백분위로 윈저화(winsorized), 범위는 −3.617~2.942. 대서양 연안(보스턴-뉴욕-필라델피아-볼티모어-워싱턴D.C.)과 베이 에어리어가 고노출, 아이오와주는 농촌 지역임에도 일부 카운티가 고노출로 나타남 (p.24, Figure 1).

## Limitations and Future Work

- 크라우드소싱 응답자의 인식이 현재까지의 AI 발전 양상과 AI에 대한 통속적 이해에 의해 편향될 수 있으며, 창의적이거나 비전통적인 AI 응용 방식을 예측하지 못할 가능성 (Appendix A, p.39).
- AIOE는 직업 내 능력 구성이 정확하게 기술되어 있다는 가정에 의존하며, 기술 발전에 따른 직업 내 능력 구성 변화(예: 자율주행이 보급되면 택시운전사의 구술이해·언어인지 능력 중요도가 낮아질 가능성)를 반영하지 못함 (Appendix B, p.43-44).
- O*NET 갱신에 따라 향후 데이터 갱신 시, AI가 보완하는 능력은 수요가 늘어난 것으로, 대체하는 능력은 수요가 줄어든 것으로 잘못 해석되어 편향이 발생할 수 있음 (Appendix C.4, p.52-53).
- 로봇공학·센서 등 AI 이외의 기술에 의한 노출은 측정하지 않음을 방법론적으로 명시 — 자율주행차량과 같이 AI와 로봇공학이 결합된 기술의 영향은 AIOE가 부분적으로만 포착 (Appendix B, p.43).
- AI 응용 10개를 독립적인 것으로 가정하고 응용 간 상호작용을 고려하지 않음(계산상 불가능하다고 명시) (p.8).

## Related Work

- Felten, E. W., Raj, M., and Seamans, R. (2018) "A Method to Link Advances in Artificial Intelligence to Occupational Abilities" — 본 논문이 수정해 사용하는 원래 방법론(과거 회고적 측정, 2010~2015년) (p.2, p.5, 각주 1).
- Frey, C. B., and Osborne, M. A. (2017) "The future of employment" — 전문가 예측 기반 자동화 대체가능성 측정, 본 논문과 구별되는 대표적 기존 데이터셋 (p.3, p.12, Appendix D).
- Brynjolfsson, E., Mitchell, T., and Rock, D. (2018); Brynjolfsson, E., Frank, M. R., Mitchell, T., Rahwan, I., and Rock, D. (2020) — 머신러닝 적합성(suitability for machine learning) 기반 크라우드소싱 측정, 본 논문과 구별되는 기존 데이터셋 (p.3, p.18-19, Appendix D).
- Webb, M. (2020) "The Impact of Artificial Intelligence on the Labor Market" — 특허 텍스트 기반 머신러닝 노출 측정 (p.18-19, Appendix D).
- Mann, K., and Püttmann, L. (2017) "Benign Effects of Automation: New Evidence from Patent Texts" — 자동화 특허 기반 측정 (Appendix D, p.67-68).
- Acemoglu, D., Autor, D., Hazell, J., and Restrepo, P. (2020) "AI and Jobs: Evidence from Online Vacancies" — 본 논문의 AIOE를 기업 단위 Burning Glass 데이터와 결합해 AI 인력 채용 패턴 연구에 활용한 사례 (p.21-22, p.26).
- Goldfarb, A., Taska, B., and Teodoridis, F. (2019) "Could Machine Learning be a General-Purpose Technology?" — AIOE를 의료산업의 범용기술 여부 검증에 활용 (p.26).
- Fossen, F. M., and Sorgner, A. (2019) — AIOE를 활용해 AI가 성장지향적 창업 기회에 미치는 영향을 연구 (p.26).

## Glossary

- **AI Occupational Exposure (AIOE)**: O*NET 6자리 SOC 직업 단위로 측정한 AI 노출지수. 평균 0, 표준편차 1로 표준화 (p.9, p.11).
- **AI Industry Exposure (AIIE)**: AIOE를 4자리 NAICS 산업의 2019년 고용 비중으로 가중평균한 산업 단위 노출지수 (p.11).
- **AI Geographic Exposure (AIGE)**: AIIE를 카운티(FIPS 코드)의 2019년 산업별 고용 비중으로 가중평균한 지역 단위 노출지수 (p.11-12).
- **EFF AI Progress Measurement**: Electronic Frontier Foundation이 운영하는 AI 응용별 과학적 진보 추적 프로젝트로, 본 논문의 10개 AI 응용 선정 기준 (p.5-6).
- **O*NET 직무능력(occupational abilities)**: 미국 노동부가 개발한 O*NET 데이터베이스가 정의하는 52개 직무 수행 능력, 중요도(importance, 1–5)와 수준(level/prevalence, 1–7)으로 측정 (p.7).
