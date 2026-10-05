# Sensor Tower 이용자 수 기반 AI 어시스턴트 월간 메시지·업무용 대화 데이터 구축

### --- 원자료와 구축 과정 ---

**AI-effects 프로젝트**

> 이 .md는 같은 이름의 .tex를 읽기 쉽게 옮긴 것이다. 표 수치는 `results/table/17_*.tex`(`code/04_analysis_sensortower_messages_summary.do` 생성)에서 그대로 가져왔다.

---

## 초록

본 문서는 Sensor Tower *State of AI 2026*의 True Audience 이용자 수, Chatterji et al.(2025)의 ChatGPT 주간 메시지 수, OpenAI Signals v2.0의 국가별 업무용 메시지 비중을 결합해 만든 다섯 가지 데이터의 원자료와 구축 과정을 기록한다. 다섯 가지는 (1) 제품별 월간 메시지 수, (2) 국가별 월간 메시지 수, (3) Worldwide 월간 메시지 수, (4) 국가별 월간 업무용 메시지 수, (5) Worldwide 월간 업무용 메시지 수와 업무용 대화량이다. 구축은 두 단계다. 1단계(`02_clean_sensortower_share_all_products.do`)는 True Audience 이용자 수를 시장 × 월로 합산해 국가별 점유율을 만들고, 국가 시트가 있는 18개국의 제품별 이용자 수를 합해 제품별 점유율(18개국 기준)을 만든다. 2단계(`03_merge_sensortower_openai_messages.do`)는 세 가정을 둔다. "모든 제품의 이용자 1인당 메시지 수가 같다", "전 세계 메시지 중 18개국 비중이 모든 제품·시기에서 같다", "모든 제품의 업무용 메시지 비중이 같다"이다. 먼저 ChatGPT 2025년 7월 전 세계 월 메시지(797.1억 건)에 AEI Claude.ai 2025년 8월의 18개국 대화 비중(61.0%)을 곱해 18개국 메시지(486.3억 건)를 구한다. 이를 18개국 ChatGPT 이용자(9.05억 명)로 나누면 1인당 월 메시지 수는 53.75건이다. 이 값을 이용자 수에 곱하고 국가별 ChatGPT 업무 비중을 적용한다. 그 결과 8개 제품 합계 월간 메시지(Worldwide 25개 시장)는 2025년 7월 921억 건, 2026년 5월 1,284억 건이다. 2026년 5월 업무용 메시지는 410억 건(31.9%)이고, 대화당 메시지가 3건이면 업무용 대화는 137억 건이다. 이 값들은 세 가정에 전적으로 의존하므로 "관측값"이 아니라 "가정 아래의 규모 추정"으로 읽어야 한다.

---

## 1. 목적과 개요

이 저장소의 목표는 AI 노출도(exposure)에 실제 사용량(usage)을 결합하는 것이다. 사용량 자료는 대부분 **비중**(점유율, 업무 비중, 과업 구성)만 공개하고 **규모**(건수)는 공개하지 않는다. 본 문서의 데이터는 이 빈칸을 메우려고 만들었다. 가장 신뢰할 만한 한 시점의 규모값(ChatGPT 2025년 7월 주 메시지 180억 건)을 Sensor Tower의 제품별·국가별 이용자 수로 넓혀 **제품 × 국가 × 월 단위의 메시지 규모**를 만든다.

1. **점유율**(1단계): True Audience 이용자 수 → 국가별 전체 제품 점유율(⑮), 제품별 18개국 합계 이용자와 점유율(⑯)
2. **1인당 메시지**: ChatGPT 2025년 7월 전 세계 월 메시지 × 18개국 비중(AEI) ÷ ChatGPT 2025년 7월 18개국 이용자
3. **메시지 수**: 1인당 메시지 × 이용자 수 → 제품별, 국가별, Worldwide
4. **업무용 메시지**: 국가 메시지 × 그 국가의 ChatGPT 업무 비중(Signals)
5. **대화량**: 업무용 메시지 ÷ 대화당 메시지 수 k ∈ {1.5, 3, 5, 7, 10}

번호 ①–⑯은 원자료 폴더의 `_download_manifest.md`와 report 13의 데이터셋 번호를 따른다.

---

## 2. 원자료

**표 1. 원자료**

