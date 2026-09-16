---
title: "The Anthropic Economic Index report: Uneven geographic and enterprise AI adoption"
authors: Ruth Appel, Peter McCrory, Alex Tamkin, Miles McCain, Tyler Neylon, Michael Stern
institution: Anthropic
year: 2025
doi: ""
category: [labor_economics]
source_tier: 1
pdf_path: papers/local/appel-2025-uneven-geographic-and-enterprise-ai.pdf
pdf_filename: appel-2025-uneven-geographic-and-enterprise-ai.pdf
verified_date: 2026-07-29
datasets_used: []
---

## One-line Summary

Anthropic Economic Index 3번째 보고서(V3). Claude.ai 대화 데이터에 처음으로 지리적(150개국+미국 전 주) 분해를 도입하고, 1P(첫당사자) API 기업 트래픽을 처음으로 분석해, AI 채택이 소득 수준이 높은 국가·주에 집중되어 있으며(Anthropic AI Usage Index와 GDP의 강한 양의 상관), 기업(API) 사용은 소비자(Claude.ai) 사용보다 훨씬 더 코딩·자동화에 특화되어 있음을(자동화 77% vs 약 50%) 실증.

## Document Information

- 저자: Ruth Appel, Peter McCrory, Alex Tamkin(이상 공동 리드저자), Miles McCain, Tyler Neylon, Michael Stern (p.1).
- 발행: Anthropic, 2025년 9월 15일 (p.1). Anthropic Economic Index 보고서 시리즈의 3번째 판(본문에서 "V3", "this third iteration of the Anthropic Economic Index Report"로 자칭, p.9, p.45).
- DOI 없음. 게재 학술지 없음 — Anthropic 자체 발행 온라인 연구보고서.
- 전체 47페이지(서론·3개 챕터·결론·주석)를 pdftotext 텍스트추출로 전체 읽기 검증함(Tier 1).

## Key Contributions

- Claude.ai 사용 데이터에 처음으로 지리적 분해(150개국 이상 및 미국 전 50개주+DC)를 도입, "Anthropic AI Usage Index(AUI)"를 신규 정의 — 특정 지역의 Claude 사용 점유율을 해당 지역의 근로연령인구(15~64세) 점유율로 나눈 지수 (p.13-14).
- 1P(첫당사자) API 기업 트래픽을 사상 최초로 분석해 소비자용 Claude.ai와 대비되는 기업 AI 배치 패턴을 규명 (p.30 이하, Chapter 3).
- API 고객의 과업별 비용(입력·출력 토큰 기준)과 사용빈도 간 관계를 분석해, 비용보다 모델 역량·자동화의 경제적 가치가 기업 채택을 더 크게 좌우함을 실증 (p.41-43).
- API 트래픽에서 입력 토큰 길이와 출력 토큰 길이 간 안정적 관계(탄력성 0.38)를 발견해, 복잡한 과업일수록 맥락(context) 접근성이 배치의 병목이 될 수 있음을 제시 (p.38-40).

## Methodology and Data

- Chapter 1: Claude.ai 대화 표본(무작위 샘플링, 프라이버시 보존 자동분류 시스템 사용). V1(2024.12~2025.1)·V2(2025.2~3)·V3(2025.8, 본 보고서의 신규 데이터) 3개 시점 간 O*NET 과업·SOC 대분류·협업모드(automation/augmentation) 변화를 비교 (p.6-11).
- Chapter 2: Claude.ai Free·Pro 대화 100만 건(2025.8.4~8.11 샘플링, 트러스트앤세이프티 위반 플래그 제외)으로 국가별·미국 주별 AUI 산출. 프라이버시 필터: 셀당 최소 15개 대화·5개 고유 계정, 하위(bottom-up) 요청군집은 최소 500개 대화·250개 고유 계정 (p.16 각주1, p.28 각주2).
- 국가·주 단위 AUI 계층화: 최소 200개(국가)/100개(미국 주) 관측치를 가진 지역을 표본으로 사분위 기준 4개 등급(Leading/Upper middle/Lower middle/Emerging)+관측 없는 지역은 Minimal로 분류 (p.15 각주4).
- Chapter 3: 1P API 고객 트랜스크립트 100만 건(2025년 8월, 1P API 트래픽의 약 절반을 구성하는 고객 풀에서 무작위 샘플링)을 동일한 프라이버시 보존 방식으로 O*NET 과업·하향식(bottom-up) 분류에 매핑. 각 레코드는 프롬프트-응답 쌍(다회차 세션의 경우 세션 중간일 수 있음) (p.44 각주2).
- API 비용 분석: 과업별 평균 API 비용을 표본 전체 평균(비가중)으로 나눈 "API 비용 지수"를 구성, 직업군별 사용점유율과의 관계를 OLS로 추정(탄력성 3, 그림3.8) 및 과업 특성(직업군 고정효과·Claude.ai 협업모드 비중·검열 표시 더미) 통제 후 편회귀(탄력성 -0.29, 그림3.9) (p.41-42, 각주12-13).

