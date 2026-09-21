# Anthropic Economic Index 데이터 해부: 과업 노동시간과 과업·직업별 사용량

### --- Claude 사용/미사용 시간 데이터와 과업·직업별 사용량 데이터의 정의, 측정 단위, 그리고 선행 노출도·적용률 개념과의 접점 ---

**AI-effects 프로젝트**

---

## 초록

본 문헌은 `07_AEI실증연구_노출도사용량_계보.tex`가 다룬 개별 실증연구들이 아니라, 그 연구들이 공통으로 사용하는 **Anthropic Economic Index(AEI) 데이터셋 자체**의 구조를 직접 해부한다. Anthropic이 HuggingFace에 공개하는 `Anthropic/EconomicIndex` 저장소(6개 릴리스 폴더+`labor_market_impacts` 폴더, 각 릴리스의 `data_documentation.md`/`README.md`)를 2026년 9월 시점 스냅샷으로 직접 조회해, (1) **과업의 Claude 사용/미사용 시 노동시간 데이터**(`human_only_time`·`human_with_ai_time` 등 "경제원시지표" 계열 필드)와 (2) **과업·직업별 사용량 데이터**(`onet_task`·`soc_occupation`·`request` 등 facet의 건수·비중)의 정의, 측정 단위, 코딩 방식, 도입 시점을 필드 단위로 정리한다. 나아가 이 두 데이터가 선행 AI 노출도(exposure) 연구—Felten et al.(2021/2023), Webb(2020), Eloundou et al.(2023)—및 AI 적용률(adoption) 연구—기업·근로자 자기보고 서베이, 전병유·신영민(2025)의 AI Firm Exposure(AIFE)—의 개념과 각각 어떻게 연결·대비되는지를 논의한다. 핵심 결론은 다음과 같다: (2) 사용량 데이터는 "예측된 노출"을 "관측된 사용"으로 대체하는 데이터이고, (1) 노동시간 데이터는 노출도 지표가 이분법적·서수형으로만 표현하던 "잠재력"을 시간절감률이라는 **연속적 실현 크기**로 정량화하는 데이터다. 두 데이터는 `labor_market_impacts/job_exposure.csv`·`task_penetration.csv` 두 파일에서 이미 하나의 지수("관측노출")로 결합되어 있으며, 이는 본 프로젝트가 `data/proc/merged/`에서 재현하고자 하는 결합 구조의 실제 선례다.

---

## 1. 서론

### 1.1 목적과 기존 report와의 관계

`07_AEI실증연구_노출도사용량_계보.tex`는 AEI 데이터를 활용한 실증연구 9편이 각각 "노출도"와 "사용량"을 어떻게 *논의*하는지를 다뤘다. 그러나 그 논의는 모두 **AEI가 발행하는 원자료 자체가 정확히 어떤 필드로 구성되어 있는지**를 전제로 한다. 본 문헌은 그 전제를 직접 검증하기 위해, Anthropic이 실제로 공개한 데이터셋 저장소의 문서화 파일을 조회해 필드 단위로 재구성한 자료 해설서다. 목적은 두 가지다.

1. 향후 본 프로젝트가 AEI 원자료(HuggingFace CSV)를 직접 다운로드해 `data/raw/usage/`에 적재할 경우, 어떤 열(column)을 어떤 정의·단위로 읽어야 하는지 사전에 문서화한다.
2. (1) 노동시간 데이터와 (2) 사용량 데이터가 선행 노출도·적용률 개념과 정확히 어느 지점에서 대응하는지를, 필드 수준의 근거로 논증한다.

### 1.2 자료 출처와 조회 방법

Anthropic Economic Index의 데이터는 `https://huggingface.co/datasets/Anthropic/EconomicIndex`에 공개되어 있다. 이 저장소는 2026년 9월 시점 다음과 같은 구조를 갖는다(저장소 최상위 `README.md`와 각 릴리스 폴더의 `data_documentation.md`/`README.md`를 직접 조회해 확인).

**표 1. `Anthropic/EconomicIndex` 저장소 구조 개관**

