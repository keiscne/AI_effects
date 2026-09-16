---
title: "The Simple Macroeconomics of AI"
authors: Daron Acemoglu
institution: ""
year: 2024
doi: ""
category: [macroeconomics, labor_economics]
source_tier: 1
pdf_path: papers/local/acemoglu-2024-the-simple-macroeconomics-of-ai.pdf
pdf_filename: acemoglu-2024-the-simple-macroeconomics-of-ai.pdf
verified_date: 2026-06-21
datasets_used: []
---

## One-line Summary

AI(특히 생성형 AI)의 거시경제적 효과를 과업 기반(task-based) 모형과 Hulten 정리로 추정한 결과, 향후 10년간 총요소생산성(TFP) 증가는 0.55%~0.71%, GDP 증가는 0.9%~1.8%에 불과한 매우 완만한 수준이라고 주장한다.

## Document Information

- 저자: Daron Acemoglu (MIT)
- 발행: *Economic Policy* 게재 예정 논문 (초고 날짜 2024년 4월 5일)
- JEL 분류: E24, J24, O30, O33
- 키워드: Artificial Intelligence, automation, ChatGPT, inequality, productivity, technology adoption, wage

## Key Contributions

- Acemoglu & Restrepo(2018, 2019b, 2022)의 과업 기반 모형을 AI에 적용해, AI의 미시적 효과(과업 단위 비용절감)가 거시적 효과(TFP·GDP)로 어떻게 변환되는지를 Hulten 정리의 한 형태로 도출 (p.1, p.13-14, 식 (12)~(15)).
- "쉬운 과업(easy-to-learn)"과 "어려운 과업(hard-to-learn)"을 구분하는 기준(저차원적 행동-결과 매핑, 신뢰 가능한 결과 지표의 존재 여부)을 제시하고, 기존 실증 연구가 주로 쉬운 과업에서 얻어진 추정치임을 지적 (p.15-18, 2.5절).
- AI가 만드는 새로운 과업 중 사회적으로 부정적 가치를 갖는 것("나쁜 새 과업", 예: 딥페이크·소셜미디어 조작)을 GDP·복지 분석에 명시적으로 포함하는 틀을 제시 (p.19, 2.8절).
- AI 노출이 인구통계 집단 간에 비교적 균등하게 분포되어 있음에도, 모형상 σ<1일 때 저숙련 근로자 생산성 향상이 오히려 불평등을 심화시킬 수 있음을 보이는 반례를 제시 (p.21-23, 2.10절).

## Methodology and Data

- 핵심 식(14): TFP 증가율 = AI에 영향받는 과업의 GDP 비중 × 해당 과업의 평균 비용절감률 (p.14).
- 과업의 GDP 비중 추정: Eloundou, Manning, Mishkin, and Rock(2023)의 GPT-4 기반 과업 노출 지수(O*NET 19,265개 과업, 2,087개 DWA를 분류)를 미국 노동통계국(BLS) National Occupational Employment and Wage Estimates(2019–2022년 통합)의 임금총액 비중으로 가중하여 산출한 결과, **노출 과업 비중 19.9%** (p.25).
- 여기에 Svanberg, Li, Fleming, Goehring, and Thompson(2024)의 컴퓨터 비전 과업 자동화 가능성 추정(노출 과업 중 **23%**가 10년 내 수익성 있게 자동화 가능)을 적용해, **AI 영향 과업의 GDP 비중 = 0.23×0.199 = 4.6%** (p.26).
- 비용절감률(π̄) 추정: Noy and Zhang(2023)과 Brynjolfsson, Li, and Raymond(2023) 두 실험 연구의 평균 노동비용절감률 **27%**를 기준값으로 사용 (Peng, Kalliamvakou, Cihon, and Demirer(2023)를 포함하면 36%) (p.28).
- 노동비용절감을 전체 비용절감으로 환산하기 위해 Eloundou et al.(2023)의 산업별 노출 비중과 미국 경제분석국(BEA) National Income and Product Accounts(NIPA, 2019–2022년) 산업별 노동소득분배율을 결합 → **노출 가중 평균 노동소득분배율 0.57**, 전체 비용절감 = 0.27×0.57 = **0.154 (15.4%)** (p.28).
- 1차 추정: TFP 증가율(10년) = 0.046×0.154 = **0.71%** (연율 약 0.07%p) (p.29).
- 쉬운/어려운 과업 구분: O*NET 동사·IWA(332개) 수동 분류 + LDA 토픽모델링(100개 클러스터) + 그래디언트 부스팅 트리로 4,089개 노출 과업을 분류한 결과, **임금총액 가중 노출 과업의 74%가 "쉬운" 과업**(전체 GDP의 3.3%), 나머지 26%가 "어려운" 과업(GDP의 1.2%) (p.33-34).
- 어려운 과업의 비용절감률은 Brynjolfsson et al.(2023)의 14%의 절반인 **7%**로 가정 (p.32).
- 정교화된 추정: TFP 증가율(10년) = 0.033×0.154 + (0.045−0.033)×0.040 = **0.55%** (p.34).
- GDP 환산: 자본분배율(민간기업부문) **sK = 0.40**을 사용해 GDP 증가 = TFP 증가/(1−sK) (p.35). 기준 시나리오(투자가 TFP에 비례 증가): GDP 증가 0.92%~1.1%(10년); Acemoglu and Restrepo(2022)의 완전한 산업간·과업간 대체구조를 적용한 상한: 1.6%~1.8% (p.35, p.40).
- 과업 간 대체탄력성 **σ = 0.5** (Humlum(2023) 추정치, Acemoglu and Restrepo(2022)에서도 사용) (p.7).
- 임금/불평등 분석: Acemoglu and Restrepo(2022)의 전이행렬(propagation matrix) 방법론을 500개 인구통계 집단(교육·연령·성별·인종·출생지)에 적용, 산업간 재배분 탄력성 η=0.2(Buera, Kaboski, Rogerson, and Vizcaino(2022)) 사용 (p.39).

