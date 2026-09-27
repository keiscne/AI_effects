# Sensor Tower "State of AI 2026" 추출 데이터 설명서

### --- AI 어시스턴트 이용자 수, 이용자당 사용 강도, 생성형 AI 앱·웹 사용량 CSV 5종 ---

**AI-effects 프로젝트**

---

## 초록

본 문서는 Sensor Tower의 공개 보고서 *State of AI 2026*에 실린 차트 가운데 AI 사용 규모를 추정하는 데 필요한 5개 차트의 데이터를 추출해 만든 CSV의 설명서다. 추출한 데이터는 ① 제품별 중복 제거 월간 이용자 수(True Audience, 독립 앱+모바일 웹+데스크톱 웹), ② 앱 이용자의 월평균 사용 일수, ③ 앱 이용자의 월평균 사용 시간, ④ 생성형 AI 앱 카테고리 전체의 세션 수와 사용 시간, ⑤ 생성형 AI 웹사이트 카테고리 전체의 방문 수와 사용 시간이다. ①은 19개 시장(한국 포함), ④·⑤는 23–24개 시장(한국 포함)으로 나뉘어 있고, ②·③은 전 세계 값만 있다. 모든 값은 보고서 원본에 들어 있는 차트 데이터를 그대로 옮긴 것이며, 보고서 본문에 적힌 수치와 대조해 일치함을 확인했다. 이용자당 **대화 수**는 이 보고서에 없으므로, report 11의 규모 추정에는 ①(이용자 수)과 ②(사용 일수)를 조합해 쓰되 앱 기준 지표를 전체 이용자에 적용하는 데 따른 편의를 명시해야 한다.

---

## 1. 출처와 수집 방법

- **보고서**: Sensor Tower, *State of AI 2026*. https://sensortower.com/report/state-of-ai-2026/download
- **접근**: 로그인이나 양식 제출 없이 공개로 열린다. 페이지 본문은 Infogram으로 만든 보고서(ID `_/ASGcPdnHtQ9NVkM5gbYV`)를 삽입한 것이고, 각 차트의 데이터표가 Infogram 페이지 안에 JSON(`window.infographicData`)으로 들어 있다.
- **수집일**: 2026-09-27. 원본 HTML 2개를 받은 그대로 보관했다.
- **추출**: node 스크립트 `_extract_sensortower.js`가 원본 HTML에서 차트 데이터표를 꺼내 CSV로 쓴다. 천 단위 쉼표와 공백만 지우고 값은 바꾸지 않는다. 데이터가 JSON 안에 있어 Stata로 직접 읽기 어려워 추출만 node로 하고, 스크립트를 원본과 함께 두어 같은 결과를 다시 만들 수 있게 했다.
- **이용 조건**: 보고서에 "© Sensor Tower – All Rights Reserved"라고만 적혀 있고 공개 라이선스는 없다. 출처를 밝혀 연구에 인용하는 용도로 쓰고 원자료는 재배포하지 않는다.
- **위치**: `data/raw/macro/scaling/sensortower_state_of_ai_2026/` (git 미추적). 차트별 Infogram 엔터티 ID는 같은 폴더의 `_download_manifest.md`에 있다.

---

## 2. 파일 목록

모든 데이터셋은 **긴 형식**(`_long.csv`, 분석용: 1행 = 1개 관측값)과 **넓은 형식**(`_wide.csv`, 차트 모양: 열 = 기간 또는 제품) 두 가지로 저장했다.

**표 1. CSV 파일 목록**

| 번호 | 파일(`sensortower_` 접두어 생략) | 내용 | 단위(관측) | 긴 형식 행 수 |
|---|---|---|---|---|
| ① | `true_audience_monthly` | 중복 제거 독립 앱+웹 월간 이용자 수 | 시장 × 제품 × 월 | 5,776 |
| ② | `days_used_monthly` | 앱 이용자 월평균 사용 일수 | 앱 × 월 | 219 |
| ③ | `time_spent_per_user_quarterly` | 앱 이용자 월평균 사용 시간(분) | 앱 × 분기 | 50 |
| ④ | `genai_apps_sessions_hours_halfyear` | 생성형 AI 앱 전체 세션 수·사용 시간 | 시장 × 반기 | 168 |
| ⑤ | `genai_web_visits_hours_quarterly` | 생성형 AI 웹사이트 전체 방문 수·사용 시간 | 시장 × 분기 | 207 |

