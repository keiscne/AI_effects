---
title: "How will Language Modelers like ChatGPT Affect Occupations and Industries?"
authors: Ed Felten, Manav Raj, Robert Seamans
institution: ""
year: 2023
doi: ""
category: [labor_economics]
source_tier: 1
pdf_path: papers/local/felten-2023-how-will-language-modelers-like-chatgpt.pdf
pdf_filename: felten-2023-how-will-language-modelers-like-chatgpt.pdf
verified_date: 2026-06-22
datasets_used: []
---

## One-line Summary

Felten, Raj, Seamans(2018, 2021)가 개발한 AI Occupational Exposure(AIOE) 지수의 가중치를 언어모델링(language modeling) 응용에만 집중하도록 조정해, ChatGPT 같은 언어모델 AI에 대한 직업별·산업별 노출도를 측정하고 임금과의 관계를 분석한다(p.1, Abstract).

## Document Information

- 저자: Ed Felten (Princeton), Manav Raj (University of Pennsylvania), Robert Seamans (New York University, 교신저자) (p.1).
- 날짜: First draft 1 March 2023; this draft 18 March 2023 (p.1, 각주 1).
- SSRN: https://ssrn.com/abstract=4375268 (각 페이지 하단 워터마크).
- 저자 순서는 알파벳순이며 모든 저자가 동등하게 기여했다고 명시 (p.1, 각주 1).
- 키워드: artificial intelligence, ChatGPT, language modeling, occupation, technology (p.1).

## Key Contributions

- Felten et al.(2018, 2021)의 AI Occupational Exposure(AIOE) 방법론을 "언어모델링"이라는 단일 AI 응용에 가중치를 집중시켜 재계산하는 방법을 제시 (p.5, 식 (3)).
- 직업별 언어모델링 노출 점수의 상위 20개 직업과 상위 20개 산업 목록을 원본 AIOE 순위와 비교 제시 (Table 1, Table 2, p.14-15).
- 언어모델링 노출 점수와 평균/중위 임금 간의 양의 상관관계를 그래픽으로 제시 (Figure 2, Figure 3, p.12-13).
- 774개 직업 전체에 대한 언어모델링 노출 점수를 SOC 코드와 함께 부록에 전부 공개 (Appendix, p.17-36).

## Methodology and Data