| 자료 | 파일 | 내용 | 단위·범위 |
|---|---|---|---|
| Sensor Tower ① | `sensortower_true_audience_monthly_long.csv` | 제품별 중복 제거 독립 앱+웹 월간 이용자 수(True Audience) | 명. 19개 시장(Worldwide + 18개국) × 8개 제품 × 2023-04~2026-05 |
| Sensor Tower ⑥ | `sensortower_true_audience_share_monthly_long.csv` | ①의 제품별 점유율(Sensor Tower 공개값) | %, 소수 첫째 자리. 검증용 |
| Chatterji et al.(2025) | `scaling_parameters_public.csv`의 `chatterji_msgs_week_2025_07` | ChatGPT 주 메시지 180억 건(2025년 7월, p.1) | 백만 건 |
| AEI release 2025-09-15 | `aei_raw_claude_ai_2025-08-04_to_2025-08-11.csv` | Claude.ai 국가별 대화 비중(`usage_pct`) | %. 173개국, 2025-08-04~08-11(1주) |
| OpenAI Signals v2.0 | `share_of_messages_by_work_related_country_month.csv`, `…_work_related_month.csv` | ChatGPT 메시지 중 업무 관련(1)/비업무(0) 비중 | 비율(0–1). 국가별·전 세계, 2024-07~2026-06 |

### 2.1 Sensor Tower True Audience(①, ⑥)

Sensor Tower *State of AI 2026*의 차트 "Deduplicated Standalone App & Web Users for Top AI Assistants"에서 추출한 값이다(report 13). 한 제품 안에서 앱과 웹 이용자의 중복을 제거한 월간 이용자 수다. 8개 항목(ChatGPT, Google Gemini, Claude, Microsoft Copilot, Perplexity, DeepSeek, Grok, Other)으로 나뉜다. 다른 앱에 내장된 AI 이용자(예: WhatsApp 안의 Meta AI)는 빠진다.

- **Worldwide는 25개 시장 합계**이고 국가 시트는 18개국뿐이다. 나머지 7개 시장은 이름이 공개되지 않아 "Worldwide − 18개국 합계"로 한 행(residual)을 만든다.
- 여러 어시스턴트를 쓰는 사람은 **제품마다 한 번씩** 센다. 제품을 합산한 값은 사람 수가 아니라 "제품별 이용자 수의 합"이다.
- 값은 유효숫자 약 3자리로 반올림되어 있다. ⑥(공개 점유율)은 소수 첫째 자리 값이다.

### 2.2 Chatterji et al.(2025)의 기준값

OpenAI 연구진의 NBER 논문 Chatterji et al.(2025)은 "2025년 7월까지 7억 명이 매주 180억 건의 메시지를 보냈다"고 쓴다(p.1). 범위는 소비자 요금제(Free, Plus, Pro)다. 이 값을 고른 이유와 한계는 report 15에서 다루었다. 월간 환산은 report 15와 같이 "주간 × 그 달 일수 ÷ 7"로 한다.

### 2.3 AEI의 18개국 대화 비중

기준값은 전 세계 ChatGPT 메시지인데 1인당 메시지의 분모(⑯)는 18개국 이용자다. 따라서 분자도 18개국 몫으로 줄여야 한다. ChatGPT의 국가별 메시지 비중은 공개되지 않으므로(Signals는 순위만 공개) Anthropic Economic Index(AEI) release 2025-09-15의 Claude.ai 국가별 대화 비중을 쓴다(Appel et al., 2025).

- 표본 기간은 2025년 8월 4~11일(1주)로, 기준값(2025년 7월)과 약 1개월 차이다.
- `usage_pct`의 분모는 공개된 173개국 대화 합계다(합 100%, do 파일에서 검사).
- 18개국(ISO 3166-1 alpha-2로 매칭) 합계는 61.01%다.
- 비교로 본 다른 후보: AEI 2026년 2월 59.0%, 4월 61.0%, 5월 63.3%. Sensor Tower ChatGPT의 18개국 비중(2025년 7월, 18개국 ÷ Worldwide)은 앱 세션 61.0%, 앱+웹 이용시간 67.0%, 웹 방문 69.6%다.

### 2.4 OpenAI Signals v2.0 업무 관련 비중