기간 표기는 월 `YYYY-MM`, 분기 `YYYYQn`, 반기 `YYYYHn`으로 통일했다.

---

## 3. 데이터셋별 설명

### 3.1 ① 중복 제거 독립 앱+웹 월간 이용자 수 (True Audience)

- **원 차트**: "Deduplicated Standalone App & Web Users for Top AI Assistants" (보고서 페이지 "ChatGPT Maintains the Largest De-Duped Web and Standalone App Audience as Competitors Gain Ground")
- **정의(보고서 원문)**: "Sensor Tower's True Audience metric measures unique users across standalone mobile apps, mobile web, and desktop web." 즉 한 달 동안 독립 모바일 앱, 모바일 웹, 데스크톱 웹 중 어느 경로로든 해당 제품을 쓴 사람을 중복 없이 센 값이다.
- **범위**: 2023-04 ~ 2026-05(월별 38개월). 시장 19개: Worldwide, Argentina, Australia, Brazil, Canada, France, Germany, India, Indonesia, Italy, Japan, Mexico, South Korea, Spain, Taiwan, Turkey, United Kingdom, United States, Vietnam. 제품 8개: ChatGPT, Google Gemini, Claude, Grok, DeepSeek, Perplexity, Microsoft Copilot, Other.
- **변수(긴 형식)**: `market`(시장), `assistant`(제품), `month`, `unique_users`(명)
- **주의**:
  - **Worldwide는 25개 시장 합계**다(차트 주석 "Worldwide includes 25 markets"). 전 세계 전체가 아니며, 18개국 시트를 더해도 Worldwide가 되지 않는다.
  - 다른 앱에 내장된 AI(WhatsApp의 Meta AI, Android의 Gemini 통합 등) 사용자는 포함하지 않는다(차트 부제).
  - 초기 월의 작은 값(예: Worldwide Claude 2023-04 = 3,050명)과 0은 원문 그대로다.
- **주요 값(Claude)**: Worldwide 2026-02 1.04억 → 2026-04 2.32억 → 2026-05 2.45억 명. 한국 2026-02 243만 → 2026-05 583만 명. DemandSage 등이 인용한 "Claude 2.45억 MAU"가 이 차트의 Worldwide 2026-05 값이다.

### 3.2 ② 앱 이용자 월평균 사용 일수

- **원 차트**: "Average Number of Days Used per Month for Select Gen AI vs. Social Apps" (보고서 페이지 "AI Assistants Became More Habitual for Users")
- **정의**: 해당 앱의 월간 이용자 1명이 한 달에 앱을 사용한 평균 일수.
- **범위**: 2024-01 ~ 2026-04(월별 28개월), 전 세계 값만 있음. 앱 9개: Google, X, Reddit, Threads(비교용 소셜·검색 앱), ChatGPT, Google Gemini, Microsoft Copilot, Claude, DeepSeek. 앱별 시작 월이 다르다(Claude 2024-08, Google Gemini·DeepSeek 2025-02, 나머지 2024-01). 원 차트의 빈 칸은 긴 형식에서 행을 만들지 않았다.
- **변수(긴 형식)**: `app`, `month`, `avg_days_used_per_month`(일)
- **주의**:
  - **모바일 앱 이용자만** 대상이다. 차트 제목은 "Android Phones, Worldwide", 페이지 주석은 "Includes mobile app users on iOS and Android worldwide"로 서로 다르다. 어느 쪽이든 웹 이용자는 포함하지 않는다.
  - 보고서에 따르면 Claude 이용자의 **80%는 웹으로만** 쓴다(페이지 "ChatGPT & Google Gemini Lead Standalone Mobile App Active User Share"). 따라서 Claude의 값은 이용자의 일부(앱 이용자)의 사용 빈도다.
