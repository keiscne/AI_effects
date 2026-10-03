---
title: "The Macroeconomic Effect of AI: Sizing the Software Engineering Channel"
authors: Alex Blumenfeld, Jonathon Hazell, Chen Lian, Andreas Schaab
institution: ""
year: 2026
doi: "NBER Working Paper No. 35793"
category: [macroeconomics]
source_tier: 1
pdf_path: papers/local/blumenfeld-2026-the-macroeconomic-effect-of-ai.pdf
pdf_filename: blumenfeld-2026-the-macroeconomic-effect-of-ai.pdf
verified_date: 2026-10-03
datasets_used: []
---

## One-line Summary
기업 주가의 AI 주가지수(THNQ) 민감도가 소프트웨어 엔지니어(SWE) 급여비중에 따라 어떻게 달라지는지를 2단계 회귀로 추정(기울기 δ=1.24)하고 이를 일반균형 모형으로 역산해, 2022년 11월~2025년 12월 AI 뉴스가 SWE 생산성의 시장 기대 현재가치를 영구적 32.6% 상승에 해당하는 만큼 높였고 이는 GDP 수준 3.61%(R&D 경로 포함 시 6.48%) 상승에 해당하며, 2026년 상반기 코딩 에이전트 확산 이후 그 효과가 2배 이상으로 커졌다고 추정한 NBER 워킹페이퍼.

## Document Information
- **유형**: NBER Working Paper No. 35793 (2026년 9월), JEL E22, G12, O33, O47
- **저자**: Alex Blumenfeld(UC Berkeley), Jonathon Hazell(LSE), Chen Lian(UC Berkeley·NBER), Andreas Schaab(UC Berkeley·NBER)
- **분량**: 본문 42페이지 + 참고문헌 + Supplemental Appendix A~D + Additional Materials E~H (PDF 전체 119페이지)
- **언어**: 영어

## Key Contributions
1. 금융시장 정보를 이용해 AI가 SWE 생산성을 통해 거시경제에 미치는 영향을 **선행적(forward-looking)·고빈도·실시간**으로 측정하는 방법 제시 — 과업수준 향상을 기업·집계수준으로 집계하는 어려움(병목·weak links)을 자산가격이 이미 내재한 시장 기대로 우회.
2. 이론: 기업 수익률이 SWE 생산성 뉴스에 기업의 SWE 급여비중에 비례해 차별 반응함을 도출(Lemma 1)하고, 2단계 회귀 기울기 δ와 구조적 기울기 δ^S로부터 생산성 승수 κ=δ/δ^S를 회복(Proposition 1). 수요구성 충격·할인율 이질성 하에서의 식별 조건 제시(Assumption 1·2, Proposition 2).
3. Baqaee and Farhi(2020)의 수정 Hulten 정리로 GDP 효과를 도출(Proposition 3: GDP 뉴스 = 기울기 × 역산 × 비용기반 GDP 가중치 γ).
4. 확장: (i) 명시적 AI 부문과 과업기반 생산(비교우위에 따른 SWE↔AI 과업 배분)과의 동형성, (ii) 미국 65개 BEA 부문 산업연관 네트워크, (iii) SWE가 R&D 투입인 준내생 성장모형(Proposition 5, 혁신 포함 Hulten 정리).

