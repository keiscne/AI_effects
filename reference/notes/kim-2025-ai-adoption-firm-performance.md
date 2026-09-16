---
title: "AI 도입이 기업 성과 및 생산성에 미치는 영향 및 시사점"
authors: 김용미
institution: "대한상공회의소 SGI(상공회의소경제연구원)"
year: 2025
doi: ""
category: [applied_econometrics, korean_economy]
source_tier: 1
pdf_path: papers/local/AI 도입이 기업 성과 및 생산성에 미치는 영향 및 시사점.pdf
pdf_filename: AI 도입이 기업 성과 및 생산성에 미치는 영향 및 시사점.pdf
verified_date: 2026-06-28
datasets_used:
  - datasets/kostat-business-activity-survey.md
---

## One-line Summary
통계청 기업활동조사 2017~2023 균형패널에 TWFE와 사건연구(event-study)를 적용해 AI 도입 기업의 부가가치(+7.6%)·매출(+4.0%)은 유의하게 증가하지만 TFP와 노동생산성(매출 기준)에는 유의한 효과 없음을 발견.

## Document Information
- **유형**: 연구보고서 (SGI BRIEF vol. 31)
- **발행기관**: 대한상공회의소 SGI(상공회의소경제연구원)
- **발행일**: 2025년 6월 9일
- **저자**: 김용미 연구위원 (ymkim117@korcham.net)
- **언어**: 한국어

## Key Contributions
1. 통계청 기업활동조사 패널로 AI 도입의 기업 성과(부가가치·매출·사업구조 변화)와 생산성(TFP·노동생산성)에 대한 인과효과를 TWFE로 추정.
2. 사건연구(event-study)로 AI 도입 이전 parallel trends 가정을 점검하고, 도입 후 연도별 동태적 효과를 제시.
3. AI 도입이 기업 성장 지표는 높이지만 TFP에는 유의한 효과 없음을 보여 생산성 역설(productivity paradox) 논의에 한국 기업 증거 제공.
4. 산업·기업 규모·지역별 이질적 효과를 추가 분석.

## Methodology and Data
- **데이터**: 통계청 기업활동조사(2017~2023년). 상시근로자 50인 이상 또는 자본금 3억 원 이상 기업 대상. 균형 패널 약 7,000개 기업, 관측치 약 42,000개. AI 도입 연도 식별 가능.
- **처리변수(Treatment)**: AI 기술 도입 여부 (기업활동조사 AI/4차산업혁명 기술 도입 문항).
- **추정 모형**: 이중고정효과(TWFE) 회귀분석.
  - 고정효과: 기업, 연도, 지역(시도), 산업(중분류)
  - 클러스터 표준오차: 기업 단위
- **사건연구(Event-study)**: AI 도입 전후 연도별 처치 효과 추정. 도입 전 2개년 dummy 포함하여 parallel trends 검증.
- **TFP 추정**: Levinsohn-Petrin(2003) 방법. 산업별로 별도 추정.
- **종속변수**: 부가가치(ln), 매출액(ln), 신규사업 진출 여부(binary), 주력사업 확대 운영 여부(binary), TFP(ln), 1인당 매출액(ln), 1인당 부가가치(ln).

## Key Results
**TWFE 평균 처치 효과 (전체 표본, 약 7,000개 기업·42,000 관측치)**

| 종속변수 | 추정계수 | 표준오차 | 유의수준 |
|---|---|---|---|
| ln(부가가치) | 0.076 | 0.023 | *** |
| ln(매출액) | 0.040 | 0.019 | ** |
| 신규사업 진출 | 0.057 | 0.015 | *** |
| 주력사업 확대 | 0.026 | 0.011 | ** |
| TFP(Levinsohn-Petrin) | 0.001 | 0.007 | (비유의) |
| ln(1인당 매출액) | 0.003 | 0.018 | (비유의) |
| ln(1인당 부가가치) | 0.043 | 0.022 | * |

**이질적 효과 (부가가치 기준)**
- 서비스업: +5.7%** (s.e. 0.027), 제조업은 비유의
- ICT 업종: +12.3%** (s.e. 0.047)
- AI 산업: +12.2%** (s.e. 0.048)
- 중소기업(SME): +8.4%*** (s.e. 0.025)
- 수도권 소재 기업: 비수도권 대비 더 유의한 효과

**사건연구**: AI 도입 이전 처치 계수는 비유의(parallel trends 지지). 도입 후 t+1, t+2년에서 부가가치 계수가 유의하게 양(+).

## Limitations and Future Work
- 기업활동조사의 AI 도입 문항은 도입 여부만 기록. 도입 강도, 어떤 AI 기술인지 구분 불가.
- TWFE는 처치 시점이 기업마다 다른 staggered DID 구조에서 이질적 처치 효과가 있을 경우 편향될 수 있음(Callaway-Sant'Anna 등 대안적 추정량 미적용).
- 대기업 표본이 제한적. 50인 미만 소규모 기업 제외로 외적 타당성 제약.
- 인과 해석의 전제인 parallel trends 가정이 관찰된 공변량으로 완전히 검증되지 않을 수 있음.

## Related Work
- [[spri-2024-ai-industry-survey]] — 한국 AI 산업 전체 매출·인력 현황 실태조사 (보완적 기술통계)
- [[bick-2026-mind-the-gap-ai-adoption]] — 미국·유럽 AI 도입률 및 생산성 연계 분석 (국제 비교)

## Glossary
- **TWFE(Two-Way Fixed Effects)**: 기업·연도 고정효과를 동시에 포함하는 패널 회귀모형. 스태거드(staggered) 처치 상황에서 편향 가능성 논의 중.
- **사건연구(Event-study)**: 처치 시점 전후 연도별 계수를 추정해 동태적 효과와 parallel trends를 동시에 점검하는 분석.
- **Levinsohn-Petrin(2003) 방법**: 중간투입물을 프록시로 활용해 내생성을 통제하는 TFP 추정방법.
- **생산성 역설(Productivity Paradox)**: AI·IT 투자가 기업 성장에는 기여하나 TFP 등 총요소생산성 향상으로 이어지지 않는 현상.
