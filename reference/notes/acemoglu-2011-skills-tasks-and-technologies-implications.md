---
title: "Skills, Tasks and Technologies: Implications for Employment and Earnings"
authors: Daron Acemoglu, David Autor
institution: ""
year: 2011
doi: "10.1016/S0169-7218(11)02410-5"
category: [labor_economics]
source_tier: 1
pdf_path: papers/local/acemoglu-2011-skills-tasks-and-technologies-implications.pdf
pdf_filename: acemoglu-2011-skills-tasks-and-technologies-implications.pdf
verified_date: 2026-06-27
datasets_used: []
---

## One-line Summary

미국·유럽 노동시장의 임금·고용 양극화를 설명하기 위해 숙련-과업 일대일 대응을 가정하는 "정통모형(canonical model)"의 한계를 지적하고, 비교우위에 따라 숙련이 과업에 내생적으로 배분되는 3-숙련·연속 과업 리카도(Ricardian) 모형을 제시하여 자동화·오프쇼어링·기술방향성을 통합적으로 분석한다.

## Document Information

- **저널/발표**: *Handbook of Labor Economics*, Volume 4B, Chapter 12 (Elsevier, 2011), pp. 1043–1171. DOI: 10.1016/S0169-7218(11)02410-5
- **저자**: Daron Acemoglu (MIT, NBER, CIFAR), David Autor (MIT, NBER, IZA)

## Key Contributions

1. **정통모형(canonical model)의 실증적 한계 진단**: 고숙련/저숙련 2요소 CES 생산함수에 기반한 정통모형은 (1) 저숙련(특히 저숙련 남성) 실질임금의 장기 하락, (2) 시기별로 다른 임금분포 부위에서 나타나는 비단조적 변화("양극화"), (3) 중숙련 직종이 줄고 고숙련·저숙련 직종이 동시에 늘어나는 고용 양극화, (4) 직종이 임금을 설명하는 힘의 증가, (5) 자본이 특정 직무를 직접 대체하는 기술의 등장을 설명하지 못한다고 지적한다(Section 2–3).
2. **3-숙련·연속 과업 리카도 모형**: [0,1] 연속체로 표현된 과업에 저(L)·중(M)·고(H) 숙련 노동을 배분하는 환경을 구축한다. 비교우위 가정(Assumption 1: α_L(i)/α_M(i), α_M(i)/α_H(i)가 i에 대해 엄격히 감소)에 따라 균형에서 두 임계과업 I_L, I_H가 존재하여 i<I_L은 저숙련, I_L<i<I_H는 중숙련, i>I_H는 고숙련이 수행한다(Lemma 1, Proposition 1).
3. **상대임금의 닫힌 형태 해**: 균형 상대임금은 상대공급과 임계과업만의 함수로 표현된다: w_H/w_M=[(1−I_H)/(I_H−I_L)]·(H/M)^(−1), w_M/w_L=[(I_H−I_L)/I_L]·(M/L)^(−1) (식 26, 27). 정통모형은 이 틀에서 비교우위 스케줄을 특정 형태로 고정한 특수사례로 포섭된다(Section 4.3).
4. **기술 대체(task-replacing technology)와 오프쇼어링의 통합 분석**: 일정 구간 [I′,I″]⊂[I_L,I_H]의 과업이 기계로 대체되면(Proposition 3, 4) 또는 해외로 오프쇼어링되면(Proposition 6) 저·고숙련 과업범위가 확장되고 중숙련 상대임금이 항상 하락하는 한편, 고숙련 대 저숙련 상대임금의 방향은 |β′_L(I_L)I_L|와 |β′_H(I_H)(1−I_H)|의 대소관계에 의존한다.
5. **내생적 기술 방향성(directed technical change)**: 비교우위 스케줄 자체가 모수 θ에 의존한다고 일반화하면(Acemoglu 2007의 틀 적용), 특정 요소의 공급 증가는 그 요소를 약하게(weakly) 편향하는 기술변화를 유도하며(Proposition 7), 총생산가능집합이 해당 요소와 θ에서 국소적으로 비凸(nonconvex)일 때만 강하게(strongly) 편향되어 그 요소의 가격을 실제로 높인다(Proposition 8).
6. **예비적 실증 접근**: 1959년 기준 인구통계집단(성·연령·교육·지역)의 초기 직종 분포(추상/반복/서비스 과업 비중)를 비교우위의 대리지표로 사용해, 1959–2007년 임금변화를 이 초기 분포에 회귀하는 패널 분석을 제시한다(Section 5, Table 10).