## Methodology and Data
- **자료**: Revelio Labs 이력서 기반 근로자 데이터(2021년 기업별 "Software Engineer" 범주 급여비중; 이 범주는 125개 O*NET 코드로 구성되며 상위 20개가 보상의 88.06%, Software Developers 33.15%), Compustat, CRSP 주간 수익률, Kenneth French 데이터 라이브러리의 Fama-French 요인, AI ETF 수익률.
- **AI 지수**: 기본 THNQ(ROBO Global Artificial Intelligence Index, 수정 동일가중, 약 50~60개 종목, 분기 리밸런싱), 강건성은 AIQ(시가총액 가중, 3% 상한).
- **표본(Table A.2)**: 2022~2025 주간 균형패널. CRSP 초기 5,070개 → 금융(SIC 6000-6999) 제외 4,317 → Revelio 매칭 3,290 → 평균 매출·자산 필터 2,889 → 균형패널 2,547 → THNQ/AIQ 구성종목 제외 2,470 → GPT 5.6 Sol로 분류한 반도체 공급망 기업(64개) 제외 2,406 → NAICS 51·54(소프트웨어 생산·판매자) 제외 1,973 → Revelio 고용 하위 5% 제외 1,874. 즉 회귀 표본은 소프트웨어를 **투입으로 사용하는** 기업(예: eBay, Sonos, Expedia, Airbnb).
- **1단계**: 기업별 주간 초과수익률을 THNQ 초과수익률과 Fama-French 3요인에 회귀해 AI 베타 β_j^AI 추정.
- **2단계**: β_j^AI를 SWE 급여비중 γ_j에 회귀, 통제변수는 2017~2021 평균 자산·매출 5분위와 NAICS3 고정효과. γ_j는 99퍼센타일(31.6%)에서 절단, 이분산 강건 표준오차.
- **캘리브레이션(3.4절)**: 수요탄력성 ε=5(Broda and Weinstein 2006, 마크업 1.25), 기업 내 SWE-비SWE 노동 대체탄력성 σ=1.6(Aum and Shin 2024의 한국 기업자료 소프트웨어-노동 대체탄력성 추정치), 매출가중 평균 SWE 급여비중 γ≈0.111, 분산 σ²_γ≈0.0116, 노동비용 비중 α=1.25×0.297≈0.372(BEA/BLS KLEMS 61개 민간산업), SWE 비용비중 약 0.041. 총합 대체탄력성 Σ≈1.70, 구조적 기울기 δ^S≈0.87, 승수 κ=δ/δ^S≈1.42.
- **누적 잔차 AI지수 수익률**: 2022.11~2025.12 FF3 잔차화 기준 22.9%(절편=비정상수익 포함).

