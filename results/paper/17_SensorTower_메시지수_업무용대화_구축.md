# Sensor Tower 이용자 수 기반 AI 어시스턴트 월간 메시지·업무용 대화 데이터 구축

### --- 원자료와 구축 과정 ---

**AI-effects 프로젝트**

> 이 .md는 같은 이름의 .tex를 읽기 쉽게 옮긴 것이다. 표 수치는 `results/table/17_*.tex`(`code/04_analysis_sensortower_messages_summary.do` 생성)에서 그대로 가져왔다.

---

## 초록

본 문서는 Sensor Tower *State of AI 2026*의 True Audience 이용자 수, Chatterji et al.(2025)의 ChatGPT 주간 메시지 수, OpenAI Signals v2.0의 국가별 업무용 메시지 비중을 결합해 만든 다섯 가지 데이터의 원자료와 구축 과정을 기록한다. 다섯 가지는 (1) 제품별 월간 메시지 수, (2) 국가별 월간 메시지 수, (3) Worldwide 월간 메시지 수, (4) 국가별 월간 업무용 메시지 수, (5) Worldwide 월간 업무용 메시지 수와 업무용 대화량이다. 구축은 두 단계다. 1단계(`02_clean_sensortower_share_all_products.do`)는 True Audience 이용자 수를 시장 × 월로 합산해 국가별 점유율을 만들고, Worldwide 안의 제품별 점유율을 다시 계산해 Sensor Tower 공개 점유율과 대조한다. 두 값은 304개 셀 모두에서 0.11%p 안에서 일치한다. 2단계(`03_merge_sensortower_openai_messages.do`)는 두 가정을 둔다. "모든 제품의 이용자 1인당 메시지 수가 같다"와 "모든 제품의 업무용 메시지 비중이 같다"이다. 이 아래에서 ChatGPT 2025년 7월 값으로 얻은 1인당 월 메시지 수(약 80건)를 이용자 수에 곱하고 국가별 ChatGPT 업무 비중을 적용한다. 그 결과 8개 제품 합계 월간 메시지는 2025년 7월 1,374억 건, 2026년 5월 1,916억 건이다. 2026년 5월 업무용 메시지는 612억 건(31.9%)이고, 대화당 메시지가 3건이면 업무용 대화는 204억 건이다. 이 값들은 두 가정에 전적으로 의존하므로 "관측값"이 아니라 "가정 아래의 규모 추정"으로 읽어야 한다.

---

## 1. 목적과 개요

이 저장소의 목표는 AI 노출도(exposure)에 실제 사용량(usage)을 결합하는 것이다. 사용량 자료는 대부분 **비중**(점유율, 업무 비중, 과업 구성)만 공개하고 **규모**(건수)는 공개하지 않는다. 본 문서의 데이터는 이 빈칸을 메우려고 만들었다. 가장 신뢰할 만한 한 시점의 규모값(ChatGPT 2025년 7월 주 메시지 180억 건)을 Sensor Tower의 제품별·국가별 이용자 수로 넓혀 **제품 × 국가 × 월 단위의 메시지 규모**를 만든다.

1. **점유율**(1단계): True Audience 이용자 수 → 국가별 전체 제품 점유율(⑮), 제품별 Worldwide 점유율(⑯)
2. **1인당 메시지**: ChatGPT 2025년 7월 월 메시지 ÷ ChatGPT 2025년 7월 이용자
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
| OpenAI Signals v2.0 | `share_of_messages_by_work_related_country_month.csv`, `…_work_related_month.csv` | ChatGPT 메시지 중 업무 관련(1)/비업무(0) 비중 | 비율(0–1). 국가별·전 세계, 2024-07~2026-06 |

### 2.1 Sensor Tower True Audience(①, ⑥)

Sensor Tower *State of AI 2026*의 차트 "Deduplicated Standalone App & Web Users for Top AI Assistants"에서 추출한 값이다(report 13). 한 제품 안에서 앱과 웹 이용자의 중복을 제거한 월간 이용자 수다. 8개 항목(ChatGPT, Google Gemini, Claude, Microsoft Copilot, Perplexity, DeepSeek, Grok, Other)으로 나뉜다. 다른 앱에 내장된 AI 이용자(예: WhatsApp 안의 Meta AI)는 빠진다.