## Methodology and Data

이 장(chapter)은 이론모형 제시와 예비적 실증 분석을 결합한 핸드북 챕터로, 다음 데이터를 사용한다(전체 읽기로 확인).

- **March CPS** (1963–2008년 소득연도): 정규직(주 35시간↑, 연 40주↑) 실질 주급 분포, 학력·연령·성별 구성보정 임금.
- **May/ORG CPS** (1973–2009): 시간당 임금(모든 근로자), 직종·산업별 임금 분해.
- **Census/American Community Survey** (1960, 1970, 1980, 1990, 2000 IPUMS 5%, 2008 ACS): 직종 구조 변화 분석(318/326개 일관 직종 코드).
- **DOT(Dictionary of Occupational Titles)** 및 **O\*NET** 과업측정치: Autor, Levy, Murnane(2003)이 구축한 추상적(abstract)·반복적(routine)·비반복 수작업(non-routine manual) 3대 과업지표, 본 장에서 새로 구축한 O\*NET 기반 5개 세분 지표(비반복 인지-분석/대인, 반복 인지/수작업, 비반복 수작업) 및 오프쇼어 가능성(offshorability) 지표.
- **유럽 비교자료**: Eurostat 직종 데이터(1992–2008, 10개 유럽국가), Goos, Manning, Salomons(2009)의 16개 EU국 직종 비중 변화 자료.
- **실증 방법**: shift-share 분해(식 1, Table 6)로 직종 양극화가 산업구성 변화가 아니라 산업 내부 변화 때문임을 확인; 부분 R² 비교(Figure 17, 18)로 학력·직종·과업측정치가 임금 설명력에서 시간에 따라 변화하는 양상을 분석; Oaxaca-Blinder류는 사용하지 않고 표준 OLS 패널 회귀(Table 10)로 1959년 직종 비중과 임금변화의 관계를 추정.

## Key Results

- **대학 프리미엄과 상대공급**: Katz and Murphy(1992) 모형을 1963–1987년 자료로 재현하면 ln ω_t = const + 0.027·t − 0.612·ln(H_t/L_t) (식, Table 8 열1), 함의된 대체탄력성 σ̂≈1.6, 연 2.7%의 숙련수요 증가. 1963–2008년으로 확장하면 σ̂≈2.9로 추정치가 달라지며, 1992년 이후 표본외 예측이 실제 자료에서 체계적으로 벗어난다(Figure 19) — 1992–2008년 관측된 대학 프리미엄 상승 12 log point 대비 모형 예측은 25 log point.
- **임금 양극화**: 1979–1988년에는 직종별 임금변화가 숙련수준에 대해 거의 단조였으나, 1988–2008년에는 U자형(양극화) 패턴으로 전환(Figure 9). 1999–2007년 자료에서는 양극화가 다소 완만해졌다(저자들의 직접 관찰, p.1069).
- **고용 양극화**: 1979년 미국에서 4대 중숙련 직종(판매·사무행정·생산·운영원)이 고용의 57.3%를 차지했으나 2007년 48.6%, 2009년 45.7%로 하락(Section 2.5). Shift-share 분해 결과 1979년 이전에는 산업구성 변화가 직종 변화의 주된 원인이었으나, 1979년 이후에는 산업 내부의 직종 재배치(within-industry shift)가 지배적 요인(Table 6).
- **직종의 임금 설명력 증가**: 남성 기준 직종 더미의 부분 R²는 1979년 약 8%에서 2007년 23%로 상승해 학력 더미(약 23%)와 비슷한 수준에 도달했고, O\*NET 과업측정치의 부분 R²는 2007년 약 24%로 학력·직종 모두를 상회한다(Figure 17, 18).
- **예비 실증(Section 5)**: 1959년 기준 추상과업 비중이 높았던 인구통계집단은 1980년대 이후 상대임금이 상승했고(남성 1979–1989년 계수 0.409, Table 10 열1), 1959년 기준 서비스과업 비중이 높았던 집단은 1980년대에는 음(−0.879~1.007 구간)이었으나 1990년대 이후 양(+1.007, 0.202)으로 전환했다. 반복과업(생략된 기준집단) 절편은 1960~1970년대 강한 양에서 1980년대 이후 음으로 전환했다.

