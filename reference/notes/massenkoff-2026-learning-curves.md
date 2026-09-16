---
title: "The Anthropic Economic Index report: Learning curves"
authors: Maxim Massenkoff, Eva Lyubich, Peter McCrory, Ruth Appel, Ryan Heller
institution: Anthropic
year: 2026
doi: ""
category: [labor_economics]
source_tier: 1
pdf_path: papers/local/massenkoff-2026-learning-curves.pdf
pdf_filename: massenkoff-2026-learning-curves.pdf
verified_date: 2026-07-29
datasets_used: []
---

## One-line Summary

Anthropic Economic Index 5번째 보고서(V5). 2026년 2월(Opus 4.5 출시 3개월 후·Opus 4.6 출시 시점) Claude 사용 데이터로, Claude.ai 사용이 상위 10대 과업 집중도 24%→19%로 다변화되고 평균 과업가치가 소폭 하락하는 한편, 모델선택(Opus)이 고임금 과업에 체계적으로 쏠리고(임금 $10 상승당 Opus 사용 비중 +1.5%p, API는 +2.8%p) 6개월 이상 사용한 고tenure 이용자가 저tenure 이용자보다 과업성공률이 4~5%p 높음(과업고정효과·전체통제 반영)을 실증, 이를 AI "학습곡선(learning curve)"의 증거로 제시.

## Document Information

- 저자: Maxim Massenkoff, Eva Lyubich, Peter McCrory(이상 공동 리드저자), Ruth Appel, Ryan Heller (p.1).
- 발행: Anthropic, 2026년 3월 24일 (p.1, Bibtex citation p.20). Anthropic Economic Index 보고서 시리즈 5번째 판(직전 판인 Economic Primitives, 2025.11 데이터 보고서를 계승, p.1).
- DOI 없음. 게재 학술지 없음 — Anthropic 자체 발행 온라인 연구보고서. 데이터는 https://huggingface.co/datasets/Anthropic/EconomicIndex 에 공개 (p.20). Bibtex 인용키 `massenkoff2026learning` (p.20).
- 전체 20페이지를 pdftotext 텍스트추출로 전체 읽기 검증함(Tier 1).

## Key Contributions

- 직전 보고서(Economic Primitives, 2025.11)의 경제원시지표 프레임워크를 계승해 2026년 2월 데이터로 갱신, Claude.ai 사용 다변화·과업가치 하락 추세를 문서화.
- 모델 선택(Haiku/Sonnet/Opus) 자체를 처음으로 원시지표로 분석해, 이용자가 과업 가치·복잡성에 따라 최상위 모델(Opus)을 체계적으로 선별함을 실증.
- 사용자 tenure(가입 후 경과기간)에 따른 사용패턴·과업성공률 차이를 처음으로 분석해 "학습곡선(learning curve)" 가설을 검증 — 6개월 이상 사용자가 더 높은 성공률·더 높은 자율성 위임·더 업무지향적 사용을 보임.

## Methodology and Data

- 표본: Claude.ai·1P API에서 각 100만 건 샘플링, 2026년 2월 5~12일(Opus 4.5 출시 3개월 후, Opus 4.6 출시와 겹치는 시점) 수집. 직전 보고서(2025.11 데이터)와 비교분석 (p.1-2).
- 변화 분석(Chapter 1): 상위10대 O*NET 과업 점유율, 업무/개인/코스워크 비중, 협업모드(directive/feedback loop/task iteration/validation/learning), 과업가치(BLS OEWS 2024년 5월 자료 기준 직업별 평균시급을 과업에 매핑해 거래량가중평균)의 시점간(2025.11 vs 2026.2) 변화를 비교 (p.5-9, 각주5).
- 모델선택 분석(Chapter 2): 유료 Claude.ai 계정(전 모델 접근권 보유) 대상, 직업군별·직업별 Opus 사용비중과 직업 시간당임금 간 관계를 이분산(binned) 산점도·선형회귀로 추정, Claude.ai와 1P API 별도 추정 (p.12-14).
- Tenure 분석(Chapter 2): 고tenure(가입 후 6개월 이상 경과)와 저tenure(그 외) 이용자를 구분해 협업모드·용도·과업성공률·AI자율성·인간교육수준·상위10대 과업 점유율을 비교(표2.1). 로그수준 데이터로 3단계 회귀: (1)단순 이분산 회귀, (2)O*NET과업·요청군집 고정효과 추가, (3)모델·용도·국가 고정효과까지 전체 통제 (그림2.4, p.15-18).

## Key Results

