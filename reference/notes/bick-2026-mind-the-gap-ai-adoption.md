---
title: "Mind the Gap: AI Adoption in Europe and the U.S."
authors: Alexander Bick, Adam Blandin, David J. Deming, Nicola Fuchs-Schündeln, Jonas Jessen
institution: ""
year: 2026
doi: ""
category: [labor_economics]
source_tier: 1
pdf_path: papers/local/bick-2026-mind-the-gap-ai-adoption.pdf
pdf_filename: bick-2026-mind-the-gap-ai-adoption.pdf
verified_date: 2026-06-27
datasets_used: []
---

## One-line Summary

미국·유럽 7개국 신규 근로자 서베이(2025–2026)와 EU-ICT-Firm/BTOS 기업 서베이를 결합해 미국·유럽 간 AI 도입률 격차를 측정하고, 이 격차의 절반 이상이 인구·기업 구성 차이로, 거의 전부가 기업의 AI 사용 장려(encouragement) 차이를 포함하면 통계적으로 설명됨을 보이며, 산업별 AI 도입률이 최근 생산성 성장과 양의 상관관계를 가짐(인과관계는 입증하지 않음)을 보인다.

## Document Information

- **저널/발표**: NBER Working Paper No. 34995 (2026년 3월); 2026년 Spring Brookings Papers on Economic Activity(BPEA) 발표 예정
- **저자**: Alexander Bick (Federal Reserve Bank of St. Louis), Adam Blandin (Vanderbilt University), David J. Deming (Harvard Kennedy School, NBER), Nicola Fuchs-Schündeln (Goethe University Frankfurt), Jonas Jessen (Berlin Social Science Center, WZB)

## Key Contributions

1. **국제 비교 가능 근로자 서베이 신규 구축**: 미국 RPS(Real-Time Population Survey)를 국제화하여 미국·독일·영국·프랑스·이탈리아·스웨덴·네덜란드 7개국에서 동시에 2025년 5–6월(국가당 약 5,000명), 2026년 1–2월(국가당 약 3,000명) 두 차례 서베이를 시행했다(총 N=55,415). CPS와 동일한 문구로 고용상태를 측정한 뒤 생성형 AI 사용 여부·시간·용도를 질문한다.
2. **국가간 AI 도입률 격차 문서화**: 2026년 기준 미국 근로자의 43.0%가 업무에 생성형 AI를 사용하는 반면 유럽 6개국은 25.6%(이탈리아)–36.3%(영국)로 격차가 존재(Figure 2). 업무시간 중 AI 사용 비중으로 보면 격차가 더 커서(미국 5.2% vs 유럽 1.5–2.8%), 이는 미국 근로자가 AI를 더 집약적으로 사용하기 때문이다(Figure 3).
3. **기업 서베이 결합 분석**: EU-ICT-Firm 서베이(32개국, 기업 10인 이상)와 미국 BTOS를 결합해, 2025년 기준 "생산 목적" AI 사용 기업 비율이 미국 7%, EU 평균 4%임을 보인다. "전체 업무 목적" AI 사용 비율은 생산 목적 대비 평균 5배 높으며, 이 관계를 이용해 미국의 전체 목적 AI 도입률을 34%로 투영(projection)한다(Figure 5).
4. **Oaxaca-Blinder 분해**: 미국-유럽 평균 도입률 격차(10.9%p)의 55%가 인구·산업·직종·기업규모 구성 차이로 설명되며(Figure 10), 이 중 산업·직종·기업규모 구성이 인구통계(연령·교육·성별)보다 더 중요(67% vs 33%). 기업의 AI 사용 장려(encouragement) 변수를 추가하면 격차의 80%가 장려 변수 단독으로, 6개국 중 5개국에서 95% 이상이 전체 변수로 설명됨(Figure 14, 15).
5. **경영관행과 AI 도입의 연결**: 국가 수준에서 World Management Survey(WMS) 경영점수와 AI 도입률의 상관계수는 생산목적 기준 0.83, 전체목적 기준 0.81(Figure 11). 근로자 수준에서 구축한 인사관리 지수(성과보상·승진·저성과자 조치 3문항) 1표준편차 증가가 AI 도입률 9.6%p 증가와 연관되나, AI 사용 장려·도구 제공을 통제하면 이 관계가 사라져 경영관행이 장려·도구제공을 통해 작동함을 시사(Figure 13, 14a).
6. **시간절감 및 생산성과의 거시적 연결**: 근로자 자기보고 시간절감 추정치(주당 업무시간의 5.8%, AI 사용자 기준)가 기존 실험 문헌의 추정치 범위(5–96%, 평균 31%)와 대체로 부합. 산업-국가 수준 패널회귀에서 2015–2019년 placebo 기간에는 AI 도입률 계수가 무의미하나(0.025, p=0.481), 2019–2024년(0.100, p=0.025)과 2022–2024년(0.259, p=0.014)에는 양의 유의한 계수를 보임(Table 1). 고용변화와의 연관성은 어떤 기간에서도 유의하지 않음(Table 2).