## Key Results

- 세계 지리적 분포: 미국이 전세계 Claude.ai 사용의 21.6%로 최고, 인도 7.2%, 브라질 3.7% (그림2.1, p.13).
- AUI 상위국: 이스라엘 7.00(N=10.9천), 싱가포르 4.57(N=5.4천), 호주 4.10(N=18.8천), 뉴질랜드 4.05(N=3.6천), 대한민국 3.73(N=35.3천), 미국 3.62(N=208.2천) (그림2.2, p.14).
- AUI 하위권 예시: 볼리비아 0.48, 인도네시아 0.36, 인도 0.27, 나이지리아 0.2 (p.16).
- GDP-AUI 관계: 국가별 로그-로그 회귀에서 R²=0.709(β=0.690, p<0.001), GDP per working-age capita 1% 증가는 AUI 0.7% 증가와 연관 (그림2.4, p.17).
- 미국 주별: 총사용량은 캘리포니아 25.3%·뉴욕 9.3%·텍사스 6.7%·버지니아 4.0% 순이나, AUI 기준으로는 워싱턴DC(3.82)가 1위, 유타(3.78)가 근소한 차이로 2위, 이어 캘리포니아(2.13)·뉴욕(1.58)·버지니아(1.57) (그림2.5, p.18-19). 유타는 조직적 어뷰징(coordinated abuse) 가능성이 발견되었으나 로버스트니스 체크로 결과에 영향 없음을 확인 (각주7, p.28).
- 미국 주 단위 GDP-AUI 관계는 국가 수준보다 약함(소득차이가 주간 변이의 절반 이하 설명)이나, 주 GDP per capita 1% 증가는 AUI 1.8% 증가와 연관(국가 수준보다 기울기가 큼) (p.19-20).
- 컴퓨터·수학직 종사자 비중이 1%포인트 높은 주는 AUI가 0.36% 더 높으며, 이 요인 하나가 주간 AUI 변이의 약 2/3를 설명 (p.13, appel-2026-economic-primitives에서 재확인).
- 과업 구성: 코딩 관련 과업이 전체 표본의 36%로 최다 지속, 교육(9.3%→12.4%)·과학(6.3%→7.2%) 과업 비중 상승, 경영(5%→3%)·비즈니스금융(6%→3%) 비중 하락 (그림1.1, p.7).
- 협업모드: Directive(자동화) 비중이 27%(V1)→39%(V3)로 급증, 이는 이번 보고서에서 처음으로 자동화가 증강을 앞지른 사례 (p.9).
- 국가 소득수준과 사용다양성: 저채택국(예: 인도, 코딩이 전체 사용의 절반 이상)일수록 코딩에 집중되고, 고채택국일수록 교육·과학·비즈니스 등으로 사용이 다변화 (p.21-23).
- 협업모드-소득 관계: 과업구성을 통제(편회귀 잔차)해도 AUI가 높은 국가일수록 자동화 잔차가 낮음(더 증강적) — 편회귀 R²=0.394, β=-3.112(그림2.11, p.26).
- API vs Claude.ai 특화: API 트래픽은 컴퓨터·수학직 44%(Claude.ai 36%), 사무행정직 10%(8%) 비중이 더 높은 반면, 교육 12%→3.6%·예술/디자인 8.2%→5.2%로 감소 (그림3.3, p.32-33).
- 자동화 비중: API 트랜스크립트의 77%가 자동화 패턴(Claude.ai는 약 50%), 과업 단위로는 API 과업의 97.9%가 자동화-지배적인 반면 Claude.ai는 47.0% (그림3.5, p.36).
- 과업 집중도: Claude.ai·API 모두 지니계수 0.82~0.86의 극단적 집중을 보이며, 하위 80% 과업이 차지하는 사용 비중은 API 10.5% vs Claude.ai 12.7% (그림3.4, p.34-35). 과업순위-사용점유율 로그-로그 회귀 기울기가 API -1.11·Claude.ai -1.13로 Zipf 법칙(-1.00)에 근접 (그림3.4 우측패널).
- API 비용-사용 관계: 직업군 단위 평균 API 비용지수와 사용점유율의 로그-로그 회귀 기울기 2.962(R²=0.228, 그림3.8, p.41) — 비용이 높은 과업일수록 사용도 많음(음의 가격민감도가 아님을 시사). 단, 과업특성을 통제한 편회귀에서는 비용 1% 상승이 사용빈도 0.29% 감소와 연관(그림3.9, p.42).
- 입력-출력 토큰 관계: 과업 단위 API 입력토큰지수 1% 증가는 출력토큰지수 0.38% 증가와 연관(탄력성 0.382, R²=0.294, 그림3.7, p.39-40) — 강한 수확체감을 시사.
- 미국 기업 AI 도입률(Census Business Trends and Outlook Survey 인용): 2023년 가을 3.7%→2025년 8월 초 9.7%로 2년 만에 2배 이상 상승했으나 여전히 대다수 기업은 미채택 (그림3.1, p.31).

