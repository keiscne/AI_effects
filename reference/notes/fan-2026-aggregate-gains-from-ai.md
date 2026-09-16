---
title: "Aggregate Gains from AI and Their Distribution: Global Evidence from Usage Data"
authors: Rachel Yuting Fan, Ha Minh Nguyen
institution: "IMF (Institute for Capacity Development); World Bank (Fan, at time of writing)"
year: 2026
doi: ""
category: [labor_economics]
source_tier: 1
pdf_path: papers/local/fan-2026-aggregate-gains-from-ai.pdf
pdf_filename: fan-2026-aggregate-gains-from-ai.pdf
verified_date: 2026-07-24
datasets_used: []
---

## One-line Summary
Anthropic Economic Index(AEI) 5개 웨이브(2025년 1월~2026년 2월, 웨이브당 약 100만 개 Claude 대화)의 실제 사용 데이터로 국가·직업별 AI 사용량을 측정해, 노동비용등가(LCE, 연 2.7조 달러·표본국 GDP의 3.4%)와 AI집중지수(ACI)를 새로 구축, 거의 모든 국가에서 AI 이득이 고임금 직업에 편중되지만(개도국일수록 극단적) 그 편중도가 점차 완화되고 있음을 보임.

## Document Information
- **유형**: IMF Working Paper WP/26/147
- **발행기관**: IMF, Institute for Capacity Development
- **저자**: Rachel Yuting Fan (집필 당시 World Bank 이코노미스트), Ha Minh Nguyen (IMF Senior Economist)
- **발행일**: 2026년 7월
- **언어**: 영어
- **JEL 코드**: D63, O33, O14, O12, J31

## Key Contributions
1. AI의 잠재적 노출(exposure) 지수(Felten et al. 2021; Eloundou et al. 2024)가 아니라 실제 사용(observed usage) 데이터를 이용해 "AI가 실제로 어느 직업에서 얼마나 쓰이고 있는가"를 100개국 이상에서 시계열로 관측한 최초의 다웨이브·다국가 연구.
2. 노동비용등가(labor cost equivalent, LCE): 각국 고유 임금으로 AI가 절감한 시간의 가치를 평가하는 지표를 구축, 연간 약 2.7조 달러(표본 86개국 GDP의 3.4%)로 추정.
3. AI집중지수(AI concentration index, ACI): 보건경제학의 concentration index(Wagstaff et al. 1991; Kakwani et al. 1997)를 응용해, AI 사용이 고임금·저임금 직업 중 어느 쪽에 편중되는지를 -1~+1 단일 지표로 요약.
4. 국가간 회귀분석으로 AI 규제준비도(regulatory readiness)가 국가별 AI가치 포착(LCE/GDP)과 ACI 수준의 핵심 예측변수임을, 영어 공용어 여부가 ACI 하락 속도(집중도 완화 속도)의 핵심 예측변수임을 규명.

## Methodology and Data
- **자료**: Anthropic Economic Index(AEI) 5개 릴리스(R1: 2025년 1월경, R2: 2025년 3월경 — 국가분류 없이 세계 전체만, R3: 2025.8.4~11 — 114개국, R4: 2025.11.13~20 — 117개국, R5: 2026.2.5~12 — 117개국). 웨이브당 약 100만 개 Claude 대화를 Anthropic 자체 분류기로 O*NET 직무(task)에 매칭 후 SOC-2 22개 직업군으로 집계, 국가간 비교를 위해 ILO 자료가 일관되게 제공되는 최소단위인 ISCO-08 1자리 9개 그룹으로 크로스워크. R5 기준 176개국에 지리코드가 부여되고 이 중 117개국이 Anthropic의 최소 대화건수(200건) 기준을 충족해 분석에 포함(전체 GDP의 79%). ILO 임금·고용자료(ISCO-1 단위)가 직접 존재하는 86개국이 기준표본(전세계 GDP의 67%), 나머지 31개국은 GDP·서비스업비중·수도간거리 기준 최근접 동일지역 국가의 자료를 대체 사용(매칭국 확장표본 115개국).
- **시간 추정치**: R4·R5는 과업별로 AI 없이/AI 활용 시 완료시간을 Claude 자체가 추정해 보고(예: "기존 소프트웨어 수정" 3.54시간→17.8분, 3.24시간 절감). R3는 시간 추정치 미보고로 가장 가까운 웨이브인 R4 값을 적용. R4-R5 간 약 3,200개 공통 과업의 절감시간 상관계수 ρ=0.80.
- **LCE 산식(식 1)**: LCE = Σ_c Σ_s Σ_{t∈s} (n_{c,t}/N*_country) × C_total,w × h_t × (W_{c,s}^monthly × 12 / 2,080). n_{c,t}=국가c 과업t의 분류된 대화수, C_total,w=웨이브별 전체 플랫폼 AI 대화수(주간, R5 기준 Claude 주간 대화 2억건÷Claude 시장점유율 25%≈8억건), h_t=과업별 절감시간, W_{c,s}=ILO 국가c 직업s 명목월평균임금(USD). 2,080=연간 근무시간(주40시간×52주).
- **ACI 산식(식 2)**: ACI_{c,w} = (2/μ_{c,w}) Σ_s g_{c,s,w}(R_{c,s} - 1/2·e_{c,s}), g=직업군별 AI절감시간 비중, e=직업군별 고용비중, R=국가 자체 임금분포 내 직업군의 분수순위(fractional rank), μ=고용가중 평균 AI효과. -1~+1 범위, 양수는 고임금 직업 편중, 0은 고용비중에 비례.
- **회귀분석**: (1) LCE/GDP(%), (2) ACI 수준(R3·R4·R5 풀링), (3) ΔACI(연속 두 웨이브 간 변화)를 각각 OLS로 추정, 웨이브 고정효과 포함, 국가 클러스터 표준오차. 공변량: 로그(1인당GDP, PPP), IMF AI Preparedness Index의 규제 하위지수(AI regulatory readiness), 실업률·서비스업부가가치비중·인터넷이용률(World Bank WDI), 가처분소득 지니계수(Standardized World Income Inequality Database), 영어 공용어 여부 더미.
- **강건성 점검**: 과업별 시간 추정치(h_t)의 95% 신뢰구간 하한/상한 조합으로 극단적 상한·하한 시나리오 구성. 시장침투 가정(Claude 주간대화 1.5~2.5억건, 시장점유율 15~35%)에 대한 민감도 그리드(부록 표 A2). 매칭국 확장표본(115개국)으로 전체 회귀 재추정.