## Limitations and Future Work

- 저자들은 본 장의 모형이 (1) 조직변화(organizational change)와 기술의 상호작용, (2) 노동시장 마찰(서치·단체협약·최저임금 등)의 역할, (3) 노동시장 제도의 국가간 차이, (4) 남녀·인종간 격차의 차별적 진화, (5) 서비스직종 수요 증가의 보몰(Baumol) 효과적 설명을 충분히 다루지 못한다고 명시한다(Section 6, 항목 1–7 나열).
- Section 5의 실증 분석은 "이론에 기반한 실증 접근의 예시"로 제시된 것으로, 저자들 스스로 "이는 단지 예시적 분석(highly preliminary)"이라고 명시한다(p.1153–1156) — 본 장의 핵심 기여는 이론 모형이며 실증 결과는 시사적(suggestive) 수준이다.

## Related Work

- Tinbergen(1974, 1975); Katz and Murphy(1992): 정통모형(canonical model)의 토대 — 본 장이 비판적으로 검토하는 출발점.
- Autor, Levy, and Murnane(2003) "ALM": 반복화(routinization) 가설과 DOT 과업측정치의 직접적 토대.
- Acemoglu and Zilibotti(2001): 본 장의 3-숙련 리카도 모형이 일반화한 2-숙련 특수사례(Section 4.3).
- Acemoglu and Restrepo(2018, 2022): 본 장의 과업기반 틀을 동일 저자(Acemoglu)가 자동화·신규과업 이분법으로 확장한 후속 연구([[acemoglu-2018-the-race-between-man-and]], [[acemoglu-2022-tasks-automation-and-the-rise]]) — wiki/subjects/acemoglu-task-based-automation-and-ai 참조.
- Acemoglu(2007): 본 장 4.8절의 유도된 기술변화(directed technical change) 일반 결과(Proposition 7, 8)의 직접적 근거.
- Costinot and Vogel(forthcoming): 연속 숙련·연속 과업 배정모형으로 본 장의 결과를 일반화하는 관련 연구로 언급.

## Glossary

- **과업(task)**: 재화·서비스를 생산하는 작업 단위. 숙련(skill)과 구분되는 개념으로, 숙련은 노동자가 다양한 과업을 수행할 수 있는 역량의 내생적 배분 대상이다.
- **비교우위 스케줄(comparative advantage schedule, α(i))**: 과업 i에서 각 숙련 유형의 생산성을 나타내는 함수. α_L(i)/α_M(i), α_M(i)/α_H(i)가 i에 대해 감소한다는 가정(Assumption 1)이 모형의 핵심.
- **임계과업(threshold task, I_L, I_H)**: 균형에서 숙련 유형 간 과업 배분이 바뀌는 경계 과업.
- **과업변위/대체 기술(task-replacing technology)**: 특정 과업 구간을 기계가 대체하도록 만드는 기술변화(Section 4.5).
- **반복화 가설(routinization hypothesis)**: ALM(2003)이 제시한, 반복적(routine) 과업이 정보통신기술에 의해 자동화되어 중숙련 직종을 잠식한다는 가설.
- **오프쇼어 가능성(offshorability)**: 대면 상호작용이 필요하지 않아 해외로 이전 가능한 과업의 정도를 나타내는 O\*NET 기반 지표.
