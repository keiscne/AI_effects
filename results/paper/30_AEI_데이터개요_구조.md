# Anthropic Economic Index 데이터 해설

**목적과 릴리스별 특징, 데이터 구조, 그리고 지표 A~C로 이어지는 경로**

AI-effects 프로젝트

> 이 문서는 같은 이름의 `.tex`와 같은 내용이다. 표 5·6의 수치는 `results/table/30_*.tex`(code/04_analysis_aei_v6_structure.do 생성)를 옮긴 것이다.

## 요약

Anthropic Economic Index(AEI)는 Claude 대화를 미국 O*NET 과업과 SOC 직업에 대응시켜, AI가 경제의 어떤 일에 실제로 쓰이는지를 집계해 공개하는 자료다. 이 보고서는 HuggingFace `Anthropic/EconomicIndex`의 릴리스 6개와 `labor_market_impacts` 폴더를 원자료 파일 수준에서 확인해 정리했다(2026년 9월 26일 다운로드본). 앞부분은 AEI의 목적과 특징, 릴리스별 차이를 다룬다. 뒷부분은 이 프로젝트의 지표 A~C가 쓰는 release 2026-06-26(V6)의 스키마, 범주, 지표 공개 범위, 지표의 구조를 설명하고, 어떤 셀이 어떤 계산을 거쳐 지표 A~C가 되는지를 단계별로 보인다.

- 릴리스마다 표본 기간, 플랫폼, 지리 단위, 분류 범주, 파일 형식이 달라 릴리스 간 값을 그대로 이어 붙일 수 없다. V1·V2는 과업별 비중 CSV, V3~V5는 1주 표본의 긴 형식(long format) 패널, V6은 달력 월 단위의 새 스키마다.
- V6은 국가 단위에서 세부 범주(세부 직업, O*NET 과업 등)는 대화 비중 `pct`만, 대분류 수준(SOC 대분류 등)은 모든 지표를 공개한다. 세부 직업의 시간 지표는 전 세계(GLOBAL) 값만 있다.
- 지표 A~C는 점유율이라 한국 대화 총량(Sensor Tower)과 대화당 메시지 수 K가 지워진다. 그래서 사실상 AEI의 네 가지 값으로 정해진다. 한국 SOC 대분류의 `pct`와 `use_case_work_pct`, 한국 세부 직업 `pct`, 전 세계 세부 직업의 소요 시간 두 가지다. 여기에 SOC–KSCO 연계표가 더해지고, 지표 C에는 1인당 근로시간이 더해진다.

## 1. 데이터 개요

### 1.1 목적

AEI는 Anthropic이 2025년 2월부터 공개하는 자료다. 목적은 AI가 노동시장과 경제에 주는 영향을 "AI가 할 수 있는 일"의 예측이 아니라 "AI가 실제로 하고 있는 일"의 관측으로 추적하는 것이다(Handa et al., 2025). 기존의 AI 노출도 지표(Felten AIOE, Webb, Eloundou GPT 노출도 등)는 직업·과업이 AI로 처리될 수 있는지를 사람이나 모델이 사전에 판정한 값이다. 반면 AEI는 이미 일어난 대화를 집계한 값이다. 그래서 이론상 노출도가 높아도 실제로는 거의 쓰이지 않는 과업, 반대로 노출도는 낮아도 실제로 많이 쓰이는 과업을 드러낼 수 있다.

보고서가 거듭되면서 질문이 넓어졌다. 처음에는 "어떤 과업에 쓰이는가"(V1)와 "자동화인가 증강인가"(V1·V2)를 다뤘다. 이후 "어느 나라·지역에서 얼마나 쓰이는가"와 "기업 API 사용은 어떻게 다른가"(V3, Appel et al., 2025)가 더해졌다. 다음으로 "과업이 얼마나 복잡하고, AI가 시간을 얼마나 줄이는가"(V4 경제 원시지표, Appel et al., 2026), "사용이 시간에 따라 어떻게 달라지는가"(V5, Massenkoff et al., 2026b), "월·시간 단위의 리듬과 산출물"(V6, Massenkoff et al., 2026a)로 이어졌다. 별도의 `labor_market_impacts` 자료는 이론 노출도와 사용 자료를 결합한 직업별 관측 노출도(observed exposure)를 제공한다(Massenkoff and McCrory, 2026).

### 1.2 특징

