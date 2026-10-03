---
title: "The Recent Evolution of AI-Related Labor Demand"
authors: Kevin Rinz
institution: "Federal Reserve Bank of Cleveland"
year: 2026
doi: "10.26509/frbc-wp-202624"
category: [labor_economics]
source_tier: 1
pdf_path: papers/local/rinz-2026-the-recent-evolution-of-ai.pdf
pdf_filename: rinz-2026-the-recent-evolution-of-ai.pdf
verified_date: 2026-10-03
datasets_used: []
---

## One-line Summary
Lightcast 온라인 구인공고와 CPS를 결합해, 2024년 이후 미국 구인공고의 AI 언급이 LLM 노출이 큰 직업에 집중되어(노출 1표준편차당 AI 언급률 약 3.1%p 상승) 증가했고, 노출 직업에서 상대적 공고 수 안정·게시임금 상승(2026Q2 1표준편차당 3.2%)·채용과 이직 증가가 함께 나타났으나, 재직자 임금은 약 0.9% 하락하고 신규공고당 실업자가 약 9% 늘어 노동시장 긴장도가 낮아졌음을 보인 클리블랜드 연준 워킹페이퍼.

## Document Information
- **유형**: Federal Reserve Bank of Cleveland Working Paper No. 26-24 (2026년 9월 17일), JEL J23, J24, O33
- **저자**: Kevin Rinz (Federal Reserve Bank of Cleveland)
- **DOI**: 10.26509/frbc-wp-202624
- **분량**: 본문 9페이지 + 참고문헌 + 부록 A~D (PDF 전체 45페이지)
- **비고**: 분석 수행에 Claude Opus 4.8, Claude Opus 5, Claude Fable 5를 활용했다고 명시
- **언어**: 영어

## Key Contributions
1. 2026Q2까지의 최신 자료로 직업수준 AI 노출과 구인공고 내용·게시임금·실현임금·노동흐름의 관계를 함께 분석.
2. 구인공고 AI 언급을 구체적 AI 기술, "artificial intelligence" 단독, 일반·브랜딩용 "AI", 채용과정 AI 사용 고지로 분리해 단순 키워드 집계의 과대측정을 교정(부록 B).
3. 2024Q3 "artificial intelligence" 언급 급증이 기술 직종 중심의 일시적 표현 변화였음을 기업-직업 단위 추적과 분해로 규명.
4. 구인공고만 보면 수요 안정·강화로 보이나 노동흐름을 함께 보면 노출 직업의 노동시장 긴장도가 낮아졌다는 상반된 그림을 제시.

## Methodology and Data
- **자료**: Lightcast 정규직 온라인 구인공고(월별 AI 언급은 2026년 8월까지, 분기 분석은 2026Q2까지), CPS(월간 개인 연결로 노동흐름, 주간 소득), Real-Time Population Survey(Bick et al. 2024) 근로 중 생성형 AI 사용률(부록 그림 A2).
- **AI 노출 지표(부록 C)**: LLM 기반 측정치 — Felten et al.(2021) AIOE, Felten et al.(2023) LM-AIOE, Eloundou et al.(2024) β(GPT-4 평가), Handa et al.(2025) Anthropic AEI, Eisfeldt et al.(2025) ESTZ GenAI — 의 **제1주성분(PC1)**을 기본으로 사용. 비교: Webb(2020) AI 특허, Frey and Osborne(2017), Brynjolfsson et al.(2018) SML. 상관(Pearson): AIOE-LM-AIOE 0.98, Eloundou-ESTZ 0.89, Anthropic AEI는 다른 LLM 지표와 0.57~0.68, Frey-Osborne은 LLM 지표와 −0.15~−0.46, Webb은 거의 0(Table C2).
- **이벤트스터디(식 1)**: y_ot = Σ_t β_t(Exposure_o × 1[Quarter=t]) + 직업 FE + 분기 FE, 2022Q3(ChatGPT 직전) 기준, 노출은 표준편차 단위로 탈평균, 직업 균형패널(분기마다 공고 125건 이상, 임금 분석은 임금 게시 25건 이상), 직업 군집 표준오차.
- **CPS 분석**: 기간을 2020Q4~2022Q3(ChatGPT 이전), 2022Q4~2024Q2(ChatGPT 이후·AI 언급 급증 이전), 2024Q3~2026Q2(급증 이후)로 구분. 노동흐름은 직업-분기 셀(취업자 100명당, 사전 고용 가중), 임금은 개인 주간소득 로그(CPI-U 디플레이트), 긴장도(공고당 실업자 등)는 Poisson 회귀. 연령·성별·인종·교육 통제.
- **게시임금 선택 문제(부록 D)**: 임금 게시가 노출 직업에서 더 빠르게 늘고 주별 급여투명성법(Table D1: 2026Q2까지 11개 주+DC)이 게시율을 시행 분기에 10%p 넘게 올림(그림 D2). 기존 쌍 한정, 고용주-직업 FE, DiNardo et al.(1996) 재가중, Hainmueller(2012) 엔트로피 균형, 비의무 주 한정, Lee(2009) 경계로 검증. 급여투명성법이 게시임금 수준 자체를 바꾸므로(동일 쌍 기준 2년 후 약 4%) Heckman 교정의 배제제약은 충족되지 않는다고 판단.

