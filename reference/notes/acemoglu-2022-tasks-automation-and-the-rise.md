---
title: "Tasks, Automation, and the Rise in U.S. Wage Inequality"
authors: Daron Acemoglu, Pascual Restrepo
institution: ""
year: 2022
doi: ""
category: [applied_econometrics]
source_tier: 1
pdf_path: papers/local/acemoglu-2022-tasks-automation-and-the-rise.pdf
pdf_filename: acemoglu-2022-tasks-automation-and-the-rise.pdf
verified_date: 2026-06-26
datasets_used: []
---

## One-line Summary

500개 인구통계 집단×49개 산업 자료로 노동자 집단이 직접 겪는 과업변위(task displacement)를 측정하는 방법론을 개발해, 1980~2016년 미국 임금구조 변화의 50~70%(일반균형 효과 포함 시 약 50%)가 자동화에 기인함을 보이고, 그 효과가 큰 임금 분산 확대와 작은(3.4%) 누적 생산성 증가를 동시에 낳는다는 것을 보인다.

## Document Information

- 저자: Daron Acemoglu (MIT), Pascual Restrepo (Boston University)
- 게재지: *Econometrica*, Vol. 90, No. 5 (September 2022), pp. 1973–2016
- 담당 편집자: Charles I. Jones; 투고일 2021-06-07, 게재확정 2022-02-18

## Key Contributions

- Zeira(1998), Acemoglu and Zilibotti(2001), Autor·Levy·Murnane(2003), Acemoglu and Autor(2011), [[acemoglu-2018-the-race-between-man-and|Acemoglu and Restrepo(2018)]]의 과업기반 모형과 Grossman and Rossi-Hansberg(2008)의 오프쇼어링 모형을 다부문·다과업·다집단(여러 인구통계 집단, 유연한 비교우위)으로 일반화한 이론적 틀을 제시 (Section 2).
- 노동자 집단의 임금변화를 그 집단이 겪는 직접 과업변위(direct task displacement)에 연결하는 명시적 수식(식 6, 13)을 도출 — 자동화는 항상 자본소득분배율을 높이고 노동소득분배율을 낮추는 반면, 요소증대형·생산성심화형 기술은 대체탄력성 λ에 따라 효과의 방향이 달라짐을 증명 (Proposition 2).
- 과업변위 측정치를 두 가지로 구축: (1) 관측된 산업 노동소득분배율 하락에 기반한 측정, (2) 산업용 로봇·전용기계·특화소프트웨어 도입을 이용해 노동소득분배율 하락 중 자동화로 인한 부분만 분리한 측정(이 세 변수가 1987~2016년 산업 노동소득분배율 변화의 45%를 설명) (Section 2.4, 3절).
- 500개 인구통계 집단(성별×교육×연령×인종×이민자 여부)에 대해 직접 과업변위와 실질임금 변화 간의 축소형 관계를 추정하고, SBTC·자본심화·TFP성장·탈노조화·중국수입경쟁·마크업/산업집중도를 통제해도 결과가 견고함을 보임 (Section 4).
- 산업간 구성변화와 노동자 집단 간 파급효과(ripple effect)를 포착하는 전이행렬(propagation matrix) Θ를 도출·추정해, 직접효과뿐 아니라 일반균형 효과까지 정량화하는 방법론을 제시 (Section 5, Proposition 4).

## Methodology and Data

- 이론: 단일부문 모형에서 과업 몫(task share) Γ_g, Γ_k를 도입해 산출·임금·자본분배율을 과업 몫의 함수로 표현(Proposition 1); 이를 다부문(산업 i)으로 확장해 산업가격 p_i, CES 산업수요 s_i^Y(p)를 포함하는 균형을 특성화(Proposition 3).
- 자동화의 직접 과업변위(식 5): dlnΓ_g^auto = (자동화된 과업 집합 D_g의 노동생산성 가중 측도)/(기존 과업 집합 T_g의 측도); λ=1, Assumption 1(과업 비중복)·Assumption 2(루틴 과업만 자동화 가능) 하에서 dlnΓ_g^auto를 관측 가능한 식(식 14)으로 단순화.
- 데이터: BEA Integrated Industry-Level Production Accounts(49개 산업, 1987~2016) 노동소득분배율·요소가격·부가가치; 산업 로봇 침투도(조정됨, Acemoglu and Restrepo(2020) 방법), 전용기계·특화소프트웨어 부가가치 비중 변화(BLS Total Multifactor Productivity); Feenstra and Hanson(1999) 중간재 수입 비중(오프쇼어링); Autor·Dorn·Hanson(2013) 중국수입경쟁 노출.
- 노동자 자료: 1980년 U.S. Census + 2014–2018년 American Community Survey(ACS, 통합)로 성별·교육(5단계)·연령(10세 구간)·인종(5범주)·출생지에 따른 500개 인구통계 집단의 1980→2016년 실질임금·고용·비참여율 변화를 측정.
- 루틴 직업 분류: Acemoglu and Autor(2011)의 정의(1980년 직업의 1/3이 루틴으로 분류)를 자동화 가능 과업의 대리변수로 사용; Webb(2020)의 특허텍스트 기반 측정으로도 강건성 확인.
- 식별: 핵심 도구변수로 로봇 침투도·전용기계·특화소프트웨어를 사용한 2SLS(첫단계 F=846.9 등); 일반균형 분석에서는 산업수요 탄력성 η=0.2(Buera·Kaboski·Rogerson 2015), 과업 간 대체탄력성 λ=0.5(Humlum 2020), 자동화 비용절감률 π=30%를 사용.

