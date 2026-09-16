---
title: "Which Economic Tasks are Performed with AI? Evidence from Millions of Claude Conversations"
authors: Kunal Handa, Alex Tamkin, Miles McCain, Saffron Huang, Esin Durmus, Sarah Heck, Jared Mueller, Jerry Hong, Stuart Ritchie, Tim Belonax, Kevin K. Troy, Dario Amodei, Jared Kaplan, Jack Clark, Deep Ganguli
institution: "Anthropic"
year: 2025
doi: "arXiv:2503.04761"
category: [labor_economics]
source_tier: 1
pdf_path: papers/local/handa-2025-which-economic-tasks-are.pdf
pdf_filename: handa-2025-which-economic-tasks-are.pdf
verified_date: 2026-07-24
datasets_used: []
---

## One-line Summary
Anthropic Economic Index의 최초 보고서(R1, 2024년 12월~2025년 1월 Claude.ai 대화 100만 건 표본)로, 프라이버시 보존 분석도구 Clio를 이용해 대화를 O*NET 과업·직업에 매핑, AI 사용이 소프트웨어개발·글쓰기 과업에 집중(전체의 절반 가까이)되면서도 직업의 약 36%가 과업의 25% 이상에서 AI를 사용하고 있음을 보이고, 사용의 57%는 증강(augmentation)·43%는 자동화(automation) 패턴으로 분류.

## Document Information
- **유형**: Anthropic 기술보고서 (arXiv:2503.04761v1 [cs.CY])
- **발행기관**: Anthropic
- **저자**: Kunal Handa, Alex Tamkin (공동 제1저자), Miles McCain, Saffron Huang, Esin Durmus, Sarah Heck, Jared Mueller, Jerry Hong, Stuart Ritchie, Tim Belonax, Kevin K. Troy, Dario Amodei, Jared Kaplan, Jack Clark, Deep Ganguli
- **발행일**: 2025년 2월 (arXiv 게재일 2025.2.11)
- **언어**: 영어

## Key Contributions
1. Clio(Tamkin et al. 2024) 프라이버시 보존 분석 시스템으로 Claude.ai 대화 400만 건 이상을 O*NET 과업·직업 체계와 연결한 최초의 대규모 실사용(observed usage) 측정 프레임워크 — 기존의 이론적 노출(exposure)지수(Webb 2019, Eloundou et al. 2023, Felten et al. 2023)와 대비되는 실측 접근.
2. 직업별 AI 사용의 "깊이(depth)"를 정량화(과업 대비 사용비중의 누적분포) — 직업의 약 4%만이 과업의 75% 이상에서 AI 사용, 약 36%는 과업의 25% 이상에서 사용.
3. O*NET 35개 직무능력(occupational skills) 중 어떤 능력이 Claude와의 대화에서 가장 많이 발현되는지 측정 — 인지적 능력(읽기이해·글쓰기·비판적사고)이 높고 물리적/관리적 능력(설치·장비유지보수·협상)은 낮음.
4. 임금·진입장벽(O*NET Job Zone)별 AI 사용률 분석 — 사용률이 임금 상위 사분위(특히 컴퓨터 프로그래머 등)에서 정점을 찍고 양극단(저임금·최고임금)에서는 낮아지는 역U자형 패턴을 규명.
5. Claude와의 상호작용을 5가지 협업 패턴(Directive·Feedback Loop·Task Iteration·Learning·Validation)으로 분류해 자동화(43%) 대 증강(57%) 비중을 정량화.
6. Claude 3 Opus와 Claude 3.5 Sonnet(New) 간 모델별 사용 패턴 차이(Opus는 창작·교육, Sonnet은 코딩에 특화) 비교.

