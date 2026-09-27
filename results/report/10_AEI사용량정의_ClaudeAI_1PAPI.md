# AEI 실증연구는 "사용량"을 어느 플랫폼으로 정의했는가

### --- Claude.ai 데이터와 1P API 데이터를 합산했는가, 하나만 썼는가, 따로 비교했는가 ---

**AI-effects 프로젝트**

---

## 초록

Anthropic Economic Index(AEI)의 사용량(usage) 데이터는 두 갈래로 공개된다. (1) 소비자용 대화 서비스 **Claude.ai**(Free·Pro·Max, V6부터 Cowork 포함)의 대화 표본과 (2) 개발자·기업이 Anthropic API를 직접 호출하는 **1P(first-party) API** 트래픽 표본이다. 본 노트는 AEI 사용량 데이터를 실증에 활용한 연구 11편이 "사용량"을 두 데이터 중 무엇으로 정의했는지를 원문(PDF)과 원자료 문서로 대조해 정리한다. 결론은 세 가지다. 첫째, 11편 중 5편(Handa et al. 2025; Tamkin and McCrory 2025; Fan 2026; Fan and Nguyen 2026; Bick et al. 2026)은 **Claude.ai만** 사용량으로 정의했다. 둘째, AEI 정기 보고서 4편(V3–V6)은 두 데이터를 **합치지 않고 플랫폼별로 따로 측정해 비교**했으며, 그 안에서도 지리 지표·실효 AI 커버리지·tenure 분석처럼 Claude.ai에만 존재하는 지표가 많다. 셋째, 두 데이터를 **하나의 사용량으로 합산한 연구는 Massenkoff and McCrory(2026)의 관측노출(observed exposure) 하나뿐**이며, 이 합산은 대칭적이지 않다 — Claude.ai는 업무용 대화만, API는 전체 트래픽을 세고, 자동화 가중치에서는 API 사용 전체를 "자동화"로 간주한다. 김수현·이정아(2026)는 이 관측노출을 한국 직업분류에 그대로 이식했으므로 합산 정의를 간접적으로 계승한다.

---

## 1. 서론: 질의와 확인 방법

질의: AEI 사용량 데이터를 활용한 각 연구가 사용량을 어떻게 정의했는지, 특히 **Claude.ai 데이터와 1P API 데이터를 합쳐서 정의했는지, 둘 중 하나만 정의했는지**를 연구별로 정리한다.

확인 방법:

1. 대상 선정: report 07(`07_AEI실증연구_노출도사용량_계보.tex`)이 확정한 AEI 직접 활용 연구 9편에, AEI 과업 점유율을 비교 벤치마크로 쓰는 Bick et al.(2026)과 AEI 관측노출을 한국에 적용한 김수현·이정아(2026)를 더해 11편.
2. 각 연구의 `reference/notes/` 노트로 1차 분류한 뒤, 판단이 갈리는 부분은 `reference/papers/`의 원문 PDF를 텍스트 추출(pdftotext)해 "Claude.ai", "1P API", "first-party" 언급을 전수 검색했다.
3. Massenkoff and McCrory(2026) 부록의 사용량 정의식은 PDF 안에 이미지로 들어 있어 텍스트 추출이 되지 않으므로, 해당 페이지(부록 p.2–3)를 이미지로 렌더링해 수식을 직접 확인했다.
4. 공개 데이터의 플랫폼 구분은 `data/raw/usage/anthropic_economic_index/`에 내려받은 각 릴리스의 `README.md`·`data_documentation.md`로 확인했다.

---

## 2. 두 데이터의 정의와 공개 데이터 구조

**Claude.ai**: 소비자용 채팅 서비스 대화. V6 문서 기준 "Claude chat and Cowork (Free, Pro, and Max plans)". IP 주소 기반으로 국가·미국 주·하위지역이 식별되어 **지리 분해가 가능**하며, 대화 목적(업무/코스워크/개인) 분류가 붙는다.