| 폴더 | 대응 보고서(발행일) | 스키마 형식 | 비고 |
|---|---|---|---|
| `release_2025_02_10` | Handa et al.(2025), R1 | 개별 flat CSV(`onet_task_mappings.csv`, `automation_vs_augmentation.csv` 등) | 과업·협업패턴별로 파일이 분리된 초기 형태 |
| `release_2025_03_27` | (R2, 국가분류 없는 세계 전체 웨이브) | flat CSV+`cluster_level_data/` 하위폴더 | |
| `release_2025_09_15` | Appel et al.(2025), V3 | 장방형(long-format) 통합 패널 최초 도입: `geo_id`/`geography`/`facet`/`level`/`variable`/`cluster_name`/`value` | 지리적 분해(AUI) 최초 도입 웨이브이나, AUI 자체는 저장된 열이 아니라 사용점유율÷인구점유율로 논문이 직접 계산하는 파생지표 |
| `release_2026_01_15` | Appel et al.(2026), V4 | 위와 동일 스키마+`human_only_time`/`human_with_ai_time` 등 "경제원시지표" facet 신규 추가 | 부록 `aei_v4_appendix.pdf`에 9개 분류기 프롬프트 전문 수록 |
| `release_2026_03_24` | Massenkoff et al.(2026c), V5 | 동일 스키마 유지 | |
| `release_2026_06_26` | Massenkoff et al.(2026a), V6 | 열 이름 재정의: `facet`→`category_name`, `variable`→`metric_id`, `cluster_name`→`node_name`, `level`→`hierarchy_level` | 산출물(artifact) 분류 24종 신규 추가 |
| `labor_market_impacts` | Massenkoff and McCrory(2026b) | 독립 CSV 2종: `job_exposure.csv`, `task_penetration.csv` | (1)과 (2)를 결합한 "관측노출" 산출 파생 데이터 |

이 표가 보여주듯, AEI의 데이터 스키마는 고정되어 있지 않고 릴리스마다 진화해 왔다—R1의 목적별 개별 파일 구조에서 V3부터 장방형 통합 패널로, V6에서 다시 열 이름이 재정의되는 식이다. 이는 AEI 데이터를 `data/proc/`에 흡수할 때 **릴리스별로 파싱 로직을 분리**해야 함을 시사한다.

---

## 2. (1) 과업 노동시간 데이터: 정의와 측정 단위

### 2.1 도입 배경: Tamkin and McCrory(2025)에서 Appel et al.(2026)로

노동시간 데이터는 원래 AEI 공식 시리즈의 일부가 아니라, Tamkin and McCrory(2025)가 별도 응용연구로 개발한 방법론이었다. 이들은 Claude.ai 대화 10만 건 각각에 대해 Claude 자신에게 (i) "AI 지원 없이 전문가가 이 과업을 완료하는 데 걸리는 시간"과 (ii) "AI 지원으로 실제 걸린 시간"을 프롬프트로 직접 추정시켰다—전자는 시간(hour) 단위로, 후자는 분(minute) 단위로 응답하도록 설계되었다(부록 프롬프트 "Human time estimation prompt"/"Interaction time estimation prompt"). 이 방법론은 자기일관성 검정(로그상관 r=0.89–0.93)과 외부 벤치마크(JIRA 티켓, Spearman ρ=0.44–0.50)로 검증되었다.

이 방법론은 이후 Appel et al.(2026, V4 "경제원시지표")에서 AEI 공식 데이터셋의 정식 facet으로 흡수되었다—`release_2026_01_15`부터 `human_only_time`·`human_with_ai_time` facet이 최초로 등장하며, 직전 릴리스(`release_2025_09_15`, V3)의 `data_documentation.md`에는 이 facet이 **존재하지 않음**을 직접 확인했다. 즉 "노동시간 데이터"는 AEI 시리즈 전체가 아니라 **V4(2026년 1월) 이후**에만 공식 데이터로 존재한다.

### 2.2 필드 정의

**표 2. 과업 노동시간 관련 facet 정의**(`release_2026_01_15` `data_documentation.md` 기준)