- **주요 값**: Claude 2025-04 4.1일 → 2026-02 5.2일 → 2026-04 7.4일. ChatGPT는 2026년 들어 약 13–14일.

### 3.3 ③ 앱 이용자 월평균 사용 시간

- **원 차트**: "Average Avg Time Spent per Month for Top Generative AI Apps" (보고서 페이지 "User Engagement Deepened Across AI Assistants"). 보고서에서는 두 개의 차트로 나뉘어 있어 하나로 합쳤다.
- **정의**: 해당 앱의 월간 이용자 1명이 한 달에 앱에서 보낸 평균 시간(분). 본문이 "minutes per month"로 서술한다.
- **범위**: 2025Q1 ~ 2026Q1(분기별 5개), 전 세계 값만 있음. 앱 10개: Character AI, PolyBuzz, ChatGPT, DeepSeek, Grok, Claude, Microsoft Copilot, Perplexity, Google Gemini, Meta AI.
- **변수(긴 형식)**: `app`, `quarter`, `avg_minutes_per_month`(분)
- **주의**: iOS·Android **폰 앱 이용자만** 대상이다(차트 제목 "IOS and Android Phones Worldwide"). Character AI·PolyBuzz 같은 AI 컴패니언 앱은 사용 시간이 월 600–1,000분 수준이라 어시스턴트 앱과 성격이 다르다.
- **주요 값**: Claude 40.3분(2025Q1) → 120분(2026Q1). ChatGPT 160분 → 215분. Google Gemini 14.4분 → 100분.

### 3.4 ④ 생성형 AI 앱 카테고리 전체 세션 수·사용 시간

- **원 차트**: "Yearly Time Spent and Session Trends for Generative AI Apps"의 "Total Session Count"와 "Time Spent (Hours)" (보고서 페이지 "AI App Sessions Have Increased More Than 100x in Three Years")
- **정의**: 생성형 AI 앱 카테고리에 속한 **모든 앱**의 세션 수 합계와 사용 시간(시간) 합계. 제품별 값이 아니다.
- **범위**: 2023H1 ~ 2026H1(반기별 7개). 시장 24개: Worldwide와 Argentina, Australia, Brazil, Canada, China Mainland, France, Germany, India, Indonesia, Italy, Japan, Mexico, Saudi Arabia, Singapore, South Korea, Spain, Taiwan, Thailand, Turkey, United Arab Emirates, United Kingdom, United States, Vietnam. 플랫폼 iOS·Google Play.
- **변수(긴 형식)**: `market`, `half_year`, `sessions`(회), `time_spent_hours`(시간), `preliminary`(1 = 예비 추정치)
- **주의**:
  - **2026H1은 6월 말까지 투영한 예비 추정치**다(차트 각주). `preliminary=1`로 표시했다.
  - 앱 세션은 웹 방문(⑤)과 정의가 다르므로 둘을 더하지 않는다.
  - China Mainland는 Google Play가 없어 iOS만 반영됐을 가능성이 크다(같은 보고서 다른 페이지 주석 "iOS only for China").
- **주요 값**: 2026H1 세션 Worldwide 9,650억 회, 한국 193억 회. 사용 시간 Worldwide 360억 시간, 한국 7.32억 시간.

**보완(2026-09-27): 세션 수가 의미하는 것.** 세션 수는 생성형 AI 앱을 한 번 열어 쓰기 시작해서 멈출 때까지를 1회로 센 앱 사용 횟수의 합계이며, 대화나 메시지 수가 아니다. 다만 이 보고서의 "Mobile App Methodology" 페이지는 다운로드와 매출만 설명하고 세션을 정의하지 않는다. Sensor Tower의 공개 자료(Usage Intelligence API 문서 등)에도 세션 수, 평균 세션 길이, 이용자당 하루 세션 수라는 지표 이름만 있고 세는 규칙은 나와 있지 않다. 업계에서는 보통 앱이 화면 앞(포그라운드)에 열리면 세션이 시작되고, 앱을 닫거나 다른 앱으로 넘어가면 끝나며, 짧은 시간 안에 다시 돌아오면 같은 세션으로 묶는다. 이 설명은 업계 관행이며 이 보고서에서 확인한 것은 아니다. Sensor Tower의 사용량 지표는 1천만 명 이상 소비자 패널의 앱 사용 기록에 모형 추정을 더한 값이다.

