---
title: "The Anthropic Economic Index report: Economic Primitives"
authors: Ruth Appel, Maxim Massenkoff, Peter McCrory, Miles McCain, Ryan Heller, Tyler Neylon, Alex Tamkin
institution: Anthropic
year: 2026
doi: ""
category: [labor_economics]
source_tier: 1
pdf_path: papers/local/appel-2026-economic-primitives.pdf
pdf_filename: appel-2026-economic-primitives.pdf
verified_date: 2026-07-29
datasets_used: []
---

## One-line Summary

Anthropic Economic Index 4번째 보고서(V4). 2025년 11월 Claude 사용 데이터(Opus 4.5 출시 직전)를 대상으로 과업복잡성·인간과 AI의 숙련·용도(업무/코스워크/개인)·AI 자율성·과업성공 5개 신규 "경제 원시지표(economic primitives)"를 도입해, 성공률을 반영하면 직업별 AI 노출도가 달라지고(예: 데이터입력원·영상의학과 전문의는 과업커버리지 대비 실질영향이 더 큼), Claude가 다루는 과업은 평균적으로 경제 전체보다 더 높은 교육수준을 요구해 이를 제거하면 순탈숙련(net deskilling) 효과가 나타나며, 신뢰도(성공률)를 반영하면 향후 10년 연 노동생산성 증가 기여분이 1.8%p에서 1.0~1.2%p로 축소됨을 제시.

## Document Information

- 저자: Ruth Appel, Maxim Massenkoff, Peter McCrory(이상 공동 리드저자), Miles McCain, Ryan Heller, Tyler Neylon, Alex Tamkin (p.1).
- 발행: Anthropic, 2026년 1월 15일 (p.1). Anthropic Economic Index 보고서 시리즈의 4번째 판("this fourth Anthropic Economic Index report", p.53).
- DOI 없음. 게재 학술지 없음 — Anthropic 자체 발행 온라인 연구보고서. 데이터는 https://huggingface.co/datasets/Anthropic/EconomicIndex 에 공개 (p.20, p.23).
- 온라인 부록(Online Appendix, "Economic Primitives and Classification Prompts", papers/local/appel-2026-economic-primitives-appendix.pdf, 19페이지)을 포함해 전체 읽기로 검증함(Tier 1). 부록은 9개 신규 분류기(primitives classifier)의 프롬프트 전문과 보충 그림(국가/미국 주별 AUI 순위, 편회귀 그림 등)으로 구성되며 별도 실증 결과는 포함하지 않음.

## Key Contributions