Signals는 매월 소비자 ChatGPT 메시지 표본(약 30만 건)을 LLM 분류기로 분류해 점유율만 공개한다(report 12). `work_related` = 1은 업무 관련 메시지다. 국가별 파일은 135개국을 포함하며 Sensor Tower 18개국은 24개월 모두 있다. 국가 코드는 ISO 3166-1 alpha-2, 월은 `YYYY-MM-01` 형식이다. 차등정보보호 잡음이 들어 있다.

---

## 3. 1단계: 점유율 데이터(`02_clean_sensortower_share_all_products.do`)

### 3.1 국가별 전체 제품 점유율(⑮)

월 t, 시장 c에 대해 8개 제품 이용자 수를 합한다.

- all_users(c,t) = Σ_p users(c,p,t)
- share_all_products_pct(c,t) = 100 × all_users(c,t) / all_users(Worldwide,t)

18개국에 residual 행을 더하면 합이 100%가 된다(do 파일에서 검사). 보조 변수 `share_within_18_pct`는 분모를 18개국 합계로 둔 값이다. 산출 파일은 `sensortower_share_all_products_monthly_{long.csv, long.dta, wide.csv}`다(긴 형식 722행 = 38개월 × 19행).

### 3.2 제품별 18개국 합계 이용자와 점유율(⑯)

①의 Worldwide(25개 시장) 행 대신, 국가 시트가 있는 18개국의 제품별 이용자 수를 합한다(나머지 7개 시장 residual은 제외).

- users(18,p,t) = Σ_{c∈18} users(c,p,t)
- share_ww_pct(p,t) = 100 × users(18,p,t) / Σ_q users(18,q,t)

18개국은 25개 시장 ChatGPT 이용자의 약 91%다(2025년 7월 9.05억 명 대 9.94억 명). ①은 유효숫자 약 3자리로 반올림되어 있다. 그래서 이용자가 거의 18개국에만 있는 소규모 제품·월 10개 셀(Claude 2023년 5~6월, Grok 2023년 11월~2024년 11월 일부)에서는 18개국 합계가 Worldwide를 최대 0.67% 넘는다(do 파일은 1%까지 허용).

비교용으로 Sensor Tower 공개 Worldwide 점유율 ⑥을 붙였다. 차이(`diff_pp`)는 이제 반올림뿐 아니라 시장 범위 차이(18개국 대 25개 시장)를 함께 담는다.

- 상관은 0.9993이다.
- 차이의 절댓값은 평균 0.40%p, 최대 3.66%p다(Google Gemini 2024-02: 14.8% 대 18.5%).
- 참고로 25개 시장 기준으로 계산했던 이전 버전(2026-10-04)에서는 ⑥과의 차이가 최대 0.11%p였다. 공개 점유율이 "제품 이용자 수 ÷ 8개 항목 합계"로 재현됨을 그때 확인했다.

산출 파일은 `sensortower_share_worldwide_by_product_monthly_long.{csv, dta}`다(304행, `market` = "18 countries", 공개값 `share_pct_st`와 차이 `diff_pp` 포함).

두 산출물은 사용자 지정에 따라 원자료 폴더(`data/raw/macro/scaling/sensortower_state_of_ai_2026/`)에 저장된다. CLAUDE.md의 "가공 데이터는 `data/proc/`" 규칙의 예외이며 manifest에 기록했다.

---

## 4. 2단계: 메시지 수(`03_merge_sensortower_openai_messages.do`)

### 4.1 가정

- **(A1) 모든 제품의 이용자 1인당 월 메시지 수는 같다.** 구현상 이 값은 시점과 국가에 따라서도 변하지 않는다. 2025년 7월 ChatGPT 값 하나를 2023-04~2026-05의 모든 제품·국가에 쓴다.
- **(A2) 모든 제품의 업무용 메시지 비중은 같다.** 그 비중은 국가별로 Signals의 ChatGPT 업무 비중과 같다고 둔다.
- **(A3) 전 세계 메시지 중 18개국 비중은 모든 제품·시기에서 같다.** 그 비중은 AEI Claude.ai 2025년 8월 4~11일의 18개국 대화 비중(61.01%)과 같다고 둔다.

### 4.2 이용자 1인당 메시지 수

**표 2. 이용자 1인당 월 메시지 수 산출**