- 상위10대 O*NET 과업 점유율: Claude.ai 24%(2025.11)→19%(2026.2)로 하락, 1P API는 28%(2025.8)→32%(2025.11)→33%(2026.2)로 지속 상승 (그림1.1, p.5).
- 용도 구성: 코스워크 19%→12%, 개인용 35%→42%로 변화(코스워크 하락은 학사일정상 방학중인 국가에서 12%p, 학기중인 국가에서 5%p 하락) (그림1.2, p.6, 각주3).
- 누적 직업 커버리지: 직업의 49%가 과업의 25% 이상에서 AI사용이 관측된 비율은 이번 데이터에서 거의 변화 없음(부록 그림A.2) (p.6).
- 협업모드(Claude.ai): 증강(validation+task iteration+learning) 비중이 소폭 상승(주로 validation·learning 증가에 기인), 1P API에서는 자동화가 급격히 감소(부록 그림A.3) (p.6).
- 컴퓨터·수학직 과업 비중: 2025년 8월 이후 API에서 14% 상승, Claude.ai에서 18% 하락 (p.6).
- 평균 과업가치(거래량가중 시급): Claude.ai $49.3(2025.1)→$50.4(2025.11)→$47.9(2026.2), 미국 평균시급 $37.3 (그림1.4, p.7).
- 원시지표 변화(표1.1, 2025.11 vs 2026.2, 모두 p<0.001 단 인간단독시간은 p<0.05): 인간교육연수 12.21년→11.92년(-0.29), 인간단독시간 3.38분→3.41분(+0.02), 인간+AI시간 185.53분→183.77분(-1.76), 인간단독완료불가 비율 15.35%→14.30%(-1.05%p) (표1.1, p.8-9).
- 지리적 수렴: 미국 주 지니계수 0.37(2025.8)→0.31(2025.11)→0.29(2026.2)로 지속 하락(수렴속도는 둔화, 5~9년내 균등화 예상으로 하향조정). 국가간 지니계수는 반대로 0.48→0.46→0.50으로 상승(상위20개국 점유율 45%→48%) (그림1.5, p.10-11).
- 모델선택(그림2.1): 유료 Claude.ai 이용자 중 컴퓨터·수학직 과업의 55%가 Opus 사용(전체평균 대비 +4.4%p), 교육직 과업은 45%(-6.5%p 상당, 그림2.1 수치는 문서상 -5.7%p·-6.5%p 두 막대가 존재해 원문 그대로 병기).
- 모델선택-임금 관계(그림2.2): Claude.ai에서 시간당임금 $10 상승당 Opus 사용비중 +1.48%p(예: 소프트웨어개발자 34% vs 튜터 12%), 1P API에서는 기울기가 약 2배인 +2.79%p (p.14).
- Tenure 비교(표2.1, 고 vs 저tenure): 개인용 비중 -8.7%p, 업무용 비중 +6.4%p, directive -4.0%p, learning +7.3%p(전체 협업모드 방향은 표 레이아웃 손상으로 정확한 행-값 대응이 불확실해 델타값만 원문 그대로 인용), 인간교육연수 +6.6%(11.5→12.3년 상당), AI교육연수 +6.0%, 상위10대 과업 점유율 22.2%→20.7%로 하락 (표2.1, p.15).
- Tenure-교육수준: 가입 후 매 1년마다 프롬프트 이해에 필요한 교육연수가 거의 1년씩 증가, 개인용 비중은 신규가입자 44%에서 1년차 38%로 하락 (그림2.3, p.16).
- Tenure-과업성공률(그림2.4): (1)단순회귀 +5%p, (2)과업고정효과 추가 시 +3%p, (3)모델·용도·국가 전체통제 시 +4%p — 세 사양 모두 고tenure 이용자의 유의한 성공률 우위 확인 (p.16-17).
- tenure가 높을수록 평균사용 tenure가 긴 요청군집: AI 리서치, git 명령어, 원고수정, 스타트업 자금조달. 평균사용 tenure가 짧은 군집: 하이쿠 작성, 스포츠 스코어 확인, 파티음식 추천 (p.17).

## Limitations and Future Work

- 저자가 명시: tenure 분석 결과는 코호트 효과·생존자편향(survivorship bias)으로 설명될 가능성을 배제할 수 없음 — 조기채택자가 원래 더 기술적 성향이었거나, 1년 전 가입 후에도 계속 사용중인 사람은 이미 긍정적 결과를 경험한 생존자일 수 있음. 단, 과업·요청군집 고정효과를 추가해도 tenure 효과가 유지되므로 "고tenure가 단순히 다른 과업을 가져온다"는 단순한 교란은 배제됨 (p.16, p.18-19).
- 샘플링 기간이 Anthropic 슈퍼볼 광고 방영과 겹쳐 신규가입자가 다수 유입되었음을 각주에서 명시 (각주3, p.18).
- 저자들은 이번 보고서의 발견이 "숙련편향 기술변화(skill-biased technological change)"의 새로운 경로 — 조기채택자·고숙련 과업 사용자가 AI와 더 성공적으로 상호작용하게 됨으로써 격차가 심화될 가능성 —를 시사한다고 결론에서 논의하며, 향후 코호트효과·생존자편향과 순수 학습효과(learning-by-doing)를 더 정밀하게 분리하는 것을 향후 과제로 제시 (p.19).

## Related Work

- [[appel-2026-economic-primitives]] — 본 보고서(V5)가 직접 계승하는 직전 판(V4, 2025.11 데이터)으로 경제원시지표 프레임워크의 원 출처.
- [[massenkoff-2026-cadences]] — 본 보고서를 계승해 시간당(hourly) 표집·산출물(artifact) 분류·설문(survey)을 추가한 후속 판(V6).
- [[massenkoff-2026-labor-market-impacts-of-ai]] — 동일 저자진(Massenkoff, McCrory)이 Anthropic Economic Index 데이터를 Eloundou β와 결합해 관측노출 지수를 구축한 병행 연구.
- [[handa-2025-which-economic-tasks-are]] — Anthropic Economic Index 최초 보고서(R1)로 O*NET 과업 매핑·협업모드 분류 방법론의 원전.

## Glossary

- **학습곡선(learning curve)**: 사용자가 AI 사용 경험(tenure)이 누적됨에 따라 더 높은 가치의 과업을 시도하고 더 성공적으로 AI를 활용하게 되는 현상. 본 보고서에서는 고tenure 이용자의 높은 과업성공률로 조작화됨 (p.3).
- **고tenure/저tenure 이용자**: Claude 가입 후 6개월 이상 경과한 이용자(고tenure) 대 그 외 이용자(저tenure) 구분 (p.15).
- **과업가치(task value)**: 특정 O*NET 과업을 수행하는 미국 근로자의 평균 시간당임금(BLS OEWS)으로 정의되는, 해당 과업의 경제적 가치 추정치 (p.7, 각주5).