## Key Results
- **AI 언급 추이(그림 1a, Table A1)**: 수년간 완만히 증가하던 AI 언급이 2024Q3 급등. 2023Q4~2024Q2 대비 2024Q3~Q4에 전체 AI 언급 공고 비중 1.97% → 4.68%(+2.71%p, 기업 내 변화가 +2.41%p·89%), "artificial intelligence" 단독 0.30% → 2.50%(+2.20%p, 기업 내 +2.09%p·95%). 급등은 주로 컴퓨터·수학 직업(소프트웨어 개발자, 데이터 과학자, 컴퓨터·정보 연구과학자)에서 발생.
- **급등 이후(그림 1b)**: 2024Q3 "artificial intelligence"를 처음 쓴 기업-직업 중 다음 분기 공고를 낸 곳의 약 3분의 1은 더 이상 AI 용어를 쓰지 않았고, 6분기 후 더 구체적 AI 용어를 쓰는 곳은 약 2%. 저자는 이를 AI 기술 수요의 일시적 관심이 아닌 직무 기술 방식의 일시적 변화로 해석(AI 기술이 당연한 요건이 되어 명시 불필요해졌을 가능성). 시점은 2024년 5월 GPT-4o 무료 제공과 일치하며 2024년 9월 o1은 정점 이후라 원인이 될 수 없다고 봄. 2026년에는 구체적 AI 기술 언급이 가속, 채용과정 AI 사용 고지도 최근 증가.
- **노출과 AI 언급(그림 1c, 초록)**: LLM 노출 1표준편차당 AI 언급률이 2024Q3 약 3%p, 이후 약 4%p 가까이 상승(초록: 3.1%p). 비LLM 노출 지표는 상관이 약하거나 음.
- **공고 수·게시임금(그림 1d)**: 노출 직업의 상대적 공고 수는 ChatGPT 이전부터 시작된 감소 이후 대체로 안정. 실질 게시임금은 ChatGPT 직후부터 상승세로 1표준편차당 2023Q1 1.7%, 2026Q2 3.2% 높음. 효과는 최고노출 직업이 주도하며 기술직 제외해도 유지, AI 미언급 공고에서 오히려 더 뚜렷(그림 A6). 공고 단위 AI 게시임금 프리미엄은 월 FE만 0.606 → 직무명·고용주 FE 포함 0.026 로그포인트(그림 A5).
- **노동흐름(그림 2a·b)**: ChatGPT 이후 노출 직업에서 유출·유입 모두 사전평균 대비 약 3~5% 증가. 유출은 주로 비취업(대부분 비경활)으로, 실업으로의 이동은 거의 전부 해고이며 자발적 이직 증가 증거 없음. 유입은 주로 실업에서. 유출 추정치가 유입보다 약간 크나(순유출) 유의한 차이는 아님. 총이동(churn)률은 ChatGPT 이후 0.4%p 이상, AI 언급 증가기에는 0.6%p 가까이 높음.
- **임금(그림 2c)**: 신규채용자 실현 실질임금 변화는 0과 구분되지 않으나 점추정치는 양(AI 언급 급증 이후 약 1%), 신뢰구간이 게시임금 변화 점추정치를 대체로 포함. 직장이동자 임금 변화는 0에 가까움. **동일 직장 계속 재직자 임금은 후기 기간 약 0.9% 하락(통계적으로 유의)**.
- **긴장도(그림 2d)**: 노출 1표준편차당 신규 공고당 실업자 수 약 9% 증가 — 이직 기회 감소로 재직자의 임금 상승 압력이 줄었다는 해석.
- **청년층(각주 12)**: 선행연구와 일치하게 노출 직업에서 젊은 근로자(35세 미만)의 상대적 채용 감소로 순유출 발생(Table A3). 노출 직업은 최소 경력요건을 높였으나 경력요건 명시 비율은 증가하지 않음(그림 A8).
- **채택과의 비교(그림 A2)**: 22개 주요 직업군에서 2024Q3~2026Q2 AI 언급률 변화와 2024.8~2026.5 근로 중 생성형 AI 사용률 변화(RPS)의 상관 Spearman +0.51, Pearson +0.62, OLS 기울기 3.6(언급 1%p당 사용 3.6%p, R² 0.38) — 사용이 언급보다 훨씬 빠르게 증가.

