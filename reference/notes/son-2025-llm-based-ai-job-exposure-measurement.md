---
title: "LLM을 통한 AI 직업 노출도 측정 연구"
authors: 손녕선, 노희용
institution: 정보통신정책연구원
year: 2025
doi: ""
category: [labor_economics]
source_tier: 1
pdf_path: papers/local/son-2025-llm-based-ai-job-exposure-measurement.pdf
pdf_filename: son-2025-llm-based-ai-job-exposure-measurement.pdf
verified_date: 2026-08-14
datasets_used: []
---

## One-line Summary

O*NET 923개 직업의 과업 텍스트에 8개 오픈소스 LLM을 델파이 참여자 후보로 적용해 강건성 검정(분산지표+텍스트 코사인 유사도)으로 5개 모델을 최종 선정하고, GPT-4o를 메타평가자로 삼아 두 가지 방식(전체 종합 AIE_S1, 최다동의 모델 선택 AIE_S2)의 AI 직업 노출도를 산출·검증한 정보통신정책연구원(KISDI) 정책자료.

## Document Information

- 자료명: 「LLM을 통한 AI 직업 노출도 측정 연구」(정책자료 25-12-03)
- 소속 사업: 2025 데이터 기반 미래예측·정책지원 사업(연구보고총서 25-12-01~05, KISDI 등 5개 기관 공동 시리즈 중 하나)
- 발행: 정보통신정책연구원(KISDI), 발행인 이상규, 2025년 12월
- 저자: 손녕선(총괄책임자, 연구위원), 노희용(참여연구원, 연구위원)
- ISBN: 979-11-7000-446-2 / 94320
- 연구 추진 체계 특기사항: 당초 KISDI 내부 연구진만으로 기획했으나 과제 수행 중 연구책임자 1인이 한국기술교육대학교로 이직하면서, 미가공 노출도(raw value) 생성은 한국기술교육대학교가, 메타평가(최종 결과물 산출)는 KISDI가 각각 담당하는 협업 체계로 마무리됨(전문가 자문 형태).

## Key Contributions

- AI 직업 노출도 측정을 위해 8개 오픈소스 LLM(Deepseek-R1, Falcon, Hermes3, Gemma3, Llama3.3, Mistral-small, Phi4, QWQ2.5)을 델파이 참여자 후보로, GPT-4o를 진행촉진자(메타평가자)로 두는 단일라운드 델파이 방법론을 제시.
- 델파이 참여 최종 모델을 사전에 강건성 검정(IQR range·변동계수·절대편차의 3개 산포척도 + 산출근거 텍스트 코사인 유사도)으로 선별해, 중국계 모델(Deepseek-R1, QWQ2.5) 등 일관성이 낮은 3개 모델(Falcon 포함)을 제외.
- 메타평가 결과를 두 가지 시나리오(AIE_S1: 5개 모델 결과 종합, AIE_S2: 가장 동의하는 1개 모델 선택)로 병행 제시하고, 단순평균·중앙값·가중평균(O*NET 빈도·중요도 가중)과의 상관관계, Eloundou et al.(2023) GPT 기반 결과와의 상관관계까지 다각도로 교차검증.
- O*NET 923개 직업 전체에 대한 5개 모델별 원점수와 메타평가 최종점수를 부록에 전량 공개.

## Methodology and Data

### 문헌연구(제2장)
- 거대언어모형(LLM)의 연구도구 활용 문헌(Liao et al. 2024, Hayes 2025 등)과 창발적 능력(emergent abilities, Wei et al. 2022) 개념을 검토.
- AI 노출도 측정 선행연구를 4개 방법론 계열(전문가 서베이-Arntz et al. 2016/Frey & Osborne 2017/Lassébie & Quintini 2022; 인지능력 매개-Felten et al. 2018/Tolan et al. 2021; 텍스트매칭-Webb 2019/Koga et al. 2023; LLM 프롬프팅-Eloundou et al. 2023·2024/Gmyrek et al. 2023)로 유형화하고 각 계열의 공통 한계(설문조사의 범위 제약, 특허 텍스트의 시차 문제, 단일 LLM 의존의 블랙박스·재현성·편향 문제)를 지적.
- LLM 정책적 편향성의 근거로 Feng et al.(2023)의 좌표평면(좌우-권위/자유) 시각화를 인용, 복수 LLM을 전문가 에이전트 집단으로 활용하는 선행사례(Bano & Whittle 2023의 GPT-3.5+GPT-4 앱리뷰 분류, Bertolotti & Mari 2025의 5~15개 LLM 델파이, Nóbrega et al. 2023의 GPT-페르소나 델파이)를 근거로 다중 LLM 델파이 방법론을 채택.