**1P API**: Anthropic API를 직접 호출하는 개발자·기업 트래픽(Amazon Bedrock·Google Vertex 등 제3자 경유 트래픽은 제외, V6부터 Claude Code 제외). 각 레코드는 단일 입력–출력 쌍이며, **지리 정보가 없어 전세계(GLOBAL) 집계만 공개**된다.

**표 1. 릴리스별 플랫폼 공개 현황(원자료 문서 기준)**

| 릴리스 | Claude.ai | 1P API | 비고 |
|---|---|---|---|
| `release_2025_02_10` (R1) | ○ | × | 과업별 사용 비중(`onet_task_mappings.csv`) |
| `release_2025_03_27` (V2) | ○ | × | `task_pct_v1/v2.csv` |
| `release_2025_09_15` (V3) | ○ (국가·미국 주) | ○ (GLOBAL만) | API 최초 공개, 파일 분리 |
| `release_2026_01_15` (V4) | ○ | ○ | 플랫폼별 raw 파일 분리 |
| `release_2026_03_24` (V5) | ○ | ○ | 플랫폼별 raw 파일 분리 |
| `release_2026_06_26` (V6) | ○ (국가·하위지역) | ○ (GLOBAL만) | `aei_claude_ai_*.csv` / `aei_1p_api_*.csv` |
| `labor_market_impacts` | 합산 | 합산 | `job_exposure.csv`, `task_penetration.csv` |

AEI 정기 릴리스는 한 번도 두 플랫폼을 합친 사용량 파일을 공개한 적이 없다. 두 플랫폼이 합산된 공개 산출물은 Massenkoff and McCrory(2026)의 결과물인 `labor_market_impacts/` 폴더뿐이다.

---

## 3. 연구별 사용량 정의

**표 2. 연구별 사용량 정의(Claude.ai / 1P API)**

| 연구 | 사용 데이터 | Claude.ai | 1P API | 사용량 정의 유형 |
|---|---|---|---|---|
| Handa et al. (2025) [R1] | 2024.12–2025.1, Claude.ai Free·Pro 100만 건(전체 400만+) | 사용 | 미사용(엔터프라이즈·API 제외 명시) | A. Claude.ai 단독 |
| Tamkin and McCrory (2025) | Claude.ai Free·Pro·Max 10만 건 | 사용 | 미사용 | A. Claude.ai 단독 |
| Appel et al. (2025) [V3] | 2025.8, Claude.ai 100만 + 1P API 100만 | 사용(과업·지리) | 사용(3장 기업 사용) | B. 플랫폼별 병렬 비교 |
| Appel et al. (2026) [V4] | 2025.11, Claude.ai 100만 + 1P API 100만 | 사용 | 사용 | B. 플랫폼별 병렬 비교 |
| Massenkoff and McCrory (2026) | V3·V4(2025.8·11), Claude.ai 200만 + 1P API 200만 | 업무용 대화만 | 전체 트래픽 | **C. 합산** |
| Massenkoff et al. (2026), Learning Curves [V5] | 2026.2, Claude.ai 100만 + 1P API 100만 | 사용 | 사용 | B. 플랫폼별 병렬 비교 |
| Massenkoff et al. (2026), Cadences [V6] | 2026.4–6, Claude 대화(chat·Cowork), Claude Code, 1P API | 사용 | 사용 | B. 병렬 비교(+Claude Code). 3장은 C형 관측노출 차용 |
| Fan (2026) | V5 릴리스, Claude.ai 약 80만 건(국가 식별분) | 사용 | 미사용(국가별 미공개) | A. Claude.ai 단독 |
| Fan and Nguyen (2026) | R1–R5, Claude.ai | 사용 | 각주의 보조 추정에만 사용 | A. Claude.ai 단독 |
| Bick et al. (2026) | V2 릴리스(2025.3.27) 과업 점유율 | 사용(비교용) | 미사용 | A. Claude.ai 단독 |
| 김수현·이정아 (2026) | Massenkoff and McCrory(2026) 관측노출 | 간접 | 간접 | C. 합산(계승) |

### 3.1 유형 A: Claude.ai만 사용량으로 정의

