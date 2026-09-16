---
title: "Estimating AI productivity gains from Claude conversations"
authors: Alex Tamkin, Peter McCrory
institution: ""
year: 2025
doi: ""
category: [macroeconomics]
source_tier: 1
pdf_path: papers/local/tamkin-2025-estimating-ai-productivity-gains-from.pdf
pdf_filename: tamkin-2025-estimating-ai-productivity-gains-from.pdf
verified_date: 2026-07-29
datasets_used: []
---

## One-line Summary

Claude.ai 실사용 대화 10만 건을 대상으로 Claude 자신에게 "AI 없이 이 작업을 하려면 몇 시간 걸릴지"를 추정시켜 과업단위 시간절감을 계산하고, 이를 Hulten 정리로 경제 전체에 집계해 현세대 AI 모델이 향후 10년간 미국 연간 노동생산성 증가율을 1.8%p 높일 수 있다고 추정한다(2019년 이후 실제 증가율의 약 2배).

## Document Information

- 저자: Alex Tamkin, Peter McCrory (소속 명시 없음; Anthropic 발행 연구보고서, 감사의 글에서 Anthropic 직원들에게 사사) (p.1).
- 발행: Anthropic 연구보고서, 2025년 11월 5일 발행 (p.1, Bibtex citation, p.21).
- DOI 없음. 게재 학술지 없음 — Anthropic 자체 발행 온라인 연구노트(URL: https://www.anthropic.com/research/estimating-productivity-gains, Bibtex citation, p.21).
- 전체 25페이지(표지 1페이지 + 본문 20페이지 + 부록/프롬프트 4페이지)를 표지부터 부록 프롬프트까지 전체 읽기로 검증함(2026-07-29).

## Key Contributions

- Anthropic Economic Index의 기존 방법론(어떤 과업에 AI가 쓰이는지, 즉 "breadth")을 넘어, 동일 과업이라도 실제 소요시간이 5분짜리인지 5일짜리인지(즉 "depth"/within-task heterogeneity)를 포착하는 새 측정 프레임워크를 제시 (p.4).
- Claude 자신을 활용해 실사용 대화록으로부터 "AI 없이 걸렸을 시간"과 "AI로 걸린 시간" 두 추정치를 직접 생성하는 방법론을 개발하고, 이를 자기일관성 검정과 외부 벤치마크(JIRA 소프트웨어 개발 티켓)로 검증 (p.5-8).
- 과업단위 시간절감 추정치를 Hulten 정리(Acemoglu 2024의 과업기반 모형 적용 방식을 따름)로 집계해 경제 전체 노동생산성·TFP 증가율을 계산 (p.14-16).
- "가속화되는 과업"과 "병목이 되는 과업"을 직업별로 구분해, AI가 일부 과업만 가속화할 때 나머지 과업이 상대적으로 더 큰 비중을 차지하게 되는 현상을 실증 (p.17-18).

## Methodology and Data

- 표본: Claude.ai(Free, Pro, Max 티어)에서 프라이버시 보존 분석시스템으로 추출한 대화 전사록 10만 건 (p.5).
- 시간 추정 절차: 각 대화에 대해 Claude에게 (1) "AI 지원 없이 전문가가 이 작업을 완료하는 데 걸릴 시간(시간단위)"과 (2) "AI 지원으로 걸린 시간(분단위)"을 프롬프트로 추정시킴. 프롬프트 원문은 부록에 수록(p.23-25, "Human time estimation prompt", "Interaction time estimation prompt"). 개별 대화 추정치는 Economic Index 방법론에 따라 O*NET 과업 단위로 중앙값을 취해 집계 (p.5-6).
- 자기일관성 검증: "적절한 기술을 가진 직원"과 "숙련된 전문가"처럼 문구를 바꾼 프롬프트 변형들로 사용자 동의를 받은 대화 1,800건씩을 분석, 로그스케일 상관계수 r=0.89~0.93 (p.6, Figure 2: r=0.892).
- 외부 벤치마크 검증: 오픈소스 저장소의 JIRA 티켓(개발자 자체추정치+실제 추적완료시간 포함) 1,000건 표본. 인간 개발자 자신의 추정치는 실제시간과 Spearman ρ=0.50, 로그값 Pearson r_log=0.67. Claude Sonnet 4.5(제로샷, 티켓 제목·설명만 제공)는 ρ=0.44, r_log=0.46. 10-shot(정답 예시 10개 제공)은 ρ=0.39(악화)이나 r_log=0.48(개선) (p.7-8, Figure 3). Claude 추정치는 짧은 과업은 과대추정, 긴 과업은 과소추정하는 압축(compression) 경향을 보임 (p.8).
- 시간·비용 산출: 과업별 O*NET 직업 매칭 후 OEWS(Occupational Employment and Wage Statistics) 2024년 5월 자료의 시간당 임금을 곱해 과업비용(task cost)을 계산. 시간절감(time savings) = 1 − time_with_ai / time_without_ai (p.9, Figure 4 캡션).
- 경제 전체 집계 방법론(Hulten 정리, p.14): Acemoglu(2024)의 "baseline" 접근을 따라 노동생산성 증가를 과업단위 생산성 향상의 가중평균으로 모형화(자본투자가 TFP 상승에 따라 증가한다는 암묵적 가정 포함). TFP 증가분 = 노동생산성 증가분 × 노동소득분배율. (1) 과업구성: 직업별 O*NET 과업 목록에 대해 Claude가 노동자의 주당 시간배분을 추정(예: 프로그래머는 코드작성·유지보수 23%, 프로그램 분석·재작성 15% 등, p.14). (2) 과업단위 생산성향상: AI 유무 완료시간의 로그차이를 사용하고, 표본에 관측되지 않은 과업은 보수적으로 개선치 0을 부여. (3) 각 과업의 경제적 중요도 가중치 = 해당 직업이 그 과업에 쓰는 시간비중 × 해당 직업의 미국 전체 임금총액 대비 비중(OEWS 2024년 5월 고용·임금자료 기준) (p.14-15).
- 이상치 처리: Claude가 일부 프로그래밍 과업을 "수년" 또는 "수백만 달러"로 추정하는 등 극단치를 산출하는 경향이 있어, 과업별 대화 건수로 가중한 중앙값의 평균을 취해 보수적으로 산출 (p.21, 각주 1).

## Key Results

- 전체 10만 건 대화 기준: AI 지원 없는 예상 소요시간 평균 약 90분(1.4시간), Claude로 인한 평균 시간절감 80%(Overview, p.2; 본문은 "typically... 1.4 hours"로 서술, p.3). O*NET 직업·OEWS 임금 매칭으로 이 작업들의 인건비 환산 가치는 평균 $55 (p.3).
- 직업별 과업시간 편차(Table, p.11; Figure 5, r=0.799, R²=0.638, n=22): Management 2.0시간·$68/h·$133(과업비용)·시간절감 85.1%; Legal 1.8시간·$66/h·$119·80.7%; Business & financial operations 1.5시간·$45/h·$69·83.5%; Computer & mathematical 1.5시간·$56/h·$82·80.2%; Education, training & library 1.7시간·$32/h·$52·84.5%; Food preparation & serving 0.5시간·$17/h·$8·75.4%; Transportation & material moving 0.3시간·$23/h·$7·79.4% (Table 전체 22개 SOC 대분류, p.11).
- 개별 과업 사례(Figure 4, p.9): Vocational education teachers 커리큘럼개발 4.5h·$33/h·$149·96%; Library science teachers 참고문헌목록작성 2.5h·$41/h·$101·93%; Financial analysts 데이터해석 0.8h·$58/h·$43·80%; Office clerks 사무기기문제해결 0.3h·$22/h·$7·56%.
- 시간절감 분포(Figure 6, p.13): 중앙값 시간절감 81%(본문 텍스트, p.13; Overview는 "약 80%"로 서술, p.2). 진단영상 확인 과업은 20% 절감에 그치나(이미 전문가가 빠르게 수행 가능하기 때문으로 해석), 보고서 정보 취합 과업은 약 95% 절감. 분포는 50~95% 구간에 집중, 80~90%에서 정점.
- 경제 전체 집계(Figure 7, p.15): 10년 내 전 경제 보편도입 가정 시 연간 미국 노동생산성 증가율 +1.8%p(암묵적 TFP 증가율 +1.08%p/년, 노동소득분배율 0.6 가정). 기여도 상위 직업: Software developers 19%, General and operations managers 6%, Market research analysts and marketing specialists 5%, Customer service representatives 4%, Secondary school teachers 3% (p.16-17).
- 역사적 비교(p.15-16, Figure 8): 1947년 이후 평균 노동생산성 증가율 2.1%/년, 2019년 이후 1.8%/년. 1.8%p 추가효과는 이 최근 증가율을 대략 2배로(1960~70년대·1990년대 후반 수준으로) 높이는 규모. TFP 증가율은 2015~2024년 평균 0.7%/년, 1995~2004년 평균 1.6%/년(연준리 샌프란시스코 자료 인용, p.22 각주 5).
- 다른 추정치와의 비교(부록 Figure 10, p.22, Filippucci·Gal·Schief 2024 재인용): Baily·Brynjolfsson·Korinek(2023, 미국) 약 2.6%p, McKinsey(2023, 글로벌) 범위 상단 약 3.4%p, Goldman Sachs(2023, 미국) 약 1.5%p, IMF(2024, 영국) 범위 상단 약 1.5%p, AI Commission of France(2024) 약 1.3%p, Aghion and Bunel(2024, 미국) 약 1.0%p, Bereaud(2024, 유럽지역) 약 0.5%p, Acemoglu(2024, 미국) 약 0.3%p. 본 보고서의 1.8%p는 이 분포에서 상단에 위치.
- 가속-병목 과업 구분 사례(Figure 9, p.18): 소프트웨어개발자는 소프트웨어개발·테스트·검증절차(86% 절감, 주당 약 11%시간)·기존코드수정(76% 절감)에서 AI 사용이 관측되나, 시스템설치조율이나 타 기술자 감독 업무는 AI 사용데이터가 없음("No AI usage data"). 소매판매원은 상품추천(80% 절감)에서는 AI가 쓰이나 판매가격계산·현금결제처리는 AI 사용데이터 없음. 중고등학교교사는 교과과정·활동계획(82% 절감)에서는 AI가 쓰이나 교외활동지도·수업규율집행은 AI 사용데이터 없음.

## Limitations and Future Work

- 저자가 명시한 5가지 한계(Limitations, p.19-20): (1) Claude의 시간추정 자체가 불완전하며, 대화 종료 이후의 활동(결과물 검증·수정 등)은 포착하지 못하고, 이를 검증할 실측 데이터가 없음; (2) O*NET 과업 목록이 실제 업무의 복잡성(암묵지·관계·불확실성 하 판단 등)을 다 담지 못하며, 실제로 종단간(end-to-end) 소프트웨어 기능 개발을 다룬 한 무작위통제실험(RCT)에서는 AI로 인한 시간절감이 관측되지 않았다고 인용; (3) AI 유무 완료시간 비교라는 구조적 가정 자체가 (직원 채용·맥락공유 비용 미반영으로) 효과를 과소평가할 수도, (AI 결과물의 품질이 인간보다 낮다면) 과대평가할 수도 있음; (4) 조직 재구성(historically 가장 큰 생산성 향상의 원천)의 속도나 방식은 모형이 예측할 수 없음; (5) AI가 과학적 발견 과정 자체를 가속·자동화할 가능성과 그로 인한 성장·생산구조 변화는 모형에 포함되지 않음.
- 추가로 명시된 데이터 한계(p.20): 표본이 Claude.ai 대화로만 구성되어 AI 활용 전체 스펙트럼을 대표하지 못하며, 사용자가 "AI가 유용할 것 같다"고 판단한 과업 위주로 선택편의(selection effect)가 존재할 수 있고, 유한표본이라 드문 과업유형은 누락될 수 있음.
- 본 추정치는 "예측이 아니라 현재 사용패턴에 기반한 탐색적 연습(exercise)"이라고 명시(p.16); 향후 AI 능력 향상이나 채택 속도의 불균등성은 반영하지 않음.
- 향후 연구 방향으로 기업의 AI 중심 조직재구성 시점·방식을 이해하는 것을 핵심 과제로 제시(p.21).

## Related Work

이 위키 내에서는 본 보고서가 직접 인용하거나 방법론적으로 의존하는 선행연구, 그리고 동일한 Anthropic Economic Index 시리즈의 병행 연구들이 이미 정리되어 있다:

- [[acemoglu-2024-the-simple-macroeconomics-of-ai]] — 본 보고서가 경제 전체 집계 시 채택한 "baseline" Hulten 정리 적용 방식의 원 출처. 노동소득분배율 0.6 가정 등 세부 파라미터도 이 논문의 수치(AI노출산업 0.57)를 참고해 결정 (p.14, 22).
- [[massenkoff-2026-labor-market-impacts-of-ai]] — 동일 저자(McCrory) 및 동일 Anthropic Economic Index 데이터를 사용해 AI 노출과 실업률·청년 신규채용의 관계를 실증한 병행 연구. 두 보고서 모두 O*NET 과업 단위 분석과 시간비중 가중치(Tamkin and McCrory 2025의 산출물)를 공유.
- [[handa-2025-which-economic-tasks-are]] — Anthropic Economic Index 최초 보고서로, 본 보고서가 "breadth"(어떤 과업에 AI가 쓰이는지)라고 지칭하며 보완 관계로 규정하는 선행 프레임워크의 원전.
- [[appel-2026-economic-primitives]] — 동일 데이터로 과업복잡성·숙련·자율성·성공률 등 경제원시지표를 도입한 병행 시리즈(V4). 본 보고서도 성공률 지표를 초기 측정치에 포함시켰으나 순위 상관 r=0.999로 직업과 강하게 연관되지 않아 최종 분석에서는 제외했다고 명시(부록, 각주 4).

## Glossary

- **Time estimate without AI(AI 미지원 시간추정)**: Claude가 해당 대화의 과업을 AI 지원 없이 전문가가 완료하는 데 필요하다고 추정한 시간(시간단위) (p.5).
- **Time estimate with AI(AI 지원 시간추정)**: 사용자가 실제로 AI 지원을 받아 해당 과업을 완료하는 데 걸린 시간(분단위, Claude가 대화 전사록으로부터 추정) (p.5).
- **Time savings(시간절감)**: 1 − time_with_ai / time_without_ai로 계산되는 과업단위 생산성 향상 지표 (p.9 캡션).
- **Within-task heterogeneity(과업내 이질성)**: 동일한 O*NET 과업이라도 실제 소요시간·복잡도가 크게 다를 수 있다는 개념. 기존 Economic Index 방법론이 포착하지 못하던 부분 (p.4).
- **Hulten 정리**: 완전경쟁·왜곡없는 균형에서 미시적 생산성 향상이 총요소생산성(TFP)에 기여하는 정도가 그 생산요소의 Domar가중치(총산출가치/GDP 비율)에 1차근사로 비례한다는 정리. 본 보고서에서는 로그시간차이(ln(AI미지원시간)−ln(AI지원시간))를 Domar가중합으로 집계 (p.21, 각주 2).
- **가속화 과업(accelerated tasks) 대 병목 과업(bottleneck tasks)**: 표본에서 AI 사용으로 시간절감이 크게 관측되는 과업과, 표본에 AI 사용 자체가 거의 관측되지 않는(따라서 상대적으로 그 직업 내 비중이 커질 수 있는) 과업의 구분 (p.17-18, Figure 9).