### 분석 프레임워크(제3장)
- 델파이 방식: Eloundou et al.(2023/2024)과의 비교가능성을 위해 회차 반복형이 아닌 진행촉진자(GPT-4o) 단일라운드 수렴 방식 채택.
- 랭체인(LangChain) 아키텍처로 복수 LLM 프롬프팅을 구성.
- 데이터: O*NET 29.3 Task Statements(923개 직업, 직업당 약 20~30개 과업), Felten et al.(2021)·Eloundou et al.(2023/2024)과의 비교가능성을 근거로 채택.

### 분석 결과(제4장)
- 프롬프트 설계(<표 4-1>): 역할부여+퓨샷러닝(교사/수업계획 0.4·complementary, 교사/과제채점 0.6·complementary, 교사/학생상담 0.2·neutral, 데이터입력사원/수기입력 0.95·substitution) 4개 few-shot 예시. 출력변수: Degree_of_exposure(0~1), Exposure_reason, AI_impact(complementary/substitution/neutral), AI_impact_reason.
- 강건성 검정용 직업 선정: ChatGPT에 O*NET 데이터를 업로드해 923개 직업 중 AI 영향 상/하위 10개씩 도출한 뒤 Eloundou et al.(2023/2024)의 결과와 매칭되는 4개 직업(고노출: Financial and Investment Analysts, Tax Preparers; 저노출: Athletes and Sports Competitors, Chefs and Head Cooks)을 강건성 테스트 대상으로 선정.
- 강건성 테스트: temperature=0.1, 직업-과업 쌍당 30회 반복(직업당 약 750개 응답). 산포척도(IQR range·CV·MAD)와 산출근거 텍스트 코사인 유사도로 검정. 텍스트 유사도(<표 4-3>): Deepseek-R1 0.2792, Falcon 0.5032, Hermes3 0.6417, Gemma3 0.7300, Llama3.3 0.7946, Mistral-small 0.6164, Phi4 0.5196, QWQ2.5 0.3414. 산포척도·텍스트유사도 두 기준 모두 Falcon·QWQ·Deepseek가 최하위권으로 일관되게 나타나 최종 델파이 패널에서 제외, 최종 5개 모델(Gemma3, Llama3.3, Phi4, Hermes3, Mistral-small)을 923개 전체 직업에 적용.
- 메타평가(<표 4-4> 프롬프트): GPT-4o에 5개 모델의 점수+근거를 제공, 논리적 일관성·타당성을 비판적으로 검토해 최종 점수 산출. AIE_S1(5개 결과 종합) / AIE_S2(가장 동의하는 1개 모델 선택) 두 시나리오 병행 산출. 직업 단위 점수는 직업 내 과업별 점수의 단순평균(가중평균과 비교했을 때 결과 차이가 크지 않고 일부 과업에서 O*NET 가중치 결측이 있어 단순평균을 주 결과로 채택).

## Key Results

