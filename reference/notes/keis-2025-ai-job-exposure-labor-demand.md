---
title: "자동화 및 인공지능 기술 발전에 따른 고용 구조 변화 분석 — 제5장 인공지능 직업 노출도 측정 및 직업 수요 변화 논의"
authors: 노희용, 손녕선, 이학기
institution: 한국고용정보원
year: 2025
doi: ""
category: [labor_economics]
source_tier: 1
pdf_path: papers/local/keis-2025-ai-job-exposure-labor-demand.pdf
pdf_filename: keis-2025-ai-job-exposure-labor-demand.pdf
verified_date: 2026-08-13
datasets_used: []
---

## One-line Summary

O*NET 923개 직업의 과업 텍스트에 8개 오픈소스 LLM을 델파이 전문가 패널로, GPT-4o를 진행촉진자로 활용해 AI 직업 노출도를 측정하고, 이를 한국 온라인 채용공고 데이터와 연계해 노출도가 높은 직업일수록 2020~2025년 채용공고 증가율이 유의하게 낮음을 실증했다.

> 이 문서는 보고서 전체(총 8개 장) 중 제5장만을 대상으로 한다. 나머지 장(1~4장, 6~8장)은 아직 검증·요약되지 않았다.

## Document Information

- 보고서명: 「자동화 및 인공지능 기술 발전에 따른 고용 구조 변화 분석」(기본사업 2025-40)
- 발행: 한국고용정보원, 원장 이창수, 2025년 12월
- ISBN: 979-11-7073-218-1 (93320)
- 전체 저자: 김수현(제1·2·6·8장), 박상현(제2장 공동), 이정아(제3장), 김새봄(제4장), 노희용·손녕선·이학기(제5장), 김수현(제6장), 정순기(제7장)
- 본 문서가 다루는 범위: 제5장 「인공지능 직업 노출도 측정 및 직업 수요 변화 논의」(노희용·손녕선·이학기, pp.125-160)
- 발간사 명시 사항: "본 보고서에 수록된 내용은 연구진의 견해이며, 한국고용정보원의 공식적인 입장이 아님을 함께 밝힙니다."

## Key Contributions

- 단일 LLM에 의존하는 기존 직업별 AI 노출도 측정 방법(Eloundou et al., 2023/2024 등)의 한계(블랙박스성·비재현성·모델별 편향)를 극복하기 위해, 8개 오픈소스 LLM을 전문가로, GPT-4o를 진행촉진자로 하는 단일라운드 델파이 앙상블 방법론을 제안.
- 델파이 패널에 포함할 모델을 사전에 견고성 검정(IQR·CV·MAD 분산지표 + 텍스트 추론 코사인 유사도)으로 선별해, 중국계 모델(Deepseek-R1, QWQ2.5) 등 일관성이 낮은 모델을 최종 패널에서 배제.
- O*NET 기반으로 산출한 AI 노출도를 5단계 하이브리드 크로스워크(문자열 유사도 → 의미 유사도 → 전문가 검토)로 한국 직업명에 매칭하고, KISDI 온라인 채용공고 데이터와 결합한 잡(job)×월(month) 패널을 구축해 직업 단위 채용 수요 변화를 실증.
- 직업 고정효과 없는 패널모형(모형 1·2)에서는 AI 노출도 계수가 스퓨리어스하게 양(+)으로 나타나지만, 2020년 기준 채용공고 수준을 통제하는 장기차분모형(모형 3)에서는 AI 노출도가 채용공고 증가율에 유의한 음(-)의 효과(계수 -2.168***)를 가짐을 규명해, 직업 고정효과 미통제로 인한 편의 문제를 명시적으로 드러냄.

## Methodology and Data

### 분석 프레임워크
- 델파이 방식: Eloundou et al.(2023/2024)과의 비교가능성을 위해 반복형이 아닌 단일라운드 진행촉진자 집계 방식을 채택. LangChain 기반으로 다중 LLM 프롬프팅을 오케스트레이션.
- 후보 8개 LLM(전문가 역할) + GPT-4o(진행촉진자): Deepseek-R1:32b(DeepSeek/중국, 2024.5), Falcon:40b(Technology Innovation Institute/UAE, 2023.5), Hermes3:70b(Nous Research/미국, 2024.4, Llama3:70b 기반), Gemma3:27b(Google DeepMind/미국, 2025.6), Llama3.3:70b(Meta AI/미국, 2024.12), Mistral-small:20b(Mistral AI/프랑스, 2024.9), Phi4:14b(Microsoft/미국, 2025.5), QWQ2.5:32b(Alibaba DAMO/중국, 2024.5).
- 1차 데이터: O*NET 29.3 Task Statements(923개 직업, 직업당 약 20~30개 과업 텍스트). O*NET을 선택한 이유는 지속 갱신되는 신뢰도 높은 자료이며 Felten et al.(2021), Eloundou et al.(2023/2024)과의 벤치마킹 비교가능성 때문.
- 2차 데이터: 정보통신정책연구원(KISDI) ICT 통계포털(itstat.go.kr)의 온라인 채용공고 크롤링/API 자료(2019-09-15~현재, 국내 주요 채용플랫폼 기반 일별 KSIC 산업별·KSCO 직업별 공고 건수 및 비정형 직무 키워드). KISDI는 이를 주간 "온라인 노동지수"(기준: 2020-04-12=100, 격주 갱신)로도 발표하며, Oxford Online Labour Index(OLI)에 대응하는 지표로 국내 코로나19 노동시장 회복력 측정에 활용됨(손녕선 외, 2025 인용).

