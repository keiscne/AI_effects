---
title: "What Work Does Generative AI Do?"
authors: Alexander Bick, Adam Blandin, David J. Deming, Tyler Schumacher
institution: "Federal Reserve Bank of St. Louis"
year: 2026
doi: "10.20955/wp.2026.017"
category: [labor_economics]
source_tier: 1
pdf_path: papers/local/bick-2026-what-work-does-generative.pdf
pdf_filename: bick-2026-what-work-does-generative.pdf
verified_date: 2026-09-06
datasets_used: []
---

## One-line Summary
Real-Time Population Survey(RPS)의 신규 과업수준(O*NET DWA) genAI 채택 모듈(2025.8~2026.5, 4개 웨이브)을 이용해 직업·과업 단위 genAI 채택지수를 최초로 구축하고, genAI 노출점수(Eloundou et al. 2024 등)가 채택변이의 5~53%(직업)·7~44%(과업)만을 설명하며, 현재 채택이 "광범위하지만 얕다(widespread but shallow)"는 것과, 챗로그 기반 측정치(Anthropic·OpenAI·Microsoft)가 ONET 과업이 아닌 일반적 활동에 과대분류되어 서베이 기반 측정치와 상관관계가 0.4 미만으로 낮음을 보인다.

## Document Information
- **유형**: Federal Reserve Bank of St. Louis Working Paper 2026-017
- **저자**: Alexander Bick(Federal Reserve Bank of St. Louis & CEPR), Adam Blandin(Vanderbilt University), David J. Deming(Harvard University & NBER), Tyler Schumacher(Vanderbilt University)
- **발행**: Creation Date 2026년 8월, Working Paper Number 2026-017A
- **DOI**: https://doi.org/10.20955/wp.2026.017
- **언어**: 영어

## Key Contributions
1. Real-Time Population Survey(RPS)에 2025년 8월부터 도입된 O*NET 과업수준(DWA) genAI 채택 측정치를 이용해 최초의 직업·과업 단위 genAI 채택지수(adoption index)를 구축.
2. genAI 채택을 과업 경제모형(Y=Σλ_o Σω_o,t y_o,t)에 내재화해, 채택지수가 노동시장 효과 분석에 어떻게 연결되는지 개념적 틀 제시.
3. 6개 genAI 노출점수(Eloundou et al. 2024의 α/β/ζ, Brynjolfsson et al. 2018, Webb 2020, Felten et al. 2021)와 실제 채택률을 비교, 노출점수가 채택변이의 절반 이하만 설명함을 실증.
4. 3가지 준실험적 검증(과거 사용경험, 과업간 파급, 직장-비직장간 파급)을 통해 개인별 학습(learning)이 채택의 핵심 동인임을 제시.
5. Anthropic(Handa et al. 2025)·OpenAI(Chatterji et al. 2025)·Microsoft(Tomlinson et al. 2025) 챗로그 기반 과업점유율과 RPS를 비교, 챗분류기가 직업맥락을 모르기 때문에 일반적 활동(예: "문서 편집")에 과대분류됨을 규명.

## Methodology and Data
- **주 자료**: Real-Time Population Survey(RPS, Bick and Blandin 2023), Qualtrics 온라인 패널 기반 미국 18-64세 노동시장 서베이. 2020년부터 운영, 2024년 8월부터 분기별 시행.
- **표본**: 웨이브당 약 5,000명, 분석은 2025년 8월·11월, 2026년 2월·5월 4개 웨이브(과업수준 genAI 모듈 포함) 풀링.
- **직업 측정**: 2018 SOC 기준 자유기술+자동완성(40,000개 이상 O*NET/OOH 직업), NIOSH 매칭 알고리즘으로 상위 5개 SOC 후보 제시.
- **과업 측정**: O*NET Detailed Work Activities(DWA, 2,040개)를 Intermediate Work Activities(IWA, 332개)·Work Activities(WA, 37개)·Broad Work Activities(BWA, 9개)로 집계. 응답자 직업의 중요도 상위 10개 DWA를 제시하고 실제 수행 여부·genAI 사용 여부를 질문.
- **genAI 정의**: "프롬프트에 반응해 텍스트·이미지·오디오·비디오를 생성하는 AI 유형"(ChatGPT, Gemini, Midjourney 예시 제공).
- **개념틀**: Y=Σ_o λ_o Σ_t ω_o,t y_o,t 생산함수에 과업별 채택률 a_t·genAI 생산성증대 g_t를 도입, ΔY/Y=Σ_t ω_t a_t g_t로 총생산성효과를 분해.
- **노출점수 비교**: Eloundou et al.(2024)의 α(직접노출)·β(가중노출)·ζ(최대노출), Brynjolfsson et al.(2018), Webb(2020), Felten et al.(2021)을 RPS 채택률과 가중상관·회귀분석.
- **학습 채널 식별**: (1) 6개월 전 genAI 사용 여부(회귀, occupation FE 통제), (2) Other-Task Adoption Index(OAI, leave-one-out 다른 과업 채택률)를 도구변수로 한 2SLS, (3) 직장 채택을 OAI로 도구화한 비직장 채택 2SLS.
- **챗데이터 비교**: Handa et al.(2025)(Anthropic, 2025.3.27 릴리스), Chatterji et al.(2025)(OpenAI Signals, 2026.2), Tomlinson et al.(2025)(Microsoft Copilot). Google Gemini(Iscenko et al. 2026)는 과업수준 데이터 미공개로 제외.