## Key Results

- 기준 회귀(Table I, Panel B, col. 3 — 자동화발 노동소득분배율 하락 기반 측정, 산업변화요인·제조업비중·교육·성별 통제): 과업변위 계수=−1.36(표준오차 0.21), 설명되는 분산 비중=53%, R²=0.83, N=500. 동일 명세에서 노동소득분배율 기반 측정(Panel A col. 3): 계수=−1.31(0.19), 설명비중 55%.
- 단순 회귀(col. 1)에서 25%p의 과업변위 증가(예: 고졸 미만 26~35세 백인 남성이 겪는 수준)는 약 40%의 상대임금 하락과 연관(계수 −1.6, 표준오차 0.09, 분산의 67% 설명).
- 2SLS(Table II, Panel A col. 1, 로봇·기계·소프트웨어를 도구변수로 사용): 계수=−1.23(표준오차 0.19), 1단계 F=846.9, 설명비중 50%.
- 고용효과(Table IV): 자동화발 측정 기준, 과업변위 10%p 증가는 고용률을 4.4%p 낮추고(계수 −0.44, 표준오차 0.16) 비참여율을 3.5%p 높임(계수 0.35, 표준오차 0.16).
- SBTC와의 비교(Table III): 과업변위를 통제하지 않으면 교육수준 더미가 임금구조 변화의 55%를 설명하지만, 과업변위를 포함하면 교육수준의 설명력은 17% 미만으로 줄고 과업변위가 50% 이상을 설명. 대졸-고졸 임금 프리미엄 차이는 과업변위 포함 시 거의 사라짐.
- 마크업·산업집중도·탈노조화·중국수입경쟁을 통제해도 과업변위 계수는 −1.3 내외로 안정적(Table V, VI) — 이들 요인 자체는 임금구조에 직접적·독립적 영향이 거의 없음.
- 일반균형 정량화(Table VIII, 자동화발 측정 기준): 직접 과업변위 효과만으로는 임금구조 변화의 93.34%를 설명하지만, 전이행렬을 통한 파급효과(ripple effect)를 반영하면 46.88%로 줄어듦(노동자들이 비자동화 과업을 두고 경쟁하며 효과가 분산되기 때문). 대학 프리미엄 상승은 데이터 25.51% 중 모형 21.02%(80% 이상 직접효과에서 기인 37.71%p), 성별 임금격차 축소는 데이터 15.37% 중 모형 1.90%, 노동소득분배율 하락은 자동화로 인해 −10.41%p(전체 관측 −8%p와 유사한 크기).
- 거시 효과는 작음: 1980~2016년 누적 TFP 증가는 3.42%, 평균 실질임금 증가는 5.18%(데이터 상 실제 증가 35%, 29.15%)에 불과 — 즉 자동화는 큰 분배효과를 낳지만 생산성효과는 작아, 정체된 실질임금과 둔화된 생산성 성장이 함께 나타날 수 있음을 보여줌.

## Limitations and Future Work

- 저자가 명시한 한계 및 향후 연구방향(Section 6): (1) 모형이 정태적이어서 자본축적, 새 기술 개발의 동태적 유인, 교육·숙련습득에 대한 효과가 빠져 있음; (2) 본 논문은 새로운 노동집약적 과업의 창출 효과를 모형화·추정하지 않음 — 이는 [[acemoglu-2018-the-race-between-man-and|Acemoglu and Restrepo(2018)]]에서 다룬 주제이며 향후 연구과제로 남김; (3) 산업 단위 노동소득분배율 하락에 의존했으나, 최근 연구들(Acemoglu, Lelarge, and Restrepo(2020) 등)은 하락이 일부(주로 대형) 기업에 집중됨을 보여 기업 단위 경쟁 모형화가 필요; (4) 분석이 1980~2016년 미국에 한정되어, 다른 시기·국가로 확장할 자료 구축이 필요.

## Related Work

- [[acemoglu-2018-the-race-between-man-and]] — 본 논문 이론 모형의 직접적 토대인 과업기반 정태·동태 모형(참고문헌에 명시적으로 인용됨).
- [[acemoglu-2022-artificial-intelligence-and-jobs-evidence]] — 본 논문 각주 12에서 "AI 활용은 2015년 이후 본격화된다"는 근거로 인용된 사업장 단위 AI 노출 연구.

## Glossary

- **과업변위(task displacement)**: 자동화로 인해 한 노동자 집단이 직접 잃는 과업 몫의 비율 — 산업×루틴직무 특화도×자동화발 노동소득분배율 하락의 가중합으로 측정 (식 14).
- **전이행렬(propagation matrix), Θ**: 한 집단의 과업변위가 다른 집단의 임금에 미치는 파급효과(ripple effect)를 포착하는 G×G 행렬 — 과업을 두고 경쟁하는 정도를 나타냄 (Section 5.1).
- **자동화발 노동소득분배율 하락(automation-driven labor share decline)**: 로봇·전용기계·특화소프트웨어 도입으로 설명되는 산업 노동소득분배율 하락의 구성요소.
- **충분통계량(sufficient statistics) 접근**: 과업변위(직접효과)와 비용절감(cost savings)이라는 두 통계량만으로 자동화의 임금·생산성·자본분배율 효과를 요약하는 분석방법 (Proposition 2).