## Limitations and Future Work
- 기술적 이벤트스터디로 인과효과를 식별하지 않음.
- 게시임금은 실무적·개념적 제약이 있으며(Batra et al. 2023) 임금 게시로의 선택 문제가 있음 — 부록 D의 보정에서 2026Q2 노출 직업 게시임금은 모든 방법에서 양이고 대부분 Lee 경계가 0보다 위에 있음.
- CPS 표본이 작아 기간을 길게 묶어야 함; 외부선택지 통제(Borusyak et al. 2023)를 넣으면 노출과의 높은 상관으로 정밀도 저하(Table A2: PC1과 목적지 노출 0.85 등).
- 데이터 과학자·소프트웨어 개발자·웹 개발자에서 최근 1년 AI 언급률이 2024Q3보다 낮지만 AI의 중요성이 줄었다는 뜻은 아니므로, 기업의 생산과정과 채용·인사 관행을 구분하는 측정이 필요하다고 제언.

## Related Work
- [[acemoglu-2022-artificial-intelligence-and-jobs-evidence]] — 총노동수요가 대체로 유지되었다는 선행연구로 인용.
- [[hampole-2025-artificial-intelligence-and-the-labor]] — 같은 맥락의 선행연구로 인용.
- [[felten-2021-occupational-industry-and-geographic-exposure]] / [[felten-2023-how-will-language-modelers-like-chatgpt]] — PC1을 구성하는 AIOE·LM-AIOE 노출지표.
- [[eloundou-2023-gpts-are-gpts-an-early]] — PC1 구성 지표(β, GPT-4 평가; Science 2024 판 인용).
- [[handa-2025-which-economic-tasks-are]] — PC1 구성 지표(Anthropic AEI, 사용기반 노출).
- [[webb-2020-impact-artificial-intelligence-labor]] — 비LLM 비교 지표(AI 특허 기반); 구인공고 AI 언급과의 관계가 약하거나 음.
- [[fairlie-2026-the-early-impacts-of-ai]] — 같은 시기 CPS 기반 연구로, 최근 대졸자 실업률에서 2026년 유의한 상승을 찾지 못함(상호 인용 없음).

## Glossary
- **PC1 (LLM exposure)**: LLM 능력 기반 직업 노출지표 5종(AIOE, LM-AIOE, Eloundou β, Anthropic AEI, ESTZ GenAI)의 제1주성분.
- **Generic/branding AI mentions**: 직무 내용과 무관하게 "AI-powered", "AI company" 등 일반·브랜딩 맥락에서 쓰인 "AI".
- **Hiring-process disclosure**: 채용과정에서 고용주의 AI 사용을 고지하는 문맥의 AI 언급.
- **Labor market tightness**: 본 논문에서는 신규 공고 대비 실업자 수(공고 재고가 아닌 기간 중 신규 공고 기준).