- **Handa et al. (2025)**: AEI 최초 보고서. 사용량 = Claude.ai Free·Pro 대화의 O\*NET 과업별 점유율. 자료 설명에서 "엔터프라이즈/API 고객 데이터 제외"를 명시하고, 한계 절에서 API 데이터와는 사용자층·제품 기능이 달라 대표성이 제한된다고 적는다. "직업의 36%가 과업의 25% 이상에서 AI를 사용" 같은 커버리지 수치도 Claude.ai만으로 계산된 것이다.
- **Tamkin and McCrory (2025)**: Claude.ai(Free·Pro·Max) 대화 10만 건으로 과업별 "AI 없이/AI와 함께" 소요시간을 추정하고 이를 Hulten 정리로 집계(연 1.8%p 생산성 효과). 원문은 사용 표본이 Claude.ai 대화로만 구성되어 AI 활용 전체를 대표하지 못한다고 명시한다.
- **Fan (2026)**: V5 릴리스(2026.2)로 국가별 사용 강도(인구 백만 명당 대화 수)와 확산폭(요청군집 HHI)을 측정. 1P API는 국가별로 공개되지 않아 **구조적으로 쓸 수 없었다**고 밝히고, API 스트림의 국가별 공개를 향후 과제로 제시한다. API는 소프트웨어 집중도(컴퓨터·수학 51.6%)를 보여주는 전세계 수치로만 각주에서 인용된다.
- **Fan and Nguyen (2026)**: R1–R5 다섯 웨이브의 Claude.ai 데이터로 노동비용등가(LCE, 연 약 2.7조 달러)와 AI 집중지수(ACI)를 계산. R5 API 표본을 쓰면 API만으로 연 약 1.14조 달러의 잠재 LCE가 나온다는 보조 추정을 각주에 제시하지만, **모든 공식 추정치에서 API는 제외**된다. 저자는 API 트래픽이 컴퓨터·수학직에 치우쳐 있어 Claude.ai만 쓴 ACI가 실제 집중도의 하한일 수 있다고 적는다.
- **Bick et al. (2026)**: 자체 서베이(RPS)가 주 자료이고, AEI는 비교 벤치마크다. 비교에 쓴 것은 "2025년 3월 27일 AEI 릴리스"(V2)의 과업 점유율로, 이 릴리스에는 Claude.ai 데이터만 있다(표 1). 원문 각주는 이후 OpenAI·Anthropic이 기업 사용 데이터를 공개했다고만 언급한다.

### 3.2 유형 B: 두 데이터를 합치지 않고 플랫폼별로 병렬 비교

AEI 정기 보고서 V3–V6은 매번 Claude.ai와 1P API를 각각 100만 건씩 표집하지만, **두 표본을 하나의 사용량으로 합치지 않는다**. 모든 그림·표가 "Claude.ai vs 1P API" 두 패널로 나뉘고, 결론도 두 플랫폼의 차이(예: API는 코딩·자동화 비중이 훨씬 높음)를 보여주는 방식이다. 다만 보고서 안의 개별 지표 중에는 **Claude.ai에만 정의된 것이 많다**는 점이 중요하다.