사용 시간을 세션 수로 나누면 세션 1회의 평균 길이는 2026H1 전 세계 약 2.2분(360억 시간 ÷ 9,650억 회), 한국 약 2.3분(7.32억 시간 ÷ 193억 회)이다. 앱을 잠깐 열어 질문 하나를 하고 닫는 식의 사용이 많다는 뜻이다. 따라서 세션과 대화는 1:1로 대응하지 않는다. 한 세션 안에서 대화를 여러 번 주고받을 수 있고, 반대로 대화 하나가 다른 앱을 오가는 사이에 여러 세션으로 나뉠 수도 있다.

**표 2. 자료별 사용 단위 비교**

| 자료 | 사용 단위 | 무엇을 세는가 |
|---|---|---|
| Sensor Tower ④ | 앱 세션 | 앱을 열어 쓴 1회(카테고리 전체, 앱만) |
| Sensor Tower ⑤ | 웹 방문 | 한 사이트에서의 활동. 30분 넘게 쉬면 새 방문 |
| AEI | 대화(Claude.ai), 입력–출력 한 쌍(1P API) | 대화 주제 단위 |
| OpenAI Signals | 메시지 | 사용자가 보낸 메시지 1개 |

그러므로 ④는 Claude의 대화 수를 직접 추정하는 데 쓸 수 없다. 카테고리 전체의 앱 전용 값이고, Claude 이용자의 80%는 웹으로만 쓰기 때문이다. ④는 한국과 전 세계의 생성형 AI 앱 사용 강도 추세, 그리고 세션당 평균 길이 같은 사용 패턴을 비교하는 데 쓴다.

### 3.5 ⑤ 생성형 AI 웹사이트 카테고리 전체 방문 수·사용 시간

- **원 차트**: "Yearly Time Spent and Visits Trends for Generative AI Websites"의 "Total Visits"와 "Time Spent (Hours)" (보고서 페이지 "Generative AI Web Engagement Expanded Despite Slower Growth")
- **정의**: 생성형 AI 카테고리에 속한 **모든 웹사이트**의 방문 수 합계와 사용 시간(시간) 합계. 데스크톱과 모바일 웹을 합친 값이다. 방문은 한 사이트에서의 활동을 30분 단위로 묶은 것으로, 30분 넘게 활동이 없으면 다음 활동을 새 방문으로 센다(보고서 "About this Data: Web Methodology").
- **범위**: 2024Q1 ~ 2026Q1(분기별 9개). 시장 23개(④에서 China Mainland 제외).
- **변수(긴 형식)**: `market`, `quarter`, `visits`(회), `time_spent_hours`(시간)
- **주의**: **Worldwide는 56개 시장 합계**다(주석 "Worldwide includes 56 available markets"). ①(25개), ④(시장 수 표기 없음)와 Worldwide의 범위가 서로 다르다. 방문 수의 출처는 Sensor Tower Web Insights로, Similarweb의 방문 수와는 추정 방식이 다르므로 섞어 쓰지 않는다.
- **주요 값**: 2026Q1 방문 Worldwide 674억 회, 인도 133.7억, 미국 82.3억, 한국 12.3억 회. 사용 시간 Worldwide 229.5억 시간, 한국 4.77억 시간.

---

## 4. 공통 주의사항