## Key Results
- **웨이브별 사용가중 평균임금(wage index, 식 3, 그림 2a)**: 2025.1월 82,353달러→2026.2월 77,845달러로 5.5% 하락. Computer & Math의 전세계 AI대화 점유율이 4.9%p 감소한 대신 Education(+4.1%p)·Sales(+2.7%p)·Office/Admin(+1.6%p)이 증가.
- **LCE 추세**: R3(2025.8월) 연환산 1.2조달러 → R5(2026.2월) 2.7조달러(표본 86개국 GDP의 3.4%). R4→R5 증가분의 약 84%, R3→R4 증가분의 약 72%가 대화건수 증가(extensive margin), 나머지가 대화당 가치 변화(intensive margin)에서 기인(주20 계산식).
- **소득수준별 LCE/GDP(그림 2b)**: 고소득국 GDP의 4.2%, 중소득국 약 0.6%, 저소득국 0.1% — 고소득국이 전체 LCE의 96%를 차지.
- **LCE 민감도(부록 표 A2)**: 보수적 가정(주1.5억 대화, 시장점유율35%) 1.6조달러 ~ 공격적 가정(주2.5억 대화, 점유율15%) 6.1조달러. 시간추정치 상한/하한 극단 적용 시에도 2.5~2.9조달러 범위로 안정적(3.4절).
- **ACI 국가별 사례(그림 4, Box 3)**: 미국 ACI=+0.49(Professionals 17.4%가 고용의 83.6%의 AI절감시간 차지), 인도 ACI=+0.84, 케냐 ACI=+0.78. 저소득국(사하라이남아프리카·남아시아, 1인당GDP<5,000달러)은 ACI 0.90~1.00에 밀집, 서유럽·북미(1인당GDP>50,000달러)는 0.35~0.55.
- **ACI 시간 추이(그림 5)**: 3개 웨이브 모두 관측된 81개국 중 61개국에서 실질적 ACI 변동 발생(20개국은 모든 대화가 단일 직업군에 매핑되어 변동 없음). ACI 하락국 비중이 1기(2025.8→11월) 23개국(28%)에서 2기(2025.11→2026.2월) 43개국(53%)로 증가. 1기에 ACI 상승했다가 2기에 하락 반전한 국가 26개국 중 12개국이 중소득국.
- **회귀결과(표 5, 86개국 표본, 원문 텍스트 서술 기준 — 표 자체는 pdftotext 레이아웃 손상으로 셀 대응 불확실하여 일부 계수만 인용)**: 로그(1인당GDP)는 LCE/GDP 단순회귀에서 0.384(p<0.01)로 유의하나, 규제준비도 등 통제변수 추가 시 유의성 상실. AI 규제준비도는 LCE/GDP의 핵심 예측변수(양의 방향, p<0.01)이자 ACI 수준의 핵심 예측변수(음의 방향, 즉 규제준비도 높을수록 집중도 낮음, p<0.01). ACI 수준 회귀에서 로그(1인당GDP) 계수는 음(-)이고 유의(p<0.01) — 부국일수록 AI이득이 더 고르게 분포. 서비스업 부가가치 비중이 클수록 LCE/GDP가 큼. 소득불평등(지니계수)이 높을수록, 인터넷이용률이 높을수록 ACI가 높음(집중 심화). ΔACI(집중도 변화 방향) 회귀에서는 소득·규제준비도가 유의하지 않은 반면, 영어 공용어 여부가 유의(음의 방향, ACI 하락 가속)했으며 미국을 제외해도 계수(-0.004)가 10%수준에서 유의해 결과가 미국 주도가 아님을 확인(각주23).
- **확장표본(115개국, 표 6)**: R5 LCE 3.0조달러(GDP의 3.2%). 회귀 결과의 방향·유의성은 86개국 기준표본과 동일하게 유지.
- **기업용 API 사용 별도 추정**: R5 API 표본 적용 시 Anthropic API만으로도 연간 약 1.14조달러의 잠재 LCE(수익 기반 역산, 각주24) — 본 논문의 모든 공식 추정치에서는 제외됨. API 트래픽은 Computer & Math가 약 51%를 차지해, 소비자용(Claude.ai) 데이터만 사용한 본 연구의 ACI는 실제 집중도의 하한(lower bound)일 가능성.