- **Appel et al. (2025) [V3]**: 1–2장(과업 구성 변화, 국가·미국 주별 Anthropic AI Usage Index(AUI))은 Claude.ai만, 3장(기업 사용, API 비용 지수, 토큰 탄력성)은 1P API만 쓴다. 과업 집중도(지니계수 0.84 vs 0.86)나 자동화 비중(Claude.ai 약 50% vs API 77%)처럼 두 플랫폼을 나란히 놓고 비교할 뿐이다. 원문은 "지리적 사용 패턴은 현재 Claude.ai 트래픽에만 존재한다"고 명시한다.
- **Appel et al. (2026) [V4]**: 경제 원시지표(과업 복잡성, 교육 수준, 용도, 자율성, 성공률)를 두 플랫폼에 각각 적용해 비교한다(예: 업무 비중 API 74% vs Claude.ai 46%). 생산성 추정도 플랫폼별로 따로 하는데, 성공률을 반영하지 않으면 둘 다 연 1.8%p이고 반영하면 Claude.ai 1.2%p, API 1.0%p다. 반면 **실효 AI 커버리지(effective AI coverage)는 Claude.ai만으로 정의**된다(그림 4.4 설명: "based on Claude.ai data. Task coverage is the share of tasks that appear in Claude.ai usage"). 지리 분석도 Claude.ai만 쓴다.
- **Massenkoff et al. (2026), Learning Curves [V5]**: 상위 10대 과업 점유율(Claude.ai 24%→19%, API 28%→33%), 평균 과업 가치, 협업 모드를 플랫폼별로 비교한다. 모델 선택(Opus 비중)–임금 관계도 Claude.ai(+1.48%p)와 API(+2.79%p)를 따로 추정한다. tenure(가입 후 경과 기간) 분석은 가입 계정 단위 개념이라 Claude.ai 이용자 대상이다. 원문은 "signed up for Claude"라고만 쓰며 플랫폼을 명시하지는 않는다.
- **Massenkoff et al. (2026), Cadences [V6]**: 분석 단위를 "Claude 대화(Claude.ai·Cowork)", "Claude Code", "1P API" 셋으로 나눠 따로 보고한다(요일·시간대 리듬, 산출물 분류). Claude Code가 제3의 축으로 추가되었는데, 공개 데이터(V6)에서는 1P API에서도 Claude Code가 제외되어 있다. 3장 설문 분석은 선행연구의 관측노출을 비교 변수로 쓰므로 그 부분만 유형 C 정의를 차용한다.

### 3.3 유형 C: 두 데이터를 합산해 하나의 사용량으로 정의

**Massenkoff and McCrory (2026)**는 두 플랫폼을 하나의 사용량으로 합친 유일한 연구다. 부록 p.2–3의 정의식은 다음과 같다.

- 과업 t의 업무 사용량: **WorkUsage_t = ClaudeWorkUsage_t + APIUsage_t**
  - ClaudeWorkUsage_t: Claude.ai 대화 중 Appel et al.(2026)의 용도 분류상 **업무 관련(work-related)** 으로 분류된 것만 센다. 코스워크·개인용은 제외한다.
  - APIUsage_t: 1P API 트래픽은 업무 여부를 구분하지 않고 **전부** 센다. API 호출은 대개 생산 워크플로에 통합된 사용이기 때문이라고 설명한다.
- 커버리지 관문: WorkUsage_t ≥ 100(직전 두 보고서 Claude.ai 200만 + API 200만 건 기준으로 전체 트래픽의 0.0025%)을 넘어야 과업이 "커버됨"으로 인정된다.
- 과업 노출도: r̃_t = 1{WorkUsage_t ≥ 100} × 1{β_t ≥ 0.5} × α_t
- 자동화 가중치: **α_t = 1/2 + 1/2 × (ClaudeWorkUsage_t × AutoShare_t + APIUsage_t) / (ClaudeWorkUsage_t + APIUsage_t)**
  - AutoShare_t는 **Claude.ai 사용 중** 자동화형 비중이다. 분자에 APIUsage_t가 그대로 더해지므로 **API 사용은 전부 자동화형으로 간주**된다. 원문 예시로, 의료정보 코딩 과업은 사용의 90% 이상이 1P API에서 나와 α가 0.96이 된다.

이 합산은 단순한 "두 표본의 합"이 아니며, 세 가지 비대칭이 있다.

1. **범위의 비대칭**: Claude.ai는 업무용만, API는 전량을 센다. 부록은 이를 "API 사용에 더 큰 가중치를 준다(more weight given to API usage)"고 표현한다.
2. **자동화 판정의 비대칭**: Claude.ai는 대화별 협업 모드 분류로 자동화 비중을 계산하지만, API는 분류 없이 전량 자동화로 처리한다.
3. **결과적 효과**: API 트래픽이 많은 과업(코딩, 고객 응대, 데이터 입력 등)은 관문 통과와 자동화 가중치 두 경로 모두에서 노출도가 올라간다. 본문도 고객서비스 상담원이 2위(70.1%)인 이유로 "주요 과업이 1P API 트래픽에서 점점 더 많이 관측되기 때문"을 든다.