1. **모두 Sensor Tower의 추정치**다. 패널·모형 기반 값이며 Sensor Tower가 과거 값을 수정할 수 있다. 이 파일들은 2026-09-27 시점의 보고서 값이다.
2. **Worldwide의 범위가 데이터셋마다 다르다**: ① 25개 시장, ⑤ 56개 시장, ④는 표기 없음. 데이터셋끼리 Worldwide 값을 나누거나 비교할 때 주의한다.
3. **플랫폼 범위가 다르다**: ①은 앱+모바일 웹+데스크톱 웹, ②·③·④는 모바일 앱만, ⑤는 웹만이다. 특히 Claude는 이용자 대부분이 웹 이용자라 ②·③의 앱 기준 값이 전체 이용자를 대표하지 못한다.
4. **Infogram 시트 이름은 믿지 않는다**: ②·③의 시트 이름은 "AMER", ⑤는 "Spend"/"Impressions"로 되어 있으나 편집용 이름이다. 지표는 차트 위 제목과 본문 수치로 확인했다.
5. **수치 검증**: 추출값을 보고서 본문 수치와 대조해 모두 일치했다(① Claude 2026-05 2.45억, ② Claude 4.1→7.4일, ③ ChatGPT 215분, ④ 세션 9,650억·시간 360억, ⑤ 방문 674억).

---

## 5. 본 프로젝트에서의 활용

- **report 11의 규모 추정**: ①은 Claude의 월간 이용자 수를 앱·웹 합산으로 준다. Fan and Nguyen(2026)이 쓴 웹 MAU 1,890만 명과 달리 2026년 2월 값(1.04억 명)이 직접 있다. 이 차트의 2026년 2월 대비 비율(4월 2.23배, 5월 2.36배)은 웹 방문 수 비율(2.86배, 3.31배)과 다르므로, 4.1절 방법 A의 대안 기준으로 쓸 수 있다.
- **DAU/MAU 가정의 점검**: ②의 월 사용 일수를 한 달 일수로 나누면 DAU/MAU의 근사값이 된다. Claude 2026년 2월 5.2일 ÷ 28일 ≈ 0.19로, Fan and Nguyen이 가정한 0.5보다 낮다. 다만 앱 이용자 기준이다.
- **대화 수는 없다**: 이용자당 대화(메시지) 수는 이 보고서에 없다. 주간 대화 수를 만들려면 여전히 "사용일 1일당 대화 수"를 가정해야 한다. 예: 1.04억 명 × 월 5.2일 × 하루 3건 × (7/28) ≈ 주 4억 건(참고용 계산).
- **한국 지표**: ①(한국 제품별 이용자 수), ④(한국 생성형 AI 앱 세션·시간), ⑤(한국 생성형 AI 웹 방문·시간)는 AEI·OpenAI Signals의 한국 값과 함께 한국의 AI 사용 규모 추세를 보여 주는 보조 지표로 쓸 수 있다.

---

## 6. 보완(2026-09-27): 보고서의 방법론 페이지와 페이지 주석

보고서 끝의 방법론 페이지(71–73쪽)와 모든 페이지의 출처·주석 문구를 전부 확인했다. 결론부터 말하면, **앱 활성 이용자(MAU), 세션 수, 사용 시간, 사용 일수를 어떻게 추정했는지는 보고서 어디에도 설명이 없다.** 정의가 제시된 것은 웹 지표와 True Audience뿐이다. 나머지는 각 페이지 주석에 적힌 범위 정보가 전부다. 따라서 ②·③·④는 "Sensor Tower의 모바일 앱 사용 추정치"라는 것 외에 산출 방식(패널 규모, 모형 등)을 보고서로 확인할 수 없다.

### 6.1 방법론 페이지 요약

**표 3. 보고서 방법론 페이지(71–73쪽)**

| 쪽 | 제목 | 내용 | 이 문서 데이터와의 관계 |
|---|---|---|---|
| 71 | Mobile App Methodology | Sensor Tower Mobile App Insights 플랫폼의 다운로드·인앱결제(IAP) 매출 추정치. 기간 2014.1.1–2026.5.31. 다운로드는 Apple·Google 계정당 1회만 셈. Android는 Google Play만. IAP 매출은 수수료 차감 전(gross)이며 광고 매출 제외 | 다운로드·매출만 설명. ②·③·④의 이용자·세션·시간 지표는 설명하지 않음 |
| 72 | Digital Advertising Methodology | Pathmatics가 패널과 데이터 수집업체에서 광고를 표본으로 모아 노출·지출을 통계적으로 추정 | 관계없음(보고서에서 추정 방식이 설명된 유일한 페이지) |
| 73 | Web Methodology | Sensor Tower Web Insights 플랫폼의 방문 수·순방문자 추정치. 데스크톱 웹과 모바일 웹(폰·태블릿) 포함. 방문·순방문자·True Audience 정의 | ①·⑤의 정의 |

