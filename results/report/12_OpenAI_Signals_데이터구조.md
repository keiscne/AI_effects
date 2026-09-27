# OpenAI Signals 데이터의 구조와 활용 가능성

### --- 파일 구성, 방법론, 한국 가용성, 그리고 AEI와의 비교 ---

**AI-effects 프로젝트**

---

## 초록

OpenAI는 2026년부터 "Signals"라는 이름으로 ChatGPT 소비자 사용 데이터를 CC BY 4.0 라이선스로 공개하고 있다. 본 노트는 2026년 9월 27일에 내려받은 **Signals v2.0**(2024년 7월–2026년 6월, 월별 24개월)의 파일 구성과 방법론을 원자료와 데이터 사전(data dictionary)으로 확인하고, 같은 페이지에서 제공되는 **AI Jobs Transition Framework** 직업 분류 데이터를 함께 정리한다. 핵심은 다음과 같다. (1) Signals는 매월 소비자 ChatGPT 메시지 30만 건을 LLM 분류기로 분류해 **업무 관련 여부, 주제(7개), Ask/Do/Express, 연령, 이름 기반 성별**의 점유율을 국가별(최대 135개국)로 공개한다. 한국(`KR`)도 모든 국가 단위 파일에 24개월 전부 들어 있다. (2) 그러나 **직업(SOC) 분류와 절감시간은 없고**, 과업에 가까운 O\*NET IWA(중간 업무활동) 분류는 **미국만** 공개된다. 대화 건수도 없이 차등정보보호(differential privacy) 잡음이 들어간 점유율만 있다. (3) 따라서 Signals는 한국의 직업별 사용량을 직접 주지는 못하며, AEI로 만든 한국 직업별 지표를 **업무 사용 비중·용도 구성의 시계열**로 보완하는 자료로 쓰는 것이 적절하다. (4) AI Jobs Transition Framework는 미국 O\*NET-SOC 923개 직업을 4개 유형(AI와 함께 성장, 재편, 자동화 위험 높음, 당장 변화 적음)으로 나눈 **노출도 계열 분류**이며, 한국 직업분류에 연계해 쓸 수 있다.

---

## 1. 자료 개요

- **공개 페이지**: https://openai.com/signals/ (한국어판 https://openai.com/ko-KR/signals/). 데이터와 방법론은 "Data and methodology" 페이지(`/signals/data-download/`)에서 받는다.
- **버전**: Signals v2.0. 데이터 사전 서버 날짜 2026-08-06.
- **라이선스**: CC BY 4.0. 권장 인용은 Chatterji, Cunningham, Deming, Hitzig, Johnston, Richmond, Ong, Shan, Wadman, "OpenAI Signals v2.0"이다(`openai-2026-signals-v2`).
- **로컬 위치**:
  - `data/raw/usage/openai_signals/signals_v2.0/` — `data-download-csv.zip`, 압축을 푼 `public_release_csv/`(CSV 25개), `data-dictionary.pdf`
  - `data/raw/exposure/openai_ai_jobs_transition_framework/release_2026_06_01/` — 직업 분류 CSV와 README
  - 각 폴더의 `_download_manifest.md`에 URL, 서버 날짜, MD5를 기록했다.
- **웹에만 있는 자료**: Enterprise Signals(기업용 ChatGPT 사용, 산업·직무별)는 페이지 안 차트로만 공개되고 내려받을 파일이 없다. Signals 웹페이지의 차트용 JSON은 CSV와 값이 겹쳐 받지 않았다.

---

## 2. 방법론 (데이터 사전 기준)