## Methodology and Data
- **자료**: Claude.ai Free·Pro 대화(엔터프라이즈/API 고객 데이터 제외) 2024년 12월~2025년 1월 수집, 7일 스냅샷 기준. 핵심 과업수준 분석은 100만 건 대화 표본, 전체 분석은 400만 건 이상 대화 활용.
- **분류 방법**: Clio(Tamkin et al. 2024)라는 프라이버시 보존 분석도구가 Claude를 이용해 각 대화를 O*NET 데이터베이스의 약 2만 개 과업문(task statement) 중 가장 관련 있는 것으로 매핑. O*NET 과업이 매우 많아 계층적 트리(hierarchical tree)를 구성해 트리 순회 방식으로 분류 수행. 특정 과업은 최소 5개 이상 서로 다른 사용자 계정에 걸쳐 15건 이상의 대화에서 나타나야 데이터셋에 포함(프라이버시 기준).
- **자동화 대 증강 분류**: 대화를 5가지 인간-AI 협업패턴(표 1)으로 분류 — 자동화적(Directive: 최소상호작용으로 과업 전체 위임, Feedback Loop: 환경피드백에 따른 과업완료), 증강적(Task Iteration: 협업적 개선, Learning: 지식습득, Validation: 작업검증). 분류 결과는 인간 검증(부록 C)을 거침.
- **모델별 비교**: 2024년 3월 출시 Claude 3 Opus와 2024년 10월 출시 Claude 3.5 Sonnet(New) 간 과업사용 패턴 비교.

## Key Results
- **직업군별 사용 비중**: Computer and Mathematical 직업군이 전체 쿼리의 37.2%로 최고, Arts/Design/Entertainment/Sports/Media가 2위(10.3%). Education 관련 직업군도 높은 비중. 물리적 노동이 필요한 직업(운송·자재이동, 보건의료지원, 농림어업)은 최저 비중(그림 2·3).
- **사용 깊이(그림 4)**: 과업의 75% 이상에서 AI 사용을 보이는 직업은 전체의 약 4%(예: Foreign Language and Literature Teachers, 동료협업·강의계획 과업에서는 사용되나 보조금신청서 작성·학생기록관리에서는 미사용). 과업의 50% 이상 사용은 약 11%(예: Marketing Managers). 과업의 25% 이상 사용은 약 36%(예: Physical Therapists — 연구·환자교육 과업에서는 사용되나 직접치료·재택간호지도에서는 미사용).
- **직무능력별 발현 빈도(그림 5)**: 비판적사고·읽기이해·프로그래밍·글쓰기 등 인지능력이 최고 빈도. 설치·장비유지보수·수리 등 물리적 능력이 최저 빈도. Active Listening이 2위로 높게 나타나나, 이는 Claude의 기본 대화행동(재진술·명료화질문)을 반영할 뿐 사용자가 의도적으로 경청 관련 상호작용을 추구한 것은 아닐 수 있음을 저자가 명시.
- **임금별 사용률(그림 6, 표 2)**: 사용률이 임금 상위 사분위(컴퓨터 프로그래머·웹 개발자 등)에서 정점을 찍고 임금 양극단(저임금 웨이터, 고임금 마취과전문의 등)에서는 낮음.
- **진입장벽별 사용률(O*NET Job Zone 1~5)**: Job Zone 1→4로 갈수록(준비필요 수준 증가) 대표성이 증가해 Zone 4(학사학위 요구 수준)에서 정점을 찍고, Zone 5(고급학위 요구 수준)에서는 오히려 하락.
- **자동화 대 증강(그림 7)**: 전체 대화의 57%가 증강적(Task Iteration·Learning·Validation), 43%가 자동화적(Directive·Feedback Loop) 패턴으로 분류. Directive 대화의 다수는 글쓰기·콘텐츠생성 과업, Feedback Loop 대화의 대다수는 코딩·디버깅 과업(사용자가 반복적으로 오류를 전달). Task Iteration은 프론트엔드개발·전문커뮤니케이션 과업에서, Learning은 일반 교육 과업에서, Validation은 대부분 언어번역 관련 과업에서 최고빈도.
- **모델별 사용 패턴(그림 8)**: Claude 3 Opus는 창작·교육 관련 과업(영화/TV/연극/음악 제작, 도서출판관리, 교육과정개발, 학술연구)에서 상대적으로 높은 사용, Claude 3.5 Sonnet(New)은 코딩·소프트웨어개발 과업(소프트웨어개발·유지보수, 컴퓨터시스템 프로그래밍/디버깅)에서 상대적으로 높은 사용.
- **선행 예측연구와의 비교**: Webb(2019)은 임금 90분위 부근에서 AI 노출이 최고일 것으로 예측했으나, 본 연구의 실측 사용률은 중~상위 임금대에서 정점을 찍음. Eloundou et al.(2023)은 미국 근로자의 80%가 과업의 최소 10% 이상 영향받을 것으로 예측했으나, 본 연구의 실측치는 직업의 약 57%가 과업의 10% 이상에서 AI를 사용하는 수준(예측보다 낮으나 추세적으로 근접 가능).