1. **관측된 사용.** 설문의 자기 보고나 전문가 판정이 아니라 실제 대화의 표본을 집계한다. 대화 내용은 프라이버시 보존 분석 도구(Clio)로 처리하고, 개별 대화가 아니라 집계값만 공개한다.
2. **과업 중심 분류.** 각 대화를 O*NET 과업(task statement)에 대응시키고, 과업이 속한 직업으로 SOC 직업을 정한다. 따라서 **AEI의 SOC는 사용자의 직업이 아니라 대화 과업이 속한 직업**이다. 이와 별도로 직업 분류와 무관하게 대화 요청 내용을 묶은 요청 범주(request)도 있다.
3. **모델이 분류·추정한 값.** 과업 대응, 협업 유형, 업무·개인·학업 용도, 사람 단독 소요 시간, AI를 쓴 소요 시간 등은 모두 Claude 기반 분류기가 대화마다 판정·추정한 값이다. 분류기 프롬프트는 V4 부록(`aei_v4_appendix.pdf`)에 있다. 측정 오차와 분류기 특성이 값에 들어 있다.
4. **비중 중심 공개.** 대화 건수 자체보다 비중(%)과 평균을 주로 공개한다. V3~V5의 raw 파일에는 `*_count`가 있지만 V6에는 건수가 없다. 그래서 다른 규모 자료와 결합하려면 외부에서 총량을 가져와야 한다(이 프로젝트에서는 Sensor Tower 이용자 수, paper 17).
5. **공개 임계치.** 대화 수와 고유 계정 수가 기준에 못 미치는 셀은 공개하지 않는다. 행이 없다는 것은 값이 0이라는 뜻이 아니다. 공개된 비중의 합은 100%보다 작다.
6. **플랫폼 범위.** Claude.ai(소비자용 채팅; V6은 Cowork 포함)와 1P API(기업 직접 API; V6은 Claude Code 제외) 두 소스다. Claude 사용자만의 자료라 다른 AI 제품 사용자의 직업 구성과 같다는 보장이 없다.

### 1.3 릴리스별 특징

**표 1. AEI 릴리스별 특징(원자료 파일과 각 폴더의 `README.md`·`data_documentation.md`로 확인)**

| 폴더(약칭) | 보고서 | 자료 기간·플랫폼 | 공개 자료와 특징 |
|---|---|---|---|
| `release_2025_02_10` (V1) | Handa et al.(2025), Which Economic Tasks are Performed with AI? | 2024년 12월~2025년 1월 Claude.ai(Free·Pro) 대화 표본 | 과업별 대화 비중(`onet_task_mappings.csv`, 과업 문장 3,514개), 협업 유형 비중(`automation_vs_augmentation.csv`). 전 세계 값만. 보조 표: O*NET 과업 문장, SOC 구조, BLS 고용(2023년 5월), 임금. 열은 `task_name`, `pct` 두 개뿐이다. |
| `release_2025_03_27` (V2) | Insights from Claude 3.7 Sonnet | Claude 3.7 Sonnet 출시(2025년 2월) 이후 Claude.ai 대화 | 과업 비중 v2(3,365개), 과업별 협업 유형 비율, 과업별 확장 사고(extended thinking) 비율, 대화 군집 630개의 군집 수준 자료(`cluster_level_dataset.tsv`: 3단계 군집명, 대화·이용자 비중, 대응 O*NET 과업, 협업 비율). 전 세계 값만. |
| `release_2025_09_15` (V3) | Appel et al.(2025), Uneven Geographic and Enterprise AI Adoption | 2025-08-04~08-11(1주). Claude.ai, 1P API | **긴 형식 패널 첫 도입**: 열 `geo_id`, `geography`, `facet`, `level`, `variable`, `cluster_name`, `value`. 지리: 전 세계, 국가, 미국 주. facet: `onet_task`, `request`(3단계), `collaboration`. 가공본(`data/output`)에 SOC 대분류(`soc_occupation`), 과업×협업 교차가 추가된다. 1P API는 전 세계만. 분석 코드와 외부 입력 자료(인구, GDP 등)도 공개. AUI(1인당 사용 지수)를 처음 정의. |
| `release_2026_01_15` (V4) | Appel et al.(2026), Economic Primitives | 2025-11-13~11-20(1주). Claude.ai(Free·Pro), 1P API | 같은 긴 형식. **경제 원시지표 facet 추가**: `human_only_time`, `human_with_ai_time`, `multitasking`, `human_only_ability`, `use_case`, `task_success`, `ai_autonomy`, `human_education_years`, `ai_education_years`. 과업·요청과의 교차(`onet_task::use_case` 등), 수치 facet의 평균·중앙값·표준편차·신뢰구간·히스토그램. 지리에 전 세계 하위 지역(`country-state`) 추가. raw 파일만 공개, 분류기 프롬프트 부록. |
| `release_2026_03_24` (V5) | Massenkoff et al.(2026), Learning Curves | 2026-02-05~02-12(1주). Claude.ai(Free·Pro·Max), 1P API | V4와 같은 스키마와 facet. raw 파일만 공개. |
| `release_2026_06_26` (V6) | Massenkoff et al.(2026), Cadences | **달력 월**: 2026년 4월, 5월. Claude.ai(채팅·Cowork, Free·Pro·Max), 1P API(Claude Code 제외) | **새 스키마**(2절). 범주 4개(`overall`, `onet` 4단계, `request` 3단계, `soc_occupation` 2단계). **SOC 세부 직업을 처음 공개**. 지표를 `metric_id` 하나로 표현(예: `use_case_work_pct`), 산출물(artifact) 32종 추가, 값은 소수 둘째 자리 반올림, 건수와 `task_success` 없음. 국가 121개, 하위 지역 609~652개. |
| `labor_market_impacts` | Massenkoff and McCrory(2026), Labor Market Impacts of AI | (릴리스와 별도) | `job_exposure.csv`(SOC 2018 직업 756개의 observed exposure), `task_penetration.csv`(과업 17,998개의 사용 침투도). 이론 노출도(Eloundou β)와 AEI 사용을 결합한 파생 지표. |