## Limitations and Future Work

- 저자가 명시한 데이터 한계: 프라이버시 보존 시스템으로 셀당 최소 관측치 미만 지역·과업은 필터링되어 분석에서 제외됨(국가 최소 15대화·5계정, 하위요청군집 최소 500대화·250계정) (p.16 각주1, p.28 각주2).
- 유타주 AUI 최상위권 결과에 조직적 어뷰징 가능성이 발견되어 별도 로버스트니스 체크를 거쳤음을 명시 (각주7, p.28).
- API 비용-사용 관계 분석은 "예비적 탐색(preliminary exploration)"으로 명시되며, 비용 민감도 추정치는 상대적 비교일 뿐 외부 경쟁 가격압력에 대한 전체 Claude 사용의 민감도를 다루지 않음을 각주에서 밝힘 (각주11, p.44).
- 저자들은 AI 채택이 이미 부유한 지역·자동화 준비가 된 부문에 집중되면 기존 불평등이 심화될 수 있다는 점, 그리고 암묵적 조직지식을 가진 경험 많은 근로자가 AI 자동화의 보완재로 이득을 볼 가능성 등 노동시장 함의의 불확실성을 결론에서 명시 (p.46-47).
- 향후 연구 질문으로 AI 사용·채택의 지역별 노동시장 결과, 국가간 채택 결정요인, 비용-과업 배치 관계, 자동화 가능/불가능 과업의 구분 요인 등을 제시 (p.5).

## Related Work

- [[handa-2025-which-economic-tasks-are]] — Anthropic Economic Index 최초 보고서(R1/V1)의 O*NET 과업 매핑·Clio 분류방법론을 계승하며, 본 보고서는 여기에 지리적 분해와 API 데이터를 추가함.
- [[massenkoff-2026-labor-market-impacts-of-ai]] — 본 보고서 이후 웨이브의 Anthropic Economic Index 데이터를 Eloundou β와 결합해 "관측노출" 지수로 발전시킨 후속 연구.
- [[fan-2026-aggregate-gains-from-ai]] — 본 보고서를 포함한 Anthropic Economic Index 여러 웨이브의 지리적 데이터를 국가×직업 단위로 확장해 노동비용등가·AI집중지수를 구축한 후속 IMF 연구.
- [[eloundou-2023-gpts-are-gpts-an-early]] — 본 보고서가 언급하는 LLM 기반 이론적 노출 추정 선행연구.

## Glossary

- **Anthropic AI Usage Index(AUI)**: 특정 지역(국가·미국 주)의 Claude.ai 사용 점유율을 해당 지역 근로연령인구(15-64세) 점유율로 나눈 지수. 1보다 크면 인구 대비 과대사용, 1보다 작으면 과소사용을 의미 (p.14).
- **1P(첫당사자) API**: Anthropic 자체 프로그래밍 인터페이스를 통한 개발자 트래픽. Amazon Bedrock·Google Cloud Vertex 등 제3자 플랫폼이나 Claude.ai 소비자용 애플리케이션과 구분됨 (p.29).
- **Directive/Feedback Loop(자동화) vs Learning/Task Iteration/Validation(증강)**: 사용자가 Claude에게 과업을 완전 위임하는지(자동화) 대 반복적·협력적으로 상호작용하는지(증강)를 구분하는 5가지 협업모드 분류 (p.9).
- **API 비용 지수/출력 토큰 지수**: 특정 O*NET 과업에 연계된 API 트랜스크립트의 평균 비용(또는 출력 길이)을 표본 전체 평균(비가중)으로 나눈 정규화 지수 (p.38, p.41).