## Key Results
- **2단계 기울기(Table 1)**: 통제 없음 1.70 (0.21), +규모 1.81 (0.20), +NAICS2 1.91 (0.21), **+NAICS3(기준) 1.24 (0.26), N=1,850**, +Eisfeldt et al.(2026) 생성형AI 과업노출 5분위 1.28 (0.33), N=1,144. 해석: SWE 급여비중이 1%p 다른 두 기업에서 AI 지수 1%p 상승 시 수익률 차이 1.24bp. 1단계 AI 베타가 5% 수준에서 유의한 기업은 18.2%(Newey-West 4시차).
- **강건성(Table 2, 기준 1.24)**: NAICS4 FE 1.10, NAICS6 FE 0.75 (0.40), 생성형AI 제품시장 노출 통제 1.41, 1단계 NASDAQ 통제 1.20, FF5 1.04, 모멘텀 1.12, 재무비율 통제 1.45, 시가총액 1.38, 본사 주 FE 1.14, 인접 직종 비중 1.42, 평균보상 1.30, 일별 자료 1.50 (0.19), AI 모델 출시일만 사용 1.71 (0.55), ex-Mag7 시장요인 1.31, 초소형주 제외 1.67, AIQ 지수 1.08, 시총가중 1.07, SWE 고용비중 사용 1.23, Revelio 표본 재가중 1.38, 2020년 값 도구변수 1.24, 블록+기업 부트스트랩 SE 0.47(여전히 유의). 연도별 추정도 2022~2025 매년 유사. Assumption 1 제2조건의 와일드 클러스터 부트스트랩 검정 p=0.155로 기각 실패(Table C.1). Oster(2019) 검정: 추가 통제 시 계수가 오히려 1.38→1.90으로 상승(Table C.2).
- **분위 회귀(Table A.4)**: 효과는 SWE 급여비중 상위 분위(특히 5분위)가 주도.
- **SWE 생산성 효과(식 15)**: κ×22.9% ≈ **32.6%**의 영구적 SWE 생산성 상승에 해당(현재가치 정규화 기준). 실험연구의 과업수준 향상(Peng et al. 2023 −56% 시간, Paradis et al. 2025 약 21%, Cui et al. 2026 풀리퀘스트 +26%, Gambacorta et al. 2024 코드산출 +55%)과 유사한 규모 — 선행적 기대(상향)와 과업 간 병목(하향)이 상쇄된 결과로 해석.
- **σ 민감도(Table A.6)**: σ=0.5 → 생산성 14.0%·GDP 1.56%; 1.0 → 22.5%·2.49%; 1.5 → 30.9%·3.43%; 1.6(기준) → 32.6%·3.61%; 2.0 → 39.3%·4.36%.
- **잔차화 방법(Table A.7)**: FF3 고정 22.9%→32.6%, FF3 롤링104주 21.4%→30.5%, 시장만 9.6%→13.7%, FF5 16.5%→23.4%, FF3 ex-Mag7 38.3%→54.4%.
- **γ 측정 대안(Table A.8)**: Revelio 기준 γ=0.1110 → 32.6%·3.61%; BEA 산출가중·미매칭 부문 제외 0.0929 → 32.5%·3.02%; BEA 산출가중·미매칭 0 처리 0.0745 → 32.8%·2.44%; OEWS 컴퓨터 직종 0.0528 → 33.6%·1.77%; Revelio 전 컴퓨터 직종 0.1542 → 32.4%·4.99%.
- **GDP 효과(4.1절)**: γ×32.6% ≈ **3.61%** 영구적 GDP 수준 상승(성장률이 아님). 비선형 정확해는 0.0361→0.0384 로그포인트. 고정 생산요소 하에서 TFP 변화=GDP 변화이므로 3.61% TFP 수준 상승으로도 해석 — Acemoglu(2025)의 10년 0.53~0.66%보다 크고 Aghion and Bunel(2024)의 6.8~13%보다 작음. SWE 경로만 포착하고 2025년 말 이후 뉴스를 제외하므로 하한으로 봄.
- **과업기반 AI 부문 확장(4.2절)**: Harte-Hanks Ci 소프트웨어 예산 자료로 소프트웨어 지출 포함 비중 γ^T 구성(본사 기준 값으로 도구변수). δ^T=0.98, γ^T=0.148, κ≈1.13 → SWE 생산성 25.9%, GDP 3.84%.
- **산업연관 네트워크(4.3절, 부록 G)**: 65개 BEA Summary 부문(2024 I-O표). δ^S_in=0.97, κ≈1.28 → SWE 생산성 29.3%; GDP 가중치 γ^IO≈0.0825 → GDP **2.41%**(비선형 2.55%). 기준 대비 차이의 약 30%는 역산, 약 70%는 GDP 집계 가중치(소프트웨어 급여비중이 0으로 측정된 부문이 노동소득의 약 15%) 때문. σ 0.5~2에서 네트워크 GDP 효과 1.06~2.91%(Table G.2).
- **혁신 경로(5절)**: 준내생 성장 R&D 부문(ψ=1/3, Jones 2022; R&D 비노동비중 ≈0.32, SWE 비중 ≈0.20) → 혁신포함 GDP 계수 (0.1110+0.0667)/0.893 ≈ 0.199 → GDP **6.48%**(기준의 약 1.79배).
- **실시간 추적(그림 2, B.4)**: 2026년 상반기 AI 뉴스가 그 이전 3년 누적을 넘어서며, 2026년 중반까지 생산성·GDP 효과가 2025년 말 대비 2배 이상으로 증가 — Claude Code·Codex 등 코딩 에이전트의 확산 시기와 일치.

