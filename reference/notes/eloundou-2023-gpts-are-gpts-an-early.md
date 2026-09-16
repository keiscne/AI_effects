---
title: "GPTs are GPTs: An Early Look at the Labor Market Impact Potential of Large Language Models"
authors: Tyna Eloundou, Sam Manning, Pamela Mishkin, Daniel Rock
institution: ""
year: 2023
doi: ""
category: [labor_economics]
source_tier: 1
pdf_path: papers/local/eloundou-2023-gpts-are-gpts-an-early.pdf
pdf_filename: eloundou-2023-gpts-are-gpts-an-early.pdf
verified_date: 2026-06-22
datasets_used: []
---

## One-line Summary

GPT-4 분류와 인간 평가를 결합한 새로운 노출(exposure) 루브릭으로 미국 O*NET 직업 데이터베이스 전체를 평가한 결과, 미국 근로자의 약 80%가 업무 과업의 최소 10%에서 LLM의 영향을 받을 수 있고, 약 19%는 과업의 최소 50% 이상이 영향받을 수 있다고 추정하며, LLM이 일반목적기술(general-purpose technology)의 특성을 보인다고 결론짓는다.

## Document Information

- 저자: Tyna Eloundou(OpenAI), Sam Manning(OpenAI, OpenResearch), Pamela Mishkin(OpenAI, 교신저자), Daniel Rock(University of Pennsylvania) (p.1).
- 발행: arXiv:2303.10130v5 [econ.GN], 2023년 8월 22일(v5), "WORKING PAPER" 표기 (p.1).
- 저자들은 알파벳순으로 기재되었으며 동등하게 기여했다고 명시 (p.1, 각주).

## Key Contributions

- LLM 및 LLM-기반 소프트웨어에 대한 과업(task)·작업활동(DWA) 단위의 새로운 노출 루브릭(E0~E3)을 제시하고, 이를 O*NET 데이터베이스 전체(1,016개 직업, 19,265개 과업, 2,087개 DWA)에 적용 (p.1, 3.1절, Appendix A.1).
- 인간 평가자와 GPT-4 분류자를 모두 활용해 노출 지수를 산출하고, 두 방법 간 직업 단위 상관관계가 높음을 보임 (Table 2, Figure 2, p.5-6).
- 임금, 산업, 교육·훈련 장벽(Job Zone), O*NET 기본 스킬(Basic Skills)별로 노출도의 분포를 체계적으로 분석 (4절 전체, Table 3-10).
- 기존 자동화·AI 노출 측정치(Webb 2020, Felten et al. 2018, Frey and Osborne 2017, Acemoglu and Autor 2011a, Brynjolfsson et al. 2018/2023의 SML)와 회귀분석으로 비교해, 새 측정치가 28~40%의 미설명 분산을 추가로 갖는다는 것을 보임 (5.1절, Table 8-9).

## Methodology and Data

- 데이터: O*NET 27.2 데이터베이스(1,016개 직업, 19,265개 과업, 2,087개 DWA) (p.6, 3.1절). BLS 2020·2021 Occupational Employment series(직업명, 직업별 근로자 수, 2031년 고용 전망, 필요 교육·훈련 수준)와 BLS-O*NET crosswalk, BLS Labor Force Demographics(CPS 기반) (p.6, 3.2절).
- 노출(exposure) 정의: LLM 또는 LLM 기반 시스템 접근이 동등한 품질을 유지하면서 특정 DWA/과업 완료 시간을 50% 이상 줄일 수 있는지 여부 (p.6-7, 3.3절).
- 노출 등급: E0(노출 없음), E1(직접 노출 — ChatGPT/OpenAI playground 단독으로 50% 이상 시간단축), E2(LLM 기반 응용 프로그램 추가 개발 시 노출, 이미지 능력 제외), E3(이미지 능력 결합 시 노출) — E2와 E3은 분석에서 결합 (p.7, Appendix A.1).
- 종속변수 3종: 𝜷=E1(직접 노출, 하한), 𝜻=E1+0.5×E2(보완투자 필요성 반영 가중), 𝝓=E1+E2(최대 노출 상한) (p.8).
- 라벨링: 저자 본인들이 다수의 과업·DWA를 직접 라벨링하고, GPT-3/3.5/4 출력 검토 경험이 있는 사람 평가자(human annotators)를 추가 고용 (Human Ratings); 동일 취지의 약간 수정된 루브릭을 "초기 버전"의 GPT-4에 프롬프트로 제공해 전체 과업/직업 쌍에 라벨링 (GPT-4 Ratings) (p.7-8, 3.3절).
- 모델-인간 일치도(Table 2, p.7): GPT-4 Rubric 1 vs Human — E1 기준 일치율 80.8%, Pearson r=0.223; E1+E2 기준 일치율 82.1%, r=0.654. GPT-4 Rubric 1 vs GPT-4 Rubric 2 — E1 기준 일치율 91.1%, r=0.611.
- 한계로 명시한 항목(3.4절): (1) 평가자의 직업적 다양성 부족으로 인한 편향 가능성, (2) GPT-4 분류는 루브릭 문구·순서·예시 제시 여부에 민감, (3) 과업 기반 분해가 직업을 완전히 대표하는지 불확실, (4) 미래 예측이며 변경 가능, (5) 사람-모델 간 의견 불일치가 발생하는 영역(다자간 협상·규제/규범상 인간 개입 필요 영역·이미 자동화 기술이 존재하는 영역) 존재.
- 회귀분석(Table 5, p.16): O*NET Basic Skills 중요도 점수(0~1 정규화)를 직업단위 인간평가 노출(𝜻)에 회귀. Reading Comprehension 계수 0.082(s.e. 0.011, ***, 𝜷); Writing 계수 0.128(s.e. 0.047, **, 𝜷)·0.214(s.e. 0.043, ***, 𝜻); Critical Thinking 계수 -0.127(s.e. 0.026, ***, 𝜷); 표 내 다른 행들은 스킬명과 계수 행 간 정렬이 본문 추출 과정에서 어긋나 일부 스킬-계수 대응이 불확실하므로 해당 항목은 공백으로 둔다 (Table 5, p.16).
- 산업간 비교(5.1절, Table 8-9): Webb(2020)의 Software/Robot/AI 점수, Felten et al.(2018)의 AI Occupational Exposure Score, Frey and Osborne(2017)의 Automation 점수, Acemoglu and Autor(2011a)의 정규화된 routine cognitive/manual 점수, Brynjolfsson et al.(2018, 2023)의 Suitability for Machine Learning(SML) 점수를 BLS 임금과 함께 통제변수로 사용한 OLS 회귀, N=680~681 (Table 9, p.17).