| 항목 | 값 |
|---|---:|
| ChatGPT 주 메시지(억 건, 2025-07, 전 세계) | 180.0 |
| ChatGPT 월 메시지(억 건, 전 세계) = 주 메시지 × 31/7 | 797.1 |
| 18개국 비중(%, AEI Claude.ai 2025-08-04~08-11) | 61.01 |
| ChatGPT 월 메시지(억 건, 18개국) = 전 세계 × 18개국 비중 | 486.3 |
| ChatGPT True Audience 이용자(억 명, 18개국 합계) | 9.05 |
| 이용자 1인당 월 메시지(건) | 53.75 |

m = (180억 × 31/7 × s18) ÷ ChatGPT 2025년 7월 18개국 True Audience 이용자(⑯), s18 = 0.6101(A3).

m은 s18에 정비례한다. s18을 2.3절의 다른 후보(59.0~69.6%)로 바꾸면 m은 52.0~61.3건이 된다. 모든 메시지·업무용 메시지·대화량도 같은 비율로 바뀐다(업무 비중과 국가·제품 구성은 바뀌지 않는다).

### 4.3 제품별·국가별·Worldwide 메시지 수

- messages(p,t) = m × users(18,p,t) (18개국 합계)
- messages(c,t) = m × all_users(c,t) (residual 포함)
- messages(WW,t) = m × Σ_p users(WW,p,t) (25개 시장)

residual과 25개 시장에도 같은 m을 곱한다. do 파일은 매월 "제품 합계 = 18개국 국가 합계"와 "국가 합계(18개국 + residual) = Worldwide"를 검사한다. 2025년 7월 ChatGPT 메시지(18개국)가 797.1억 건 × 0.6101 = 486.3억 건과 같은지도 검사한다.

**표 3. 제품별 18개국 합계 이용자(억 명)와 월간 메시지(억 건)**

| 제품 | 이용자 2024-07 | 이용자 2025-07 | 이용자 2026-05 | 메시지 2024-07 | 메시지 2025-07 | 메시지 2026-05 |
|---|---:|---:|---:|---:|---:|---:|
| ChatGPT | 4.62 | 9.05 | 10.11 | 248.09 | 486.31 | 543.32 |
| Google Gemini | 0.79 | 3.08 | 6.05 | 42.73 | 165.74 | 324.99 |
| Claude | 0.23 | 0.45 | 2.22 | 12.10 | 24.08 | 119.39 |
| Microsoft Copilot | 0.21 | 0.37 | 0.36 | 11.09 | 19.84 | 19.12 |
| Perplexity | 0.20 | 0.93 | 0.62 | 11.01 | 49.96 | 33.12 |
| DeepSeek | 0.00 | 0.59 | 0.47 | 0.12 | 31.84 | 25.08 |
| Grok | 0.01 | 0.54 | 0.68 | 0.64 | 29.07 | 36.66 |
| Other | 0.41 | 0.54 | 1.04 | 22.04 | 29.24 | 56.01 |
| 합계 | 6.47 | 15.56 | 21.54 | 347.82 | 836.08 | 1157.69 |

(A1) 때문에 제품별 메시지 비중은 이용자 비중(⑯)과 똑같다. 예를 들어 Claude의 2026년 5월 메시지 비중은 18개국 이용자 비중 10.3%와 같다. 제품 간 1인당 사용 강도 차이는 반영되지 않는다(report 15에서 본 앱 세션·웹 방문 차이 등).

### 4.4 업무용 메시지 수

work_messages(c,t) = messages(c,t) × work_share(c,t). work_share는 Signals 국가별 `work_related` = 1 비중이다.

- residual 행(나머지 7개 시장)은 국가를 알 수 없어 Signals **전 세계** 비중을 쓴다(`work_share_src` = 2).
- Worldwide 업무용 메시지는 18개국과 residual의 합이다. 비교용으로 "Worldwide 메시지 × Signals 전 세계 비중"(`work_messages_global`)도 저장한다.
- Signals가 2024-07부터 있으므로 업무용 파일은 2024-07~2026-05(23개월)만 포함한다.
- 매칭은 Sensor Tower 시장명을 ISO 3166-1 alpha-2로 바꾼 코드와 월(Signals `YYYY-MM-01`의 앞 7자리)로 한다. 18개국 모두 23개월 내내 Signals 값이 있다(검사).

**표 4. 국가별 월간 메시지와 업무용 메시지(2026년 5월)**

