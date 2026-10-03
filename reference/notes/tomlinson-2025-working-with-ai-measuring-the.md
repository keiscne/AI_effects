---
title: "Working with AI: Measuring the Applicability of Generative AI to Occupations"
authors: Kiran Tomlinson, Sonia Jaffe, Will Wang, Scott Counts, Siddharth Suri
institution: "Microsoft Research / Microsoft"
year: 2025
doi: "arXiv:2507.07935v6"
category: [labor_economics]
source_tier: 1
pdf_path: papers/local/tomlinson-2025-working-with-ai-measuring-the.pdf
pdf_filename: tomlinson-2025-working-with-ai-measuring-the.pdf
verified_date: 2026-09-30
datasets_used: []
---

## One-line Summary
Microsoft Bing Copilot 미국 대화 20만 건(균등표본 10만+피드백표본 10만, 2024.1~9)을 LLM 파이프라인으로 O*NET 중간작업활동(IWA)에 다중분류하되 **사용자 목표(user goal)**와 **AI 행위(AI action)**를 분리하고, 커버리지·과업완료율·범위(scope)를 결합한 직업별 **AI 적용가능성 점수(AI applicability score)**를 구축해, 가장 흔하고 성공적인 AI 활용이 정보업무(정보의 생성·처리·전달)이며 대부분의 직업이 어느 정도의 AI 적용가능성을 가지나 임금과의 상관은 약함(고용가중 r=0.13)을 보임.

## Document Information
- **유형**: arXiv 프리프린트 (arXiv:2507.07935v6 [cs.AI], 2025년 12월 22일 판)
- **저자 소속**: Tomlinson·Jaffe·Wang·Suri(Microsoft Research), Counts(Microsoft)
- **IRB**: Microsoft IRB #11028
- **분량**: 본문 9페이지 + 참고문헌 + 부록 A~I(보충 그림 S1~S23, 표 S1~S5), PDF 전체 40페이지
- **공개 결과물**: IWA·직업 수준 집계지표를 GitHub(microsoft/working-with-ai)에 공개, 대화원문은 비공개
- **비고**: Chatterji et al.(2025) 참고문헌에는 이전 제목 "Working with AI: Measuring the Occupational Implications of Generative AI"로 인용됨
- **언어**: 영어

## Key Contributions
1. 한 대화를 **사용자 목표**(사용자가 도움받으려는 작업활동)와 **AI 행위**(AI가 대화에서 직접 수행하는 작업활동)로 분리 분류 — 예: 문서 인쇄법을 묻는 경우 사용자 목표는 "사무기기 조작", AI 행위는 "타인에게 장비 사용법 훈련"(p.1). 이를 통해 AI에 위임될 수 있는 활동과 AI와 협업해 수행되는 활동을 구분.
2. Handa et al.(2025)이 대화를 직업특수적인 O*NET 과업 1개에 매핑한 것과 달리, 대화를 직업 간에 공통 적용되는 **모든 관련 IWA**에 망라적으로 분류해 직업 간 AI 역량을 식별(p.2).
3. 사용량에 더해 성공 척도(LLM 과업완료 분류 + 사용자 thumbs 피드백)와 범위(scope: 해당 IWA 업무 중 AI가 수행/보조 가능한 비율의 6단계 서열척도)를 결합해 직업별 AI 적용가능성 점수를 정의(식 (1)).
4. 사용데이터만으로 "노동력의 x%가 과업의 y% 이상 영향"과 같은 절대치를 산출하는 것은 사용 임계값 선택에 극도로 민감함(그림 S20)을 보이고, 상대비교용 지표로 설계(4.4.2절).