## Key Results
- 2026년 5월 기준 미국 성인(18-64세)의 55%가 비업무 목적, 45%가 업무 목적으로 genAI 사용, 전체 채택률(업무 또는 비업무) 62%.
- 직업수준: 80% 이상 직업이 채택률 20% 초과, 그러나 15%만 70% 초과 채택률 — "광범위하지만 얕은(widespread but shallow)" 채택 패턴.
- 과업수준: 40% 과업이 채택률 20% 초과하나 채택률 70% 초과 과업은 전무. 최고채택 직업(Table 1): Computer and information research scientists 87.3%, Information security analysts 85.4%. 최저채택 직업: Animal caretakers 5.3%, Receptionists and information clerks 7.6%.
- 노출점수의 설명력(직업수준, Figure 7): Eloundou α ρ=0.212(R²=0.045), β ρ=0.634(R²=0.402), ζ ρ=0.704(R²=0.496); Brynjolfsson(2018) ρ=0.077(R²=0.006); Webb(2020) ρ=0.477(R²=0.228); Felten et al.(2021) ρ=0.727(R²=0.529).
- 노동자수준 예측력(Table 2): 직업 고정효과 조정R² 0.176, Eloundou ζ 노출점수 조정R² 0.081, Felten 노출점수 조정R² 0.086 — 노출점수는 직업 자체가 설명하는 변이의 절반 이하만 설명.
- 과대예측(over-predicted) 직업: Receptionists and information clerks(예측-실제 격차 -46.4%p), Medical secretaries and administrative assistants(-44.2%p), Tellers(-33.6%p) — 주로 사무·행정직으로 컴플라이언스·기밀정보 제약이 원인으로 해석.
- 과소예측(under-predicted) 직업: Construction equipment operators(+41.2%p), Computer and office machine repairers(+39.7%p), Special education teachers(+32.3%p) — 자율성이 높은 직업.
- 학습채널 3검증 모두 유의: (1) 6개월 이상 사용자는 과업수 0.429개 더 많음(s.e. 0.113, ***, 조정R²=0.441, N=6,565); (2) 과업간 파급 2SLS 계수 0.545~0.702(첫단계F=92.97~436.37); (3) 직장-비직장 파급 2SLS 계수 0.504***(첫단계F=55.38).
- 개인고정효과 포함시 조정R²가 0.112(과업FE만)에서 0.440으로 급증(Table 4) — 특정 근로자가 과업과 무관하게 체계적으로 더 채택하는 경향을 확인.
- 챗데이터 비교(Figure 9, Table 8): RPS-OpenAI 상관 0.11, RPS-Anthropic 0.34, RPS-Microsoft 0.10. 상위 IWA 1개가 총 제곱불일치의 50.3%(OpenAI)·60.9%(Anthropic)·63.5%(Microsoft) 차지. OpenAI 챗의 15.1%가 "Edit written materials or documents"로 분류되나 해당 과업을 O*NET상 보유한 근로자는 2.4%뿐.
- 지니계수(Figure 10): RPS 0.64, Anthropic 0.83, OpenAI 0.83, Microsoft 0.87 — 챗데이터가 서베이보다 훨씬 소수 과업에 집중.

## Limitations and Future Work
저자가 명시:
1. genAI 정의에 대한 응답자 인지 여부에 의존하므로, 자동 삽입형 AI 글쓰기 제안처럼 인지하지 못하는 사용은 과소측정될 수 있어 채택률은 하한(lower bound)으로 해석해야 함(2.4절).
2. RPS는 직업당 상위 10개 과업으로 제한되어 과업의 일부를 누락하며(Figure 3), 챗데이터와의 커버리지 차이가 과업점유율 불일치의 일부를 설명할 수 있음(7.1.2절).
3. Cross-task spillover 분석에서 3자리 세부 직업통제를 포함하면 도구변수(OAI)의 잔여변이가 부족해 첫단계가 약해짐(Appendix B) — 저자는 투명성을 위해 결과를 보고하되 신뢰하지 않음을 명시.
4. 미래 생산성효과 채널(학습주도 확산, 과업장벽 완화, genAI 성능개선, 과업재배분)을 개념적으로만 논의하고 실증 정량화는 향후 과제로 남김(6절).

## Related Work
- [[eloundou-2023-gpts-are-gpts-an-early]] — 본 연구가 실제 채택률과 비교하는 6개 노출점수 중 가장 강한 상관(ζ 기준 ρ=0.704)을 보이는 이론적 노출지수 원 논문.
- [[felten-2021-occupational-industry-and-geographic-exposure]] — 본 연구가 실제 채택률과 비교하는 노출점수 중 가장 강한 상관(직업수준 ρ=0.727)을 보이는 AIOE 원 논문.
- [[handa-2025-which-economic-tasks-are]] — 본 연구가 직접 비교하는 Anthropic 챗로그 기반 과업점유율의 원 데이터.

## Glossary
- **채택률(Adoption rate, a_t)**: 특정 과업을 수행하는 근로자 중 해당 과업에 genAI를 사용한다고 응답한 비율.
- **widespread but shallow**: genAI가 많은 직업·과업에 걸쳐 사용되지만(광범위), 대부분의 직업·과업 내에서는 채택률이 50%를 넘지 않는(얕은) 현재 채택 패턴을 요약하는 표현.
- **Other-Task Adoption Index(OAI)**: 근로자의 특정 과업을 제외한 나머지 과업들에 대해, 다른 근로자들의 평균 채택률(leave-one-out)을 평균한 도구변수.