| 시장 | 이용자(백만 명) | 점유율(%) | 메시지(억 건) | 업무 비중(%) | 업무용 메시지(억 건) | 업무용 대화(k=3, 억 건) |
|---|---:|---:|---:|---:|---:|---:|
| India | 724.0 | 30.3 | 389.2 | 33.2 | 129.2 | 43.1 |
| United States | 293.6 | 12.3 | 157.8 | 32.1 | 50.7 | 16.9 |
| Brazil | 209.6 | 8.8 | 112.6 | 35.4 | 39.9 | 13.3 |
| Indonesia | 126.9 | 5.3 | 68.2 | 40.8 | 27.8 | 9.3 |
| Japan | 101.7 | 4.3 | 54.7 | 27.8 | 15.2 | 5.1 |
| Mexico | 92.6 | 3.9 | 49.8 | 29.1 | 14.5 | 4.8 |
| Turkey | 74.9 | 3.1 | 40.3 | 18.6 | 7.5 | 2.5 |
| Germany | 69.1 | 2.9 | 37.1 | 26.1 | 9.7 | 3.2 |
| South Korea | 61.0 | 2.6 | 32.8 | 31.7 | 10.4 | 3.5 |
| France | 59.8 | 2.5 | 32.1 | 25.5 | 8.2 | 2.7 |
| Vietnam | 58.3 | 2.4 | 31.4 | 31.8 | 10.0 | 3.3 |
| United Kingdom | 56.3 | 2.4 | 30.3 | 32.6 | 9.9 | 3.3 |
| Spain | 53.3 | 2.2 | 28.7 | 29.8 | 8.5 | 2.8 |
| Italy | 47.6 | 2.0 | 25.6 | 30.5 | 7.8 | 2.6 |
| Canada | 39.8 | 1.7 | 21.4 | 32.9 | 7.0 | 2.3 |
| Argentina | 38.4 | 1.6 | 20.7 | 29.1 | 6.0 | 2.0 |
| Australia | 26.1 | 1.1 | 14.0 | 39.7 | 5.6 | 1.9 |
| Taiwan | 20.7 | 0.9 | 11.1 | 33.5 | 3.7 | 1.2 |
| 나머지 7개 시장(residual) | 235.3 | 9.8 | 126.4 | 30.5 | 38.6 | 12.9 |
| Worldwide(합계) | 2389.1 | 100.0 | 1284.1 | 31.9 | 410.1 | 136.7 |

주: 이용자는 8개 제품 True Audience 이용자 수의 합이다(중복 계산 포함). 업무 비중은 Signals 국가별 ChatGPT 값이다. residual은 Signals 전 세계 값, Worldwide 행은 함의된 비중(업무용 메시지 ÷ 메시지)이다.

### 4.5 업무용 대화량

대화당 메시지 수 k에 대한 공개 자료가 없으므로 격자로 둔다. conv_kK = work_messages / K, K ∈ {1.5, 3, 5, 7, 10}. 변수 이름은 `conv_k1p5`, `conv_k3`, `conv_k5`, `conv_k7`, `conv_k10`이며 국가별·Worldwide 업무용 파일에 모두 들어 있다.

**표 5. Worldwide 월간 메시지, 업무용 메시지, 업무용 대화(억 건)**