참고: `reference/notes/massenkoff-2026-labor-market-impacts-of-ai.md`는 α_t를 "1/2 + 1/2 × AutomationShare_t"로만 요약해, API 사용이 자동화 비중의 분자에 들어간다는 점이 빠져 있다. 위 식은 부록 원문 p.3에서 직접 확인한 것이다.

**김수현·이정아 (2026)**는 Massenkoff and McCrory(2026)의 직업별 관측노출을 SOC 2018 → ISCO → KSCO 8차 세분류로 연계해 지역별 고용조사와 결합한다. 사용량을 새로 정의하지 않고 관측노출 값을 그대로 이식하므로 합산 정의(유형 C)를 간접적으로 계승한다. 원문은 이 지표를 "Claude 실제 사용 기록"으로만 서술하며, 1P API 트래픽이 합산되어 있다는 점이나 API가 전량 자동화로 가중된다는 점은 언급하지 않는다.

---

## 4. 종합: 무엇을 사용량으로 삼았는가

**표 3. 유형별 요약**

| 유형 | 정의 | 해당 연구 | 이유·특징 |
|---|---|---|---|
| A. Claude.ai 단독 | Claude.ai 대화의 과업·직업·국가별 점유율 또는 건수 | Handa et al. (2025); Tamkin and McCrory (2025); Fan (2026); Fan and Nguyen (2026); Bick et al. (2026) | 초기 릴리스에 API가 없었거나(R1·V2), 국가 단위 분석에 API를 쓸 수 없음(GLOBAL만 공개) |
| B. 병렬 비교 | 두 플랫폼을 각각 측정하고 합치지 않음 | Appel et al. (2025, 2026); Massenkoff et al. (2026, Learning Curves; 2026, Cadences) | 소비자 사용과 기업 배치의 차이 자체가 분석 대상. 지리·실효 커버리지·tenure 지표는 Claude.ai 전용 |
| C. 합산 | WorkUsage = Claude.ai 업무용 + API 전체, API는 전량 자동화 가중 | Massenkoff and McCrory (2026); (계승) 김수현·이정아 (2026) | 노동시장 영향 측정 목적상 "업무 관련 사용"을 넓게 포착하려는 설계 |

11편 중 두 데이터를 합산한 것은 사실상 1개 지표(관측노출)뿐이며, 나머지는 모두 Claude.ai 단독이거나 플랫폼별로 분리되어 있다. Claude.ai 단독 연구가 많은 가장 큰 이유는 데이터 구조다. 1P API는 전세계 합계만 공개되므로 **국가·지역 단위 분석에서는 Claude.ai만이 유일한 선택지**다.

---

## 5. 본 프로젝트에 대한 시사점

1. **한국 단위 사용량은 Claude.ai로만 정의 가능하다.** V6의 `geo_id="KOR"` 행은 `aei_claude_ai_*.csv`에만 존재하고 1P API는 GLOBAL뿐이다(report 09). 따라서 한국 사용량 지표는 유형 A가 될 수밖에 없으며, 한국 기업의 API 배치는 포착하지 못한다는 한계를 명시해야 한다.
2. **`job_exposure.csv`를 쓰면 유형 C가 된다.** `labor_market_impacts/job_exposure.csv`와 `task_penetration.csv`는 Claude.ai 업무용과 API 전체를 합산하고 API를 전량 자동화로 가중한 값이다. 김수현·이정아(2026)처럼 이를 한국에 적용하면, 미국 중심의 전세계 API 배치 패턴이 한국 직업 노출도에 섞여 들어간다.
3. **두 유형을 섞어 비교할 때 주의해야 한다.** 한국 Claude.ai 사용량(유형 A)과 관측노출(유형 C)을 한 모형에서 함께 쓰거나 비교할 경우, 두 지표의 차이 중 일부는 "한국 vs 미국"이 아니라 "API 포함 여부"에서 온다.
4. **재현 가능한 대안.** V6 GLOBAL에서 Claude.ai와 1P API의 과업별 사용량을 각각 가져오면, Massenkoff and McCrory의 합산식을 (i) Claude.ai만, (ii) 합산 두 버전으로 다시 계산해 API 포함 여부의 민감도를 점검할 수 있다. 다만 공개된 `task_penetration.csv`에는 과업 ID·직업 코드가 없고, 가중치 w_t(과업 시간 비중)도 공개되지 않아 원 지표를 정확히 재현하려면 별도 작업이 필요하다.

