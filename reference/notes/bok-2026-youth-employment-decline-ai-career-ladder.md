---
title: "청년고용 위축, AI 탓인가? 변화하는 경력 사다리와 대응 과제"
authors: 오삼일, 오영식
institution: "한국은행 조사국 고용연구팀"
year: 2026
doi: ""
category: [labor_economics]
source_tier: 1
pdf_path: papers/local/bok-2026-youth-employment-decline-ai-career-ladder.pdf
pdf_filename: bok-2026-youth-employment-decline-ai-career-ladder.pdf
verified_date: 2026-09-06
datasets_used: []
---

## One-line Summary
국민연금 가입자수와 Felten et al.(2021) AIOE를 결합해 AI 고노출업종 청년고용 감소(-28.5만개 중 94%가 고노출업종)를 확인하고, 자동화·증강 활용방식별 이질성, 대졸청년층의 유독 높은 실업률 상승, 신규채용 위축뿐 아니라 기존 청년근로자 유출 증가까지 분석 범위를 확장해 한진수·오삼일(2025)을 최신 자료로 연장한 후속 연구.

## Document Information
- **유형**: BOK 이슈노트 제2026-19호
- **발행기관**: 한국은행 조사국 고용연구팀
- **저자**: 오삼일 팀장, 오영식 조사역
- **발행일**: 2026년 8월 18일
- **언어**: 한국어

## Key Contributions
1. 한진수·오삼일(2025)의 연공편향(seniority-biased) 기술변화 분석을 최신 자료로 연장.
2. AI 활용 방식(자동화 vs 증강)에 따른 청년고용 영향의 이질성을 업종 단위로 분석.
3. 학력별 실업률 격차(대졸 vs 전문대졸이하)를 ChatGPT 출시 전후로 비교해 AI 확산과의 시점 연관성을 제시.
4. 청년 고용 위축의 경로를 신규채용 감소뿐 아니라 기존 근로자의 유출(이직·실업 전환) 증가로까지 확장해 분석.
5. 삼중차분(DDD) 회귀와 Felten AIOE 기반 강건성 검증(대안 노출지수)으로 결과의 견고성을 확인.

## Methodology and Data
- **취업자수 자료**: 국민연금 가입자수(업종 중분류×연령대), 약 1,600만 명 규모의 행정통계.
- **AI 노출도(주 지표)**: Felten et al.(2021) AIOE를 업종(KSIC 중분류 75개) 내 직업분포로 가중평균.
- **AI 활용방식 자료**: 자동화(automation) 활용 업종 vs 증강(augmentation) 활용 업종 구분.
- **실업률 자료**: 학력별(대졸 vs 전문대졸이하) 청년 실업률 시계열, ChatGPT 출시(2022.11월) 전후 비교.
- **고용 유출입 자료**: AI 고노출업종에서의 청년근로자 유출량(이전 4년 vs 최근 4년 비교), 이탈 후 신규실업자 유입 추적.
- **식별전략**: 업종×연령대×post(ChatGPT 출시 시점 더미)×AI노출도 백분위의 삼중교차항(DDD) 회귀(Appendix 1). 강건성 검증으로 Felten AIOE 대체 지수를 이용한 동일 회귀를 반복(Appendix 2).

## Key Results
- AI 고노출업종 청년고용: 청년 일자리 -28.5만개 중 26.8만개(94%)가 AI 고노출업종에서 발생. 세부업종: 정보서비스업 -31.4%, 출판업 -27.4%, 컴퓨터프로그래밍업 -16.6%, 전문서비스업 -11.6%. 반면 50대는 같은 업종에서 고용 증가.
- AI 활용방식별 이질성: 자동화 방식을 활용하는 업종에서는 청년고용이 감소한 반면, 증강 방식을 활용하는 업종에서는 청년고용 감소가 제한적.
- 실업률 격차: 2022년 11월(ChatGPT 출시) 이후 평균 대졸청년층 실업률 7.0% vs 전문대졸이하 5.4%(격차 1.6%p). ChatGPT 출시 전에는 두 집단의 실업률이 거의 동일(대졸 8.2% vs 전문대졸이하 8.0%).
- 고용 유출입: AI 고노출업종에서의 청년근로자 유출량이 이전 4년 평균 3.7천명에서 최근 4년 평균 4.9천명으로 약 32% 증가. 고노출업종 이탈 이후 신규실업자로 유입되는 규모도 함께 증가.
- DDD 회귀(Appendix 1): 삼중교차항(청년×post×AIOE백분위) 계수 -0.0030***. 청년층은 50대 대비 AI노출도 25percentile 상승 시 고용증가율이 -7.6%p 낮음.
- 강건성 검증(Appendix 2): Felten AIOE를 대안 지수로 대체해도 동일한 방향과 유의성의 패턴이 재확인됨.

## Limitations and Future Work
(원문에서 확인되지 않아 공백)

## Related Work
- [[han-2025-ai-diffusion-youth-employment-decline]] — 본 연구가 직접 연장 대상으로 삼는 직접 선행연구(한진수·오삼일 2025). 동일한 국민연금 가입자수·Felten AIOE 방법론을 최신 자료로 갱신하고, AI 활용방식·고용유출입·실업 분석으로 범위를 확장.
- [[bok-2025-rapid-ai-diffusion-productivity-effects]] — 한국의 AI 활용률·생산성 효과에 관한 원자료 성격의 선행연구.
- [[eloundou-2023-gpts-are-gpts-an-early]] — AI 노출도 측정의 대표적 선행 방법론(GPT 기반 노출 등급).
- [[felten-2021-occupational-industry-and-geographic-exposure]] — 본 연구의 주 AI노출지표(AIOE)의 원 출처.
- [[handa-2025-which-economic-tasks-are]] — 자동화/증강 활용방식 구분과 유사한 관점을 제공하는 Anthropic Economic Index 계열 연구.

## Glossary
- **연공편향 기술변화(seniority-biased technological change)**: AI가 경력이 적은 청년층의 업무를 상대적으로 쉽게 대체하는 반면 경력기반 업무에서는 보완적으로 작동해 시니어 고용은 늘고 청년 고용은 줄어드는 현상.
- **AI 노출도(AIOE)**: Felten et al.(2021)의 직업단위 지표로 자동화 가능성을 측정.