| 월 | 메시지 | 업무 비중 함의(%) | Signals 전 세계(%) | 업무용 메시지 | 대화 k=1.5 | k=3 | k=5 | k=7 | k=10 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 2024-07 | 379.7 | 53.8 | 51.3 | 204.5 | 136.3 | 68.2 | 40.9 | 29.2 | 20.4 |
| 2024-08 | 406.1 | 51.1 | 48.3 | 207.6 | 138.4 | 69.2 | 41.5 | 29.7 | 20.8 |
| 2024-09 | 458.8 | 49.3 | 46.6 | 226.4 | 150.9 | 75.5 | 45.3 | 32.3 | 22.6 |
| 2024-10 | 502.1 | 48.1 | 45.4 | 241.6 | 161.1 | 80.5 | 48.3 | 34.5 | 24.2 |
| 2024-11 | 539.9 | 46.8 | 43.7 | 252.8 | 168.6 | 84.3 | 50.6 | 36.1 | 25.3 |
| 2024-12 | 555.0 | 43.2 | 40.1 | 239.6 | 159.7 | 79.9 | 47.9 | 34.2 | 24.0 |
| 2025-01 | 630.3 | 43.6 | 40.3 | 274.7 | 183.1 | 91.6 | 54.9 | 39.2 | 27.5 |
| 2025-02 | 703.8 | 41.9 | 38.9 | 295.0 | 196.7 | 98.3 | 59.0 | 42.1 | 29.5 |
| 2025-03 | 762.5 | 40.0 | 37.6 | 305.1 | 203.4 | 101.7 | 61.0 | 43.6 | 30.5 |
| 2025-04 | 806.7 | 37.8 | 35.2 | 304.7 | 203.1 | 101.6 | 60.9 | 43.5 | 30.5 |
| 2025-05 | 842.6 | 38.0 | 35.5 | 319.9 | 213.2 | 106.6 | 64.0 | 45.7 | 32.0 |
| 2025-06 | 866.7 | 35.7 | 33.3 | 309.4 | 206.3 | 103.1 | 61.9 | 44.2 | 30.9 |
| 2025-07 | 921.1 | 34.1 | 31.4 | 314.0 | 209.4 | 104.7 | 62.8 | 44.9 | 31.4 |
| 2025-08 | 963.6 | 32.9 | 30.6 | 316.6 | 211.1 | 105.5 | 63.3 | 45.2 | 31.7 |
| 2025-09 | 1028.2 | 35.0 | 33.0 | 360.0 | 240.0 | 120.0 | 72.0 | 51.4 | 36.0 |
| 2025-10 | 1057.8 | 35.8 | 33.9 | 378.2 | 252.1 | 126.1 | 75.6 | 54.0 | 37.8 |
| 2025-11 | 1067.7 | 35.2 | 33.6 | 376.2 | 250.8 | 125.4 | 75.2 | 53.7 | 37.6 |
| 2025-12 | 1070.3 | 32.4 | 30.5 | 347.1 | 231.4 | 115.7 | 69.4 | 49.6 | 34.7 |
| 2026-01 | 1092.7 | 32.7 | 30.7 | 357.1 | 238.0 | 119.0 | 71.4 | 51.0 | 35.7 |
| 2026-02 | 1102.5 | 32.5 | 30.8 | 357.8 | 238.5 | 119.3 | 71.6 | 51.1 | 35.8 |
| 2026-03 | 1193.5 | 32.6 | 31.0 | 388.8 | 259.2 | 129.6 | 77.8 | 55.5 | 38.9 |
| 2026-04 | 1250.8 | 33.3 | 31.7 | 416.2 | 277.5 | 138.7 | 83.2 | 59.5 | 41.6 |
| 2026-05 | 1284.1 | 31.9 | 30.5 | 410.1 | 273.4 | 136.7 | 82.0 | 58.6 | 41.0 |

주: "함의" = 18개국 + residual 업무용 메시지 합 ÷ Worldwide 메시지.

함의된 Worldwide 업무 비중은 모든 달에서 Signals 전 세계 비중보다 1.4–3.3%p 높다. Sensor Tower 25개 시장의 이용자 구성이 Signals 전 세계 메시지 구성과 다르기 때문이다. 예를 들어 2026년 5월 이용자 비중이 30%인 인도의 업무 비중은 33.2%로 전 세계 30.5%보다 높다. 업무 비중은 2024년 7월 약 54%에서 2026년 5월 약 32%로 낮아졌는데, 이는 Signals ChatGPT 업무 비중 하락을 그대로 옮긴 것이다.

---

## 5. 산출 파일

`data/proc/macro/scaling/sensortower_state_of_ai_2026/`, 각 .csv/.dta.

| 파일 | 주요 변수 | 행 수 | 키 |
|---|---|---:|---|
| `sensortower_messages_by_product_monthly` | `unique_users`, `ww_total_users`, `share_ww_pct`, `msgs_per_user`, `messages` | 304 | assistant × month |
| `sensortower_messages_by_country_monthly` | `iso2`, `residual`, `all_users`, `share_all_products_pct`, `messages` | 722 | market × month |
| `sensortower_messages_worldwide_monthly` | `worldwide_users`, `msgs_per_user`, `messages` | 38 | month |
| `sensortower_work_messages_by_country_monthly` | `work_share`, `work_share_src`, `work_messages`, `nonwork_messages`, `conv_k*` | 437 | market × month |
| `sensortower_work_messages_worldwide_monthly` | `work_share_implied`, `work_messages`, `work_share_global`, `work_messages_global`, `conv_k*` | 23 | month |