| 항목 | 내용 |
|---|---|
| 모집단 | 소비자 ChatGPT(Free, Plus, Pro, Go) 메시지. 신고 연령 18세 이상 계정만 |
| 제외 | 기업용(Enterprise 등) 메시지, Codex, 계정 삭제자, 학습 데이터 사용 거부자 |
| 표본 | 매월 메시지 30만 건(v1.1부터, 이전 기간도 소급 확대). 모든 시계열이 같은 전세계 표본에서 나온다 |
| 분석 단위 | **메시지**(대화가 아님) |
| 가중치 | 일(day) 단위 가중치로 월 안의 날짜별 구성을 실제에 맞춤(최대 1.5) |
| 분류 | LLM 분류기가 자동 분류. 연구자는 원문을 보지 않음. 분류 프롬프트 전문은 데이터 사전 9절에 수록 |
| 성별 | 이름 기반 추정(특정 성별 비중 95% 초과 이름만). 자기 보고가 아님 |
| 공개 형태 | 점유율(`share_of_messages`, 0–1) 또는 1인당 사용 순위(`rank`). **건수는 없음** |
| 반올림 | 소수 셋째 자리(IWA 파일은 다섯째 자리). 그래서 월별 합이 정확히 1이 되지 않음 |
| 차등정보보호 | 셀 단위 가우시안 잡음 추가. 공개 1회당 (ε=1, δ=1/N). 2025년 12월 이전 자료는 세 번 재공개되어 누적 ε=4 |
| 셀 억제 | 가중치·잡음 반영 후 유효 메시지 수가 100 이하인 칸은 공개하지 않음(v2.0에서 도입) |

변경 이력: v1.1(2026년 1–3월 추가, 월 표본 10만→30만 건, 업무/학업/기타 분류 추가, 국가 순위를 분기별로 변경), v2.0(2026년 4–6월 추가, 셀 억제 도입, 국가별 세분 시계열 8개 추가, 월 0.5% 미만 메시지 제거에 따른 소급 수정).

---

## 3. 파일 구성

**표 1. Signals v2.0 CSV 25개**

| 구분 | 파일(`share_of_messages_by_…`) | 차원 | 지역 | 기간 | 한국 |
|---|---|---|---|---|---|
| 업무 여부 | `work_related_month` | 업무(1)/비업무(0) | 전세계 | 24개월 | — |
| | `work_related_country_month` | 같음 | 135개국 | 24개월 | ○ (전 칸) |
| | `work_related_plan_type_month` | × 요금제(free, plus, pro, go) | 전세계 | 22개월(2024.9–) | — |
| | `work_schoolwork_month` | 업무/학업/기타 | 전세계 | 24개월 | — |
| 주제 | `topic_month` | 주제 7개 | 전세계 | 24개월 | — |
| | `topic_country_month` | 같음 | 134개국 | 24개월 | ○ (전 칸) |
| | `topic_work_related_month` | 업무 여부별 주제 구성 P(주제 \| 업무 여부) | 전세계 | 24개월 | — |
| | `topic_work_related_country_month` | 같음 | 125개국 | 24개월 | ○ (전 칸) |
| | `work_related_topic_month` | 주제별 업무 비중 P(업무 여부 \| 주제) | 전세계 | 24개월 | — |
| 의도 | `work_related_ask_do_express_month` | 업무 여부 × Ask/Do/Express | 전세계 | 24개월 | — |
| | `work_related_ask_do_express_country_month` | 같음 | 125개국 | 24개월 | ○ (전 칸) |
| 연령 | `age_group_month` | 연령 6구간 | 전세계 | 24개월 | — |
| | `age_group_country_month` | 같음 | 124개국 | 24개월 | ○ (전 칸) |
| | `age_group_topic_month` | 주제별 연령 구성 | 전세계 | 24개월 | — |
| | `age_group_topic_country_month` | 같음 | 92개국 | 24개월 | △ (93% 칸) |
| 성별(이름 기반) | `global_…_by_gender_month` | 남성형/여성형 | 전세계 | 24개월 | — |
| | `gender_country_month` | 같음 | 119개국 | 24개월 | ○ (전 칸) |
| | `gender_topic_month` | 주제별 성별 구성 | 전세계 | 24개월 | — |
| | `gender_topic_country_month` | 같음 | 86개국 | 24개월 | △ (57% 칸) |
| 순위 | `country_quarter_rank` | 1인당 사용 순위 | 150개국(분기별 143–148) | 6분기(2025Q1–2026Q2) | ○ |
| 미국 | `usa_…_by_onet_iwa_month` | O\*NET IWA 165개(기타 포함) | 미국 | 24개월 | — |
| | `usa_share_of_work_related_…_by_onet_iwa_month` | 업무 메시지 중 IWA 구성 | 미국 | 24개월 | — |
| | `usa_…_by_state_2025_rank` | 주별 1인당 순위 | 미국 51개 주 | 2025년 | — |
| | `usa_…_by_topic_2025`, `usa_…_by_topic_state_2025` | 주제 구성(전국, 주별) | 미국 | 2025년 | — |