릴리스를 이을 때 주의할 점은 다음과 같다.

- **표본 기간이 다르다.** V3~V5는 각각 1주 표본이고, V6은 달력 월이다. 같은 지표도 표본 설계가 달라 시계열로 바로 잇기 어렵다.
- **플랫폼 범위가 바뀌었다.** V4는 Free·Pro, V5부터 Max가 포함되고, V6은 Cowork를 포함하며 1P API에서 Claude Code를 뺐다.
- **분류 체계가 바뀌었다.** V1의 과업 3,514개와 V2의 3,365개는 과업 문장(소문자 정규화) 기준이다. V6은 O*NET Task ID와 O*NET 위계(Task→DWA→IWA→GWA), SOC 세부 직업을 공식 범주로 둔다. 요청 범주는 대화를 묶은 군집이라, 릴리스 간에 같은 범주인지는 확인되지 않았다.
- **열 이름이 바뀌었다.** V6에서 `facet`→`category_name`, `level`→`hierarchy_level`, `variable`→`metric_id`, `cluster_name`→`node_name`, `geography`→`geo_level`로 바뀌었다(표 3). 파싱 코드는 릴리스별로 나눠야 한다.

## 2. 데이터 구조

이 절은 지표 A~C가 쓰는 V6(`release_2026_06_26`)을 기준으로 한다. 파일은 `aei_claude_ai_2026-06-26.csv`(`source_id` = `claude_ai`)와 `aei_1p_api_2026-06-26.csv`(`1p_api`) 두 개다.

### 2.1 데이터 스키마

한 행은 "월 × 지역 × 범주 × 계층 × 노드 × 지표" 하나의 값이다(긴 형식).

**표 2. V6 데이터 스키마**

| 열 | 형식 | 내용 |
|---|---|---|
| `date_start` | date | 집계 기간 시작(포함). 2026-04-01, 2026-05-01 |
| `date_end` | date | 집계 기간 끝(제외). 다음 달 1일 |
| `geo_id` | string | `GLOBAL`, ISO 3166-1 알파-3 국가 코드(예: `KOR`), ISO 3166-2 하위 지역 코드 |
| `geo_level` | string | `global`, `country`, `subregion` |
| `category_name` | string | 분석 범주: `overall`, `onet`, `request`, `soc_occupation` |
| `hierarchy_level` | int | 범주 안 계층. 0이 가장 세분된 수준 |
| `metric_id` | string | 지표 이름(2.4절) |
| `value` | float | 공개값. 소수 둘째 자리 반올림 |
| `node_name` | string | 범주 안 개별 항목의 이름(과업 문장, 직업명, 요청 범주명 등) |
| `node_external_id` | string | 항목 식별자: O*NET 요소 ID, SOC 코드, 요청 범주 UUID. `overall`은 `-` |

**표 3. V3~V5와 V6의 열 대응**