기간은 메시지 파일이 2023-04~2026-05(38개월), 업무용 파일이 2024-07~2026-05(23개월)다. 국가별 파일은 18개국 + residual(월당 19행)이다. 요약표는 `results/table/17_sensortower_messages.xlsx`에도 있다.

---

## 6. 해석상 주의와 한계

1. **(A1)의 강도.** 제품·국가·시점에 걸쳐 1인당 메시지가 같다고 두었다. 실제로는 2024년 6월~2025년 7월에 ChatGPT 메시지가 5.9배 늘 때 이용자는 1.9배 늘어 1인당 사용이 크게 변했다(report 15). 따라서 2025년 7월에서 멀어질수록 오차가 커진다. 특히 2024년 이전 메시지는 과대, 2026년 메시지는 과소일 가능성이 크다. 제품별로도 사용 강도가 다르다(예: Claude 이용자는 대부분 웹 이용자).
2. **(A2)의 강도.** 업무 비중을 ChatGPT 값으로 통일했다. 그래서 업무 중심 제품(Claude, Copilot)의 업무용 메시지는 과소 추정될 수 있다. 반대로 일반 소비자 중심 제품이 많은 국가의 업무용 메시지는 과대 추정될 수 있다. 이 점은 report 18에서 AEI와 비교해 점검한다.
3. **(A3)과 범위 보정.** 기준값 180억 건은 전 세계 ChatGPT(소비자 요금제) 값이고 분모는 18개국 독립 앱+웹 이용자이므로, 18개국 비중 61.01%로 분자를 줄였다. 이 비중은 ChatGPT가 아니라 Claude.ai의 국가 분포다. report 18에서 보듯 AEI는 Sensor Tower보다 고소득국 비중이 커서 ChatGPT의 실제 18개국 비중과 다를 수 있다. 시점도 기준값(2025년 7월)과 약 1개월 어긋난다. 후보 값의 범위(59.0~69.6%)만큼 모든 규모가 비례해서 달라진다. API, 기업 요금제, 앱 내장 AI 사용은 빠진다.
4. **중복 계산.** 국가 메시지는 제품별 이용자 수 합에 1인당 값을 곱한 것이므로 "그 국가 모든 제품 메시지의 합"이다. 여러 어시스턴트를 쓰는 사람의 메시지는 제품 수만큼 더해진다. 이는 (A1) 아래에서 일관적이다.
5. **대화량.** 대화당 메시지 수 k는 근거 자료가 없어 1.5–10의 격자로만 제시한다. 대화량은 k에 반비례하므로 메시지 수보다 훨씬 불확실하다.
6. **반올림과 잡음.** Sensor Tower 이용자 수(유효숫자 3자리)와 Signals 비중(차등정보보호 잡음, 소수 셋째 자리)의 오차가 그대로 전파된다.

---

## 7. 재현

Stata 17에서 다음 순서로 실행한다.

1. `code/02_clean_sensortower_share_all_products.do`: ⑮, ⑯(원자료 폴더에 저장)
2. `code/02_clean_sensortower_share_within_product.do`: 제품 내 국가 비중(report 18에서 사용)
3. `code/03_merge_sensortower_openai_messages.do`: 위 다섯 데이터(AEI release 2025-09-15 원자료를 직접 읽어 s18을 계산)
4. `code/04_analysis_sensortower_messages_summary.do`: 본 문서의 표(`results/table/17_*.tex`, `.xlsx`)

## 참고문헌

- Appel, R., McCrory, P., Tamkin, A., McCain, M., Neylon, T., and Stern, M. (2025). The Anthropic Economic Index Report: Uneven Geographic and Enterprise AI Adoption. Anthropic, September 15, 2025.
- Chatterji, A., Cunningham, T., Deming, D. J., Hitzig, Z., Ong, C., Shan, C. Y., and Wadman, K. (2025). How People Use ChatGPT. NBER Working Paper 34255.
- Chatterji, A. et al. (2026). OpenAI Signals v2.0. OpenAI, dataset and data dictionary.
- Sensor Tower (2026). State of AI 2026. Sensor Tower report (Infogram).