### 견고성 검정(델파이 패널 모델 선정)
- ChatGPT에 O*NET 데이터셋을 업로드해 923개 직업 중 AI 영향이 높은/낮은 상위 10개씩을 도출(<표 5-3>)하고, Eloundou et al.(2023/2024)·Gmyrek et al.(2023) 결과와 교차 확인해 검정용 직업 4개를 선정: 고노출 — Financial and Investment Analysts, Tax Preparers; 저노출 — Athletes and Sports Competitors, Chefs and Head Cooks.
- 프롬프트 설계(<표 5-4>): temperature=0.1, 직업-과업 쌍마다 모델당 30회 반복 프롬프팅(직업당 과업 약 25개 기준 약 750회/모델/직업). 역할 부여 + few-shot 예시(교사/수업계획 0.4·complementary, 교사/과제채점 0.6·complementary, 교사/학생상담 0.2·neutral, 데이터입력사원/수기입력 0.95·substitution) 사용. 출력 변수: `Degree_of_exposure`(0.0~1.0), `Exposure_reason`, `AI_impact`(complementary/substitution/neutral), `AI_impact_reason`.
- 견고성 지표(<표 5-5>, 텍스트 추론 코사인 유사도): Deepseek-R1:32b 0.2792, Falcon:40b 0.5032, Hermes3:70b 0.6417, Gemma3:27b 0.7300, Llama3.3:70b 0.7946, Mistral-small:20b 0.6164, Phi4:14b 0.5196, QWQ2.5:32b 0.3414. 수치 분산지표(IQR·CV·MAD, [그림 5-5])도 대체로 동일한 순위를 보임.
- 최종 델파이 패널(5개 모델, Falcon·QWQ·Deepseek 제외): Gemma3:27b, Llama3.3:70b, Phi4:14b, Hermes3:70b, Mistral-small:20b. 이 5개 모델을 O*NET 923개 직업 전체의 직업-과업 쌍에 적용.

### 메타평가 및 집계
- GPT-4o가 5개 모델의 점수·근거를 입력받아 <표 5-6> 프롬프트에 따라 최종 점수를 비판적으로 종합. 두 시나리오: S1(AIE_S1, 5개 결과를 종합), S2(AIE_S2, 5개 결과 중 가장 동의하는 하나를 선택).
- 직업 단위 점수는 직업 내 과업 단위 점수의 단순(비가중) 평균. O*NET 과업 빈도·중요도 가중치 적용 여부와 무가중 결과가 유사하고 일부 쌍에서 가중치 결측이 있어 단순평균 채택.

### 한국 적용 - 크로스워크 및 회귀분석
- 5단계 하이브리드 크로스워크로 한국 직업명을 O*NET 직업에 매칭: (1) 노동시장 표준 용어집 기반 영문 번역, (2) 전처리(소문자화·특수문자/불용어(manager/assistant/staff 등) 제거·복수형 단수화), (3) 문자열 유사도(Levenshtein Distance, Jaccard Similarity, 0-100 스케일; ≥90 확정매칭, 80-90 잠재매칭으로 재검토, <80은 의미매칭으로 이관), (4) BERT 임베딩 코사인 유사도 기반 의미매칭(동일 90/80 임계값), (5) 하이브리드 조정 및 전문가 검토(O*NET DWA 과업 설명 교차확인), 1:N 매칭 허용(평균 또는 최댓값 사용). O*NET에 대응 직업이 없는 경우(병역특례, 자원봉사자 등)는 매칭 불가로 제외.
- 패널 구성: 직업(job_id)×월(ym), 2020~2025년, KISDI 채용공고 건수 × AI 노출도(시간불변, 2020년 값을 2025년까지 적용). 2025년 5월은 이상급증(데이터 오류로 판단)으로 제외. 종속변수: ln(월평균 공고 건수 + 1).
- 모형(1): `ln(공고수_it + 1) = α + β·AI노출도_i + γ_t + ε_it` (월 고정효과만 포함, 직업 고정효과는 AI노출도가 시간불변이라 식별불가하므로 미포함; 표준오차는 직업 단위 클러스터링).
- 모형(2): 모형(1)에 2023년 이후 더미와 AI노출도×2023년이후 상호작용항 추가.
- 모형(3): 장기차분 횡단면 회귀, 2020→2025 `Δln(공고수)`를 AI노출도에 회귀(2020년 초기 공고수준 통제).