- **Worldwide는 25개 시장 합계**이고 국가 시트는 18개국뿐이다. 나머지 7개 시장은 이름이 공개되지 않아 "Worldwide − 18개국 합계"로 한 행(residual)을 만든다.
- 여러 어시스턴트를 쓰는 사람은 **제품마다 한 번씩** 센다. 제품을 합산한 값은 사람 수가 아니라 "제품별 이용자 수의 합"이다.
- 값은 유효숫자 약 3자리로 반올림되어 있다. ⑥(공개 점유율)은 소수 첫째 자리 값이다.

### 2.2 Chatterji et al.(2025)의 기준값

OpenAI 연구진의 NBER 논문 Chatterji et al.(2025)은 "2025년 7월까지 7억 명이 매주 180억 건의 메시지를 보냈다"고 쓴다(p.1). 범위는 소비자 요금제(Free, Plus, Pro)다. 이 값을 고른 이유와 한계는 report 15에서 다루었다. 월간 환산은 report 15와 같이 "주간 × 그 달 일수 ÷ 7"로 한다.

### 2.3 OpenAI Signals v2.0 업무 관련 비중

Signals는 매월 소비자 ChatGPT 메시지 표본(약 30만 건)을 LLM 분류기로 분류해 점유율만 공개한다(report 12). `work_related` = 1은 업무 관련 메시지다. 국가별 파일은 135개국을 포함하며 Sensor Tower 18개국은 24개월 모두 있다. 국가 코드는 ISO 3166-1 alpha-2, 월은 `YYYY-MM-01` 형식이다. 차등정보보호 잡음이 들어 있다.

---

## 3. 1단계: 점유율 데이터(`02_clean_sensortower_share_all_products.do`)

### 3.1 국가별 전체 제품 점유율(⑮)

월 t, 시장 c에 대해 8개 제품 이용자 수를 합한다.

- all_users(c,t) = Σ_p users(c,p,t)
- share_all_products_pct(c,t) = 100 × all_users(c,t) / all_users(Worldwide,t)

18개국에 residual 행을 더하면 합이 100%가 된다(do 파일에서 검사). 보조 변수 `share_within_18_pct`는 분모를 18개국 합계로 둔 값이다. 산출 파일은 `sensortower_share_all_products_monthly_{long.csv, long.dta, wide.csv}`다(긴 형식 722행 = 38개월 × 19행).

### 3.2 제품별 Worldwide 점유율(⑯)과 공개값 대조

Worldwide 시장 안에서 제품 p의 비중을 ①에서 다시 계산한다. share_ww_pct(p,t) = 100 × users(WW,p,t) / Σ_q users(WW,q,t).

⑥의 Worldwide 행과 정의가 같으므로 두 값을 `assistant` × `month`로 붙여 대조했다. 결과는 다음과 같다.

- 304개 셀(8개 제품 × 38개월)이 모두 짝지어졌고 상관은 1.0000이다.
- 차이의 절댓값은 평균 0.025%p, 최대 0.108%p다(ChatGPT 2026-02: 51.19% 대 51.3%).
- ⑥의 반올림 폭(0.05%p)을 넘는 셀은 24개이며, ①의 유효숫자 3자리 반올림으로 설명된다.

따라서 Sensor Tower의 공개 점유율은 "제품 이용자 수 ÷ 8개 항목 합계"로 정확히 재현된다. ①을 규모 계산의 바탕으로 써도 공개 점유율과 어긋나지 않는다. 산출 파일은 `sensortower_share_worldwide_by_product_monthly_long.{csv, dta}`다(304행, 공개값 `share_pct_st`와 차이 `diff_pp` 포함).

두 산출물은 사용자 지정에 따라 원자료 폴더(`data/raw/macro/scaling/sensortower_state_of_ai_2026/`)에 저장된다. CLAUDE.md의 "가공 데이터는 `data/proc/`" 규칙의 예외이며 manifest에 기록했다.

---

## 4. 2단계: 메시지 수(`03_merge_sensortower_openai_messages.do`)

### 4.1 가정

- **(A1) 모든 제품의 이용자 1인당 월 메시지 수는 같다.** 구현상 이 값은 시점과 국가에 따라서도 변하지 않는다. 2025년 7월 ChatGPT 값 하나를 2023-04~2026-05의 모든 제품·국가에 쓴다.
- **(A2) 모든 제품의 업무용 메시지 비중은 같다.** 그 비중은 국가별로 Signals의 ChatGPT 업무 비중과 같다고 둔다.