- 협업패턴(자동화/증강) 외에 5개 차원의 신규 "경제 원시지표"를 정의: ①과업복잡성(사람 단독 소요시간·사람+AI 소요시간·멀티태스킹 여부), ②인간·AI 숙련(사람 단독 완료가능 여부, 사람·AI 응답 이해에 필요한 교육연수), ③용도(업무/코스워크/개인), ④AI 자율성(1~5점), ⑤과업성공 여부 — 총 9개 분류기(표2.1) (p.19-24).
- 과업 성공률을 가중치로 반영한 "실효 AI 커버리지(effective AI coverage)" 지표를 신규 정의해, 단순 과업등장 여부 기반 커버리지와 다른 직업별 실질 영향을 규명 (p.42-44).
- Claude가 다루는 과업의 평균 예측교육연수(14.4년, Associate's degree 수준)가 경제 전체 과업 평균(13.2년)보다 약 1년 높음을 과업 임베딩 기반 릿지회귀로 추정, 이를 제거할 경우 순탈숙련 효과가 나타남을 실증 (p.45-47).
- 과업성공률·과업보완성(CES 집계, 탄력성 ρ)을 반영해 기존 생산성 추정치(연 1.8%p)를 갱신 — 신뢰도 반영 시 1.0~1.2%p, ρ=0.5(보완재) 가정 시 0.6~0.9%p로 하향 (p.48-51).

## Methodology and Data

- Chapter 1: 2025년 11월 13~20일 샘플링된 Claude.ai 소비자(Free/Pro/Max) 대화 100만 건과 1P API 트랜스크립트 100만 건(각 프라이버시 보존 분류, 분류기는 Sonnet 4.5 사용, 이전 보고서는 Sonnet 4 사용) (p.17 각주1, p.17 각주7).
- Chapter 2: 9개 신규 분류기를 "Claude에게 익명화된 대화 관련 특정 질문을 직접 던져(prompt) 응답을 primitives로 사용"하는 방식으로 구현. 검증은 사용자 피드백이 있어 원문 확인 허가를 받은 소표본에 대한 인간연구자-분류기 비교(Claude.ai)와 내부·합성데이터 혼합(1P API)으로 수행, 방향적 정확성(directional accuracy)만을 기준으로 채택 여부 결정, 3개 항목(인간시간 추정·인간+AI시간 추정·AI자율성)에서만 chain-of-thought 프롬프팅이 성능을 유의하게 개선해 최종 채택 (p.21-22).
- Chapter 3: 지리 분석은 프라이버시 보존 분석(셀당 최소 15대화·5계정)을 적용한 Claude.ai Free/Pro/Max 대화 100만 건(2025.11.13~20)에 기반, 지오로케이션은 IP주소 기반 ISO-3166 코드(VPN/anycast/호스팅 트래픽 제외) (p.36 각주1-2).
- Chapter 4: 과업복잡성-생산성 분석은 Claude가 추정한 "사람 단독 소요시간" 대비 "사람+AI 소요시간"의 비율("speedup")을 O*NET 과업 단위로 산출, 관측치 200건 이상 과업만 포함. 교육수준 산출은 사전학습 문장임베딩(all-mpnet-base-v2)+BLS 직업단위 교육수준을 타겟으로 한 릿지회귀로 과업단위 교육연수를 예측 (p.51 각주4, p.52 각주6).
- 생산성 집계: Hulten 정리(탄력성 ρ=1 특수사례) 및 CES 집계함수(ρ≠1, 직업내 과업을 시간비중으로 가중)를 이용해 과업단위 시간절감을 경제전체 생산성효과로 환산, 과업성공률로 시간절감을 할인하는 조정도 병행 (p.53 각주9).

## Key Results

- 과업 집중도: Claude.ai 상위10대 과업 비중이 24%(2025.11)로 8월(23%) 대비 소폭 상승, 1P API는 28%→32%로 더 크게 상승 (p.6).
- 협업모드: 2025년 8월 자동화가 증강을 초과했던 추세가 반전, 2025년 11월 Claude.ai 증강 비중이 5%p 상승해 52%, 자동화는 4%p 하락해 45%(directive 단독 39%→32%) (p.9).
- 미국 주간 수렴: 2025.8~11월 미국 주 지니계수 0.37→0.32로 하락, 이 속도가 유지되면 약 2년 내 사용 균등화 예상(글로벌 국가간 지니계수는 변화 없음) (p.12).
- 컴퓨터·수학직 근로자 비중 1% 증가는 주 단위 AUI 0.36% 상승과 연관, 이 요인 하나가 주간 AUI 변이의 약 2/3 설명 (p.13).
- 미국주 수렴 속도 모형: OLS 추정 λ≈0.77(가중 0.76), 2SLS(주 노동력구성을 도구변수로 사용) λ≈0.89(가중 0.86) — 2SLS 기준으로도 로그편차 90% 해소에 4~5년 소요 (p.15-16).
- 두 예시 request cluster 비교(그림2.2, N=999,875 전체 대비 소프트웨어개발 N=147,984·개인생활관리 N=26,460): 소프트웨어개발은 사람단독 3.3시간·교육수준 13.8년·업무비중 64%·성공률 61%, 개인생활관리는 각각 1.8시간·9.1~9.4년·17%·78% (그림2.2, p.24-25).
- Claude.ai vs API 원시지표 비교: API는 업무비중 74%(Claude.ai 46%)·directive 64%(32%)·자동화 75%(Claude.ai 50% 미만), Claude.ai는 성공률 67%(API 49%)·사람시간 3.1시간(API 1.7시간) (p.26).
- 국가수준 회귀: GDP per working-age capita 1% 증가는 AUI 0.7% 증가와 연관, 인간교육연수(프롬프트 이해에 필요한 교육연수)는 국가·미국 주 수준 모두에서 AUI와 유의한 양의 상관 (p.30-31).
- 과업성공-인간교육 관계: 국가수준에서는 음의 상관(교육수준 높은 인구가 더 어려운 과업 시도), 미국 주수준에서는 양의 상관이나 다른 원시지표 통제 시 비유의 — 서로 반대방향의 패턴 (그림3.5, p.33).
- 인간-AI 교육연수 상관: 국가수준 r=0.925(p<0.001, N=117), 미국 주수준 r=0.928(p<0.001, N=50) (p.34).
- 과업복잡성-속도향상: 고졸수준(12년 교육) 과업은 speedup 9배, 대졸수준(16년) 과업은 12배 (그림4.1, p.38-39). 단, 복잡한 과업일수록 성공률은 낮음(고졸 미만 70% vs 대졸수준 66%, Claude.ai) (그림4.1 우패널, p.39).
- Task Horizon: API 데이터에서 성공률 50% 도달 지점이 인간소요시간 3.5시간(METR 벤치마크 Sonnet 4.5의 2시간, Opus 4.5의 약 5시간과 비교), Claude.ai에서는 약 19시간까지 확장(다회차 대화의 반복적 피드백 루프 효과로 해석) (p.41).
- 직업단위 과업커버리지: 누적 보고서 기준 직업의 49%가 과업의 25% 이상에서 AI 사용 관측, 약 4%가 75% 이상 커버리지 (p.42-43).
- 교육수준: 경제 전체 과업 평균 예측교육연수 13.2년, Claude가 다루는 과업 평균 14.4년(Associate's degree 수준) (그림4.5, p.46).
- 탈숙련/숙련상승 사례: 기술문서작성자(technical writers)·여행상담사(travel agents)·여러 교직은 AI가 담당하는 과업이 더 고학력 과업이라 탈숙련 효과, 부동산관리자(real estate managers)는 저학력 행정과업(12.6~12.8년)이 제거되고 고차 협상·이사회관리 과업이 남아 숙련상승 효과 (p.46-47).
- 생산성 재추정: 성공률 미반영 기준 연 1.8%p(Claude.ai·API 동일), 성공률 반영 시 Claude.ai 1.2%p·API 1.0%p로 하향 (p.48). CES 탄력성 ρ=0.5(과업보완적)에서는 0.7~0.9%p(성공률 추가반영시 Claude.ai 0.8%p·API 0.6%p), ρ=1.5(과업대체적)에서는 2.2~2.6%p로 상승 (그림4.6, p.49-50).

## Limitations and Future Work

- 저자가 명시: 9개 신규 분류기는 "방향적으로 정확(directionally accurate)"함만 검증되었고, 개별 분류값 자체는 정밀하거나 확정적인 것으로 간주해서는 안 됨(예: Claude.ai가 많은 과업의 인간교육연수를 다소 과소추정할 가능성) (p.23).
- 인간연구자 비교 검증(Claude.ai)과 내부·합성데이터 검증(1P API) 모두 실제 트래픽을 완전히 대표하지는 못한다는 한계를 명시 (p.22).
- 과업 성공률은 사용자가 실패할 것으로 예상되는 과업을 애초에 가져오지 않는 선택효과(selection)에 의해 실제 역량보다 관측성공률이 과대평가될 수 있음을 논의(API·Claude.ai가 서로 다른 방식으로 선택효과를 가질 수 있음) (p.41-42).
- 과업제거 기반 탈숙련/숙련상승 분석은 현재 Claude 사용패턴에 기반하므로, 향후 모델이 새 역량을 학습하고 사용자가 새 응용을 발견함에 따라 어느 과업이 커버되는지, 순효과가 탈숙련인지 숙련상승인지가 달라질 수 있음을 명시 (p.47).
- 생산성 추정치는 현재 모델 세대의 역량을 반영하며, 신뢰도(과업 지속시간에 따른 성공률 저하)가 향후 개선될 것으로 예상됨을 언급 (p.4, p.53).

## Related Work

- [[handa-2025-which-economic-tasks-are]] — Anthropic Economic Index 최초 보고서(R1)의 O*NET 과업 매핑 방법론을 계승, 본 보고서가 5개 신규 원시지표로 확장.
- [[appel-2025-uneven-geographic-and-enterprise-ai]] — 직전 판(V3, 2025년 8월 데이터)의 지리적 분해·AUI 정의를 그대로 계승해 2025년 11월 데이터로 갱신.
- [[massenkoff-2026-learning-curves]] — 본 보고서(V4, 2025.11 데이터)가 도입한 경제원시지표 프레임워크를 계승해 2026년 2월 데이터로 갱신한 후속 보고서(V5).
- [[hampole-2025-artificial-intelligence-and-the-labor]] — 과업별 대체효과와 노출집중도를 구분하는 접근이 본 보고서의 실효 AI 커버리지 논의와 관련.

## Glossary

- **경제 원시지표(economic primitives)**: 대화의 익명화된 트랜스크립트에 Claude가 직접 특정 질문에 답하는 방식으로 생성하는, 과업복잡성·인간과 AI의 숙련·용도·AI자율성·과업성공 등 AI 사용의 단순·기초적 측정치 (p.19).
- **실효 AI 커버리지(effective AI coverage)**: 근로자 하루 업무 중 Claude가 성공적으로 수행 가능한 비중. 과업성공률×과업의 시간비중(빈도로 조정)의 가중합으로 계산 (p.42-43).
- **AI 자율성(AI autonomy)**: Claude가 과업 수행 중 스스로 결정을 내리는 정도(1=전무~5=매우높음) (p.19-20, 부록 2.2.1).
- **CES(Constant Elasticity of Substitution) 집계**: 직업 내 여러 과업의 시간절감을 탄력성 ρ로 가중집계해 직업단위 speedup을 산출하는 생산함수 형태. ρ<1(보완재)이면 병목과업이 전체 이득을 제약, ρ>1(대체재)이면 특화를 통해 이득이 증폭 (p.53 각주9).