| V3~V5 | V6 | 비고 |
|---|---|---|
| `geo_id`, `geography` | `geo_id`, `geo_level` | raw 파일의 국가 코드는 2자리(`KR`), V6은 3자리(`KOR`). 하위 지역은 V3 미국 주(`state_us`), V4·V5 `country-state` |
| `date_start`, `date_end` | 같음 | V3~V5는 1주, V6은 달력 월 |
| `platform_and_product` | (파일로 구분, `source_id`) | |
| `facet` | `category_name` | V3~V5는 지표 차원(`use_case`, `collaboration` 등)도 facet이었다. V6에서는 이것이 지표(`metric_id`)로 옮겨졌다 |
| `level` | `hierarchy_level` | |
| `variable` | `metric_id` | 예: `onet_task_pct` → `pct`; `onet_task::use_case` 교차 비중 → `use_case_work_pct` 등 |
| `cluster_name` | `node_name`, `node_external_id` | V3~V5의 교차는 `base::category` 형식의 이름. V6은 이름과 ID를 나눴다 |
| `value` | `value` | V3~V5에는 건수(`*_count`)와 분포 통계(중앙값, 신뢰구간, 히스토그램)가 있다. V6은 비중과 평균만 |

### 2.2 범주(categories)

**표 4. V6 범주와 계층**

| `category_name` | 내용 | 계층 0(가장 세분) | 계층 1 | 계층 2 | 계층 3 |
|---|---|---|---|---|---|
| `overall` | 모든 대화(주제·과업 구분 없음) | 전체 | -- | -- | -- |
| `onet` | O*NET 업무 활동 위계 | Task(과업) | DWA(세부 업무 활동) | IWA(중간 업무 활동) | GWA(일반 업무 활동) |
| `request` | 사용자 요청을 주제별로 묶은 위계(직업 분류와 무관) | Detailed | Minor | Major | -- |
| `soc_occupation` | 미국 BLS 표준직업분류(SOC) | 세부 직업 | 대분류 | -- | -- |

- **식별자**: `onet` 계층 0은 O*NET Task ID(숫자, 예: `9789`), 계층 1~3은 O*NET 요소 ID(예: GWA `4.A.4.c.1`). `soc_occupation` 계층 0은 O*NET-SOC 8자리 코드(예: `15-1252.00`), 계층 1은 SOC 대분류 2자리(예: `15`). `request`는 UUID다.
- **SOC 세부 직업은 8자리 O*NET-SOC 코드다.** SOC 2018 세부 직업(6자리)과 결합하려면 앞 7자리로 묶어야 한다. 예를 들어 15-1299(Computer Occupations, All Other)는 O*NET에 .00 코드가 없고 .01~.09만 있다(paper 23).
- **과업은 직업 하나에만 속한다.** 한국 2026년 5월 과업 647개는 모두 O*NET-SOC 하나에만 대응한다. 같은 과업 문장이 여러 직업에 다른 Task ID로 있는 경우가 있어, 과업–직업 연결은 문장이 아니라 Task ID로 해야 한다(2026-10-18 작업 로그).

### 2.3 지표 공개 범위(metric availability)

데이터 문서의 Metric Availability를 요약하면 다음과 같다. 전 세계 수준에서는 모든 범주·계층에 모든 지표가 공개된다. 국가 수준에서는 `overall`과 각 범주의 가장 상위 계층(O*NET GWA, 요청 Major, SOC 대분류)에만 모든 지표가 공개되고, 그보다 세분된 계층은 `pct`만 공개된다. 하위 지역은 `overall`을 빼면 `pct`만 공개된다. 1P API는 전 세계 값만 있다. 공개되려면 셀의 집계 임계치와 지역 표본 하한을 모두 넘어야 한다. 표 5는 원자료 파일에서 이 규칙을 직접 확인한 것이다.

**표 5. V6 공개 범위(2026년 5월): 소스·지리 × 범주 × 계층별 지역 수, 노드 수, 지표 수**