## Methodology and Data

이 논문은 두 가지 신규/기존 서베이 자료와 회귀 분석을 결합한 실증 연구다(전체 읽기로 확인).

- **국제 근로자 서베이(자체 구축)**: Bilendi 패널을 이용해 미국+유럽 6개국에서 2025년 5–6월, 2026년 1–2월 두 차례 시행. 표본은 18–67세(프랑스는 63세, 정년 기준) "지난주 취업·근무" 인구로, 성·연령·교육·소득·지역 인구 비례에 맞춰 표적화하고 Deming and Stephan(1940) raking 알고리즘으로 사후 가중치 부여. 미국 ChatGPT 도입률은 기존 RPS 추정치와 부합함을 확인(Bick et al. 2026 인용).
- **EU-ICT Household survey(EU-ICT-HH)**: Eurostat이 2002년부터 매년 시행하는 ICT 사용 서베이, 2025년에 생성형 AI 문항 3개 추가.
- **EU-ICT Firm survey(EU-ICT-Firm)**: Eurostat의 기업 ICT 사용 서베이(직원 10인 이상 기업, 2025년 기준 157,000개 기업 응답), 2021년부터 AI 모듈, 8개 AI 기술 카테고리 질문.
- **US BTOS(Business Trends and Outlook Survey)**: 미국 Census의 격주 기업 서베이(표본틀 약 120만 비농업 사업체), 2023년 9월부터 "생산 목적" AI 사용 질문, 2025년 11월부터 "전체 업무 기능" 질문으로 확대.
- **World Management Survey(WMS)** 및 **UK Management and Expectations Survey(MES)**: 경영관행 점수와 AI 도입률의 상관관계 분석에 사용.
- **생산성·고용 자료**: 유럽 29개국(EU 27개국+노르웨이+세르비아)의 1자리 NACE 산업별 생산성(노동자당 산출) 및 고용 자료에 EU-ICT-Firm 도입률을 연결한 국가×산업 패널, 미국은 산업별 생성형 AI 도입률(자체 서베이)과 2025년 3분기까지의 산업 생산성·고용 자료를 연결.

## Key Results

- **도입률 분해(Oaxaca-Blinder, Figure 10)**: 미국-유럽 평균 격차 10.9%p 중 인구·산업·직종·기업규모 구성으로 6.1%p(55%) 설명. 국가별로는 스웨덴 100%(설명되지 않는 잔차 거의 0), 영국은 가장 낮은 설명력(잔차 −7.3%p).
- **고용주 장려가 핵심 매개변수(Figure 14a)**: AI 도구·교육을 받지 않은 근로자 중 고용주 장려를 받은 경우 47%가 AI를 사용한 반면, 장려받지 않은 경우 10%만 사용. 도구 제공 단독으로는 21% vs 10%. 교육(training)은 장려·도구제공을 통제하면 추가 설명력이 없음.
- **국가별 R² 비교(Figure 16)**: 인구통계만으로는 국가별 조정 R²가 9–14%, 직종·산업·기업규모 추가시 16–19%, 고용주 장려까지 추가하면 42–47%로 크게 상승.
- **생산성 회귀(Table 1)**: 2019–2024년 유럽 기준 회귀계수 0.048–0.100(specification에 따라), 이는 AI 도입률 10%p 증가가 해당 기간 누적 생산성성장 2.40–5.00%p 증가와 연관됨을 의미. 2022–2024년에는 계수 0.108–0.259(누적 2.16–5.18%p). 미국 산업수준 분석(2019–2025년 3분기, 추세 대비)에서는 AI 도입률 10%p 증가가 누적 생산성성장 약 3.7%p와 연관(ρ=0.49), 2022–2025년에는 2.9%p(ρ=0.46) — 유럽 추정치와 유사한 크기.
- **고용 회귀(Table 2)**: 2015–2019년 placebo 기간 계수는 specification에 따라 유의하거나 무의미하게 혼재하나, 2019–2025년(−0.170~−0.263, 모두 비유의)·2022–2025년(−0.044~−0.130, 모두 비유의) 모두 통계적으로 유의한 고용효과를 발견하지 못함. 미국 산업수준 분석에서도 AI 도입률과 고용성장 간 명확한 관계 없음(ρ=0.05, −0.10).
- **시간절감의 실험적 추정치와의 비교**: 풀링된 표본에서 AI 사용자의 평균 시간절감은 주당 근무시간의 5.8%로, 사용 시간당 0.6시간의 절감(즉 AI 사용시간의 60%에 해당하는 추가 작업시간 절감)에 해당하며, 이는 Peng et al.(2023, 55%), Noy and Zhang(2023, 18%), Cui et al.(2026, 26%) 등 기존 실험 추정치 범위(5–96%, 평균 31%)와 정합적이다.