| facet 이름 | 정의 | 도입 시점 | 비고 |
|---|---|---|---|
| `human_only_time` | 사람이 AI 지원 없이 해당 과업을 완료하는 데 필요한 추정 시간 | V4(2026.1) | Tamkin and McCrory(2025)의 방법론상 시간(hour) 단위로 프롬프트 설계되었으나, 공개 데이터셋 문서에는 단위가 명시되어 있지 않음(§2.4 유의사항 참조) |
| `human_with_ai_time` | 사람이 AI 지원을 받아 해당 과업을 완료하는 데 걸린 추정 시간 | V4(2026.1) | 위와 동일 사유로 방법론상 분(minute) 단위이나, 문서상 단위 미명시 |
| `human_only_ability` | 사람이 AI 없이 해당 과업을 단독으로 완료할 수 있는지 여부 | V4(2026.1) | 범주형(완료가능/완료불가 등); `massenkoff-2026-learning-curves`가 인용한 "인간단독완료불가 비율"(15.35%→14.30%, 2025.11→2026.2)의 원 출처 |
| `task_success` | 해당 과업(대화)이 성공적으로 완료되었는지 여부 | V4(2026.1) | Appel et al.(2026)의 "실효 AI 커버리지" 산출에 사용되는 성공률의 원 필드 |
| `ai_autonomy` | 과업 수행 중 AI가 스스로 결정을 내리는 정도 | V4(2026.1) | 1(전무)~5(매우 높음) 서열 척도(원 보고서 서술 기준) |
| `human_education_years` | 프롬프트를 이해하는 데 필요한 사람의 교육연수 추정치 | V4(2026.1) | Appel et al.(2026)의 순탈숙련(net deskilling) 분석에 사용 |
| `ai_education_years` | Claude의 응답을 이해하는 데 필요한 교육연수 추정치(응답의 "숙련도") | V4(2026.1) | 위와 동일 분석에 사용, 인간-AI 교육연수 상관 r=0.925(국가수준) |
| `use_case` | 대화의 용도 구분(업무/코스워크/개인) | V4(2026.1) | Massenkoff et al.(2026a, V6)의 산출물-용도 교차분석에도 재사용 |

이 8개 facet은 모두 **개별 대화(conversation) 단위로 Claude 자신이 직접 분류·추정한 값**을 O*NET 과업·직업 또는 지리 단위로 집계한 것이다(Appel et al. 2026, "9개 신규 분류기"). 검증은 인간 연구자와의 비교(소표본) 및 방향적 정확성(directional accuracy) 확인에 그치며, 개별 값의 정밀도는 보장되지 않음이 원 보고서에 명시되어 있다.

### 2.3 파일 구조와 집계 통계량

`release_2026_01_15`의 장방형 스키마에서, 위 facet들은 다음과 같은 `variable`(집계통계량) 값을 갖는다: `mean`, `median`, `stdev`, `mean_ci_lower`, `mean_ci_upper`, `median_ci_lower`, `median_ci_upper`, `count`, `histogram_count`, `histogram_pct`. 즉 하나의 과업(`cluster_name`)에 대해 "평균 소요시간이 얼마인가"뿐 아니라 "그 분포의 신뢰구간·히스토그램"까지 함께 제공되어, 단일 평균값이 아니라 분포 전체를 이용한 분석(예: Appel et al. 2026의 speedup 분포 비교)이 가능하도록 설계되어 있다.

시간절감률(time savings)은 저장된 필드가 아니라, `human_only_time`과 `human_with_ai_time`의 평균값으로부터 연구자가 직접 계산하는 **파생 지표**다: $\text{time savings} = 1 - \dfrac{\text{human\_with\_ai\_time}}{\text{human\_only\_time}}$. Tamkin and McCrory(2025)는 이를 Hulten 정리로 집계해 거시 노동생산성 증가율(+1.8%p)을 산출했다.

### 2.4 유의사항: 측정 단위의 문서화 공백

`data_documentation.md`를 직접 조회한 결과, **`human_only_time`·`human_with_ai_time`의 측정 단위(시간 vs 분)는 데이터셋 문서 어디에도 명시되어 있지 않다.** Tamkin and McCrory(2025)의 방법론 절(원 논문 p.5)은 "AI 지원 없이... 시간단위로", "AI 지원으로... 분단위로" 프롬프트를 설계했다고 서술하지만, 이 서술이 V4 공식 데이터셋에 그대로 반영되었는지—즉 두 facet이 서로 다른 단위로 저장되어 있는지, 아니면 공식 데이터셋화 과정에서 단일 단위(예: 분)로 통일되었는지—는 문서만으로 확인할 수 없다. **본 프로젝트가 이 데이터를 `data/proc/`에 적재할 경우, 반드시 원자료 CSV의 실제 표본값(예: 소프트웨어 개발 관련 과업의 `human_only_time` 평균값이 1~10 범위인지 60~600 범위인지)을 직접 확인해 단위를 역으로 검증하는 절차를 do 파일 초반에 넣어야 한다**—이는 재현성 원칙(`CLAUDE.md`)상 반드시 `01_import_*.do`의 주석으로 남겨야 할 사안이다.