| 소스 / 지리 | 범주 | 계층 | 지역 수 | 노드 수 | 지표 수 | artifact 지표 수 | 공개 지표 |
|---|---|---|---|---|---|---|---|
| claude_ai / 전 세계 | overall | 0 전체 | 1 | 1 | 20 | 32 | 전체 지표(pct 없음) |
|  | onet | 0 Task | 1 | 2713 | 19 | 32 | 전체 지표 |
|  | onet | 1 DWA | 1 | 722 | 19 | 32 | 전체 지표 |
|  | onet | 2 IWA | 1 | 207 | 19 | 32 | 전체 지표 |
|  | onet | 3 GWA | 1 | 35 | 19 | 32 | 전체 지표 |
|  | request | 0 Detailed | 1 | 1007 | 19 | 32 | 전체 지표 |
|  | request | 1 Minor | 1 | 195 | 19 | 32 | 전체 지표 |
|  | request | 2 Major | 1 | 20 | 19 | 32 | 전체 지표 |
|  | soc_occupation | 0 세부 직업 | 1 | 718 | 19 | 32 | 전체 지표 |
|  | soc_occupation | 1 대분류 | 1 | 22 | 19 | 32 | 전체 지표 |
| claude_ai / 국가 | overall | 0 전체 | 121 | 1 | 20 | 32 | 전체 지표(pct 없음) |
|  | onet | 0 Task | 121 | 1673 | 1 | 0 | pct만 |
|  | onet | 1 DWA | 121 | 568 | 1 | 0 | pct만 |
|  | onet | 2 IWA | 121 | 182 | 1 | 0 | pct만 |
|  | onet | 3 GWA | 121 | 35 | 19 | 32 | 전체 지표 |
|  | request | 0 Detailed | 121 | 950 | 1 | 0 | pct만 |
|  | request | 1 Minor | 121 | 190 | 1 | 0 | pct만 |
|  | request | 2 Major | 121 | 20 | 19 | 32 | 전체 지표 |
|  | soc_occupation | 0 세부 직업 | 121 | 628 | 1 | 0 | pct만 |
|  | soc_occupation | 1 대분류 | 121 | 22 | 19 | 32 | 전체 지표 |
| claude_ai / 하위 지역 | overall | 0 전체 | 652 | 1 | 20 | 32 | 전체 지표(pct 없음) |
|  | onet | 0 Task | 550 | 870 | 1 | 0 | pct만 |
|  | onet | 1 DWA | 609 | 378 | 1 | 0 | pct만 |
|  | onet | 2 IWA | 609 | 149 | 1 | 0 | pct만 |
|  | onet | 3 GWA | 609 | 34 | 1 | 0 | pct만 |
|  | request | 0 Detailed | 545 | 789 | 1 | 0 | pct만 |
|  | request | 1 Minor | 609 | 177 | 1 | 0 | pct만 |
|  | request | 2 Major | 609 | 20 | 1 | 0 | pct만 |
|  | soc_occupation | 0 세부 직업 | 604 | 473 | 1 | 0 | pct만 |
|  | soc_occupation | 1 대분류 | 609 | 22 | 1 | 0 | pct만 |
| 1p_api / 전 세계 | overall | 0 전체 | 1 | 1 | 20 | 32 | 전체 지표(pct 없음) |
|  | onet | 0 Task | 1 | 2295 | 19 | 32 | 전체 지표 |
|  | onet | 1 DWA | 1 | 721 | 19 | 32 | 전체 지표 |
|  | onet | 2 IWA | 1 | 207 | 19 | 32 | 전체 지표 |
|  | onet | 3 GWA | 1 | 37 | 19 | 32 | 전체 지표 |
|  | request | 0 Detailed | 1 | 860 | 19 | 32 | 전체 지표 |
|  | request | 1 Minor | 1 | 184 | 19 | 32 | 전체 지표 |
|  | request | 2 Major | 1 | 20 | 19 | 32 | 전체 지표 |
|  | soc_occupation | 0 세부 직업 | 1 | 690 | 19 | 32 | 전체 지표 |
|  | soc_occupation | 1 대분류 | 1 | 22 | 19 | 32 | 전체 지표 |

주: 노드 수는 지역 전체의 합집합(서로 다른 `node_external_id` 수). 지표 수는 artifact를 뺀 `metric_id` 수이고, `overall`의 20개에는 `usage_pct`, `usage_per_capita_index`가 들어 있으며 `pct`는 없다.

**표 6. 한국(`KOR`, Claude.ai) 공개 범위: 노드 수와 공개된 `pct`의 합**

| 범주 | 계층 | 노드 수 4월 | 노드 수 5월 | pct 합(%) 4월 | pct 합(%) 5월 | 공개 지표 |
|---|---|---|---|---|---|---|
| overall | 0 전체 | 1 | 1 | -- | -- | 전체 지표(pct 없음) |
| onet | 0 Task | 532 | 647 | 78.51 | 81.32 | pct만 |
| onet | 1 DWA | 275 | 297 | 88.82 | 90.36 | pct만 |
| onet | 2 IWA | 115 | 125 | 96.30 | 98.50 | pct만 |
| onet | 3 GWA | 28 | 29 | 97.31 | 98.90 | 전체 지표 |
| request | 0 Detailed | 553 | 625 | 92.23 | 94.61 | pct만 |
| request | 1 Minor | 160 | 166 | 96.69 | 98.41 | pct만 |
| request | 2 Major | 20 | 20 | 97.11 | 98.72 | 전체 지표 |
| soc_occupation | 0 세부 직업 | 389 | 424 | 96.16 | 98.08 | pct만 |
| soc_occupation | 1 대분류 | 22 | 22 | 97.37 | 98.94 | 전체 지표 |