## Limitations and Future Work
- 표본이 Claude.ai Free·Pro의 7일 스냅샷 기준이며, API 데이터나 타 AI 제공사 데이터와는 사용자층·모델능력·제품기능이 달라 대표성이 제한적. Claude.ai는 텍스트만 출력하므로 이미지·영상 등 다른 양식에 의존하는 잠재적 사용자(예: 패션디자이너)를 포착하지 못함.
- Claude 자체를 이용한 대화 분류가 O*NET의 의도된 과업 정의와 불일치할 경우 노이즈를 유발할 수 있음(인간검증·클러스터수준 분석으로 일부 교차검증했으나 완전히 배제하지는 못함).
- 사용자 질의의 복잡도(전문성 수준)를 통제하지 않아, 초보자의 질의도 해당 과업의 "사용"으로 계산되어 특정 과업의 사용률을 과대추정할 가능성.
- O*NET 데이터베이스가 정태적이어서 AI가 새로 창출할 수 있는 신규 과업·직업을 포착하지 못하며, 미국 중심 분류체계여서 국제적 맥락의 사용 패턴 차이를 반영하지 못함.
- Claude.ai 대화 데이터만으로는 사용자가 실제로 산출물을 어떻게 활용하는지(코드를 개발환경에 붙여넣는지, 글쓰기 제안을 문서에 반영하는지, 팩트체크를 하는지 등)를 관찰할 수 없음.

## Related Work
- [[felten-2021-occupational-industry-and-geographic-exposure]] — 이론적 노출(exposure)지수 접근의 대표 선행연구로 본 연구가 실측 사용 데이터와 대비.
- [[eloundou-2023-gpts-are-gpts-an-early]] — 언어모형 자체를 이용해 과업수준 노출을 추정한 선행연구로, 본 연구가 방법론적으로 따르면서도(언어모형 기반 세밀한 추정) 실측 채택률은 예측치보다 낮음을 대조.
- [[massenkoff-2026-labor-market-impacts-of-ai]] — Anthropic Economic Index의 후속 웨이브 데이터와 Eloundou et al.(2023) 이론적 노출등급을 결합해 "관측노출(observed exposure)" 지수로 발전시킨 후속 연구.
- [[fan-2026-aggregate-gains-from-ai]] — Anthropic Economic Index를 국가×직업 단위로 확장해 노동비용등가·AI집중지수를 구축한 후속 IMF 연구, 본 연구의 O*NET 과업매핑 방법론을 국제적으로 확장.
- [[bick-2026-mind-the-gap-ai-adoption]] — 서베이 기반 실제 AI 채택률 측정 연구로, 본 연구의 대화기반 실사용 관측과 상호보완적인 방법론적 방향성을 공유.

## Glossary
- **Clio**: Anthropic이 개발한 프라이버시 보존 분석 시스템(Tamkin et al. 2024). Claude 자체를 이용해 대규모 대화 데이터에서 집계된 통찰을 추출하며, 개별 사용자 활동이 노출되지 않도록 하는 프라이버시 통제를 내장.
- **자동화(automation) 대 증강(augmentation)**: Autor(2015)의 구분을 따라, 전자는 기술이 인간노동을 대체하는 것, 후자는 기술이 인간의 능력을 보완·향상시키는 것을 의미. 본 연구는 5가지 협업패턴(표 1)으로 이를 조작화.
- **O*NET Job Zone**: 미국 노동부 O*NET 데이터베이스가 직업을 요구되는 준비수준(교육·경험·훈련)에 따라 1(최소 준비)~5(고도 준비)로 분류한 체계.
- **과업 사용 깊이(depth of AI usage)**: 한 직업 내 전체 과업 중 AI 사용이 관측된 과업의 비율. 폭(breadth, 몇 개 직업에서 AI가 쓰이는가)과 대비되는 개념.