---

## 3. (2) 과업·직업별 사용량 데이터: 정의와 측정 단위

### 3.1 원형: R1(Handa et al. 2025)의 flat CSV

R1(`release_2025_02_10`)의 사용량 데이터는 목적별로 분리된 개별 CSV로 존재한다.

- `onet_task_mappings.csv`: 열 `task_name`(과업 기술문), `pct`(해당 과업을 포함하는 대화의 비율)로 구성—O*NET 약 2만 개 과업문 중 Clio가 각 대화를 매핑한 결과를 과업 단위로 집계한 것이다.
- `automation_vs_augmentation.csv`: 열 `interaction_type`(directive/feedback loop/task iteration/learning/validation 5유형), `pct`(해당 패턴을 보이는 대화의 비율)로 구성—협업모드 분류 결과다.
- 이 외 `SOC_Structure.csv`(직업 대분류 체계), `bls_employment_may_2023.csv`(BLS 고용통계), `onet_task_statements.csv`(O*NET 과업 원문), `wage_data.csv`(임금자료)가 매칭·가중치 계산용 보조 테이블로 함께 제공된다.

### 3.2 V3 이후: 장방형 통합 패널

`release_2025_09_15`(V3)부터는 사용량 데이터가 `human_only_time` 계열과 동일한 장방형 스키마(`geo_id`/`geography`/`facet`/`level`/`variable`/`cluster_name`/`value`)로 통합된다. 사용량과 직접 관련된 facet은 다음과 같다.

**표 3. 과업·직업별 사용량 관련 facet 정의**

| facet 이름 | 정의 | `level`(0–2) 의미 | 도입 시점 |
|---|---|---|---|
| `onet_task` | O*NET 과업 단위 사용 비중/건수 | 0=개별 과업, 상위레벨=과업군 | R1(2025.2)부터, V3부터 장방형 스키마로 통합 |
| `soc_occupation` | SOC(Standard Occupational Classification) 직업 단위 사용 비중/건수 | 0=세부직업(6자리), 상위레벨=대분류(2자리) | V3(2025.9)부터 명시적 facet화 |
| `request` | 요청 내용 기반 군집(직업 분류와 독립적인 "요청군집") | 0=최하위 세부과업, 상위=대분류 | V3(2025.9)부터, Fan(2026)이 "두 개의 렌즈" 중 하나로 채택 |
| `collaboration` | 협업모드(자동화 대 증강) 5유형 분류 | 단일 레벨 | R1(2025.2)부터(구 `automation_vs_augmentation.csv`) |
| `multitasking` | 한 대화 내 여러 과업 동시 수행 여부 | 단일 레벨 | V3 이후 |

각 facet의 `variable`(집계통계량)은 `count`(해당 셀에 매핑된 대화 건수)와 `pct`(비율)가 기본이며, `pct`의 정의는 데이터 문서에 "부모 지리 단위 대비 전체 사용량의 비율(국가는 전세계 대비, 미국 주는 소속 국가 대비)"로 명시되어 있다—즉 **분모가 항상 상위 지리 단위의 총사용량**이라는 점이 R1의 flat CSV(분모가 항상 전체 표본)와 구별되는 V3 이후의 특징이다.

### 3.3 "두 개의 렌즈": 직업 렌즈 대 요청 렌즈

Fan(2026)이 명시적으로 정리했듯, AEI의 사용량 데이터는 대화를 두 가지 독립적인 방식으로 분류한다.