## Limitations and Future Work
- 시장의 기대가 정확하다는 보장은 없으며(1절), 추정치는 시장 기대의 현재가치이지 실현된 생산성이 아님.
- 가장 영향력이 큰 구조모수는 σ(SWE-비SWE 대체탄력성)이고, γ 측정(Revelio의 컴퓨터·관리직 과대표집; OEWS 기준 컴퓨터 직종 급여비중 5.3% vs Revelio 11.1%)에 따라 GDP 효과가 1.77~4.99%로 변동.
- 잔차화 방법(시장요인만 vs ex-Mag7)에 따라 누적 수익률이 9.6~38.3%로 크게 달라짐.
- 혁신 경로는 정상상태 비교만 다루며 전이동학은 분석하지 않음.
- 향후 과제: 동일 식별전략을 직업별 비용비중을 이용해 다른 직업군 경로로 확장, AI가 SWE를 통해 혁신과정에 미치는 영향 연구.

## Related Work
- [[acemoglu-2024-the-simple-macroeconomics-of-ai]] — 본 논문이 인용하는 Acemoglu(2025, Economic Policy)의 워킹페이퍼 판. 10년 TFP 0.53~0.66%를 비교 기준으로 사용하고 Hulten 정리 기반 집계 방식을 공유.
- [[aghion-2017-artificial-intelligence-and-economic-growth]] — 본 논문이 인용하는 Aghion, Jones, and Jones(2019) 단행본 장의 NBER 워킹페이퍼 판. AI의 장기 효과가 연구과정 자동화 여부에 달려 있다는 성장이론 문헌으로 인용.
- [[acemoglu-2022-artificial-intelligence-and-jobs-evidence]] — 공저자 Hazell이 참여한 선행연구. 직업 노출 측정과 NAICS 51·54 제외 방식을 차용.
- [[hampole-2025-artificial-intelligence-and-the-labor]] — AI 노출 측정과 과업수준 대체·생산성 효과 상쇄를 보인 연구로 인용.
- [[eloundou-2023-gpts-are-gpts-an-early]] — 직업수준 AI 노출 측정의 출발점으로 인용(Science 2024 판).
- [[acemoglu-2018-the-race-between-man-and]] / [[acemoglu-2019-automation-and-new-tasks-how]] / [[acemoglu-2022-tasks-automation-and-the-rise]] — 4.2절 과업기반 확장이 기반한 자동화 과업모형.
- [[tebrake-2026-generative-ai-and-the-limits]] — 같은 시기 IMF 논문으로, 미시 과업수준 향상과 거시 추정 간 괴리를 국민계정 측정 문제로 설명. 본 논문은 이 괴리를 자산가격으로 우회한다는 점에서 상호보완적(상호 인용 없음).

## Glossary
- **SWE payroll share (γ_j)**: 기업 총급여 중 Revelio "Software Engineer" 범주 근로자 급여 비중(2021년).
- **AI beta (β_j^AI)**: Fama-French 요인 통제 후 기업 초과수익률의 AI 지수 초과수익률 민감도.
- **δ (second-stage slope)**: AI 베타를 SWE 급여비중에 회귀한 기울기.
- **δ^S (structural gradient)**: SWE 급여비중 단위당 SWE 생산성에 대한 이윤탄력성, (ε−1)α/Σ.
- **κ (productivity multiplier)**: δ/δ^S. 잔차화 AI 지수 수익률 1%당 정규화 현재가치 SWE 생산성 뉴스(%).
- **Σ (aggregate elasticity of substitution)**: 기업 내 대체(σ)와 기업 간 재배분을 합친 SWE-비SWE 노동의 총합 대체탄력성.
- **Cost-based Domar weight**: 마크업 왜곡이 있는 경제에서 Baqaee and Farhi(2020)의 수정 Hulten 정리가 사용하는 비용기반 가중치.