### 4.2 이용자 1인당 메시지 수

**표 2. 이용자 1인당 월 메시지 수 산출**

| 항목 | 값 |
|---|---:|
| ChatGPT 주 메시지(억 건, 2025-07) | 180.0 |
| ChatGPT 월 메시지(억 건) = 주 메시지 × 31/7 | 797.1 |
| ChatGPT True Audience 이용자(억 명, Worldwide 25개 시장) | 9.94 |
| 이용자 1인당 월 메시지(건) | 80.20 |

m = (180억 × 31/7) ÷ ChatGPT 2025년 7월 Worldwide True Audience 이용자(⑯).

### 4.3 제품별·국가별·Worldwide 메시지 수

- messages(p,t) = m × users(WW,p,t)
- messages(c,t) = m × all_users(c,t) (residual 포함)
- messages(WW,t) = m × Σ_p users(WW,p,t)

do 파일은 매월 "제품 합계 = 국가 합계(18개국 + residual) = Worldwide"를 검사한다. 2025년 7월 ChatGPT 메시지가 기준값 797.1억 건과 같은지도 검사한다.

**표 3. 제품별 Worldwide 이용자(억 명)와 월간 메시지(억 건)**

| 제품 | 이용자 2024-07 | 이용자 2025-07 | 이용자 2026-05 | 메시지 2024-07 | 메시지 2025-07 | 메시지 2026-05 |
|---|---:|---:|---:|---:|---:|---:|
| ChatGPT | 5.02 | 9.94 | 11.10 | 402.58 | 797.14 | 890.17 |
| Google Gemini | 0.88 | 3.31 | 6.62 | 70.73 | 265.45 | 530.89 |
| Claude | 0.25 | 0.49 | 2.45 | 19.73 | 39.30 | 196.48 |
| Microsoft Copilot | 0.23 | 0.40 | 0.39 | 18.12 | 31.84 | 30.88 |
| Perplexity | 0.23 | 0.99 | 0.68 | 18.12 | 79.71 | 54.45 |
| DeepSeek | 0.00 | 0.82 | 0.76 | 0.31 | 65.68 | 60.79 |
| Grok | 0.01 | 0.60 | 0.78 | 0.95 | 48.20 | 62.63 |
| Other | 0.45 | 0.59 | 1.12 | 36.01 | 46.99 | 89.66 |
| 합계 | 7.06 | 17.14 | 23.89 | 566.56 | 1374.31 | 1915.95 |

(A1) 때문에 제품별 메시지 비중은 이용자 비중(⑯)과 똑같다. 예를 들어 Claude의 2026년 5월 메시지 비중은 이용자 비중 10.3%와 같다. 제품 간 1인당 사용 강도 차이는 반영되지 않는다(report 15에서 본 앱 세션·웹 방문 차이 등).

### 4.4 업무용 메시지 수

work_messages(c,t) = messages(c,t) × work_share(c,t). work_share는 Signals 국가별 `work_related` = 1 비중이다.

- residual 행(나머지 7개 시장)은 국가를 알 수 없어 Signals **전 세계** 비중을 쓴다(`work_share_src` = 2).
- Worldwide 업무용 메시지는 18개국과 residual의 합이다. 비교용으로 "Worldwide 메시지 × Signals 전 세계 비중"(`work_messages_global`)도 저장한다.
- Signals가 2024-07부터 있으므로 업무용 파일은 2024-07~2026-05(23개월)만 포함한다.
- 매칭은 Sensor Tower 시장명을 ISO 3166-1 alpha-2로 바꾼 코드와 월(Signals `YYYY-MM-01`의 앞 7자리)로 한다. 18개국 모두 23개월 내내 Signals 값이 있다(검사).

**표 4. 국가별 월간 메시지와 업무용 메시지(2026년 5월)**