---

## 6. 보론: GLOBAL 단위에서 두 플랫폼 사용량을 합산할 수 있는가

질의: `geo_id="GLOBAL"` 수준에서 `1p_api`의 사용량과 `claude_ai`의 사용량을 합산할 수 있는가. 1P API는 GLOBAL만 공개되므로(2절) 두 플랫폼을 함께 쓸 수 있는 곳은 GLOBAL 행뿐이다. 아래는 V6(`release_2026_06_26`) 원자료 두 파일을 직접 집계해 확인한 결과다.

결론부터 말하면, **기술적으로는 결합할 수 있지만 두 플랫폼의 상대 규모를 알려주는 정보가 공개되어 있지 않다. 따라서 합산 가중치를 연구자가 가정으로 정해야 한다.** 합산 사용량은 관측된 양이 아니라 가정에 의존하는 구성 지표다.

### 6.1 결합이 가능한 근거

- 두 파일의 GLOBAL 행은 분류 체계(`onet` 과업→DWA→IWA→GWA, `soc_occupation`, `request`)와 지표(`pct`, `use_case_work_pct`, `collaboration_bucket_automation_pct` 등)가 같다. 따라서 `date_start`×`node_external_id`로 1:1 결합할 수 있다.
- 두 파일 모두 2026년 4월·5월 두 달을 담고 있어 기간이 일치한다.

### 6.2 단순 합산이 안 되는 이유

1. **분모가 다르다.** V6의 `pct`는 각 플랫폼 안에서 정규화된 점유율이다. GLOBAL `overall`의 `usage_pct`는 두 파일 모두 100.0이고, 대화 건수·토큰량 같은 규모 지표는 없다. "Claude.ai 트래픽이 1P API의 몇 배인가"를 데이터로 알 수 없으므로, 과업 t의 합산 점유율은 다음과 같이 가중치 w를 외생적으로 정해야만 정의된다.
   - **pct_pooled_t(w) = w × pct_claude_ai_t + (1 − w) × pct_1p_api_t,  0 ≤ w ≤ 1**
2. **이전 릴리스의 count도 해결책이 아니다.** V3–V5의 raw 파일(`aei_raw_*.csv`)에는 `onet_task_count` 같은 건수 변수가 있다. 그러나 이는 플랫폼마다 약 100만 건씩 따로 뽑은 표본의 건수이며 실제 사용 규모를 반영하지 않는다. Massenkoff and McCrory(2026)의 WorkUsage_t = ClaudeWorkUsage_t + APIUsage_t도 두 표본의 크기가 같으므로(각 200만 건), 사실상 위 식에서 **표본 동일 가중**(w≈0.5, 업무용 필터 적용 전 기준)을 암묵적으로 가정한 것이다.
3. **과업 단위 `pct`는 합이 100이 아니고, 공개 과업 집합도 다르다.** 표 4처럼 GLOBAL 과업(레벨 0) `pct`의 합은 100에 못 미친다. 과업에 배정되지 않았거나 공개 임계치에 미달한 부분이 있다는 뜻이다. 두 플랫폼에서 공개된 과업 집합도 일부만 겹친다. 문서는 "누락된 행은 값이 0이라는 뜻이 아니다"라고 명시하므로, 한쪽에만 있는 과업의 다른 쪽 값을 0으로 채우는 것도 가정이다. 공개 과업끼리 다시 정규화할지도 함께 정해야 한다.
4. **두 플랫폼의 성격이 크게 다르다.** 업무용 비중과 자동화 비중이 두 배 가까이 차이 난다(표 4). 그래서 합산 결과의 과업 구성이 w에 민감하게 달라진다.