## Methodology and Data
- **자료(4.1절)**: 익명화·개인정보 제거된 미국 Bing Copilot 대화, 2024.1.1~2024.9.30. 주 데이터 Copilot-Uniform(균등추출 약 10만 건), 보조 데이터 Copilot-Thumbs(thumbs up/down 반응이 1회 이상 있는 대화 중 균등추출 약 10만 건).
- **직업·임금 자료(4.2절)**: O*NET 29.0 데이터베이스, BLS 2023 OEWS(임금·고용), 2024 CPS(인구통계 Table 11·11b), 2018 SOC. 군 직업(55-xxxx), 어로·수렵(45-3031), 과업데이터가 없는 74개 SOC 코드를 제외해 785개 SOC 코드(2023 OEWS 기준 1억 4,980만 명, 전체 1억 5,190만 명)를 분석(부록 A.1).
- **IWA 분류 파이프라인(부록 C)**: 1단계 — gpt-4o-2024-08-06이 대화 전체를 보고 사용자 목표·AI 행위를 IWA 형식으로 요약(각 4개 변형 추가, temperature 1), text-embedding-3-large 코사인 유사도로 332개 IWA를 정렬. 2단계 — GPT-4o가 20개씩 블록으로 모든 IWA에 대해 일치 여부를 이진분류(temperature 0), 사용자·AI 쪽 별도 프롬프트. 대화당 평균 IWA 매칭 수: 사용자 목표 2.88(Uniform)/3.53(Thumbs), AI 행위 6.63/7.32(그림 S1).
- **검증**: 저자 3인이 PII 제거된 영어 대화 195건 주석(검증 95/테스트 100). 테스트셋 인간 간 Cohen's κ는 사용자 목표 0.51·0.58·0.41, AI 행위 0.50·0.49·0.57; 파이프라인-인간 κ는 사용자 목표 0.44·0.35·0.38, AI 행위 0.53·0.34·0.39. 전체 매칭률이 한 자릿수 %여서 모든 평가자 간 정확도는 90% 이상. Scope의 인간-인간 평균 MAE는 사용자 목표 0.94·AI 행위 1.05, 인간-LLM은 1.06·1.23(균등무작위 기대 MAE 약 1.94).
- **활동점유율·커버리지(4.3.1절)**: 대화를 매칭된 IWA에 균등 배분한 활동점유율(activity share)을 계산, 0.05% 이상이면 해당 IWA를 "커버됨"으로 정의. 이 임계값에서 사용자 목표 127개, AI 행위 87개 IWA(332개 중)가 커버됨(그림 S21). 임계값은 커버리지 0 또는 1인 직업 수를 최소화하도록 선택, 순위는 세 자릿수 범위의 임계값에 강건(그림 S19).
- **완료율·범위(4.3.2절, 부록 D)**: gpt-4o-mini-2024-07-18로 과업완료(not/partially/complete) 분류 — IWA별 완료율과 thumbs 긍정비율의 가중상관이 사용자 목표 0.827, AI 행위 0.758(그림 S5). Scope는 none~complete 6단계, IWA별로 moderate 이상 비율 사용.
- **직업 가중치(4.4.1절)**: 과업 k의 가중치 = 2^importance × relevance, 같은 IWA로 합산 후 직업 내 정규화(w_ij). AI 행위 쪽은 GPT-5로 O*NET 18,796개 과업의 물리성(사람·사물을 만지거나 옮기는지)을 라벨링해 비물리 과업만 포함한 w_ij^nonphys 사용 — 인간 2인과 200개 과업 중 183·184개 일치(κ 0.82·0.84), 인간 간 181개(κ 0.80)(부록 E).
- **AI 적용가능성 점수(식 (1))**: a_i^user = Σ_j 1[f_j^user ≥ 0.0005] · c_j^user · s_j^user · w_ij (f=활동점유율, c=완료율, s=scope moderate 이상 비율). a_i^AI는 AI 행위 지표와 w_ij^nonphys로 동일하게 계산, 최종점수 a_i = (a_i^user + a_i^AI)/2.
- **사용자 목표 vs AI 행위 편향(4.4.3절)**: 두 점수에 PCA를 적용해 제1주성분은 전반적 적용가능성, 제2주성분은 어느 쪽으로 치우쳤는지를 측정.