주제 7개는 Writing, Practical Guidance, Seeking information, Technical help, Multimedia, Self-expression, Other/Unknown이다. 세부 분류(예: computer_programming, tutoring_or_teaching)를 묶은 것이며 대응표는 데이터 사전 5절 각주에 있다. 연령은 18–24, 25–34, 35–44, 45–54, 55–64, 65+의 6구간이다.

`topic_work_related_month`와 `work_related_topic_month`는 이름이 비슷하지만 조건부 방향이 반대인 서로 다른 파일이다. 미국 IWA 파일 두 개도 분모(전체 메시지 / 업무 메시지)가 다른 서로 다른 파일이다.

---

## 4. 한국 데이터

국가 단위 파일 9개 모두에 한국(`country="KR"`)이 들어 있다. 한국 칸이 일부 빠지는 파일은 세 차원을 교차한 두 개(연령×주제, 성별×주제)뿐이다(셀 억제). 한국 행으로 할 수 있는 것은 다음과 같다.

- 업무 관련 메시지 비중의 월별 추이(24개월)
- 업무/비업무별 주제 구성, Ask/Do/Express 구성
- 연령·성별 구성과 1인당 사용 순위(분기)

예시로 업무 관련 비중을 보면, 한국은 2024년 7월 55.3%에서 2026년 6월 32.1%로, 전세계는 51.3%에서 30.4%로 낮아졌다. 한국의 1인당 사용 순위는 2025년 1분기 57위(148개국 중)에서 2026년 2분기 25위(147개국 중)로 올라갔다. 이 수치는 원자료를 직접 집계한 참고값이며, 분석에 쓸 때는 do 파일로 다시 만든다.

한국 행으로 **할 수 없는 것**은 직업별 사용량, 과업(O\*NET task·IWA)별 사용량, 절감시간이다. IWA는 미국만 있고, 직업(SOC) 분류는 어느 지역에도 없다.

---

## 5. AEI와의 비교

**표 2. OpenAI Signals v2.0과 AEI(V5·V6) 비교**

| 항목 | OpenAI Signals v2.0 | Anthropic Economic Index (V5·V6) |
|---|---|---|
| 플랫폼 | 소비자 ChatGPT만(기업·Codex 제외) | Claude.ai(소비자·Cowork) + 1P API(GLOBAL) |
| 분석 단위 | 메시지 | 대화(Claude.ai), 입력–출력 한 쌍(API) |
| 기간 | 2024.7–2026.6 **매월 연속** | 1주(V5, 2026.2) 또는 2개월(V6, 2026.4–5) 스냅샷 |
| 표본 | 월 30만 메시지 | 릴리스당 약 100만 건 |
| 규모 정보 | 없음(점유율·순위만) | V5는 건수 있음, V6는 점유율만 |
| 분류 | 업무 여부, 주제 7개, Ask/Do/Express, (미국) IWA | O\*NET 과업, SOC 직업, 요청 군집, 협업 유형 |
| 직업 분류 | **없음** | SOC 세부직업(GLOBAL), 국가는 대분류·세부직업 점유율 |
| 절감시간 | **없음** | 과업·직업별 AI 없이/AI 활용 시 소요시간 |
| 인구학 변수 | 연령, 이름 기반 성별 | 없음 |
| 국가 범위 | 최대 135개국(한국 포함, 24개월) | 약 117개국(한국 포함) |
| 프라이버시 처리 | 차등정보보호 잡음 + 유효 100건 이하 억제 | 최소 건수 임계치(칸 비공개) |

두 자료는 서로를 대체하지 않는다. AEI는 **직업·과업 구성과 절감시간**을, Signals는 **업무 사용 비중과 용도 구성의 월별 추이, 인구학적 구성**을 준다.

