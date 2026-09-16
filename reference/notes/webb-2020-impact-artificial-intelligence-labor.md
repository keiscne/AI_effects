---
title: "The Impact of Artificial Intelligence on the Labor Market"
authors: Michael Webb
institution: "Stanford University"
year: 2020
doi: ""
category: [labor_economics]
source_tier: 1
pdf_path: papers/local/webb-2020-impact-artificial-intelligence-labor.pdf
pdf_filename: webb-2020-impact-artificial-intelligence-labor.pdf
verified_date: 2026-09-06
datasets_used: []
---

## One-line Summary
특허 텍스트와 O*NET 직무기술 간의 동사-명사 조합 중복도를 이용해 어떤 기술이든 적용 가능한 객관적 직업별 기술노출 측정법을 개발하고, 이를 두 역사적 사례(소프트웨어·산업용로봇)와 인공지능에 각각 적용해 1980~2010년 노출도-고용/임금 변화의 관계를 실증한 뒤, 이 관계가 지속된다는 가정 하에 AI가 90:10 임금불평등은 완화하되 상위 1%에는 영향을 주지 않을 것으로 추정한다.

## Document Information
- **유형**: Stanford University Job Market Paper (working paper)
- **저자**: Michael Webb(Stanford University)
- **발행**: 2020년 1월
- **최신본 링크**: https://web.stanford.edu/~mww/webb_jmp.pdf (원문 각주)
- **JEL 코드**: J23, J24, O33
- **언어**: 영어

## Key Contributions
1. 특허 제목 텍스트와 O*NET 직무기술 텍스트에서 동사-명사 쌍을 추출·매칭해 어떤 기술에도 객관적·재현가능하게 적용할 수 있는 "노출(exposure)" 측정법을 최초로 제시(기존 노출측정치는 경제학자의 주관적 판단에 의존하는 "ad hoc" 방식이라고 비판).
2. Acemoglu and Restrepo(2018)의 과업기반 모형에 직업(occupation) 단위를 추가한 정태 모형으로, 과업수준 자동화가 직업수요에 미치는 순효과가 이론적으로 모호함(전치효과 vs 생산성효과)을 보임.
3. 동일한 방법론을 소프트웨어·산업용로봇·AI라는 세 개의 서로 다른 기술 사례에 일관되게 적용해, 각 기술이 서로 다른 유형의 직업·인구집단에 영향을 미침을 실증적으로 대조.
4. AI 노출도와 임금변화 간의 관계가 소프트웨어·로봇과 동일한 부호·선형관계를 유지한다는 가정 하에, AI가 90:10 임금비율은 축소하되 99:90 비율은 확대할 것이라는 불평등 시나리오를 최초로 정량 제시.

## Methodology and Data
- **특허 데이터**: Google Patents Public Data(IFI CLAIMS Patent Services 제공, Google BigQuery로 접근). 특허의 title·abstract·CPC 코드만 사용, 각 특허패밀리 중 최초 출원된 공개문서로 제한.
- **직업 데이터**: O*NET 데이터베이스(미국 노동부 산하 기관 제작, 964개 직업). 각 직업의 과업(task)이 자연어로 기술되어 있으며, 중요도(importance)·빈도(frequency) 점수를 가중치로 사용.
- **고용/임금 데이터**: IPUMS 제공 미국 Census 1960-2000·ACS 2000-2018 개인수준 마이크로데이터, 18-65세 취업자로 제한. occ1990dd 직업분류(Dorn 2009, Deming 2017 확장)와 IPUMS ind1990 산업분류 사용.
- **노출 측정 절차**: (1) 특허 제목에서 dependency parsing(Honnibal and Johnson 2015, 표준 벤치마크 정확도 91.85%)으로 동사-직접목적어 쌍 추출 후 표제어화(lemmatize); (2) WordNet(Miller 1995) 개념위계로 명사를 레벨3 수준에서 그룹화; (3) O*NET 과업 기술문에서도 동일 방식으로 동사-명사 쌍 추출; (4) 각 직업의 노출점수 = Σ_k[w_k,i·Σ_c∈Sk rf^t_c] / Σ_k[w_k,i·|{c: c∈Sk}|], 여기서 w_k,i는 과업 k의 직업 i 내 가중치(O*NET 빈도·중요도·관련성 평균).
- **로봇 특허 선정**: 제목·초록에 "robot" 또는 "manipulat" 포함, CPC 코드 A61(의료)·B01(화학공정) 제외. 저자와 RA가 수작업으로 만든 검증셋(양성 50건·음성 50건)에서 F1 점수 최고인 기준 채택.
- **소프트웨어 특허 선정**: Bessen and Hunt(2007)의 기존 표준정의 사용(제목/초록에 "software"·"computer"·"program" 중 하나 포함, "chip"·"semiconductor"·"bus"·"circuity"·"circuitry" 미포함; 재현율 78%·오탐율 16%).
- **AI 특허 선정**: "supervised learning", "reinforcement learning", "neural network", "deep learning" 키워드. AI 정의는 지도학습(supervised learning)과 강화학습(reinforcement learning) 알고리즘으로 한정.
- **고용/임금 회귀식**: Δy_o,i,t = α_i + βExp_o + γZ_o + ε_o,i,t (직업-산업-연도 셀 단위, 산업고정효과, 오프쇼어링가능성(Firpo-Fortin-Lemieux 2011/Autor-Dorn 2013)·교육수준 3분위·평균임금(2차항) 통제). 고용변화는 DHS(arc percentage change, Davis-Haltiwanger-Schuh 1996) 사용, 임금변화는 전일제-연중근무자 실질주급의 로그차분. 노출점수는 고용가중 백분위수로 변환. 산업표준오차는 산업 단위 클러스터.