1. **직업 렌즈**(`onet_task`→`soc_occupation`): 미국 노동시장 데이터(O*NET)로 훈련된 분류기가 대화를 직업 과업에 매핑. 미국 중심 분류체계이므로 비미국 국가에서는 미분류(not-classified) 비율이 훨씬 높다(Fan 2026 보고: 국가수준 미분류 비율 중앙값이 직업 렌즈 66% vs 요청 렌즈 7%).
2. **요청 렌즈**(`request`): 직업 분류와 무관하게 대화의 내용 자체로 군집화(3단계 위계, 621개 최하위 세부과업→104개 level-1→26개 level-2 대분류). 국가간 비교에는 이 렌즈가 더 안정적이라는 것이 Fan(2026)의 판단이다.

이는 "과업·직업별 사용량"이라는 단일한 개념이 실제로는 **미국 노동시장 프레임에 고정된 지표**(직업 렌즈)와 **프레임에 중립적인 지표**(요청 렌즈)로 나뉜다는 뜻이며, 본 프로젝트가 한국 노동시장과 AEI 데이터를 결합할 때 직업 렌즈를 그대로 쓸 경우 미분류율이 높을 수 있음을 시사한다(§6에서 재론).

### 3.4 지리적 분해와 프라이버시 임계치

`geo_id`는 R1~V2 시기에는 존재하지 않다가, V3(`release_2025_09_15`)부터 도입되었다. 형식은 국가의 경우 ISO-3166-1(V3는 2자리, V4부터는 3자리로 변경), 미국 주의 경우 ISO 3166-2, 그 외 `"GLOBAL"`이다. 셀 포함 여부에는 두 층위의 프라이버시 임계치가 적용된다.

- **국가/지역 단위 포함 임계치**: 국가당 최소 200건 대화, 미국 주당 최소 100건 대화("Minimum Observations", V3·V4 문서에 동일하게 명시)—이 기준 미만인 지역은 데이터셋에서 아예 제외된다("enrichment 단계에서 적용, raw 전처리 단계 아님"이라는 단서도 명시).
- **셀(cell) 단위 억제 임계치**: `reference/notes/appel-2025-uneven-geographic-and-enterprise-ai.md`가 원 보고서에서 확인한 대로, 국가-과업 셀은 최소 15건 대화·5개 고유 계정, 하위(bottom-up) 요청군집은 최소 500건 대화·250개 고유 계정을 충족해야 한다.

두 임계치는 서로 다른 단계에 적용되는 별개의 기준이다(전자는 "이 국가를 데이터셋에 포함할지", 후자는 "이 국가 내에서 이 특정 과업 셀을 노출할지").

### 3.5 파생 지표: AUI

Appel et al.(2025)이 정의한 AUI(Anthropic AI Usage Index, 지역 사용점유율÷지역 근로연령인구점유율)는 **저장된 열이 아니다.** 데이터셋 문서를 직접 확인한 결과 AUI라는 이름의 필드는 어느 릴리스에도 존재하지 않으며, 이는 `soc_occupation`/`request` facet의 `pct` 값과 외부 인구통계(UN/World Bank 근로연령인구 자료)를 연구자가 직접 결합해 사후에 계산하는 지수다. 마찬가지로 Fan(2026)의 확산폭(로그HHI)·강도(PPML 회귀 대상), Fan and Nguyen(2026)의 LCE·ACI도 모두 원자료의 `count`/`pct` 값에 외부 임금·인구 자료를 결합해 연구자가 사후 계산하는 2차 지표이지, AEI가 직접 제공하는 필드가 아니다.

---

## 4. (1)과 (2)의 결합: `labor_market_impacts` 폴더

AEI 저장소에서 (1) 노동시간 데이터와 (2) 사용량 데이터가 실제로 결합되어 있는 유일한 지점은 `labor_market_impacts` 폴더다. 이 폴더는 릴리스 날짜별 하위구조 없이 독립적으로 존재하며, 단 2개의 CSV만 포함한다.

**표 4. `labor_market_impacts` 폴더 구성**

| 파일 | 내용(추정 근거) | Massenkoff and McCrory(2026b) 원 논문과의 대응 |
|---|---|---|
| `task_penetration.csv` | 과업 단위 사용량(usage) 침투도 | 원 논문의 $WorkUsage_t$(과업 t의 가중 업무사용량)에 대응—§2·3의 사용량 데이터를 과업 단위로 정리한 것 |
| `job_exposure.csv` | 직업 단위 "관측노출(observed exposure)" 지수 $R_o$ | Eloundou β(이론노출)를 $WorkUsage_t \geq 100$ 게이트로 걸러 자동화비중 가중치 $\alpha_t$로 집계한 최종 지수—§2의 성공/자동화 관련 필드와 §3의 사용량 필드를 모두 사용해 산출된 **결합형 지표**의 공개 배포판 |