- 기초통계(923개 직업, <표 4-5>~<표 4-6>): AIE_S1 평균 0.402(sd 0.130, min 0.112, max 0.775), AIE_S2 평균 0.416(sd 0.137, min 0.110, max 0.808), 5개 LLM 단순평균(LLM평균) 0.408(sd 0.121), LLM중앙값 0.416(sd 0.135).
- 상관관계(<표 4-7>): AIE_S1-AIE_S2 0.990, AIE_S1-LLM평균 0.996, AIE_S1-LLM중앙값 0.989, AIE_S2-LLM평균 0.984, AIE_S2-LLM중앙값 0.986, LLM평균-LLM중앙값 0.988. 923개 직업별 5개 모델 간 평균 표준편차는 0.109로 모델 간 이견이 크지 않음을 시사.
- 분포(<표 4-8>·<표 4-9>): 1사분위 0.307, 3사분위 0.496, 상위 10% 임계값 0.571, 하위 10% 임계값 0.233. AI 노출도 상위 30개는 Bookkeeping/Accounting/Auditing Clerks(0.775)·Word Processors and Typists(0.766)·Telemarketers(0.758) 등 정형화·반복적 사무직 중심, 하위 30개는 Terrazzo Workers and Finishers(0.112)·Plasterers and Stucco Masons(0.120)·Paperhangers(0.130) 등 건설·마감·수공예 계열 물리적 직무 중심.
- ISCO-08 대분류 기준(그림 4-6, 군 관련 직업 제외): 노출도 최상위는 사무 및 행정 지원직(Clerical Support Workers), 다음으로 관리직(Managers), 기술 관련직(Technicians and Associate Professionals) 순. 최하위는 숙련기능 및 수공기반 직업(Craft and Related Trades Workers), 다음으로 농림어업 종사자(Skilled Agricultural, Forestry and Fishery Workers).
- 가중치 기반 결과: O*NET 과업 빈도·중요도 가중치를 적용한 wAIE(879개 직업, 가중치 결측 44개 직업 제외 산출)와 단순평균 AIE 간 상관계수 99.6%로 강건성 확인.
- Eloundou et al.(2023) GPT 결과와 비교(<표 4-10>·<표 4-11>): GPT_alpha(직접노출 비율) 평균 0.140, GPT_beta(직접+0.5×간접) 평균 0.343, GPT_gamma(직접+간접) 평균 0.546. AIE_S1과의 상관계수는 GPT_alpha 0.463, GPT_beta 0.721, GPT_gamma 0.701로 GPT_beta와 가장 높은 상관. binscatter·LOWESS 분석 결과 0.2~0.6 구간에서 두 지표가 선형적으로 강하게 연관되나 상위 노출 구간에서는 표본 감소로 불확실성이 확대. 메타평가는 중간 수준 노출 직업의 범위를 상대적으로 넓게 잡는 반면 Eloundou et al.은 고노출 직업을 더 많이 평가하는 경향.

## Limitations and Future Work

- 미국 O*NET 데이터에 기반한 측정이며, 한국 직업·직무 데이터를 이용한 검증이나 정책 적용은 이번 1년차 연구 범위에 포함되지 않음(향후 연구에서 한국 직업 데이터 반영 예정이라고 명시).
- 강건성 검정용 4개 표적 직업(Financial and Investment Analysts, Tax Preparers, Athletes and Sports Competitors, Chefs and Head Cooks)만으로 모델 선정을 진행해, 이 표본이 923개 전체 직업의 다양성을 완전히 대표하지 못할 가능성.
- 델파이 방식이 반복 합의형이 아닌 단일라운드 진행촉진자 수렴형이어서, Eloundou et al.과의 비교가능성은 확보했으나 다회차 델파이 대비 의견 수렴의 깊이는 제한적일 수 있음.
- 메타평가 결과가 5개 LLM의 단순평균·중앙값과 상관계수 0.98~0.99로 거의 동일하게 나타난 점에 대해, GPT-4o가 이상치에 가중치를 두기보다 무난한 값으로 수렴했을 가능성과 원자료(5개 모델) 자체의 직업별 분산이 크지 않았을 가능성 두 가지를 모두 원인으로 제시, 명확히 하나로 결론짓지 않음.
- Eloundou et al.(2023)과의 비교에서 상위 노출 직업군의 표본 수가 적어 두 측정치 간 관계의 불확실성이 커지는 한계를 스스로 지적.

## Related Work

이 자료는 같은 저자진(손녕선·노희용)이 참여한 한국고용정보원 「자동화 및 인공지능 기술 발전에 따른 고용 구조 변화 분석」(기본사업 2025-40) 제5장의 델파이 방법론·강건성 검정·메타평가 결과(AIE_S1 평균 0.402, 상위/하위 직업 목록 등)와 수치가 사실상 동일하며, 해당 챕터의 한국 채용공고 크로스워크·패널회귀 응용 부분은 이 자료에는 포함되어 있지 않다. 두 자료는 동일한 델파이-메타평가 프로세스의 서로 다른 산출물로 판단된다.

## Glossary

- **미가공 노출도(raw exposure score)**: 메타평가 이전, 5개 개별 LLM이 각각 산출한 직업-과업 단위 AI 노출도 점수.
- **AIE_S1 / AIE_S2**: 메타평가자(GPT-4o)가 5개 모델 결과를 종합(S1)하거나 가장 동의하는 1개 모델을 선택(S2)해 산출한 최종 직업별 AI 노출도.
- **델파이 진행촉진자(Delphi facilitator)**: 회차 반복 없이 다수 참여자(LLM)의 응답을 단일라운드로 수렴·종합하는 역할. 이 연구에서는 GPT-4o가 담당.
- **wAIE**: O*NET이 제공하는 직업 내 과업별 빈도(FR)·중요도(IM) 값을 가중치로 사용해 산출한 가중평균 AI 노출도.