## Limitations and Future Work
- LCE는 부분균형(partial-equilibrium) 지표로, 절감된 시간을 현재 임금으로 가치평가할 뿐 고용대체·임금압축·과업재배치를 반영하지 않음 — 절감시간의 화폐가치이지 그 시간이 실제로 어떻게 재배분되는지는 측정하지 않음(4절).
- 절감시간(h_t)은 실험적으로 측정된 것이 아니라 Claude 자신이 추정한 값(A2 가정) — 다만 ACI는 절감시간의 상대적 분포에만 의존하므로 이 가정에 강건함(부록 표 A2).
- 데이터가 Claude.ai 웹 소비자 대화만 포함하고 API 기반 기업사용 및 타 플랫폼(ChatGPT·Gemini·Copilot)은 제외 — 각 웨이브는 1주일만 관측해 장기 패턴을 대표하지 못할 수 있으며, ACI는 실제 집중도를 과소추정할 가능성.
- LCE는 편익 측면만 측정 — 인프라 투자·에너지소비·구독/사용료 등 AI의 비용을 차감하지 않아 완전한 후생 평가에는 미달, 비용 측면은 향후 연구 과제로 제시(4절).

## Related Work
- [[felten-2021-occupational-industry-and-geographic-exposure]] — 잠재적 노출도 지수 접근의 대표 선행연구로, 본 연구는 노출(가능성) 대신 실제 사용을 관측한다는 점에서 차별화를 명시.
- [[eloundou-2023-gpts-are-gpts-an-early]] — LLM이 과업완료시간을 50% 이상 단축할 수 있는 과업 비중을 추정한 노출지수 선행연구로 본 연구가 비교·확장하는 대상.
- [[massenkoff-2026-labor-market-impacts-of-ai]] — 동일한 Anthropic Economic Index 실사용 데이터를 이용해 이론적 노출등급(Eloundou β)과 결합한 "observed exposure" 지수를 구축한 병행 연구. 두 연구 모두 이론적 잠재력과 실제 사용 간 괴리를 핵심 발견으로 제시.
- [[bick-2026-mind-the-gap-ai-adoption]] — 미국·유럽 근로자 서베이 기반 실제 AI 채택률 측정 연구로, 본 연구의 "실사용 관측" 접근과 같은 방향성을 공유.
- [[appel-2026-economic-primitives]] — 본 연구가 이용하는 Anthropic Economic Index 웨이브 중 하나(V4)로, 경제원시지표(과업복잡성·숙련·자율성·성공률)를 도입한 병행 시리즈 보고서.

## Glossary
- **노동비용등가(Labor Cost Equivalent, LCE)**: AI가 절감한 시간을 해당 직업의 자국 임금으로 환산한 화폐가치. GDP 영향의 직접적 추정치가 아니라 "현재 AI 사용이 함의하는 생산성 이득의 지표적(indicative) 측정치"로 해석해야 함(2.3절).
- **AI집중지수(AI Concentration Index, ACI)**: 보건경제학의 concentration index를 응용해 AI 시간절감이 고임금/저임금 직업 중 어디에 편중되는지를 나타내는 지표(-1~+1). 지니계수와 유사하게 분포를 한 숫자로 요약하되, 소득이 아니라 임금순위 대비 AI 이득의 분포를 측정(3.2절).
- **AI 집중곡선(AI concentration curve)**: 로렌츠곡선을 응용해, 직업군을 임금순으로 배열한 뒤 누적 고용비중(x축) 대비 누적 AI절감시간비중(y축)을 나타낸 곡선. 45도선 아래로 처질수록 고임금 직업 편중이 심함(3.2절).
- **외연적 마진(extensive margin) / 내포적 마진(intensive margin)**: LCE 증가를 로그분해했을 때, 전자는 AI 대화 건수 증가, 후자는 대화당 평균가치(임금구성) 변화에서 기인하는 부분(3.1절, 각주20).
- **AI 규제준비도(AI regulatory readiness)**: IMF AI Preparedness Index(Cazzaniga et al. 2024)의 규제 하위지수. 디지털인프라 등 다른 하위지수는 소득과 공선성이 높아 회귀에 별도 포함하지 않음(2.1절).