- 한국은 SOC 대분류 22개가 모두 공개되고(모든 지표), 세부 직업은 4월 389개, 5월 424개가 공개된다(`pct`만). 공개된 비중의 합은 세부 직업 96~98%, 대분류 97~99%다. 나머지는 공개 임계치에 걸린 몫이다.
- 과업(`onet` 계층 0)은 공개 비중의 합이 78~81%로 낮다. 과업 단위는 셀이 작아 미공개 몫이 크다.
- 국가 단위에서 세부 직업의 업무용 비중이나 소요 시간은 공개되지 않는다. 그래서 세부 직업의 업무용 비중은 소속 대분류 값으로, 소요 시간은 전 세계 값으로 대신한다(2.5절의 가정 B3, B4).

### 2.4 지표(metric)의 구조

V6의 지표 21개(산출물 32종 제외)는 성격에 따라 네 묶음으로 나뉜다.

**표 7. V6 지표의 구조**

| 묶음 | `metric_id` | 단위 | 의미(분모) |
|---|---|---|---|
| (1) 지역 규모 | `usage_pct` | % | 상위 지역 전체 사용 중 이 지역의 몫(국가는 전 세계 대비, 하위 지역은 소속 국가 대비). `overall`에만 |
| | `usage_per_capita_index` | 지수 | 사용 비중 ÷ 근로연령(15~64세) 인구 비중. 1이면 인구 비례. 국가와 미국 주만 |
| (2) 분포 | `pct` | % | 이 지역의 대화 중 이 노드(범주·계층 안)의 몫. 같은 범주·계층 안에서 합이 100 이하(미공개 몫) |
| (3) 노드 안 구성 | `use_case_{work, personal, coursework}_pct` | % | 이 노드 대화 중 용도별 몫(합 100) |
| | `collaboration_{directive, feedback_loop, task_iteration, learning, validation, none}_pct` | % | 협업 유형별 몫(합 100) |
| | `collaboration_bucket_{automation, augmentation}_pct` | % | 자동화(directive, feedback loop)와 증강(task iteration, learning, validation)의 몫(none을 빼고 합 100) |
| | `multitasking_pct`, `human_only_ability_pct` | % | 여러 과업이 섞인 대화의 몫, 사람이 AI 없이 할 수 있는 과업의 몫 |
| | `artifact_{label}_pct` (32종) | % | 대화의 대표 산출물 유형별 몫 |
| (4) 노드 안 평균 | `human_only_time_mean` | **시간** | 사람이 AI 없이 할 때의 소요 시간 평균 |
| | `human_with_ai_time_mean` | **분** | 사람이 AI와 함께 할 때의 소요 시간 평균 |
| | `ai_autonomy_mean` | 1~5 | AI 자율성 평균 |
| | `human_education_years_mean`, `ai_education_years_mean` | 년 | 과업에 필요한 사람의 교육 연수, AI 응답이 보여 주는 교육 연수 |

지표를 조합할 때 쓰는 관계는 다음과 같다.

- **분포 × 구성 = 결합 비중.** 노드 g의 `pct`와 `use_case_work_pct`를 곱해 100으로 나누면, 그 지역 전체 대화 중 "노드 g이면서 업무용"인 대화의 비중이 된다. 이를 노드에 대해 더하고 `pct`의 합으로 나누면 지역 전체의 업무용 비중이 된다. 한국 2026년 5월은 SOC 대분류로 다시 계산한 값이 47.36%, `overall`의 공개값이 47.24%로 0.12%p 차이다(paper 19).
- **대화당 절감 시간.** 두 시간 지표는 단위가 다르다. 그래서 절감 시간(분) = 60 × `human_only_time_mean` − `human_with_ai_time_mean`으로 맞춘다. 같은 대화 집합의 평균이므로 평균의 차이가 차이의 평균과 같다. 예를 들어 한국 전체(2026년 5월)는 사람 단독 4.76시간, AI 사용 41.79분이다.
- **8자리에서 6자리로.** SOC 세부 직업의 평균 지표를 6자리로 묶을 때는 `pct`로 가중평균한다(대화 평균이므로). `pct` = 0.00으로 반올림된 코드는 실제 값이 0~0.005%이므로 가중치를 0.0025로 둔다(`01_import_aei_soc_time_savings.do`).
- **반올림.** 모든 값이 소수 둘째 자리로 반올림되어 있어, 아주 작은 비중은 상대 오차가 크다.

### 2.5 지표 A~C로 이어지는 경로

지표 A~C(paper 27)는 KSCO 8차 소분류 j의 한국 업무용 AI 사용 점유율이다.

- A: CS_j = C_j / Σ_k C_k
- B: SS_j = S_j / Σ_k S_k
- C: FS_j = (S_j / h̄_j) / Σ_k (S_k / h̄_k)