## Key Results
- **로봇 사례**: 최다노출 직업(지게차 운전자, 크레인 조작기술자, 엘리베이터 설치·수리공 등)은 저학력·저임금·20대 남성에 집중. 노출도 25→75 백분위 이동 시 산업내 고용비중 9~18%↓, 임금 8~14%↓(표4·5, 제조업 표본 N=6,708/14,065).
- **소프트웨어 사례**: 최다노출 직업(방송장비조작원, 상하수처리장 조작원, 주차장 관리원 등)은 중간임금 직업에 집중(양극화 문헌과 일치), 노출도 25→75 백분위 이동 시 고용비중 7~11%↓, 임금 2~6%↓(표8·9, 전산업 N=18,975/36,070).
- **AI 사례**: 최다노출 직업(임상검사기술자, 화학공학기술자, 검안사, 발전소운전원 등)은 로봇·소프트웨어와 반대로 고학력(석사 이상 최고)·고임금(90백분위 부근 정점)·고령층에 집중. 법률직 세부사례: 변호사보다 paralegal·행정법판사가 더 고노출; 의료직 세부사례: 의사·간호사보다 임상검사기술자·검안사·병리학자가 더 고노출.
- **불평등 시나리오(강한 가정 하)**: 소프트웨어의 추정 임금탄력성을 AI에 적용 시 90:10 임금비율 4% 감소, 로봇의 탄력성 적용 시 9% 감소. 반면 99:90 비율은 노출계수가 커질수록 소폭 상승 — AI가 중간 분포는 압축하되 최상위 불평등은 확대할 가능성.
- **성별 격차**: 세 기술 모두에서 남성 직업이 여성 직업보다 더 고노출(로봇·소프트웨어·AI 공통 패턴) — 여성이 상대적으로 대인관계 업무에 집중된 직업에 종사하는 경향과 관련.
- **루틴성 지표와의 비교(부록 D)**: 소프트웨어 노출점수는 Autor-Levy-Murnane(2003)/Acemoglu-Autor(2011)의 루틴수동(routine manual) 점수와 가장 강하게 양의 상관, 비루틴인지(non-routine cognitive) 점수와는 음의 상관 — 독립적으로 동일한 정성적 결론을 재현. AI 노출점수는 비루틴인지-분석(non-routine cognitive analytic) 점수와 압도적으로 높은 양의 상관을 보여 소프트웨어와 질적으로 다름을 확인.

## Limitations and Future Work
저자가 명시(6.6절, 7절):
1. 노출점수-수요변화 간 관계(구조 파라미터)가 시간에 걸쳐 일정하다는 가정에 의존 — 과거 두 사례에서는 성립했으나 미래에도 성립한다는 보장은 없음.
2. 최상위 소득자의 소득포착 방식 변화(Smith et al. 2019), 자본소유자에 대한 AI의 편익(Freeman 2015)을 반영하지 못해 99/90 불평등 증가폭을 과소추정할 가능성.
3. 순수 노동증대형(labor-augmenting) 기술변화나 신규과업 창출 등 과업대체 이외의 채널을 통한 영향은 배제하지 못함 — 다만 이 채널의 효과가 대체효과의 분포와 체계적으로 상관될 선험적 이유는 없다고 판단.
4. AI 기술의 발전·확산 시점이 초기 단계이므로 특허에 기술된 응용만을 반영한 결과이며, 역사적으로 신기술의 노동시장 영향이 온전히 나타나기까지 최대 30년이 걸린 사례(Jovanovic and Rousseau 2005)에 비추어 시차의 불확실성이 크다고 명시.
5. 개인수준 패널데이터(종단자료) 부재로 직업수준 결과가 개별 근로자에게 미치는 영향(임금손실 vs 이직)을 직접 규명하지 못함 — Edin et al.(2019)의 스웨덴 행정자료를 방증으로 제시하되, 미국 종단자료 분석을 향후 과제로 제시.

## Related Work
- [[acemoglu-2019-automation-and-new-tasks-how]] — 본 논문의 정태모형이 직접 확장하는 Acemoglu and Restrepo(2018)의 과업기반 자동화 모형(전치효과·생산성효과의 원형).
- [[eloundou-2023-gpts-are-gpts-an-early]] — 본 논문의 특허텍스트 기반 노출측정치를 5개 기존 노출측정치 중 하나로 비교 회귀분석에 사용한 후속 연구.
- [[felten-2021-occupational-industry-and-geographic-exposure]] — 본 논문과 유사한 시기에 별도 방법론(mTurk 응용-능력 연계)으로 직업별 AI 노출지수를 구축한 병행 연구.
- [[han-2023-ai-and-labor-market-change]] — 본 논문의 특허기반 노출지수를 KSCO(한국표준직업분류)로 변환해 한국 노동시장에 직접 적용한 후속 연구.

## Glossary
- **노출(Exposure)**: 특정 기술을 설명하는 특허 제목의 텍스트와 직업의 과업기술 텍스트 간 동사-명사 조합의 중복 정도를 측정한 지표. 값이 높을수록 해당 기술의 특허활동이 그 직업의 과업을 겨냥하고 있음을 의미.
- **DHS 변화(DHS change)**: Davis, Haltiwanger, and Schuh(1996)가 제안한 대칭적 성장률 측정치(arc percentage change). 두 값의 차이를 평균으로 나눈 값으로, -2~2 범위에 제한되며 -2·2는 각각 진입·퇴출을 의미.
- **동사-명사 쌍(verb-noun pair)**: dependency parsing으로 문장에서 추출한 동사와 그 직접목적어(명사)의 조합. 특허 제목과 직업 과업기술 양쪽에서 추출해 두 텍스트를 비교 가능하게 만드는 매개 단위.