### 6.2 웹 지표와 True Audience의 정의 (73쪽)

- **방문(visit)**: "A visit captures all activity on a site within a 30-minute window." 한 사이트에서 페이지를 보면 이후 30분 안의 페이지 조회는 같은 방문으로 묶고, 30분 넘게 활동이 없으면 다음 활동부터 새 방문이다.
- **총 방문 수(total visits)**: 같은 방문자의 반복 방문을 포함해 기간 중 방문한 횟수 전체. ⑤의 `visits`가 이 값이다.
- **순방문자(unique visitors)**: 기간 중 방문한 사람을 몇 번 왔든 1명으로 센 값.
- **True Audience**: "the measure of how many unique visitors are driving traffic to a brand across multiple devices. It is defined by deduplicating the user base of a brand's app active users, mobile web visitors, and desktop web visitors." 즉 ①은 한 제품(브랜드)의 앱 활성 이용자, 모바일 웹 방문자, 데스크톱 웹 방문자를 합친 뒤 겹치는 사람을 뺀 값이다. 다만 앱과 웹에서 같은 사람을 어떻게 식별하는지(중복 제거 방법)는 설명하지 않는다.

### 6.3 앱 분류: App IQ 분류 체계

④가 실린 29쪽 주석은 "Apps classified using Sensor Tower's App IQ taxonomy as of June 2026"이라고 적는다(31·32·39쪽도 같음). 즉 ④의 "생성형 AI 앱" 카테고리는 Sensor Tower의 App IQ 분류 체계가 **2026년 6월 기준**으로 생성형 AI로 분류한 앱 집합이다. 과거 기간(2023H1 등)도 이 시점의 분류로 다시 계산한 값으로 보인다. 따라서 분류 체계가 바뀌면 과거 값도 바뀔 수 있고, 다른 시점에 발표된 Sensor Tower 수치와 카테고리 범위가 다를 수 있다.

### 6.4 이용자 수의 중복 계산

- 9·10·12쪽(AI 어시스턴트별 앱 MAU와 점유율) 주석은 "Users that use multiple AI Assistants in a month are double-counted (counted once for each AI Assistant that they use)"라고 적는다. 한 달에 여러 어시스턴트를 쓴 사람은 어시스턴트마다 한 번씩 센다.
- ①의 True Audience는 **한 제품 안에서** 앱과 웹 사이의 중복만 제거한 값이다. 따라서 제품별 ① 값을 더한 합계는 "AI 어시스턴트를 쓴 사람 수"가 아니며, 여러 제품을 쓴 사람만큼 과대 계산된다.
- 9·11쪽의 "In-App AI Active Users"는 다른 앱에 내장된 AI(WhatsApp의 Meta AI, Android의 Gemini 플로팅 화면, X의 Grok 등) 사용을 따로 센 것이다. 일부 차트(9쪽)에서는 Meta AI·Gemini 합계에 이 사용이 포함되지만, ①에는 포함되지 않는다(13쪽 주석 "Does not include embedded in-app AI users").

### 6.5 정정: 3.4절의 China Mainland 서술

3.4절은 ④의 China Mainland 값에 대해 "iOS만 반영됐을 가능성이 크다(같은 보고서 다른 페이지 주석 'iOS only for China')"라고 적었다. 그런데 ④가 실린 **29쪽 주석 자체**에 "iOS and Google Play combined. iOS only for China."가 명시되어 있다. 따라서 ④의 China Mainland 값은 **iOS만 반영한 것이 확인된 사실**이다. 처음 페이지를 확인할 때 긴 주석 문구를 놓쳤던 것을 이 절에서 바로잡는다.