이 구조는 `07_AEI실증연구_노출도사용량_계보.tex`가 논증한 "9편 중 유일한 계산적 결합 사례"가 실제로 데이터셋 저장소에서도 **별도 폴더로 격리되어 배포**되고 있음을 보여준다—즉 Anthropic 스스로도 "순수 사용량 데이터"(릴리스별 폴더)와 "노출×사용 결합 데이터"(`labor_market_impacts`)를 구조적으로 분리해 취급하고 있다.

---

## 5. 선행연구의 AI 노출도·AI 적용률 개념과의 연결

### 5.1 (2) 사용량 데이터 ↔ AI 노출도(exposure) 개념: 예측에서 관측으로

`02_AI노출도_지표_비교.tex`가 정리한 Felten et al.(2021)의 AIOE, Webb(2020)의 특허기반 지수, Eloundou et al.(2023)의 GPT 노출 루브릭은 모두 **직업·과업 단위로 "AI가 그 일을 할 수 있는가"를 사전에 추정**한 스칼라 값이다—크라우드소싱된 인간 평가자, 특허텍스트의 어휘적 유사도, 또는 LLM 평가자가 그 값을 산출한다는 점에서 방법은 다르지만, 공통적으로 **"관측"이 아니라 "판정"**이다.

AEI의 `onet_task`/`soc_occupation`/`request` facet은 이와 근본적으로 다른 종류의 숫자다. `pct`·`count` 값은 판정이 아니라 **이미 일어난 대화의 집계**이며, 따라서 이론적으로는 "노출 가능"하지만 실제로는 전혀 사용되지 않는 과업(Massenkoff and McCrory 2026b가 발견한, Computer & Math 직업군에서 이론노출 94% vs 실제 커버리지 33%의 괴리)을 있는 그대로 드러낸다. 즉 (2) 사용량 데이터는 선행 노출도 지표가 측정하지 못했던 축—"예측된 잠재력 중 실제로 실현된 부분이 얼마인가"—을 직접 관측치로 채워 넣는다. 이것이 정확히 Handa et al.(2025)이 스스로를 "이론적 노출지수와 대비되는 실측(observed usage) 접근"이라 규정한 근거이며, `job_exposure.csv`가 Eloundou β를 $WorkUsage_t$로 게이팅하는 방식은 이 관계를 계산식으로 명시한 것이다.

### 5.2 (1) 노동시간 데이터 ↔ AI 적용률(adoption) 개념: 이분법에서 연속적 실현 크기로

`06_AI채택_실사용_데이터방법론.tex`가 정리한 채택(adoption) 연구—한국 기업활동조사·WPS의 도입 여부 더미, Bick et al.(2026a)의 근로자 자기보고 채택률—는 모두 "AI를 도입/사용하는가"라는 **이분법적** 질문에 응답자가 답하는 구조다. 전병유·신영민(2025)의 AI Firm Exposure(AIFE)는 이분법을 벗어나긴 하지만, 이 역시 "AI 공급기업의 서비스가 이 직업의 과업을 대상으로 존재하는가"라는 **공급 측의 존재 여부**를 LLM이 텍스트 매칭으로 판정한 지표이지, 그 서비스가 실제로 그 과업의 소요시간을 얼마나 줄이는지는 측정하지 않는다.

(1) `human_only_time`/`human_with_ai_time` 데이터는 이 지형에서 한 단계 더 나아간다—"AI를 쓰는가/쓸 수 있는 서비스가 있는가"라는 존재 여부를 넘어, **그 사용이 실제로 과업 소요시간을 몇 퍼센트 줄이는가**라는 연속적 크기(time savings, 0~100%)를 직접 측정한다. 이는 개념적으로 Eloundou et al.(2023)의 β 등급(0/0.5/1의 3단계 서수)이 "이론상 2배 이상 속도향상이 가능한가"라는 질문에 대한 **예측된 상한**이었다면, `human_only_time`/`human_with_ai_time`은 그 예측이 실제 대화에서 **얼마나 실현되었는지를 사후적으로 재는 연속변수**라는 관계로 요약된다. Tamkin and McCrory(2025)가 자신의 연구를 "폭(breadth, 어떤 과업에 AI가 쓰이는가)이 아니라 깊이(depth, 그 과업 내에서 실제로 얼마나 절감되는가)를 포착하는 새 측정"이라 규정한 것이 정확히 이 지점이다.