## Limitations and Future Work

- 저자들은 본 논문의 생산성·고용 회귀가 인과관계를 입증하지 않음을 명시적으로 반복 강조한다("we do not establish causality", Abstract, Section 5.2 결론부): 산업·국가 고정효과를 포함하지만 AI 도입과 상관된 누락변수 가능성을 배제하지 못하며, AI가 광범위하게 도입된 기간이 매우 짧아 표본기간이 제한적이라는 점도 한계로 명시한다.
- 자기보고 시간절감 측정치는 측정오차에 취약하고 AI 접근에 대한 외생적 변동에서 도출된 것이 아니라는 점을 저자들이 직접 인정한다(Section 5.1.2).
- BTOS의 2025년 11월 이전 "생산목적" 한정 질문이 전체 AI 도입을 과소측정했을 가능성을 저자들이 제기하며, 11월 이후 확대된 질문도 EU-ICT-Firm 대비 여전히 과소측정할 수 있다고 신중하게 평가한다(Section 3.2).
- 향후 데이터 수집 우선순위로 BTOS·EU-ICT-Firm의 조사방법 조화(harmonization), 미국 CPS에 AI 모듈 별도 도입, 경영관행·AI 장려 변수의 정부서베이 반영을 제안한다(Conclusion).

## Related Work

- Bick, Blandin, and Deming(2026) "The Rapid Adoption of Generative AI": 본 논문이 사용하는 RPS AI 모듈과 인지(awareness) 질문순서 편향 보정방법론의 직접적 토대.
- Bloom, Sadun, and Van Reenen(2012) "Americans do IT better": 미국 기업의 경영관행 우위가 ICT 투자수익률을 높인다는 선행연구로, 본 논문이 AI 도입에 동일 논리를 적용하는 근거.
- Acemoglu, Autor, Hazell, and Restrepo(2022) "AI and Jobs: Evidence from Online Vacancies"([[acemoglu-2022-artificial-intelligence-and-jobs-evidence]]): 채용공고 기반 AI 노출 측정의 선행연구로, 직접 인용되지는 않으나 동일한 AI 노동시장 영향 측정 의제를 공유.
- Humlum and Vestergaard(2025a) "Large Language Models, Small Labor Market Effects": 덴마크 자료로 AI 노출 직종의 고용·소득에 의미있는 영향이 없음을 보인 선행연구 — 본 논문의 고용 무관련성 결과와 일치.
- Massenkoff and McCrory(2026)([[massenkoff-2026-labor-market-impacts-of-ai]]): 관측된 AI 노출(observed exposure)과 실제 사용 데이터를 결합한 측정치 — 본 논문과 마찬가지로 노동시장 영향 측정에 있어 자기보고·관측 기반 자료의 결합을 시도.

## Glossary

- **AI 도입률(AI adoption rate)**: 본 논문에서 근로자 기준은 "생성형 AI를 업무에 사용하는지" 여부, 기업 기준은 EU-ICT-Firm의 8개(또는 BTOS의 1–18개) AI 기술 카테고리 중 하나 이상을 사용하는지 여부로 측정.
- **Oaxaca-Blinder 분해**: 두 집단(국가) 간 결과변수(AI 도입률) 격차를 관측 가능한 구성변수의 차이(설명된 부분)와 동일 구성에서의 계수차이(설명되지 않는 부분)로 분해하는 방법(Blinder 1973; Oaxaca 1973).
- **고용주 장려(employer encouragement)**: 근로자가 고용주로부터 AI 사용을 독려받았는지를 측정하는 본 논문의 자체 서베이 변수로, AI 도구 제공·교육과 구분되는 별도 항목.
- **EU-ICT-Firm / EU-ICT-HH**: Eurostat이 매년 시행하는 기업/가구 ICT(정보통신기술) 사용 서베이의 약칭.
- **BTOS(Business Trends and Outlook Survey)**: 미국 Census Bureau가 격주로 시행하는 기업 동향 서베이.