| 시장 | 이용자(백만 명) | 점유율(%) | 메시지(억 건) | 업무 비중(%) | 업무용 메시지(억 건) | 업무용 대화(k=3, 억 건) |
|---|---:|---:|---:|---:|---:|---:|
| India | 724.0 | 30.3 | 580.6 | 33.2 | 192.8 | 64.3 |
| United States | 293.6 | 12.3 | 235.5 | 32.1 | 75.6 | 25.2 |
| Brazil | 209.6 | 8.8 | 168.0 | 35.4 | 59.5 | 19.8 |
| Indonesia | 126.9 | 5.3 | 101.8 | 40.8 | 41.5 | 13.8 |
| Japan | 101.7 | 4.3 | 81.6 | 27.8 | 22.7 | 7.6 |
| Mexico | 92.6 | 3.9 | 74.2 | 29.1 | 21.6 | 7.2 |
| Turkey | 74.9 | 3.1 | 60.1 | 18.6 | 11.2 | 3.7 |
| Germany | 69.1 | 2.9 | 55.4 | 26.1 | 14.5 | 4.8 |
| South Korea | 61.0 | 2.6 | 48.9 | 31.7 | 15.5 | 5.2 |
| France | 59.8 | 2.5 | 47.9 | 25.5 | 12.2 | 4.1 |
| Vietnam | 58.3 | 2.4 | 46.8 | 31.8 | 14.9 | 5.0 |
| United Kingdom | 56.3 | 2.4 | 45.2 | 32.6 | 14.7 | 4.9 |
| Spain | 53.3 | 2.2 | 42.8 | 29.8 | 12.7 | 4.2 |
| Italy | 47.6 | 2.0 | 38.2 | 30.5 | 11.6 | 3.9 |
| Canada | 39.8 | 1.7 | 31.9 | 32.9 | 10.5 | 3.5 |
| Argentina | 38.4 | 1.6 | 30.8 | 29.1 | 9.0 | 3.0 |
| Australia | 26.1 | 1.1 | 20.9 | 39.7 | 8.3 | 2.8 |
| Taiwan | 20.7 | 0.9 | 16.6 | 33.5 | 5.6 | 1.9 |
| 나머지 7개 시장(residual) | 235.3 | 9.8 | 188.7 | 30.5 | 57.5 | 19.2 |
| Worldwide(합계) | 2389.1 | 100.0 | 1915.9 | 31.9 | 611.9 | 204.0 |

주: 이용자는 8개 제품 True Audience 이용자 수의 합이다(중복 계산 포함). 업무 비중은 Signals 국가별 ChatGPT 값이다. residual은 Signals 전 세계 값, Worldwide 행은 함의된 비중(업무용 메시지 ÷ 메시지)이다.

### 4.5 업무용 대화량

대화당 메시지 수 k에 대한 공개 자료가 없으므로 격자로 둔다. conv_kK = work_messages / K, K ∈ {1.5, 3, 5, 7, 10}. 변수 이름은 `conv_k1p5`, `conv_k3`, `conv_k5`, `conv_k7`, `conv_k10`이며 국가별·Worldwide 업무용 파일에 모두 들어 있다.

**표 5. Worldwide 월간 메시지, 업무용 메시지, 업무용 대화(억 건)**