- 원본 AIOE 구성: 10개 AI 응용 분야(전략게임, 실시간 비디오게임, 이미지 인식, 시각질의응답, 이미지 생성, 독해, **언어모델링**, 번역, 음성인식, 악기트랙인식)와 O*NET의 52개 인간 능력(예: 구두이해, 구두표현, 귀납적 추론, 손-팔 안정성 등)을 크라우드소싱 매트릭스로 연결 (p.4). AI 응용 데이터는 Electronic Frontier Foundation(EFF), 인간 능력 데이터는 미국 노동부 O*NET(800개 이상 직업 수록) (p.4).
- 능력 수준 노출도 식(1): $A_{ij} = \sum_{i=1}^{10} x_{ij}$ — i는 AI 응용, j는 직업 능력, x는 크라우드소싱 관련성 점수 (p.4).
- 직업 k의 AIOE 식(2): $AIOE_k = \dfrac{\sum_{j=1}^{52} A_{ij} \times L_{jk} \times I_{jk}}{\sum_{j=1}^{52} L_{jk} \times I_{jk}}$ — $L_{jk}$는 O*NET 능력의 보급도(prevalence), $I_{jk}$는 중요도(importance) (p.4).
- 언어모델링 조정: 식(3) $A_{ij} = \sum_{i=1}^{10} \alpha_i x_{ij}$에서, 언어모델링 응용의 가중치 $\alpha_i$만 1로 유지하고 나머지 9개 AI 응용의 $\alpha_i$는 모두 0으로 설정해 "언어모델링에만 노출된" 능력 수준 노출도를 재구성 (p.5).
- 원본 AIOE와 언어모델링 조정 AIOE 점수 간 상관계수는 **0.979** (p.5, Figure 1, p.11).
- 임금 데이터: 미국 노동통계국(BLS) Occupational Employment and Wage Statistics, **2021년**(분석 시점 기준 최신 가용 연도) 평균·중위 임금 (p.7, 각주 7: https://www.bls.gov/oes/).
- AIOE 데이터셋과 BLS 임금 데이터셋은 1차로 직업코드(occupational code), 2차로 직업명(occupational title)으로 매칭 — 코드가 변경되었지만 동일 직업인 경우까지 포착하기 위함. 매칭 결과 양 데이터셋에 공통으로 존재하는 직업 수는 **708개** (p.7).
- 임금-노출 관계 분석: 언어모델링 AIOE 점수를 기준으로 직업을 **20개의 동일 크기 구간(equal-sized bins)**으로 나누고, 각 구간의 평균 AIOE 점수와 해당 구간 직업들의 평균·중위 임금을 매칭해 산점도로 제시 (Figure 2: 평균임금, Figure 3: 중위임금, p.7, p.12-13).
- 회귀계수, 표준오차, t값, 신뢰구간 등은 원문에 보고되지 않음(그래프와 상관관계 서술만 제시) — Tier 3(공백) 처리.

## Key Results

- 언어모델링 노출 상위 1위 직업: **Telemarketers** (SOC 41-9041, 노출점수 1.926) (Table 1, p.14; Appendix, p.17).
- 상위 20위 안에 다수의 대학(postsecondary) 교원직 포함: English Language and Literature Teachers(2위, 1.857), Foreign Language and Literature Teachers(3위, 1.814), History Teachers(4위, 1.813), Law Teachers(5위, 1.802), Philosophy and Religion Teachers(6위, 1.800) 등 (Table 1, p.14; Appendix, p.17).
- 원본 AIOE와 언어모델링 AIOE 양쪽 상위 20위에 공통으로 등장하는 직업: "Clinical, Counseling, and School Psychologists"와 "History Teachers, Postsecondary" (p.6).
- 산업 노출 1위(언어모델링 기준): **Legal Services**; 원본 AIOE 기준 산업 1위는 **Securities, Commodity Contracts, and Other Financial Investments and Related Activities**이며 이 산업은 언어모델링 기준에서는 2위 (Table 2, p.15; 본문 p.7).
- 법률서비스(Legal Services), 보험및종업원급여기금(Insurance and Employee Benefit Funds), 보험중개·대리(Agencies, Brokerages, and Other Insurance Related Activities)는 원본·언어모델링 양쪽 리스트 상위 5위 안에 공통으로 포함 (p.7).
- 언어모델링 기준 리스트에는 고등교육 관련 산업(Junior Colleges, Grantmaking and Giving Services, Business Schools and Computer and Management Training)이 원본 리스트보다 더 높은 순위로 다수 포함 (p.7, Table 2).
- 임금과 노출의 관계: 평균임금·중위임금 모두에서 언어모델링 AIOE 점수와 강한 양의 상관관계(positive correlation)가 그래프로 확인됨 (Figure 2, Figure 3, p.12-13; 본문 p.7) — 정확한 상관계수 수치나 회귀계수는 본문에 보고되지 않음(공백).
- 노출도가 높은 직업들은 백색칼라(white-collar)·고숙련(high-skilled) 직업으로 분류될 가능성이 높은 직업들로 해석됨 (p.7-8).
- 부록 전체 목록(774개 직업, SOC 코드 포함) 중 점수 최저(가장 덜 노출됨) 직업은 **Pressers, Textile, Garment, and Related Materials** (SOC 51-6021, -1.854) (Appendix, p.36, 순위 774).

## Limitations and Future Work

- 저자들은 "노출(exposure)"이라는 용어가 AI가 해당 직업을 대체(substitution)할지 보완(augmentation)할지에 대해서는 불가지론적(agnostic)임을 명시 — 텔레마케터 사례를 들어 노출이 대체로 이어질지 보완으로 이어질지는 직업별 특성에 따라 달라진다고 설명 (p.3, p.6).
- 본 논문 자체에는 명시적인 "한계(Limitations)" 또는 "향후 연구(Future Work)" 절이 따로 존재하지 않으며, 결론(Section 6)에서 본 방법론이 학자·실무자·정책결정자에게 유용할 것이라는 기대만 제시 (p.8).

## Related Work

- Felten, Raj, and Seamans (2018) "A method to link advances in artificial intelligence to occupational abilities" — AIOE 방법론의 최초 제시 (p.3, References p.9).
- Felten, Raj, and Seamans (2021) "Occupational, industry, and geographic exposure to artificial intelligence: A novel dataset and its potential uses", *Strategic Management Journal* 42(12), 2195-2217 — 본 논문이 직접 확장하는 AIOE/AIIE 데이터셋의 원전 (p.3, p.5, References p.9).
- Acemoglu, Autor, Hazell, and Restrepo (2022) "Artificial intelligence and jobs: Evidence from online vacancies", *Journal of Labor Economics* 40(S1), S293-S340 (References p.9).
- Brynjolfsson, Mitchell, and Rock (2018); Frey and Osborne (2017); Tolan, Pesole, Martínez-Plumed, Fernández-Macías, Hernández-Orallo, and Gómez (2021); Webb (2020) — AI의 직업 영향을 측정하는 다른 체계적 방법론들 (p.3).
- Goldfarb, Taska, and Teodoridis (2020) — 산업별 AI 도입 수준의 이질성(IT·금융은 높고, 헬스케어·건설은 낮음)을 보인 선행연구 (p.2).
- Agrawal, Gans, and Goldfarb (2022) "ChatGPT and How AI Disrupts Industries", *Harvard Business Review*; Zarifhonarvar (2023) — ChatGPT의 경제적 영향에 관한 신생 문헌 (p.3).

## Glossary

- **AI Occupational Exposure (AIOE)**: Felten et al.(2018, 2021)이 개발한, 각 직업이 AI에 얼마나 "노출"되어 있는지를 측정하는 지수. 대체·보완 여부에는 불가지론적 (p.3).
- **AI Industry Exposure (AIIE)**: AIOE를 산업 단위로 가중 집계한 지수 (p.5).
- **O*NET**: 미국 노동부가 운영하는 Occupational Information Network 데이터베이스로, 800개 이상의 직업을 52개 인간 능력의 가중조합으로 기술 (p.4).
- **언어모델링 조정 AIOE (Language Modeling AIOE)**: 식(3)에서 언어모델링 응용에만 가중치 1을 부여하고 나머지 9개 AI 응용의 가중치를 0으로 설정해 산출한 노출 지수 (p.5).
- **Prevalence(보급도)/Importance(중요도)**: O*NET이 각 직업 내에서 특정 능력이 얼마나 보편적으로/중요하게 요구되는지를 나타내는 두 가지 가중치 체계 (p.4).