## Key Results

- 1차 추정 TFP 증가(10년, 쉬운/어려운 과업 미구분): **0.71%** (연 0.07%p) (p.1, p.29).
- 어려운 과업 구분 반영 시 TFP 증가(10년) 상한: **0.55%** (p.6, p.34).
- GDP 증가(10년): 투자 증가가 TFP에 비례할 때 **0.92%~1.1%**; 큰 투자 붐 가정 시 **1.6%~1.8%** (p.1, p.35).
- "나쁜 새 과업"(소셜미디어·디지털광고·IT 보안공격 관련) 추정: 2022년 Meta($130B)+Alphabet($307B)+Snapchat($4.6B)+X($2.5B)+TikTok 미국 매출($16B) 합계 약 **4,600억 달러(미국 GDP의 1.64%)**, IT 보안 지출 하한 **780억 달러(GDP의 0.28%)**, 합산 약 GDP의 **2%** (p.35, 각주 26-27).
- Bursztyn, Handel, Jimenez, and Roth(2023)의 소셜미디어 실험: TikTok·Instagram 이용자의 평균 지불용의 **월 53달러**(유지 위해) vs 모두가 끊기를 바라는 지불용의 **월 19달러** → 비례 손실 **−19/53 ≈ −0.36** (p.34-35).
- 위 수치 결합 시: 명목 GDP는 약 2% 증가하지만 실제 복지는 **−0.72%** 감소할 수 있다는 예시 계산 (p.1, p.35).
- Table 1(p.39): 평균 근로자 기준 AI 노출 0.0462, 직접효과 −0.0566, 전체 임금효과(파급효과 포함) **+0.0117**(10년); 고졸 미만 근로자는 전체 임금효과 **+0.0201**로 가장 큼; GDP 전체 임금효과(자본스톡 조정 포함) **1.62%~1.79%**.
- 집단간(교육수준 간) 로그임금 표준편차(가중)는 0.35→0.36으로 소폭 상승 (p.41).
- 저학력 백인 원주민 여성의 실질임금은 하락 예상 (Figure 3, p.43).
- 자본소득분배율은 약 **0.38%p** 상승 예상 (p.41).

## Limitations and Future Work

- 저자가 직접 명시한 한계: (1) 2019년 기준 미국 기업의 1.5% 미만만 AI에 투자(Acemoglu et al. 2022)하고 있어 0.046이라는 노출 비중 자체가 과대추정일 수 있음(p.29-30); (2) 디지털 기술의 생산성 효과는 J자형 곡선을 그리며 20년 이상 정체될 수 있어(Greenwood and Yorukoglu 1997; Brynjolfsson, Rock, and Syverson 2021) 15.4% 비용절감 추정이 과대일 수 있음(p.30); (3) 좋은 새 과업으로 인한 생산성 증가는 추정에서 제외됨 — 측정이 어렵고 현재 업계의 우선순위가 자동화·온라인 수익화에 있기 때문(p.45).
- 저자는 추정치들을 "제안적(suggestive)" 수치로 해석할 것을 반복적으로 경고 (p.23).

## Related Work

- [[acemoglu-2018-the-race-between-man-and]], Acemoglu and Restrepo (2019b), [[acemoglu-2022-tasks-automation-and-the-rise]] — 본 논문이 사용하는 과업 기반 모형(정태·동태 모형, 전이행렬 방법론)의 토대.
- [[eloundou-2023-gpts-are-gpts-an-early]] (Eloundou, Manning, Mishkin, and Rock 2023) "GPTs are GPTs" — AI 노출 과업 추정의 핵심 데이터.
- Svanberg, Li, Fleming, Goehring, and Thompson (2024) — 컴퓨터 비전 과업의 자동화 비용효과성 추정.
- Noy and Zhang (2023); Brynjolfsson, Li, and Raymond (2023); Peng, Kalliamvakou, Cihon, and Demirer (2023) — 생성형 AI의 실증 생산성 효과 실험.
- Bursztyn, Handel, Jimenez, and Roth (2023) — 소셜미디어의 복지효과 추정.
- Goldman Sachs(2023), McKinsey Global Institute(2023) — 본 논문이 비판적으로 검토하는 대형 거시효과 전망.
- [[acemoglu-2019-automation-and-new-tasks-how]] — 본 논문이 직접 차용하는 전치효과(displacement)·복원효과(reinstatement) 틀의 원전.

## Glossary

- **Hulten의 정리(Hulten's theorem)**: 완전경쟁·규모불변 경제에서 미시적(과업 단위) 생산성 변화가 거시적 TFP 변화로 합산되는 방식을 설명하는 정리. d ln TFP = ∫χ(z)π_L(z)dz (p.13).
- **TFP (총요소생산성)**: Total Factor Productivity.
- **쉬운 과업(easy-to-learn task)**: 행동과 결과 간 매핑이 단순하고 신뢰 가능한 결과 지표가 존재하는 과업 (p.15).
- **어려운 과업(hard-to-learn task)**: 맥락의존적 요인이 많고 명확한 성공 지표가 없는 과업 (p.17).
- **나쁜 새 과업(new bad task)**: AI가 만들어내는, 소비자 효용이 아니라 매출만 증가시키는 과업(예: 중독·조작성 콘텐츠) (p.19).