## Key Results

- AIE_S1(923개 직업) 기술통계: 평균 0.402, 표준편차 0.130, 최소 0.112, 최대 0.775. AIE_S2: 평균 0.416, 표준편차 0.137, 최소 0.110, 최대 0.808. LLM평균: 평균 0.408, 표준편차 0.121. LLM중앙값: 평균 0.416, 표준편차 0.135 (<표 5-7>/<표 5-8>).
- 지표 간 상관계수(<표 5-9>): AIE_S1-AIE_S2 0.990, AIE_S1-LLM평균 0.996, AIE_S1-LLM중앙값 0.989, AIE_S2-LLM평균 0.984, AIE_S2-LLM중앙값 0.986, LLM평균-LLM중앙값 0.988. 직업별 5개 모델 간 평균 표준편차는 0.109.
- 분포: 1사분위 0.307, 3사분위 0.496, 상위 10% 임계값 0.571, 하위 10% 임계값 0.233([그림 5-8]).
- [그림 5-9] 상위 20개 직업(모두 노출도 ≥0.67): Bookkeeping/Accounting/Auditing Clerks(0.78), Word Processors and Typists(0.77), Telemarketers(0.76), Brokerage Clerks(0.74), Insurance Claims and Policy Processing Clerks(0.73), Data Entry Keyers(0.73), Travel Agents(0.72), Medical Records Specialists(0.72), Tellers(0.70), Logistics Analysts(0.70), Precision Agriculture Technicians(0.70), Desktop Publishers(0.69), Telephone Operators(0.69), Switchboard Operators Including Answering Service(0.69), Loan Interviewers and Clerks(0.69), Correspondence Clerks(0.69), Statistical Assistants(0.69), Payroll and Timekeeping Clerks(0.68), Order Clerks(0.67), File Clerks(0.67).
- 하위 20개 직업(모두 노출도 ≤0.16): Terrazzo Workers and Finishers(0.11), Plasterers and Stucco Masons(0.12), Paperhangers(0.13), Drywall and Ceiling Tile Installers(0.13), Embalmers(0.13), Musical Instrument Repairers and Tuners(0.14), Refractory Materials Repairers Except Brickmasons(0.14), Roofers(0.14), Crematory Operators(0.14), Fence Erectors(0.15), Insulation Workers Floor/Ceiling/Wall(0.15), Stonemasons(0.15), Cement Masons and Concrete Finishers(0.15), Tapers(0.16), Dancers(0.16), Floor Layers Except Carpet/Wood/Hard Tiles(0.16), Floor Sanders and Finishers(0.16), Pile Driver Operators(0.16), Automotive Glass Installers and Repairers(0.16), Tree Trimmers and Pruners(0.16).
- <표 5-10> 회귀 결과: 모형(1) AI노출도(mean) 계수 3.771***(s.e. 0.376), 상수항 4.444***(0.199), N=55,580, R²=0.102. 모형(2) AI노출도 3.880***(0.412), 2023이후더미 -0.249*(0.419), AI노출도×2023이후 -0.814(0.262, 비유의), 상수항 4.393***(0.217), N=55,580, R²=0.102. 모형(3, 장기차분) AI노출도 계수 **-2.168***(s.e. 0.479, p<0.01)**, 상수항 1.247***(0.237), N=231, R²=0.078.
- [그림 5-10]/[그림 5-11] 지수화 채용공고 추이(2020년 1월=100, AI노출도 3분위 그룹별): 2020.4→2025.10 순변화율 — 저노출 그룹 +25.9%, 중노출 그룹 +15.7%, 고노출 그룹 -10.9%(유일한 마이너스 성장 그룹).
- <표 5-11> 2025년 평균 공고량 기준 고노출그룹 내 상위 10개 한국 직업(노출도, 공고수): 생산직종사자(.659, 17,133), 제조단순종사자(.563, 11,230), 경영지원사무(.635, 9,847), 무역·운송·자재·구매·생산·품질사무(.659, 9,499), 기계조작원(.563, 6,797), 회계·경리사무(.775, 6,498), 회계담당자(.607, 5,909), 제조(.659, 5,588), 인바운드상담원(.623, 5,447), 온라인마케터(.662, 4,771).
- <표 5-12> 2020→2025 공고증가율(Δln) 기준 고노출그룹 내 상위 10개 직업(노출도, Δln): 컴퓨터시스템(.561, 2.10), 해외영업(.550, 1.93), 인쇄기계·사진현상기조작(.648, 1.84), 매장계산및매표(.561, 1.55), 영업기획(.536, 1.08), 텔레마케터(TM)(.758, 0.93), 미용·여행·숙박·음식 등 개인서비스 및 영업·판매·운송관리직(.559, 0.82), 생산관리(.543, 0.73), 교직원(.658, 0.69), 마케팅(.662, 0.68).
- 공고 감소 폭이 가장 큰 직업군: 콘텐츠·사이트 운영(최대), 웹 프로그래머, 시스템 프로그래머, 기술영업, 캐릭터·애니메이션, 조사·분석·통계, 인바운드 텔레마케터. 텔레마케터는 챗봇/자동응답 대체가 실제 진행 중인 것으로, 웹/시스템 프로그래머는 생성형 AI의 코딩/디버깅/문서화 자동화로 해석.
- 반대로 컴퓨터시스템·해외영업·영업기획·마케팅·대면서비스 등 일부 고노출 직업은 공고가 크게 증가, (i) AI를 도구로 활용하며 인간 전문성 가치가 높아지는 유형(시스템 관리, 디지털 마케팅, 영업기획)과 (ii) 소통·창의성·공감이 필요해 AI 대체가 어려운 유형(해외영업, 고객상담, 서비스, 교육)으로 구분.