## Key Results
- **작업활동(2.1절, 그림 1)**: 사용자 목표 상위는 학습·소통·교육/설명·글쓰기 4개 범주(학습·소통이 가장 두드러짐). AI 행위는 Provide·Explain·Teach·Assist·Respond 등 서비스 역할이 주류. 대화의 40%에서 사용자 목표 IWA 집합과 AI 행위 IWA 집합이 서로소, 96%에서는 한쪽 고유 IWA가 공통 IWA보다 많음. 사용자 목표 IWA 1개당 AI가 평균 2개의 작업활동을 수행.
- **노동력 대비 과대표 GWA**: Getting Information, Updating and Using Knowledge, Communicate with External People, Interpreting Information for Others가 미국 노동력 내 비중보다 Copilot 사용에서 더 흔함 — 정보업무에 해당.
- **성공 척도**: 소통·교육/설명·글쓰기 관련 활동의 완료율×scope가 가장 높고, 이미지 생성과 데이터 분석이 가장 낮음(thumbs 피드백으로도 확인, 그림 S3·S4). Scope와 (로그)활동점유율의 상관 r=0.64(사용자 목표), 0.54(AI 행위)(그림 S10). AI 행위 쪽 완료율×scope가 사용자 목표 쪽보다 일관되게 낮아, AI가 직접 수행할 수 있는 것보다 사용자를 도울 수 있는 업무 범위가 더 넓음.
- **사용자 목표/AI 행위 비대칭(표 S1)**: AI가 보조하는 쪽으로 치우친 IWA — Purchase goods or services(118.4배), Execute financial transactions(58.8배), Perform athletic activities(47.3배) 등. AI가 수행하는 쪽 — Train others on operational or work procedures(17.9배), Train others to use equipment or products(16.0배) 등.
- **직업별 점수 상위(그림 2, 표 S3)**: Interpreters and Translators 0.492, Historians 0.462, Writers and Authors 0.454, Sales Representatives of Services 0.449, CNC Tool Programmers 0.419, Broadcast Announcers and Radio DJs 0.409, Customer Service Representatives 0.408(고용 2,858,710명), Telemarketers 0.404, Political Scientists 0.391, Mathematicians 0.386. 상위 기여 IWA는 정보의 생성(Edit written materials 등)·수집(Maintain knowledge)·전파(Respond to customer inquiries 등).
- **직업별 점수 하위(표 S4)**: Dredge Operators, Bridge and Lock Tenders, Water and Wastewater Treatment Plant Operators, Foundry Mold and Coremakers, Rail-Track Laying Equipment Operators, Pile Driver Operators, Floor Sanders and Finishers, Orderlies가 0.000, Motorboat Operators 0.003, Logging Equipment Operators 0.005.
- **SOC 소분류(표 1)**: Media and Communication Workers 0.38, Sales Representatives, Services 0.35, Information and Record Clerks 0.33, Mathematical Science Occupations 0.32, Tour and Travel Guides 0.32 순. 최하위는 Forest and Conservation Workers 0.03. 저점수 집단은 사람을 신체적으로 다루거나 기계를 조작하는 육체노동 직업이나, 대부분 직업이 일정 수준의 적용가능성을 가짐.
- **SOC 대분류(표 S2, 점수/고용)**: Computer & Mathematical 0.29(5,177,390명), Sales & Related 0.29(13,266,370), Office & Admin. Support 0.26(18,163,760), Community & Social Service 0.25, Arts/Design/Ent./Sports/Media 0.24, Business & Financial Ops. 0.23, Architecture & Engineering 0.22, Education 0.21 … Management 0.13, Healthcare Prac. & Tech. 0.12, Construction & Extraction 0.07, Farming, Fishing & Forestry 0.06, Healthcare Support 0.05(최하위).
- **예측 노출지수와의 비교**: Eloundou et al.의 인간평가 E1 노출과 고용가중 직업수준 상관 r=0.73(그림 S12).
- **임금·학력**: 적용가능성과 평균임금의 고용가중 상관은 r=0.13에 불과(상위 10% 제외 시 0.19)(그림 S13A), 강한 양의 상관을 보고한 선행연구와 다름. 고용가중을 하지 않으면 사용자 목표 0.17, AI 행위 0.32로 상승 — 저임금·고적용가능성·대규모 고용의 판매·사무지원 직업이 차이를 만듦(부록 G). 학력요건별로도 적용가능성 범위가 넓음(그림 S13B).
- **인구통계(그림 S18, 고용가중 WLS)**: 여성 비율 r_w=0.21, 백인 −0.14, 흑인 0.02, 아시아계 0.19, 히스패닉·라티노 −0.43, 중위연령 0.11 — 히스패닉 비중이 높은 직업일수록 적용가능성이 뚜렷하게 낮음.
- **위임 vs 협업(2.2.1절, 그림 3, 표 S5)**: 미디어·재무운영 직업은 소통·훈련 관련 과업을 AI에 위임할 가능성이 높고, 식품조리·서빙 등 물리적 직업에서는 AI가 보조적 역할. 사용자 목표 백분위 높고 AI 행위 백분위 낮은 직업 — Cooks, Fast Food(83, 6), Meat Cutters and Trimmers(79, 6) 등; 반대 — Exercise Trainers and Group Fitness Instructors(17, 75), Training and Development Managers(45, 88) 등.