## Key Results

- 직업단위 평균 노출(Table 3, p.9): 𝜷(=E1) 평균 — Human 0.14(s.d. 0.14), GPT-4 0.14(s.d. 0.16); 𝜻 평균 — Human 0.30(s.d. 0.21), GPT-4 0.34(s.d. 0.22); 𝝓 평균 — Human 0.46(s.d. 0.30), GPT-4 0.55(s.d. 0.34).
- 과업단위 평균 노출(Table 3, p.9): 𝜷 평균 — Human 0.15(s.d. 0.36), GPT-4 0.14(s.d. 0.35); 𝝓 평균 — Human 0.47(s.d. 0.50), GPT-4 0.56(s.d. 0.50).
- 𝜷 값 기준으로 미국 근로자의 **약 80%**가 과업의 최소 10% 이상이 노출된 직업에 속하며, **약 19%**는 과업의 절반 이상이 노출된 직업에 속함 (Abstract, p.1, 4.1절 p.8).
- Job Zone별 𝝓 노출 50% 초과 근로자 비율(p.13, 4.4절): Job Zone 1 = 0.00%, Job Zone 2 = 6.11%, Job Zone 3 = 10.57%, Job Zone 4 = 34.5%, Job Zone 5 = 26.45%.
- Job Zone별 중위 소득(4.4절, p.13): Job Zone 1 근로자 중위소득 $30,230, Job Zone 5 근로자 중위소득 $80,980 — 준비 수준이 높아질수록 중위소득이 단조 증가.
- Table 4(p.14-15) 최고 노출 직업: Human 𝜷 기준 1위 Interpreters and Translators(76.5%); Human 𝝓 기준 Mathematicians, Tax Preparers, Financial Quantitative Analysts, Writers and Authors, Web and Digital Interface Designers 등 15개 직업이 100% 노출로 라벨링됨; Model(GPT-4) 𝜻 기준 1위 Mathematicians(100.0%); Model 𝝓 기준 Accountants and Auditors, News Analysts/Reporters/Journalists, Legal Secretaries and Administrative Assistants, Clinical Data Managers, Climate Change Policy Analysts 등 86개 직업이 100% 노출로 라벨링됨.
- Figure 3 관련: GPT-4 평가 기준 𝝓과 𝜷의 평균 차이는 0.42, 인간 평가 기준 0.32 — LLM 기반 소프트웨어가 LLM 단독보다 노출에 더 크게 기여할 수 있음을 시사 (6.1절, p.18).
- 산업별 노출(Appendix C, p.27-28): 정보처리(data/information processing) 산업과 병원(hospitals)이 인간·GPT-4 평가 모두에서 높은 노출을 보임. 2012년 이후 산업별 생산성 성장과 LLM 노출 간 상관관계는 낮은 것으로 나타남.
- 노출 없음으로 분류된 직업(Table 11, p.30): 농업장비 운전자, 운동선수, 자동차 유리 설치/수리공 등 총 **34개 직업**이 모든 측정치에서 노출 과업이 0으로 라벨링됨.
- 기존 측정치와의 회귀(Table 9, p.17): N=680~681, R²는 0.60198~0.71213 범위 — 기존 5개 측정치(Webb 3종, Felten AIOE, Frey-Osborne, Acemoglu-Autor routine 점수, SML)와 임금 통제 변수가 새 LLM 노출 측정치 분산의 60.7~72.8%를 설명, 나머지 28~40%는 미설명 (5.1절 p.16-17, Table 9).
- 교육수준별 노출(Table 10, p.29): 무자격(No formal educational credential) 평균 중위소득 $31,900, 𝜷 노출 Human 0.05/Model 0.06; Bachelor's degree 평균 중위소득 $78,375, 𝜷 노출 Human 0.12/Model 0.14; Master's degree 평균 중위소득 $79,605, 𝜷 노출 Human 0.23/Model 0.17 — 학사 이상 학위 보유자가 무자격자보다 전반적으로 높은 노출도를 보임.