### 5.3 종합: "이론적 상한 × 실현 정도"라는 공통 구조

두 데이터를 나란히 놓으면, AEI가 암묵적으로 구현하고 있는 구조는 다음과 같이 요약된다.

$$\underbrace{\text{선행 노출도 지표(예: Eloundou }\beta)}_{\text{이론적 상한: 해당 과업이 AI로 처리 가능한가}} \;\times\; \underbrace{\text{AEI 사용량 데이터(§3)}}_{\text{실현 여부: 실제로 관측되었는가}} \;\times\; \underbrace{\text{AEI 노동시간 데이터(§2)}}_{\text{실현 크기: 관측되었다면 얼마나 절감되는가}}$$

`job_exposure.csv`는 이 중 앞의 두 항만을 결합한 것(이론상한×실현여부, 이분법적 게이트)이며, 세 번째 항(실현 크기)까지 결합하는 지표는 AEI 공식 데이터셋에는 아직 존재하지 않는다—Tamkin and McCrory(2025)의 시간절감 집계와 Massenkoff and McCrory(2026b)의 관측노출은 같은 저장소 내에 있지만 두 논문 모두 서로의 지표를 자신의 공식 안에 아직 직접 대입하지는 않았다. 이는 본 프로젝트가 `data/proc/merged/`에서 시도해볼 수 있는, AEI 스스로도 아직 완성하지 않은 결합 지점이다.

---

## 6. 결론: `data/proc/merged/` 설계에 대한 시사점

본 해부가 제공하는 가장 구체적인 시사점은 매칭 키의 설계다. AEI 원자료를 한국 노동시장 데이터(한국고용직업분류, 통계청 기업활동조사 등)와 결합하려면, 다음 세 단계의 크로스워크가 필요하다.

1. **직업 렌즈 사용 시**: `onet_task`/`soc_occupation`의 O*NET/SOC 코드 → (미국 중심 분류체계이므로) 한국고용직업분류(KECO)로의 별도 크로스워크가 필요하며, `05_Felten계승연구_직업분류매칭여부.tex`가 지적했듯 이 크로스워크 자체가 방법론적 선택지가 된다.
2. **요청 렌즈 사용 시**: `request` facet은 직업 분류에 의존하지 않으므로 크로스워크 부담이 적으나, 대신 한국 노동시장 통계(임금·고용 등)와 연결할 표준 매핑이 없어 별도 구축이 필요하다.
3. **시간 데이터 결합 시**: `human_only_time`/`human_with_ai_time`을 사용하려면 §2.4에서 지적한 단위 검증을 반드시 선행해야 하며, 이를 한국 임금 자료(고용형태별근로실태조사 등)와 결합해 화폐가치화하려면 Fan and Nguyen(2026)의 LCE 산식을 참고할 수 있다.

이 세 크로스워크 키(O*NET/SOC 코드, 요청군집 코드, 시간단위 검증)를 `01_import_*.do`의 주석에 명시하는 것이, `CLAUDE.md`가 요구하는 "매칭 키를 log.md 또는 do 파일 주석에 명시" 원칙을 이 데이터에 대해 충족하는 구체적 방법이다.

---

## 참고문헌

`reference/references.bib`에 등재된 다음 문헌을 참고했다: Handa et al.(2025); Appel et al.(2025, 2026); Tamkin and McCrory(2025); Massenkoff and McCrory(2026b); Massenkoff et al.(2026a, 2026c); Fan(2026); Fan and Nguyen(2026); Felten et al.(2021, 2023); Webb(2020); Eloundou et al.(2023); 전병유·신영민(2025). 이 외 `https://huggingface.co/datasets/Anthropic/EconomicIndex`(2026년 9월 조회, README.md 및 6개 릴리스 폴더·`labor_market_impacts` 폴더의 `data_documentation.md`)를 1차 자료로 직접 조회했다.
