---
title: "Labor market impacts of AI: A new measure and early evidence"
authors: Maxim Massenkoff, Peter McCrory
institution: ""
year: 2026
doi: ""
category: [labor_economics]
source_tier: 1
pdf_path: papers/local/massenkoff-2026-labor-market-impacts-of-ai.pdf
pdf_filename: massenkoff-2026-labor-market-impacts-of-ai.pdf
verified_date: 2026-07-29
datasets_used: []
---

## One-line Summary

이론적 LLM 능력과 Anthropic Economic Index의 실제 사용 데이터를 결합한 새로운 직업별 AI 노출 측정치("observed exposure")를 제시하고, 이를 BLS 고용전망·CPS 실업률·청년 고용 데이터와 연결해 분석한 결과, AI 노출이 높은 직업의 BLS 고용성장 전망은 다소 낮지만 2022년 말 이후 실업률에는 체계적 증가가 나타나지 않았고, 다만 22~25세 청년의 고노출 직업 신규채용률이 둔화되는 시사적(suggestive) 증거를 발견한다.

## Document Information

- 저자: Maxim Massenkoff, Peter McCrory (소속 명시 없음; Anthropic 발행 연구보고서, 감사의 글에서 Anthropic 직원들에게 사사) (p.1).
- 발행: Anthropic 연구보고서, 2026년 3월 5일 발행 (p.1, Bibtex citation, p.14).
- DOI 없음. 게재 학술지 없음 — Anthropic 자체 발행 온라인 연구노트(URL: https://www.anthropic.com/research/labor-market-impacts, Bibtex citation, p.14).
- 전체 17페이지(본문 14페이지 + 주석/참고문헌 3페이지)를 표지·핵심 결과 요약·본문·주석·참고문헌까지 전체 읽기로 검증함(2026-06-27).
- 부록(Appendix to "Labor market impacts of AI", 2026년 3월 발행, 전체 11페이지)을 별도 PDF로 추가 확보해 전체 읽기로 검증함(2026-07-29, pdf_path: papers/local/massenkoff-2026-labor-market-impacts-of-ai-appendix.pdf). 본문에서 "부록에 제시"라고만 언급했던 관측노출 측정치의 수학적 정의와 강건성 검토 결과가 이 부록에 담겨 있다.

## Key Contributions

- 이론적 AI 능력(Eloundou et al. 2023의 과업별 β 노출 등급)과 Anthropic Economic Index의 실제 Claude 사용 데이터를 결합한 새로운 측정치 "observed exposure"를 제시. 이론상 가능한 과업 중 실제로 업무 관련 맥락에서, 자동화(automated) 방식으로(보완적 사용augmentative use은 절반 가중치) 사용되는 과업만을 카운트해 직업 단위로 시간비중 가중 평균함 (p.5-6, 각주 5-7).
- 직업별 이론적 AI 노출(Eloundou β)과 실제 관측노출(observed exposure) 간 격차를 직업범주별로 시각화(Figure 2)해, AI가 이론적 잠재력에 크게 못 미치게 활용되고 있음을 보임 — 예: Computer & Math 범주는 이론상 94%가 노출 가능하지만 실제 Claude 커버리지는 33%에 불과 (p.6-7).
- AI 노출과 BLS의 2024~2034년 직업별 고용성장 전망치 간 관계를 직업단위 가중회귀로 추정 (Figure 4, p.8-9).
- 실업률을 핵심 성과지표로 선택해(고용·채용공고 대신) CPS(Current Population Survey) 패널 데이터로 AI 노출 상위 25%와 노출 없음(0%) 그룹 간 실업률 격차를 이중차분(difference-in-differences)으로 추적 (Figure 6, p.11).
- CPS의 패널 차원을 이용해 22~25세 청년 근로자의 고노출 vs 비노출 직업 신규취업률(job start rate)을 별도로 분석 (Figure 7, p.12-13).

## Methodology and Data

- 노출 측정의 3가지 데이터 원천(p.4): (1) O*NET 데이터베이스(미국 약 800개 직업의 과업 목록), (2) Anthropic Economic Index의 Claude 사용 데이터(직전 4회 보고서 누적, 본문 분석에는 2025년 8월·11월 두 데이터셋 사용, 각주 5), (3) Eloundou et al.(2023)의 과업별 이론적 노출 등급 β(1=LLM 단독으로 2배 이상 속도향상 가능, 0.5=추가 도구/소프트웨어 필요, 0=불가능) (p.4-5, 각주 4).
- Observed Exposure 산출 절차(부록 "Defining exposure" 절, p.2-4): 과업 t의 가중 업무사용량 WorkUsage_t = ClaudeWorkUsage_t(Claude.ai에서 업무관련으로 분류된 사용, Appel et al. 2026의 use case primitive로 교육·개인용과 구분) + APIUsage_t(1P API 트래픽 전체, 업무 여부 구분 없이 카운트 — API 호출은 통상 프로덕션 워크플로 통합을 시사하기 때문). 과업은 WorkUsage_t ≥ 100(전체 트래픽의 0.0025%에 해당, O*NET 과업 시간비중 중앙값 0.0014%와 유사한 수준)이라는 엄격한 게이트를 통과해야 커버된 것으로 인정되며, 미달 과업은 노출 0으로 처리(부록 p.2, 각주 3). 과업단위 노출 r̃_t = 1{WorkUsage_t≥100} × 1{β_t≥0.5} × α_t, 여기서 β_t는 Eloundou et al.(2023)의 과업별 이론노출등급(0.5 이상이면 1로 상향), α_t = 1/2 + 1/2×AutomationShare_t(자동화 사용비중이 0이면 α=0.5, 완전자동화만 있으면 α=1)로 자동화 정도에 따라 커버리지를 가중(부록 p.3). 직업단위 측정치 R_o = Σ(w_t·r̃_t)/Σw_t, w_t는 과업 t에 쓰는 시간비중(Tamkin and McCrory 2025)(부록 p.4). O*NET 18,000개 과업문 중 동일·유사 과업은 IWA(332개) 공유 및 의미유사도 0.7 이상 기준으로 그룹화했으며, 이 방식이 본문의 단순 그룹화와 Spearman 상관계수 0.9로 대체로 일치함을 확인(부록 "Task granularity" 절, p.7-8).
- 노출 측정치 비교(부록 "Comparing measures of occupational exposure" 절, p.8-9, Appendix Figure 4): 기준측정치(Baseline)와 Claude.ai 원시사용량(가중X) 간 Spearman ρ=0.81, Eloundou β(시간비중 가중)와는 ρ=0.70; 성공률(사용자 목표 달성 여부)을 곱한 측정치는 기준측정치와 ρ=1.00로 거의 완전히 일치해 성공률이 직업과 강하게 상관되지 않음을 시사; DWA 단위 집계는 ρ=0.71, IWA 단위 집계는 ρ=0.66로 기준측정치보다 낮음(부록 p.8-9).
- O*NET-SOC 코드를 CPS의 occ1990 코드로 변환하기 위해 Eckhardt and Goldschlag(2025)가 제공한 크로스워크를 사용 (각주 8).
- 실업률 분석: CPS 자료로 관측노출 상위 25%(top quartile) 직업 종사자와 노출 0%(하위 30%) 직업 종사자의 실업률을 2016년부터 추적하고, ChatGPT 출시(2022년 11월)를 기준으로 이중차분 추정 (Figure 6, p.11).
- 청년 고용 분석: CPS의 패널 차원(동일 응답자의 월별 재인터뷰)을 활용해 22~25세 근로자가 전월에 없던 새 직업을 보고하는 비율(월별 신규취업률)을 고노출/비노출 직업별로 계산하고 이중차분 추정 (Figure 7, p.12-13).
- 강건성 검토 3종(부록, p.4-6): (1) 22~25세 청년 실업률(신규취업률이 아닌 실업률 자체) 이중차분 — Appendix Figure 1: 2022년 이전에는 노출 상위 25% 그룹의 실업률이 비노출 그룹보다 지속적으로 낮았고, ChatGPT 출시 이후에도 이 격차가 대체로 일정하게 유지됨. Pooled post DiD 추정치 = −0.0023(s.e. 0.0058)로 0과 구분 불가(부록 p.4, Appendix Figure 1); (2) 처치 정의 노출 백분위 기준을 50~95백분위(기준 p75)까지 바꿔가며 재추정 — Appendix Figure 2: 어느 기준을 써도 실업률 영향은 작고 비유의(pooled post ATT가 대체로 0.001~0.003 범위에서 신뢰구간이 0을 포함, 부록 p.5); (3) CPS 서베이가 아닌 노동부(Department of Labor) 실업보험(UI) 청구자 데이터(ETA 203 "Characteristics of the insured unemployed", major SOC군 단위, 주(state)×분기 집계)로 재확인 — 노출 상위 4개 대분류(Computer & Mathematical, Office & Administrative Support, Business & Financial, Sales)로 만든 상위 25%군 평균 커버리지 31% vs 하위 25%군 1%. Appendix Figure 3: 코로나19 팬데믹 기간을 제외하면 두 그룹 간 피보험실업률 격차가 대체로 일정하게 유지되었고, pooled post 추정치 = +0.001%p(s.e. 0.002)로 CPS 기반 본문 결과와 정성적으로 일치(부록 p.5-6).

## Key Results

- Figure 1(p.4): Claude 사용량을 Eloundou β 등급별로 나누면 β=1(LLM 단독으로 충분) 과업이 전체 사용량의 68%, β=0.5(도구 필요)가 29%, β=0(불가능 등급)이 3%를 차지. 직전 4회 Economic Index 보고서에서 관측된 과업의 97%가 이론적으로 노출 가능(β=0.5 또는 1.0)한 등급에 속함 (p.5).
- Figure 3(p.7): 관측노출 상위 직업 — Computer programmers 74.5%, Customer service representatives 70.1%, Data entry keyers 67.1%, Medical record specialists 66.7%, Market research analysts and marketing specialists 64.8%, Sales representatives(wholesale/manufacturing, except technical and scientific) 62.8%, Financial and investment analysts 57.2%, Software quality assurance analysts and testers 51.9%, Information security analysts 48.6%, Computer user support specialists 46.8% (Figure 3 표, p.7).
- 노출 0%(zero coverage) 직업이 전체 근로자의 30%를 차지하며, 예시로 Cooks, Motorcycle Mechanics, Lifeguards, Bartenders, Dishwashers, Dressing Room Attendants가 포함됨 (p.8).
- Figure 4 회귀(고용가중, 25개 등구간 binned scatterplot): 기울기(Slope) = −6.07(표준오차 1.32), R²=0.027 (Figure 4 박스 내 수치, p.8). 본문 서술: 관측노출이 10%포인트 높아질 때 BLS 고용성장 전망치는 0.6%포인트 낮아짐(이는 −6.07의 1/10에 해당) (p.9). 단, Eloundou β 측정치만 단독으로 사용하면 이런 상관관계가 나타나지 않는다고 명시 (p.9).
- Figure 5(CPS, 2022년 8~10월, ChatGPT 출시 직전 3개월) 비교 — 노출 0% 그룹 N=42,546, 노출 상위 25% 그룹 N=32,301 (Figure 5 표, Observations 행, p.9). 노출 상위그룹은 여성일 확률이 15.5%포인트(원문 본문은 "16 percentage points"로 서술하나 표상 차이값은 +15.5pp) 더 높고, 백인(non-Hispanic) 비율이 +10.6%포인트(본문은 "11 percentage points"), 아시아계 비율이 +4.4%포인트로 약 2배 높음. 시간당 임금은 노출 0% 그룹 $22.23 대 상위 25% 그룹 $32.69로 47% 차이(표 Hourly wage 행, 본문 "earn 47% more", p.9). 대학원 학위 보유 비율은 노출 0% 그룹 4.5%, 상위 25% 그룹 17.4%로 약 4배 차이 (Figure 5 표, p.9).
- Figure 6 이중차분(p.11): ChatGPT 출시 이후 누적(pooled post) 평균 효과 = +0.0020(표준오차 0.0019) — 노출그룹 실업률이 소폭 증가했으나 0과 통계적으로 구분되지 않음(Figure 6 그래프 내 표기, p.11).
- 시나리오 분석(p.12): 만약 노출 상위 10% 근로자 전원이 해고된다면, 노출 상위 25% 그룹 내 실업률은 3%에서 43%로, 전체 실업률은 4%에서 13%로 상승할 것으로 계산. "화이트칼라 대침체"에 해당하는, 2007~2009년 대침체 수준의 실업률 두 배 증가(5%→10%)가 노출 상위 25% 그룹에 발생한다면 그 그룹의 실업률은 3%에서 6%로 상승할 것이며, 이 정도 변화는 현재의 신뢰구간으로 탐지 가능하다고 서술(잠정적 기준치, ballpark estimate라고 명시, p.12).
- Figure 7 이중차분(22~25세 청년 신규취업률, p.12-13): ChatGPT 출시 이후 누적(pooled post) 평균 효과 = −14.3(표준오차 7.2), 단위는 2022년 기준치 대비 백분율(% of baseline)(Figure 7 그래프 내 표기, p.13). 본문은 이를 "겨우 통계적으로 유의한(just barely statistically significant)" 14% 하락으로 서술하며, 25세 초과 근로자에서는 이런 하락이 나타나지 않는다고 명시 (p.13).
- 비교 인용(직접 추정치 아님, 각주 10): Brynjolfsson et al.(2025)은 22~25세 고노출 직업 종사자의 고용이 6~16% 감소했다고 보고 — 6%포인트는 고용성장이 평탄(flat)했다는 반사실과 비교한 수치, 16%포인트는 동일 기업 내 직종이 다른 유사 근로자를 비교한 설계에서 나온 수치 (각주 10, p.16).

## Limitations and Future Work

- 저자가 명시한 한계 및 향후 연구(Discussion, p.14): (1) 본문의 사용 데이터(Claude usage data)는 향후 업데이트마다 추가로 반영되어 과업·직업 커버리지에 대한 그림이 계속 진화할 것; (2) Eloundou et al. 측정치는 2023년 초 LLM 능력 수준에 고정되어 있어 향후 갱신이 필요; (3) 청년 근로자·신규 노동시장 진입자에 대한 시사적 결과를 고려해, 노출 분야 학위를 가진 최근 졸업자가 노동시장에서 어떻게 적응하는지를 살펴보는 것이 핵심적인 다음 단계로 제시됨.
- 자체 인정한 분석상 한계: 관측노출이 매우 낮은 수준(예: 10% 과업 커버리지)에서도 고용효과를 기대해야 하는지에 대한 모형적 불확실성을 인정하며, Gans and Goldfarb(2025)의 O-ring 모형(모든 과업에 일정 수준 AI 침투가 있어야 효과가 나타날 수 있음), Hampole et al.(2025)의 노출 집중도(concentration) 효과, Autor and Thompson(2025)의 잔여 과업 전문성 수준 논의를 대안적 해석으로 언급하면서도, 단순성을 위해 평균노출 기준 상위/하위 25% 비교를 본 분석의 중심으로 채택했다고 명시 (p.10).
- 청년 신규채용 둔화 결과에 대해 스스로 제시한 대안적 해석(p.13): 채용되지 않은 청년들이 기존 직장에 머무르거나, 다른 직종으로 이동하거나, 학교로 복귀했을 수 있음; 또한 직업이동(job transition)은 설문조사에서 측정오류에 더 취약할 수 있다는 데이터상 한계를 인정 (각주 11, Fujita et al. 2024 인용).
- 본 보고서 자체가 "노동시장에 대한 AI 영향을 체계적으로 정리하기 위한 첫걸음"이라고 자평하며, 이번 분석은 모든 채널을 포착하지 못한다는 점을 서두에서부터 명시 (p.3, p.14).

## Related Work

이 위키 내에서는 본 보고서가 의존하는 노출 측정 방법론과 비교 대상으로 인용한 선행연구들이 이미 정리되어 있다:

- [[eloundou-2023-gpts-are-gpts-an-early]] — 본 보고서의 관측노출 측정치가 토대로 삼는 이론적 노출 등급(β)의 원 출처. 본 보고서는 이 측정치를 실제 Claude 사용 데이터와 결합해 확장함 (p.4-5).
- [[acemoglu-2022-artificial-intelligence-and-jobs-evidence]] — 채용공고 데이터를 이용한 AI 노출-고용 연구의 비교 대상으로 본문에 인용됨 (p.10).
- [[hampole-2025-artificial-intelligence-and-the-labor]] — 평균노출과 노출 집중도(concentration)를 구분하는 모형이 본 보고서의 처치 정의 논의에서 직접 인용·참고됨 (p.10, 각주 2).
- [[appel-2026-economic-primitives]] — 동일한 Anthropic Economic Index 데이터를 이용해 본 보고서의 "관측노출"과는 별개로 5개 경제원시지표(과업복잡성·숙련·자율성·성공률)를 도입한 병행 시리즈 보고서(V4).

## Glossary

- **Observed Exposure(관측노출)**: 이론상 LLM으로 속도향상이 가능한 과업 중, 실제로 업무관련 맥락에서 자동화 방식으로 사용되고 있는 과업의 비중을 시간가중 평균한 직업단위 지수 (p.5-6).
- **Theoretical AI capability(이론적 AI 능력)**: Eloundou et al.(2023)의 β 등급으로 측정되는, LLM이 이론상 과업 수행 속도를 2배 이상 높일 수 있는지 여부 (p.4-5).
- **Eloundou β**: 과업별 이론적 노출 등급. 1=LLM 단독으로 충분, 0.5=추가 도구/소프트웨어 필요, 0=불가능 (p.5, 각주 4).
- **자동화(automated) 대 보완적(augmentative) 사용**: 관측노출 산출 시, 완전자동화 구현은 전체 가중치를, 사람의 보완적 사용은 절반 가중치를 부여하는 구분 (p.6).
- **이중차분(difference-in-differences) 프레임워크**: 노출 상위/하위 그룹 간 실업률·신규취업률 격차가 ChatGPT 출시(2022년 11월) 전후로 어떻게 변화했는지를 추정하는 분석틀 (Figure 6, 7, p.11-13).
- **α_t (자동화 가중치)**: 과업 t의 관측노출 산출 시 자동화 사용비중(AutomationShare_t)에 따라 0.5(보완적 사용만 존재)~1.0(완전자동화만 존재) 사이 값을 부여하는 가중계수, α_t = 1/2 + 1/2×AutomationShare_t (부록 p.3).
- **R_o (직업단위 관측노출)**: 직업 o에 속한 과업들의 과업단위 노출 r̃_t를 시간비중 w_t로 가중평균한 값, R_o = Σ(w_t·r̃_t)/Σw_t (부록 p.4).