## Limitations and Future Work
- 완료율·scope는 IWA에 대한 AI의 유용성 척도일 뿐, 해당 IWA를 수행하는 사람의 생산성 효과를 측정하지 않음(3절).
- 동일 IWA라도 직업에서의 수행방식과 대화에서의 의미가 다를 수 있음(예: Provide general assistance는 승무원과 Copilot에서 의미가 다름).
- Copilot 소비자 데이터만 사용해 다른 AI 플랫폼, 과업·직업특화 LLM은 반영되지 않음.
- 직업을 작업활동으로 분해하는 방식은 과업 간 연결("glue")의 가치를 포착하지 못하며, O*NET은 미국 중심이고 현행 업무를 늦게 반영하며 직업 외(가사·자원봉사) 활동을 다루지 않음.
- AI 행위 적용가능성이 높다고 해서 일자리·임금 손실로, 사용자 목표 적용가능성이 높다고 해서 임금상승으로 이어진다고 결론 내리는 것은 오류라고 명시 — ATM 도입 후 은행창구직원 일자리가 늘어난 사례(Bessen 2015) 인용. 고용·임금 효과는 예측하기 어려운 기업 결정에 달려 있음.
- 향후 과제: 직업이 AI에 대응해 업무책임을 어떻게 재편하는지, 어떤 신규 직업이 출현하는지.

## Related Work
- [[handa-2025-which-economic-tasks-are]] — 가장 유사한 선행연구로 명시. Claude 대화를 직업특수적 O*NET 과업 1개에 매핑한 방식과 대비해 본 연구는 직업 간 공통 IWA로 다중분류, 또한 Handa et al.류의 "x% 과업 이상" 절대측정이 임계값에 민감함을 비판.
- [[chatterji-2025-how-people-use-chatgpt]] — 본 연구의 작업활동 분류방식을 채택했으나 직업별 관련성 측정에는 사용하지 않은 ChatGPT 후속 연구로 언급. Chatterji et al.의 IWA 인간주석자 간 κ=0.27보다 본 연구 주석자 간 신뢰도가 높았다고 비교.
- [[eloundou-2023-gpts-are-gpts-an-early]] — 인간평가 E1 노출과 본 점수의 고용가중 상관 r=0.73. 임금과의 강한 양의 상관을 보고한 선행연구로 대비(본 논문은 Science 2024 게재판을 인용).
- [[felten-2023-how-will-language-modelers-like-chatgpt]] — AI 벤치마크 진전 기반 노출 예측의 사례로 인용, 임금과 강한 양의 상관을 보고한 선행연구로 대비.
- [[felten-2021-occupational-industry-and-geographic-exposure]] — 생성형 AI 이전 직업영향 예측 문헌으로 인용.
- [[acemoglu-2019-automation-and-new-tasks-how]] — AI가 신규 작업활동을 수행하는 신규 직업을 창출할 수 있다는 논의에서 인용.
- [[bick-2026-what-work-does-generative]] — Tomlinson et al.(2025)의 Copilot 기반 과업점유율을 서베이 채택률과 비교한 연구.

## Glossary
- **User goal / AI action**: 대화에서 사용자가 달성하려는 작업활동 / AI가 대화 중 직접 수행하는 작업활동.
- **IWA(Intermediate Work Activity)**: O*NET의 중간 수준 작업활동(332개). 여러 직업에 걸쳐 과업을 통해 연결되며, 상위의 GWA(일반작업활동)로 묶임.
- **Activity share**: 한 대화를 매칭된 IWA 수로 균등 배분해 집계한 IWA별 사용 비중.
- **Coverage**: IWA 활동점유율이 0.05% 이상인지 여부. 직업 커버리지는 이 IWA들이 직업 업무에서 차지하는 가중 비율.
- **Scope**: AI가 해당 IWA 전체 업무 중 얼마를 보조/수행할 수 있는지에 대한 6단계 서열 평가(none·minimal·limited·moderate·significant·complete).
- **AI applicability score**: 커버리지 지시함수 × 완료율 × scope(moderate 이상 비율)를 직업의 IWA 가중치로 합산한 점수, 사용자 목표·AI 행위 점수의 평균. 상대비교용.