**표 4. V6 GLOBAL 행의 플랫폼별 비교(원자료 직접 집계)**

| 항목 | claude_ai 2026.4 | 1p_api 2026.4 | claude_ai 2026.5 | 1p_api 2026.5 |
|---|---|---|---|---|
| `overall` `usage_pct` | 100.0 | 100.0 | 100.0 | 100.0 |
| `overall` `use_case_work_pct` (%) | 45.53 | 82.19 | 43.36 | 84.03 |
| `overall` `collaboration_bucket_automation_pct` (%) | 48.98 | 93.66 | 48.62 | 94.22 |
| 과업(레벨 0) `pct` 합계 (%) | 88.40 | 81.13 | 94.32 | 85.00 |
| 공개 과업 수 | 2,410 | 1,992 | 2,713 | 2,295 |
| 두 플랫폼 공통 과업 수 | 1,577 (합집합 2,825) | | 1,815 (합집합 3,193) | |

### 6.3 권고: 합산은 민감도 분석용으로

1. **기본 사양은 플랫폼별 분리(유형 B)로 둔다.** 합산 지표는 본 분석이 아니라 민감도 분석용으로 만든다.
2. 합산할 때는 적어도 다음 세 버전을 함께 제시한다. (i) Claude.ai 단독(w=1), (ii) 표본 동일 가중(w=0.5, Massenkoff and McCrory(2026)와 같은 암묵적 가정), (iii) Massenkoff and McCrory(2026)식 업무용 필터 버전. (iii)은 Claude.ai 쪽을 pct_claude_ai_t × use_case_work_pct_t / 100으로 줄이고 1P API는 전량 반영한다. 여기에 w를 0에서 1까지 바꿔 가며 주요 결과가 얼마나 달라지는지 보고한다.
3. 한쪽 플랫폼에만 공개된 과업을 어떻게 처리했는지(0 대체 여부, 재정규화 여부)를 do 파일 주석과 `log.md`에 명시한다.
4. 어떤 버전이든 GLOBAL 합산값은 **전세계 직업·과업 구성 지표**일 뿐이며, 한국 사용 강도(`geo_id="KOR"`, Claude.ai 전용; report 09)와는 성격이 다른 지표임을 명시한다.

---

## 참고문헌

- Appel, R., McCrory, P., Tamkin, A., McCain, M., Neylon, T., and Stern, M. (2025). *The Anthropic Economic Index Report: Uneven Geographic and Enterprise AI Adoption*.
- Appel, R., Massenkoff, M., McCrory, P., McCain, M., Heller, R., Neylon, T., and Tamkin, A. (2026). *The Anthropic Economic Index Report: Economic Primitives*.
- Bick, A., Blandin, A., Deming, D. J., and Schumacher, T. (2026). *What Work Does Generative AI Do?*
- Fan, R. Y. (2026). *What Countries Use AI, and What For? Intensity and Breadth of AI Adoption Across Over 100 Countries*.
- Fan, R. Y., and Nguyen, H. M. (2026). *Aggregate Gains from AI and Their Distribution: Global Evidence from Usage Data*.
- Handa, K., Tamkin, A., McCain, M., et al. (2025). *Which Economic Tasks are Performed with AI? Evidence from Millions of Claude Conversations*.
- Massenkoff, M., and McCrory, P. (2026). *Labor Market Impacts of AI: A New Measure and Early Evidence* (및 부록).
- Massenkoff, M., Lyubich, E., McCrory, P., Appel, R., and Heller, R. (2026). *The Anthropic Economic Index Report: Learning Curves*.
- Massenkoff, M., Lyubich, E., Sacher, S., Hitzig, Z., Zhang, S., Heller, R., and McCrory, P. (2026). *Anthropic Economic Index Report: Cadences*.
- Tamkin, A., and McCrory, P. (2025). *Estimating AI Productivity Gains from Claude Conversations*.
- 김수현·이정아 (2026). 「생성형 인공지능이 국내 노동시장에 미치는 영향」, 『고용이슈』 2026 여름호.