여기서 C_j는 월평균 업무용 대화 수, S_j는 월평균 절감 시간, h̄_j는 1인당 월 주업 근로시간(2022년 상반기 지역별고용조사)이다. AEI 셀에서 C_j, S_j까지 가는 과정은 다음과 같다(월 t ∈ {2026-04, 2026-05}).

1. **한국 SOC 대분류의 업무용 기준 비중**(`KOR`, `soc_occupation`, 계층 1). 대분류 g의 `pct` p_gt와 `use_case_work_pct` w_gt로 s_work(g,t) = p_gt × w_gt / Σ_g' (p_g't × w_g't). AEI의 `pct`는 업무·개인·학업 대화를 모두 포함하고 대분류마다 업무용 비중이 8~85%로 다르다. 그래서 업무용 대화 안의 구성으로 바꾼다(paper 19).
2. **세부 직업 배분**(`KOR`, `soc_occupation`, 계층 0). 대분류 g 안 세부 직업 d(8자리)의 `pct`로 대분류 안 몫을 구해 곱한다: s_work(d,t) = s_work(g,t) × p_dt / Σ_{d'∈g} p_d't. 8자리를 앞 7자리로 더해 SOC 2018 세부 직업 s(6자리)를 만든다.
3. **대화 수**. 한국 월 업무용 대화 총량 V_t(K)(Sensor Tower 이용자 수 × 1인당 메시지 × Signals 업무 비중 ÷ 대화당 메시지 수 K, paper 17)를 곱한다: conv(s,t) = V_t(K) × s_work(s,t).
4. **대화당 절감 시간**(`GLOBAL`, `soc_occupation`, 계층 0). τ_s = 60 × `human_only_time_mean` − `human_with_ai_time_mean`(분)을 8자리에서 계산해 `pct` 가중으로 6자리에 묶고, 두 달을 합친다. 절감 시간은 SOC 단계에서 대화 수와 곱한다: saved(s,t) = conv(s,t) × τ_s / 60(시간).
5. **KSCO 변환**. SOC 2018–KSCO 8차 연계표의 배분 가중치 w_alloc(s, j)(SOC마다 합 1, paper 21)로 소분류에 더한다: C_jt = Σ_s w_alloc(s,j) × conv(s,t), S_jt = Σ_s w_alloc(s,j) × saved(s,t). C_j, S_j는 값이 있는 달의 평균이다.
6. **점유율**. 지표가 있는 소분류 129개에서 A~C를 계산한다. C는 절감 시간을 1인당 근로시간 h̄_j로 나눠 "몇 명분의 일인가"로 바꾼 뒤 점유율을 구한다.

**무엇이 지워지고 무엇이 남는가.** V_t(K)는 모든 직업에 같은 배수로 곱해지므로 점유율에서 지워진다. 대화당 메시지 수 K는 정확히 지워지고, Sensor Tower·Signals의 월별 총량은 두 달을 평균할 때의 가중치로만 남는다(두 달 총량이 거의 같아 영향이 작다). 따라서 지표 A~C를 정하는 AEI 값은 표 8의 네 가지다.

**표 8. 지표 A~C에 들어가는 AEI 셀**

| AEI 셀(`geo_id`, 범주, 계층) | `metric_id` | 노드 수(4월/5월) | A | B | C | 역할 |
|---|---|---|---|---|---|---|
| `KOR`, `soc_occupation`, 1 | `pct` | 22/22 | ✓ | ✓ | ✓ | 대분류 대화 비중 |
| `KOR`, `soc_occupation`, 1 | `use_case_work_pct` | 22/22 | ✓ | ✓ | ✓ | 업무용 기준으로 바꾸는 가중치 |
| `KOR`, `soc_occupation`, 0 | `pct` | 389/424 | ✓ | ✓ | ✓ | 대분류 안 세부 직업 구성 |
| `GLOBAL`, `soc_occupation`, 0 | `human_only_time_mean`, `human_with_ai_time_mean`, `pct` | 696/718 | | ✓ | ✓ | 대화당 절감 시간(`pct`는 8→6자리 가중치) |

AEI 밖에서 들어가는 것은 SOC 2018–KSCO 8차 연계표(A~C)와 1인당 근로시간 h̄_j(C)뿐이다. A는 대화 구성만, B는 여기에 대화당 절감 시간을, C는 다시 1인당 근로시간을 더한다. paper 29에서 A와 C의 노출도 격차가 0.92~0.96의 순위상관으로 비슷했던 것은, 대화당 절감 시간의 직업 차이가 대화 구성의 차이보다 작기 때문이다.

**가정.**

- **B1 대표성**: 한국 AI 업무용 대화의 직업 구성 = AEI Claude.ai 한국 업무용 대화의 직업 구성. 총량이 지워지므로 지표 A~C는 사실상 "Claude.ai 한국 업무용 대화의 직업 구성"을 KSCO로 옮긴 것이다.
- **B2 미공개 셀**: 공개되지 않은 몫(대분류 1~3%, 세부 직업 2~4%)은 공개된 셀과 같은 비율로 나뉜다(합이 1이 되게 다시 정규화).
- **B3 세부 직업의 업무용 비중**: 세부 직업은 `pct`만 공개되므로 업무용 비중이 소속 대분류와 같다고 둔다.
- **B4 절감 시간**: 한국의 직업별 대화당 절감 시간 = 전 세계 값(세부 직업의 시간 지표는 `GLOBAL`에만 있음).
- **B5 직업의 의미**: AEI의 SOC는 대화 과업이 속한 직업이고 사용자의 직업이 아니다. 예를 들어 기자·언론 과업(27-3023)의 사용은 연계표를 거쳐 293 연극·영화 및 영상 전문가로도 간다(paper 29).

**이 경로에 쓰지 않은 AEI 자료.** 한국의 `onet` 과업 비중은 과업 상위 30 표(paper 26)에만 썼다. 요청 범주(`request`)와 협업·산출물 지표는 아직 쓰지 않았다. V3의 국가별 `usage_pct`(18개국 비중)는 Sensor Tower 1인당 메시지 환산(paper 17)에 쓰였지만, 지표 A~C에서는 총량과 함께 지워진다. `labor_market_impacts`의 observed exposure는 비교 대상 노출도로 썼다(paper 28·29).

## 3. 이용 시 유의사항

1. **결측 ≠ 0**: 공개 임계치에 못 미친 셀은 행이 없다. 합계를 낼 때는 미공개 몫을 어떻게 처리했는지 밝혀야 한다.
2. **시간 단위**: `human_only_time_mean`은 시간, `human_with_ai_time_mean`은 분이다(V6 문서 Metrics 표). V4·V5 문서에는 단위가 적혀 있지 않았다(report 08).
3. **분류기 값**: 과업 대응, 용도, 시간 등은 모델의 추정치다. 수준보다 직업 간 상대 비교에 쓰는 것이 안전하다.
4. **릴리스 간 비교**: 표본 기간, 플랫폼, 범주 정의가 달라 같은 이름의 지표라도 그대로 잇지 않는다.
5. **과업의 직업 = 사용자의 직업이 아님**: 직업별 고용·임금 자료와 결합하면 "그 직업 종사자의 사용"이 아니라 "그 직업 과업에 대한 사용"을 결합하는 것이다.

## 4. 산출 파일

- `code/04_analysis_aei_v6_structure.do`: V6 공개 범위표를 만든다.
- `results/table/30_aei_v6_structure.xlsx`: 시트 `cells`(소스 × 월 × 지리 × 범주 × 계층), `kor`, `metrics`(지표 목록).
- `results/table/30_v6_cells.tex`, `30_v6_kor.tex`: 표 5, 6.
- 지표 A~C의 계산 파일: `01_import_aei_soc_time_savings.do`, `03_merge_sensortower_aei_kor_soc_conversations.do`, `03_merge_kor_conv_ai_ksco8.do`, `03_merge_kor_ksco3_ai_usage.do`, `04_analysis_kor_ai_share_index.do`.

## 참고문헌

- Appel, R., P. McCrory, A. Tamkin, M. Stern, M. McCain, and T. Neylon (2025). Anthropic Economic Index Report: Uneven Geographic and Enterprise AI Adoption. Anthropic.
- Appel, R., M. Massenkoff, P. McCrory, M. McCain, R. Heller, T. Neylon, and A. Tamkin (2026). Anthropic Economic Index Report: Economic Primitives. Anthropic.
- Handa, K., A. Tamkin, M. McCain, et al. (2025). Which Economic Tasks are Performed with AI? Evidence from Millions of Claude Conversations. arXiv:2503.04761.
- Massenkoff, M., E. Lyubich, S. Sacher, Z. Hitzig, S. Zhang, R. Heller, and P. McCrory (2026a). Anthropic Economic Index Report: Cadences. Anthropic.
- Massenkoff, M., E. Lyubich, P. McCrory, R. Appel, and R. Heller (2026b). Anthropic Economic Index Report: Learning Curves. Anthropic.
- Massenkoff, M. and P. McCrory (2026). Labor Market Impacts of AI. Anthropic.