## Limitations and Future Work

- 저자가 명시한 한계(6.3절, p.19): (1) 미국에 국한된 분석으로 산업구조·기술 인프라·규제·언어·문화가 다른 국가에는 일반화하기 어려움; (2) 향후 연구는 부문·직업별 실제 LLM 도입 패턴을 추적하는 연구와, 최신 모델의 실제 능력·한계를 노동활동과 대조하는 연구가 필요; (3) GPT-4의 멀티모달(이미지) 능력이 발전했음에도 직접노출(𝜷) 평가에서는 이미지 능력을 고려하지 않았음; (4) 복잡하고 개방적이며 도메인 특화된 과업에서는 이론적 성능과 실제 성능 간 괴리가 있을 수 있음.
- 그 외 3.4.3절에서 명시한 약점: 과업 기반 틀 자체의 타당성(직업을 과업으로 완전히 분해할 수 있는지 불확실), 평가자의 전문성 부족(특정 직업에 대한 사전지식 없이 DWA를 라벨링), 미래 예측이라는 한계, 사람-모델 간 의견 불일치가 발생하는 특정 영역의 존재.
- 본 논문은 노동시장에 대한 영향만 평가하며 총요소생산성(TFP)이나 자본투입 변화는 고려하지 않음을 명시 (4절 도입부, p.8).

## Related Work

- Acemoglu and Restrepo (2018, 2019) — 과업 전치효과(task-displacement)·복원효과(task-reinstatement) 구분의 토대 (2.2절).
- Felten, Raj, and Seamans (2018, 2023) — AI Occupational Exposure(AIOE) 방법론 및 언어모델 특화 버전; 본 논문이 가장 직접적으로 비교·확장하는 선행연구 중 하나 (2.2절, 5.1절, Table 8-9). [[felten-2023-how-will-language-modelers-like-chatgpt]]
- Frey and Osborne (2017) — 전문가 라벨링과 분류기를 결합한 자동화가능성(Automation) 추정.
- Webb (2020) — 특허 텍스트와 과업 설명을 매칭한 Software/Robot/AI 노출 점수.
- Acemoglu and Autor (2011a) — O*NET 기반 routine/non-routine, manual/cognitive 과업내용 분류.
- Brynjolfsson, Mitchell, and Rock (2018); Brynjolfsson, Frank, Mitchell, Rahwan, and Rock (2023) — "Suitability for Machine Learning"(SML) 루브릙; 본 논문 방법론이 가장 직접적으로 토대로 삼는 선행연구 (5.1절).
- Noy and Zhang (2023); Peng, Kalliamvakou, Cihon, and Demirer (2023) — 생성형 AI의 실증 생산성 효과(GitHub Copilot 등), 본 논문이 인용하나 직접 분석하지는 않음.
- Goldfarb, Taska, and Teodoridis (2023) — 머신러닝의 일반목적기술 여부를 채용공고로 분석; 본 논문과 유사한 연구 질문을 다른 데이터로 검증.

## Glossary

- **노출(Exposure)**: LLM 또는 LLM 기반 시스템에 접근했을 때, 동등한 품질을 유지하면서 특정 작업활동(DWA)이나 과업을 완료하는 데 필요한 시간을 50% 이상 줄일 수 있는지를 나타내는 척도 (p.6-7).
- **DWA (Detailed Work Activity)**: 과업 완료의 일부를 구성하는 포괄적 행동 단위, O*NET에서 정의 (p.6, 3.1절).
- **E0/E1/E2/E3**: 노출 등급 — E0 노출없음, E1 LLM 단독 직접노출, E2 LLM 기반 응용 프로그램을 통한 노출(이미지 제외), E3 이미지 능력 결합 시 노출 (Appendix A.1).
- **𝜷, 𝜻, 𝝓**: 본 논문이 정의한 세 가지 노출 종속변수 — 𝜷=E1(하한), 𝜻=E1+0.5×E2, 𝝓=E1+E2(상한) (p.8).
- **Job Zone**: O*NET이 정의한 직업 준비도(교육·경력·현장훈련 필요 정도) 분류, 1(준비기간 3개월 이하)부터 5(4년 이상)까지 (4.4절, p.12).
- **일반목적기술(General-Purpose Technology, GPT)**: 시간에 따른 지속적 개선, 경제 전반에 대한 광범위한 확산, 보완적 혁신의 창출이라는 세 가지 특성을 갖는 기술 (Bresnahan and Trajtenberg 1995; Lipsey et al. 2005 인용, 6.1절).