## Limitations and Future Work

- O*NET은 미국 직업/과업 텍스트 자료이며 한국 직업 데이터가 아니라는 점을 5장 서두에서 명시적으로 밝힘. 미국 자료를 사용한 이유는 지속 갱신되는 신뢰도와 미국이 AI 개발을 선도해 최신성이 유지되기 때문이며, 향후 연구에서 한국 직업/과업 데이터를 반영해 직접적 정책 적용을 도모할 계획이라고 서술.
- 모형(1)/(2)는 직업 고정효과를 포함하지 않아 AI노출도 계수가 스퓨리어스하게 양(+)으로 나타남(고노출 직업이 원래 공고량이 많았던 데서 비롯된 인위적 결과)을 저자들 스스로 지적, 모형(3)의 2020년 기준 수준 통제 장기차분 결과를 참값에 가까운 해석으로 제시.
- 모형(2)의 AI노출도×2023년이후 상호작용항이 비유의하다는 결과에 대해, AI의 채용수요 증가율 억제 효과가 2023년(생성형 AI 확산 시점) 이후 급증한 것이 아니라 2020년대 초반부터 누적적으로 진행되어 온 것으로 해석.
- Acemoglu & Restrepo(2019/2022)를 이론적 근거로 인용하면서도, Acemoglu et al.(2022)이 순고용·임금효과가 통계적으로 불분명하다고 밝힌 점을 함께 언급하며, 본 장의 2020~2025년 분석이 시의성 있는 구조적 음의 효과를 보여주는 차별점이 있다고 주장.

## Related Work

원문 제2절(선행연구 조사)에서 4가지 방법론 계열을 검토: (1) 전문가 서베이(Arntz/Gregory/Zierahn 2016; Frey & Osborne 2017; Lassébie & Quintini 2022), (2) 과업/능력단위-인지능력 매개(Felten et al. 2018; Tolan et al. 2021), (3) 텍스트마이닝/특허기반(Webb 2020; Koga et al. 2023; 한지우·오삼일 2023 BOK 이슈노트), (4) 직접 LLM 프롬프팅(Eloundou et al. 2023/2024; Gymrek et al. 2023). 다중 LLM 앙상블 선행사례로 Bano & Whittle(2023), Bertolotti & Mari(2025), Nóbrega et al.(2023) 인용.

## Glossary

- **델파이(Delphi) 방법**: 다수 전문가(본 연구에서는 LLM)의 판단을 구조화된 절차로 수집·집계해 합의된 추정치를 도출하는 기법. 본 장은 반복형이 아닌 단일라운드 진행촉진자 집계 방식을 사용.
- **AI 직업 노출도(AI occupational exposure)**: 특정 직업의 과업이 AI 기술로 대체·보완될 수 있는 정도를 0~1 스케일로 나타낸 지수.
- **AIE_S1 / AIE_S2**: 델파이 최종 5개 모델 결과를 GPT-4o가 각각 종합(S1)하거나 가장 동의하는 단일 모델 결과를 선택(S2)해 산출한 두 가지 노출도 지표.
- **substitution / complementary / neutral**: 각 과업에 대해 AI가 인간 노동을 대체하는지(substitution), 보완하는지(complementary), 혹은 영향이 중립적인지(neutral)를 분류한 라벨.
- **온라인 노동지수**: KISDI가 국내 채용공고 크롤링 자료를 바탕으로 산출하는 주간 지수(기준 2020-04-12=100), Oxford Online Labour Index(OLI)에 대응.