---

## 6. AI Jobs Transition Framework 직업 분류

같은 다운로드 페이지에서 받을 수 있는 이 자료는 사용량이 아니라 **직업별 AI 영향 분류**다. 그래서 `data/raw/exposure/`에 따로 두었다.

- 1행 = 미국 O\*NET-SOC 세부직업 1개(2019 코드 체계), 923개. 2024년 추정 고용 합계 1억 5,209만 명.
- **유형(archetype) 4개**와 해당 직업 수, 고용:

| 유형 | 직업 수 | 고용(2024 추정) |
|---|---|---|
| Jobs that grow with AI (AI와 함께 성장) | 151 | 1,803만 |
| Jobs that will reorganize (재편) | 232 | 3,525만 |
| Jobs at higher automation risk (자동화 위험 높음) | 91 | 2,687만 |
| Jobs with less immediate change (당장 변화 적음) | 449 | 7,194만 |

- **인간 필요성 범주**(`human_necessity_category`): none, physical, relational, regulatory_accountability.
- **노동수요 탄력성**(`labor_demand_elasticity`): 프레임워크의 메커니즘 입력값. 77개 값.
- 임금, 이론적 노출도, 실제(revealed) 노출도 점수는 공개하지 않는다(README).
- **주의**: README는 조인 키를 `onet_soc_code`라고 하지만 실제 열 이름은 `occupation_code`다. 고용 열은 쉼표가 들어간 문자열이라 숫자로 바꿔야 한다.

한국에 쓰려면 O\*NET-SOC 2019 → SOC 2018 → ISCO-08 → KSCO 연계가 필요하다. 이는 report 04·05에서 정리한 노출도 이식형 연구와 같은 경로다.

---

## 7. 본 프로젝트에 대한 시사점

1. **한국 직업별 사용량은 여전히 AEI에 의존한다.** Signals에는 직업 분류가 없다.
2. **Signals는 한국 사용의 "업무 비중"과 "용도 구성"을 월별로 준다.** AEI 스냅샷(V5 2026.2, V6 2026.4–5)의 한국 값이 어떤 추세 위에 있는지 보여 주는 보조 시계열로 쓸 수 있다. 다만 플랫폼(ChatGPT vs Claude)과 단위(메시지 vs 대화)가 다르다.
3. **미국 IWA 시계열은 AEI와 과업 수준에서 연결할 수 있다.** AEI의 O\*NET 과업은 O\*NET의 과업→DWA→IWA 계층으로 올릴 수 있으므로, 미국에 한해 두 플랫폼의 업무활동 구성을 비교할 수 있다.
4. **규모 추정(report 11)에는 도움이 되지 않는다.** Signals도 건수를 공개하지 않는다.
5. **해석상 주의**: 모든 값에 차등정보보호 잡음이 들어가 있고, 한국처럼 표본이 작은 국가의 교차 칸(연령×주제, 성별×주제)은 오차가 크거나 억제되어 있다. 또 기업용 사용이 빠져 있어 업무 사용을 과소 측정한다(데이터 사전 명시).
6. **후속 작업**: `code/01_import_openai_signals.do`(CSV를 불러 `data/proc/usage/openai_signals/`에 저장), `code/01_import_openai_ajtf.do`(직업 분류를 불러 `data/proc/exposure/openai_ai_jobs_transition_framework/`에 저장)를 작성한다.

---

## 참고문헌·자료

- Chatterji, A., Cunningham, T., Deming, D. J., Hitzig, Z., Johnston, D., Richmond, A. M., Ong, C., Shan, C. Y., and Wadman, K. (2026). *OpenAI Signals v2.0*. OpenAI. https://cdn.openai.com/signals/data-dictionary.pdf (CC BY 4.0, 2026-09-27 접속)
- OpenAI (2026). *The AI Jobs Transition Framework*. https://cdn.openai.com/pdf/the-ai-jobs-transition-framework_report.pdf (2026-09-27 접속)
- Anthropic Economic Index 관련 자료는 report 08–11 참고.