| 월 | 메시지 | 업무 비중 함의(%) | Signals 전 세계(%) | 업무용 메시지 | 대화 k=1.5 | k=3 | k=5 | k=7 | k=10 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 2024-07 | 566.6 | 53.8 | 51.3 | 305.1 | 203.4 | 101.7 | 61.0 | 43.6 | 30.5 |
| 2024-08 | 605.8 | 51.1 | 48.3 | 309.7 | 206.5 | 103.2 | 61.9 | 44.2 | 31.0 |
| 2024-09 | 684.5 | 49.3 | 46.6 | 337.8 | 225.2 | 112.6 | 67.6 | 48.3 | 33.8 |
| 2024-10 | 749.2 | 48.1 | 45.4 | 360.5 | 240.3 | 120.2 | 72.1 | 51.5 | 36.0 |
| 2024-11 | 805.5 | 46.8 | 43.7 | 377.2 | 251.5 | 125.7 | 75.4 | 53.9 | 37.7 |
| 2024-12 | 828.1 | 43.2 | 40.1 | 357.5 | 238.3 | 119.2 | 71.5 | 51.1 | 35.7 |
| 2025-01 | 940.4 | 43.6 | 40.3 | 409.9 | 273.3 | 136.6 | 82.0 | 58.6 | 41.0 |
| 2025-02 | 1050.1 | 41.9 | 38.9 | 440.1 | 293.4 | 146.7 | 88.0 | 62.9 | 44.0 |
| 2025-03 | 1137.7 | 40.0 | 37.6 | 455.3 | 303.5 | 151.8 | 91.1 | 65.0 | 45.5 |
| 2025-04 | 1203.6 | 37.8 | 35.2 | 454.6 | 303.1 | 151.5 | 90.9 | 64.9 | 45.5 |
| 2025-05 | 1257.2 | 38.0 | 35.5 | 477.3 | 318.2 | 159.1 | 95.5 | 68.2 | 47.7 |
| 2025-06 | 1293.2 | 35.7 | 33.3 | 461.6 | 307.8 | 153.9 | 92.3 | 65.9 | 46.2 |
| 2025-07 | 1374.3 | 34.1 | 31.4 | 468.6 | 312.4 | 156.2 | 93.7 | 66.9 | 46.9 |
| 2025-08 | 1437.7 | 32.9 | 30.6 | 472.3 | 314.9 | 157.4 | 94.5 | 67.5 | 47.2 |
| 2025-09 | 1534.1 | 35.0 | 33.0 | 537.2 | 358.1 | 179.1 | 107.4 | 76.7 | 53.7 |
| 2025-10 | 1578.3 | 35.8 | 33.9 | 564.3 | 376.2 | 188.1 | 112.9 | 80.6 | 56.4 |
| 2025-11 | 1593.0 | 35.2 | 33.6 | 561.3 | 374.2 | 187.1 | 112.3 | 80.2 | 56.1 |
| 2025-12 | 1596.9 | 32.4 | 30.5 | 517.9 | 345.2 | 172.6 | 103.6 | 74.0 | 51.8 |
| 2026-01 | 1630.4 | 32.7 | 30.7 | 532.7 | 355.2 | 177.6 | 106.5 | 76.1 | 53.3 |
| 2026-02 | 1644.9 | 32.5 | 30.8 | 533.8 | 355.9 | 177.9 | 106.8 | 76.3 | 53.4 |
| 2026-03 | 1780.7 | 32.6 | 31.0 | 580.1 | 386.7 | 193.4 | 116.0 | 82.9 | 58.0 |
| 2026-04 | 1866.1 | 33.3 | 31.7 | 621.0 | 414.0 | 207.0 | 124.2 | 88.7 | 62.1 |
| 2026-05 | 1915.9 | 31.9 | 30.5 | 611.9 | 407.9 | 204.0 | 122.4 | 87.4 | 61.2 |

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
3. **범위 불일치.** 기준값 180억 건은 전 세계 ChatGPT(소비자 요금제) 값이지만 분모는 Sensor Tower 25개 시장의 독립 앱+웹 이용자다. 25개 시장 밖 이용자의 메시지가 분자에 들어가므로 1인당 메시지가 다소 크다. API, 기업 요금제, 앱 내장 AI 사용은 빠진다.
4. **중복 계산.** 국가 메시지는 제품별 이용자 수 합에 1인당 값을 곱한 것이므로 "그 국가 모든 제품 메시지의 합"이다. 여러 어시스턴트를 쓰는 사람의 메시지는 제품 수만큼 더해진다. 이는 (A1) 아래에서 일관적이다.
5. **대화량.** 대화당 메시지 수 k는 근거 자료가 없어 1.5–10의 격자로만 제시한다. 대화량은 k에 반비례하므로 메시지 수보다 훨씬 불확실하다.
6. **반올림과 잡음.** Sensor Tower 이용자 수(유효숫자 3자리)와 Signals 비중(차등정보보호 잡음, 소수 셋째 자리)의 오차가 그대로 전파된다.

---

## 7. 재현

Stata 17에서 다음 순서로 실행한다.

1. `code/02_clean_sensortower_share_all_products.do`: ⑮, ⑯(원자료 폴더에 저장)
2. `code/02_clean_sensortower_share_within_product.do`: 제품 내 국가 비중(report 18에서 사용)
3. `code/03_merge_sensortower_openai_messages.do`: 위 다섯 데이터
4. `code/04_analysis_sensortower_messages_summary.do`: 본 문서의 표(`results/table/17_*.tex`, `.xlsx`)

## 참고문헌

- Chatterji, A., Cunningham, T., Deming, D. J., Hitzig, Z., Ong, C., Shan, C. Y., and Wadman, K. (2025). How People Use ChatGPT. NBER Working Paper 34255.
- Chatterji, A. et al. (2026). OpenAI Signals v2.0. OpenAI, dataset and data dictionary.
- Sensor Tower (2026). State of AI 2026. Sensor Tower report (Infogram).
