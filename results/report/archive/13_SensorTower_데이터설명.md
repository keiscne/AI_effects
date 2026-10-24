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

---

## 7. 보완(2026-09-28): 점유율 데이터 3종

2026-09-28에 점유율 데이터 3종을 추가했다. ⑥과 ⑦은 ①–⑤와 같은 원본(2026-09-27 스냅샷)에서 같은 스크립트(`_extract_sensortower.js`)로 추출했고 새로 받은 파일은 없다. ⑧은 보고서에 없는 값으로, ①의 이용자 수에서 Stata do 파일로 계산했다. 앞 절의 번호 ①–⑤를 그대로 이어 쓴다.

**표 4. 추가한 점유율 데이터 파일**

| 번호 | 파일(`sensortower_` 접두어 생략) | 내용 | 단위(관측) | 긴 형식 행 수 | 위치 |
|---|---|---|---|---|---|
| ⑥ | `true_audience_share_monthly` | 시장 안의 제품별 점유율(True Audience 기준) | 시장 × 제품 × 월 | 5,776 | `data/raw/…/sensortower_state_of_ai_2026/` |
| ⑦ | `worldwide_share_by_measure_monthly` | Worldwide 제품별 점유율, 측정 기준 4가지 | 기준 × 제품 × 월 | 468 | 같은 폴더 |
| ⑧ | `share_within_product_monthly` | 제품 안의 시장별 점유율(①에서 계산) | 제품 × 월 × 시장 | 5,776 | `data/proc/macro/scaling/sensortower_state_of_ai_2026/` |

세 데이터 모두 점유율은 퍼센트 값이다(예: `46.4` = 46.4%). ⑥·⑦은 원 차트의 `%` 기호만 지웠다. ⑧은 긴 형식을 `.csv`와 `.dta`로, 넓은 형식을 `.csv`로 저장했다.

### 7.1 ⑥ 시장 안의 제품별 점유율 (True Audience 기준)

- **원 차트**: "Deduplicated Standalone App & Web Market Share for Top AI Assistants" (14쪽 "ChatGPT's True Audience Market Share Falls Below 50%"). 보고서의 점유율 차트 가운데 **국가별 시트가 있는 것은 이 차트뿐**이다.
- **정의**: 한 시장에서 제품별 True Audience 이용자 수(①)를 8개 항목(Other 포함) 합계로 나눈 값. ①에서 다시 계산한 값과 비교하면 차이가 최대 0.82%p(Taiwan, Other, 2023-10)로, ①의 이용자 수가 유효숫자 3자리로 반올림된 데서 오는 차이다.
- **범위**: ①과 같다(19개 시장 × 8개 제품 × 2023-04 ~ 2026-05).
- **변수(긴 형식)**: `market`, `assistant`, `month`, `share_pct`(%)
- **주의**:
  - 분모는 제품별 이용자 수의 합이다. 여러 어시스턴트를 쓴 사람은 어시스턴트마다 한 번씩 세므로(6.4절), 이 점유율은 "AI 어시스턴트 이용자 중 그 제품을 쓰는 사람의 비율"이 아니다. "제품별 이용자 수를 모두 더한 값에서 그 제품이 차지하는 비중"이다.
  - 소수 첫째 자리로 반올림되어 있어 시장·월별 합계가 99.8–100.3이다.
  - 앱에 내장된 AI 이용자는 포함하지 않는다(①과 같음).
- **주요 값**: Worldwide 2026-05 ChatGPT 46.4%, Google Gemini 27.7%, Claude 10.3%(본문 46%·28%·10%). United States의 Claude 2025-12 5.1% → 2026-05 13.9%(본문 "5%에서 약 14%로"). South Korea 2026-05 ChatGPT 42.1%, Google Gemini 29.1%, Claude 9.6%.

### 7.2 ⑦ Worldwide 제품별 점유율(측정 기준 4가지)

보고서 9–12쪽에는 측정 기준이 다른 Worldwide 점유율 차트 4개가 있다. 네 차트를 `measure` 열로 구분해 하나의 파일로 합쳤다.

**표 5. ⑦의 측정 기준**

| `measure` | 쪽 | 원 차트 | 무엇을 세는가 | 기간 | 제품 |
|---|---|---|---|---|---|
| `total_web_app_inapp` | 9 | Total Market Share for Top AI Assistants | 웹 + 독립 앱 + 앱 내장 AI의 월간 이용자 | 2026-01 ~ 2026-06 | ChatGPT, Google Gemini, Meta AI, Claude, Other |
| `standalone_app_mau` | 10 | Standalone Mobile App MAU Market Share for Top AI Assistants | 독립 모바일 앱(iOS·Google Play) MAU | 2024-01 ~ 2026-06 | ChatGPT, Google Gemini, Perplexity, Grok AI, Meta AI, Claude, Other |
| `inapp_active_users` | 11 | In-App AI Active Users Market Share for Top AI Assistants | 다른 앱에 내장된 AI 기능의 이용자 | 2026-01 ~ 2026-06 | Google Gemini, Meta AI (WhatsApp), Grok |
| `web_visits` | 12 | Web Visits Market Share for Top AI Assistant Websites | 웹 방문 수 | 2024-01 ~ 2026-06 | ChatGPT, Google Gemini, Claude, Perplexity, Grok AI, Microsoft Copilot, Other |

- **변수(긴 형식)**: `measure`, `assistant`, `month`, `share_pct`(%). 넓은 형식은 네 기준의 월을 모두 열로 두고, 기간이 없는 칸은 비워 두었다.
- **처리 내용**:
  - 제품 이름 끝의 각주 표시(`Google Gemini*`, `Meta AI**`)를 지웠다. 그 밖의 제품 이름은 차트에 적힌 그대로 두었다(`Grok AI`와 `Grok`, `Meta AI`와 `Meta AI (WhatsApp)`).
  - `standalone_app_mau` 차트는 값이 30개월인데 마지막 열의 월 머리글이 원본에서 비어 있다. 앞 열이 2026-05이고, 같은 구조의 `web_visits` 차트 마지막 열이 2026년 6월이며, 본문의 "ChatGPT retained nearly half (49%) … in June 2026"이 마지막 값 48.9%와 맞으므로 2026-06으로 채웠다.
- **주의**:
  - 차트마다 포함한 제품이 달라 `Other`가 가리키는 범위도 다르다. 같은 제품이라도 기준 사이의 점유율을 곧바로 비교할 때는 이 점을 감안한다.
  - Worldwide는 `total_web_app_inapp`·`web_visits`에서 25개 시장이다. `standalone_app_mau`와 `inapp_active_users`에는 시장 수 표기가 없다.
  - `total_web_app_inapp`에서 Google Gemini는 독립 앱과 Android 플로팅 오버레이만 포함한다(Gmail·Docs 등 다른 Google 앱 안의 사용 제외). Meta AI는 독립 앱과 WhatsApp 안의 사용만 포함한다.
  - `web_visits`는 방문 수 기준이다. 이용자 수 기준인 다른 세 기준과 단위가 다르다.
  - 여러 어시스턴트를 쓴 이용자는 어시스턴트마다 한 번씩 센다(9·10·12쪽 주석).
- **주요 값(2026-06)**: Claude는 웹 방문 14.3%, 웹+앱+앱 내장 합계 8.5%, 독립 앱 3.2%다. 기준에 따라 점유율이 크게 다른 것은 Claude 이용자의 80%가 웹으로만 쓰기 때문이다(10쪽). ChatGPT는 웹 방문 50.7%, 독립 앱 48.9%, 합계 37.0%다. 웹 방문 기준 ChatGPT는 2024-01 84.3%에서 50.7%로 줄었다(본문 84% → 51%).

### 7.3 ⑧ 제품 안의 시장별 점유율 (①에서 계산)

⑥이 "한 시장 안에서 제품들이 나눠 가진 비중"이라면, ⑧은 "한 제품의 이용자가 어느 시장에 있는가"를 보여 준다. 예를 들어 Claude의 전 세계(25개 시장) 이용자 가운데 한국 이용자의 비중이다. 보고서에 없는 값이라 직접 계산했다.

- **만든 방법**: `code/02_clean_sensortower_share_within_product.do`(Stata 17)가 ①의 긴 형식 CSV를 읽어 계산한다. 원 데이터를 가공한 값이므로 CLAUDE.md 규칙에 따라 `data/proc/`에 두었다.
- **⑥으로는 계산할 수 없는 이유**: 제품 안의 시장별 점유율을 내려면 시장별 이용자 수가 필요하다. ⑥에는 비율만 있고 각 시장의 분모(제품 이용자 수의 합)가 없어 이용자 수로 되돌릴 수 없다. ⑥은 ①을 시장 안 합계로 나눈 값이므로, ①의 이용자 수에서 직접 계산하는 것이 같은 정보를 쓰는 올바른 방법이다.
- **정의**: 제품 p, 월 t, 시장 c에 대해
  - `share_within_product_pct` = 100 × 이용자 수(c, p, t) ÷ 이용자 수(Worldwide, p, t)
  - Worldwide는 25개 시장 합계인데 국가 시트는 18개뿐이다. 그래서 나머지 7개 시장(보고서에 이름이 없음)을 Worldwide − 18개국 합계로 계산해 `Other 7 markets (residual)` 한 행으로 넣었다. 18개국과 이 행을 더하면 정확히 100%다(do 파일에서 검사).
  - `share_within_18_pct` = 100 × 이용자 수(c, p, t) ÷ 18개국 합계. 이름이 알려진 18개국끼리 비교할 때 쓴다. residual 행에서는 비어 있다.
- **범위**: 8개 제품 × 38개월(2023-04 ~ 2026-05) × 19행(18개국 + residual) = 5,776행.
- **변수(긴 형식)**: `assistant`, `month`, `market`, `residual`(1 = residual 행), `unique_users`(residual 행은 Worldwide − 18개국 합계), `worldwide_users`, `sum18_users`, `share_within_product_pct`(%), `share_within_18_pct`(%). 넓은 형식은 행 = 제품 × 시장, 열 = 월(`m2026_05` 등), 값 = `share_within_product_pct`다.
- **주의**:
  - ①의 이용자 수가 유효숫자 3자리 정도로 반올림되어 있다. 이 때문에 이용자가 거의 없던 시기에는 residual이 음수가 된 경우가 10건 있다(Claude 2023-05·06, Grok 2023-11 ~ 2024-11 사이 8개월, 최소 −7,920명). 계산 결과를 그대로 두었다. 같은 이유로 Claude 2023년 봄(Worldwide 3,050–29,400명)처럼 이용자가 적은 시기의 점유율은 해석하지 않는다.
  - 출시 전이라 Worldwide 이용자가 0인 17개 제품·월(DeepSeek, Grok, Microsoft Copilot)은 점유율을 비워 두었다.
  - residual의 비중은 제품마다 다르다. Worldwide 이용자가 100만 명 이상인 달에서 Claude 6.0–10.2%, ChatGPT 6.3–10.0%, DeepSeek 15.3–39.6%다. DeepSeek는 이름이 공개되지 않은 7개 시장의 비중이 크다.
  - 제품 `Other`는 시장마다 포함된 제품이 다를 수 있어 해석에 주의한다.
  - Worldwide가 25개 시장 합계이므로 "전 세계 이용자 중 비중"이 아니라 **25개 시장 이용자 중 비중**이다.
- **주요 값(2026-05, `share_within_product_pct`)**:

**표 6. 제품 안의 시장별 점유율(%) — 2026-05, 주요 시장**

| 제품 | India | United States | South Korea | 나머지 7개 시장 |
|---|---|---|---|---|
| ChatGPT | 29.7 | 12.9 | 2.3 | 8.9 |
| Google Gemini | 34.6 | 8.6 | 2.7 | 8.7 |
| Claude | 29.5 | 16.7 | 2.4 | 9.3 |
| Microsoft Copilot | 13.3 | 23.3 | 1.2 | 7.6 |
| DeepSeek | 14.6 | 8.8 | 0.7 | 38.4 |

Claude의 한국 비중은 2026년 1–5월 2.0–2.4%(1월 2.36%, 3월 2.03%, 5월 2.38%)로, 2026년 초 Claude 이용자가 크게 늘어나는 동안에도 거의 같았다. 한국 이용자도 전 세계와 비슷한 속도로 늘었다는 뜻이다.

### 7.4 본 프로젝트에서의 활용

- **한국 규모의 할당**: ⑧의 한국 비중은 전 세계(25개 시장) Claude 이용자 규모를 한국으로 나누는 가중치로 쓸 수 있다. 다만 이용자 수 비중이므로, 이용자 1명당 사용량이 나라마다 같다는 가정이 필요하다.
- **AEI와의 비교**: AEI는 국가별 Claude.ai 대화 비중을 준다. 이를 ⑧의 이용자 비중과 비교하면 나라별 이용자 1인당 사용 강도의 차이를 가늠할 수 있다. 다만 AEI는 전 세계 기준이고 ⑧은 25개 시장 기준이며, ⑧은 앱·웹 이용자를 모두 포함한다는 차이가 있다.
- **기준에 따른 점유율 차이**: ⑦은 같은 제품의 점유율이 웹·앱·앱 내장 기준에 따라 크게 달라진다는 것을 보여 준다. Claude 같은 웹 중심 제품의 규모를 앱 지표(②·③)만으로 판단하면 과소평가된다는 점을 확인하는 자료로 쓴다.

---

## 8. 보완(2026-09-28): 앱 세션·웹 방문의 월별 변환과 제품별 분해

④(앱 세션 수·사용 시간, 반기)와 ⑤(웹 방문 수·사용 시간, 분기)를 월별 값으로 바꾸고, ⑥(True Audience 점유율)으로 제품별로 나눈 데이터 4종(⑨–⑫)을 만들었다. 모두 Stata do 파일 `code/02_clean_sensortower_usage_monthly_by_assistant.do`(Stata 17)가 만든 **가공 데이터**다. CLAUDE.md는 가공 데이터를 `data/proc/`에 두도록 하지만, 사용자 지정에 따라 ④·⑤와 같은 `data/raw/macro/scaling/sensortower_state_of_ai_2026/`에 두었다(예외). 다시 만들 때는 do 파일을 실행하며, 파일을 직접 고치지 않는다.

**표 7. 월별 변환·제품별 분해 데이터 파일**

| 번호 | 파일(`sensortower_` 접두어 생략) | 내용 | 단위(관측) | 기간 | 행 수 |
|---|---|---|---|---|---|
| ⑨ | `genai_apps_sessions_hours_monthly` | ④의 월별 값 | 시장(24개) × 월 | 2023-01 ~ 2026-06 | 1,008 |
| ⑩ | `genai_web_visits_hours_monthly` | ⑤의 월별 값 | 시장(23개) × 월 | 2024-01 ~ 2026-03 | 621 |
| ⑪ | `genai_apps_by_assistant_monthly` | ⑨를 ⑥으로 제품별 분해 | 시장(19개) × 제품 × 월 | 2023-04 ~ 2026-05 | 5,776 |
| ⑫ | `genai_web_by_assistant_monthly` | ⑩을 ⑥으로 제품별 분해 | 시장(19개) × 제품 × 월 | 2024-01 ~ 2026-03 | 4,104 |

사용자가 정한 사항은 세 가지다. (1) 저장 위치는 위와 같이 raw 폴더다. (2) 월별 변환은 기간 합계를 지키면서 매끄럽게 나누는 보간(Denton 방식)을 쓴다. (3) Worldwide도 국가와 같이 True Audience 점유율(⑥)로 나눈다.

### 8.1 앱 세션(④)과 웹 방문(⑤)의 관계

- **같은 사용을 두 번 세지 않는다.** ④는 모바일 앱(iOS·Google Play)의 사용만, ⑤는 웹사이트(데스크톱 웹과 모바일 웹)의 사용만 센다. 한 번의 사용이 두 데이터에 함께 잡히지 않는다.
- **사람은 겹친다.** 앱과 웹을 모두 쓰는 사람은 양쪽에 나온다. 사용량을 더할 때는 문제가 없지만 "사람 수"로 해석하면 안 된다.
- **서비스 목록이 다르다.** ④는 Sensor Tower 앱 분류 체계(App IQ, 2026년 6월 기준)의 생성형 AI 앱, ⑤는 웹 분류의 생성형 AI 사이트다. 두 목록이 같은 서비스를 짝지어 담고 있다는 보장은 없다.
- **세션 수와 방문 수는 더하지 않는다.** 단위의 크기가 전혀 다르다. 2025년 하반기(웹은 3·4분기 합계)로 계산하면 다음과 같다.

**표 8. 앱 세션과 웹 방문의 단위 비교(2025년 하반기)**

| 시장 | 앱 세션 1회 평균 | 웹 방문 1회 평균 | 횟수 중 앱 비중 | 사용 시간 중 앱 비중 |
|---|---|---|---|---|
| Worldwide | 2.3분 | 19.9분 | 85% | 40% |
| South Korea | 2.5분 | 22.9분 | 84% | 36% |

앱 세션은 앱을 잠깐 열었다 닫는 1회이고, 웹 방문은 30분 넘게 쉬기 전까지의 활동을 1회로 묶는다(6.2절). 횟수를 더하면 앱이 85%를 차지하지만 시간으로 보면 웹이 60% 이상이다. 따라서 횟수를 더한 지표는 앱 쪽으로 크게 치우친다.

- **사용 시간은 더할 수 있다.** 단위가 "시간"으로 같고 경로가 겹치지 않기 때문이다. 예: 한국 2025년 하반기 앱 4.86억 시간 + 웹 8.56억 시간 = 13.4억 시간. 이때 (1) 기간을 맞추고(⑨·⑩의 월별 값을 쓰면 된다), (2) Worldwide 값끼리는 더하지 않으며(④는 시장 수 표기 없음, ⑤는 56개 시장), 둘 다 있는 23개 시장의 국가별 값을 쓰고, (3) China Mainland는 ④에만 있고 iOS만 반영되어 있으므로 제외한다. 사용 시간을 어떻게 재는지(예: 열어 두기만 한 웹 탭이 포함되는지)는 보고서에 설명이 없다. 따라서 합계는 "생성형 AI 앱과 웹에 들인 시간"이며, AEI의 대화 수나 OpenAI Signals의 메시지 수와는 다른 개념이다.

### 8.2 ⑨·⑩ 월별 변환

- **방법: 비례 Denton(1차 차분).** 시장·변수마다 반기(분기) 안의 월별 값의 합이 원래 반기(분기) 값과 같다는 조건 아래에서, 지표 계열 대비 월별 값의 비율이 이웃한 달 사이에 가장 적게 변하도록 나눈다. 식으로는 min Σ (x_t/z_t − x_{t−1}/z_{t−1})²이다.
- **지표 계열 z_t**: 기간 월평균(값 ÷ 개월 수)의 로그를 각 기간의 중앙 달 사이에서 직선으로 이은 로그 선형 추세다. 첫 기간과 마지막 기간의 바깥은 인접 구간의 기울기로 연장한다. 결과적으로 월별 값은 증가율이 매끄럽게 변하는 추세를 따르면서 기간 합계를 정확히 지킨다.
- **방법을 바꾼 이유**: 처음에는 지표 계열이 없는 가법 Denton(월별 값 자체의 차이를 최소화)을 썼다. 그런데 앱의 2023년 상반기처럼 다음 기간에 값이 몇 배로 뛰는 구간(Worldwide 88.3억 → 425억 세션, 약 5배)에서 음수 월 값이 나왔다(최소 약 −3,000만 세션). 비례 Denton은 이 문제가 없다.
- **검증**: 월별 값을 기간별로 더하면 원래 값과 같다(상대 오차 10⁻⁹ 미만). 모든 월별 값이 양수다. 두 가지 모두 do 파일에서 검사한다. 예: Worldwide 앱 세션 2023-01 6.5억 → 2023-06 27.1억 회, 6개월 합 88.3억 회 = 2023H1 값.
- **변수**:
  - ⑨: `market`, `month`, `half_year`, `preliminary`, `sessions`(회), `time_spent_hours`(시간). 2026H1은 6월 말까지 투영한 예비 추정치이므로 2026-01~06의 `preliminary`는 1이다.
  - ⑩: `market`, `month`, `quarter`, `visits`(회), `time_spent_hours`(시간).
  - CSV에는 정수로 반올림해 저장했다.
- **주의**: 월별 값은 반기·분기 값을 나눈 **추정치**다. 한 기간 안의 월별 모양(예: 특정 달의 급증)은 원자료에 없으므로 월별 변동을 분석 대상으로 삼지 않는다.

### 8.3 ⑪·⑫ 제품별 분해

- **방법**: 시장·월별 카테고리 값(⑨·⑩) × ⑥ 점유율. ⑥은 반올림 때문에 시장·월별 합계가 99.8–100.3이므로, 합계가 100이 되게 나눈 `share_norm_pct`를 쓴다. 그래서 제품별 값을 더하면 카테고리 월별 값과 정확히 같다(do 파일에서 검사). 매칭 키는 `market` × `month`다.
- **범위**: ⑥이 있는 19개 시장(Worldwide + 18개국)과 8개 제품. 기간은 ⑥과 사용량 자료가 겹치는 달이다(⑪ 2023-04~2026-05, ⑫ 2024-01~2026-03). ⑥이 없는 5개 시장(China Mainland, Saudi Arabia, Singapore, Thailand, United Arab Emirates)은 ⑨·⑩에만 있다.
- **변수**:
  - ⑪: `market`, `assistant`, `month`, `half_year`, `preliminary`, `share_pct`(⑥ 원 값), `share_norm_pct`(정규화), `sessions`, `time_spent_hours`(제품 몫), `total_sessions`, `total_time_spent_hours`(카테고리 전체).
  - ⑫: `market`, `assistant`, `month`, `quarter`, `share_pct`, `share_norm_pct`, `visits`, `time_spent_hours`, `total_visits`, `total_time_spent_hours`.

### 8.4 해석상 주의

1. **제품별 실측 사용량이 아니다.** ④·⑤는 AI 컴패니언, 이미지 생성 앱 등을 포함한 생성형 AI 카테고리 전체의 값이고, ⑥은 AI 어시스턴트 7개와 Other(다른 어시스턴트)의 이용자 점유율이다. 분해 값은 "카테고리 사용량을 어시스턴트 이용자 점유율대로 나눈 값"이다. 어시스턴트가 아닌 앱의 사용량도 어시스턴트 몫으로 나눠 들어간다.
2. **이용자 1명당 사용량이 제품마다 같다고 가정한다.** 실제로는 제품마다 다르다(예: ③ 2026Q1 이용자당 월 사용 시간 ChatGPT 215분, Claude 120분, Google Gemini 100분).
3. **앱과 웹에서 제품 점유율이 같다고 가정한다.** ⑥은 앱과 웹 이용자를 합친 점유율이다. Claude 이용자의 80%는 웹 전용이라(10쪽), Worldwide Claude 점유율은 앱 MAU 기준 3.2%, 웹 방문 기준 14.3%(⑦, 2026-06), True Audience 기준 10.3%(⑥, 2026-05)로 크게 다르다. 따라서 앱 분해(⑪)에서 Claude 몫은 실제보다 크고, 웹 분해(⑫)에서는 작을 가능성이 크다. Worldwide는 ⑦의 경로별 점유율로 나누는 대안이 있으나, 국가와 같은 기준을 쓰기 위해 ⑥으로 통일했다.
4. **Worldwide 범위가 다르다.** ④는 시장 수 표기가 없고, ⑤는 56개 시장, ⑥은 25개 시장이다. Worldwide 분해 값은 서로 다른 범위의 값을 곱한 것이다.
5. **앱 2026년 1–6월은 예비 추정치**에서 나온 값이다(`preliminary=1`).

### 8.5 주요 값

**표 9. 제품별 분해 값 — 2026-03**

| 시장 | 제품 | 점유율(%) | 앱 세션 | 앱 사용 시간 | 웹 방문 | 웹 사용 시간 |
|---|---|---|---|---|---|---|
| Worldwide | 카테고리 전체 | 100 | 1,571.4억 회 | 58.8억 시간 | 224.1억 회 | 76.4억 시간 |
| Worldwide | ChatGPT | 48.1 | 755.8억 회 | 28.3억 시간 | 107.8억 회 | 36.7억 시간 |
| Worldwide | Google Gemini | 27.1 | 425.9억 회 | 15.9억 시간 | 60.7억 회 | 20.7억 시간 |
| Worldwide | Claude | 8.4 | 132.0억 회 | 4.94억 시간 | 18.8억 회 | 6.42억 시간 |
| South Korea | 카테고리 전체 | 100 | 30.5억 회 | 1.17억 시간 | 4.11억 회 | 1.58억 시간 |
| South Korea | ChatGPT | 43.9 | 13.4억 회 | 5,133만 시간 | 1.80억 회 | 6,929만 시간 |
| South Korea | Google Gemini | 28.4 | 8.65억 회 | 3,321만 시간 | 1.17억 회 | 4,483만 시간 |
| South Korea | Claude | 7.0 | 2.13억 회 | 818만 시간 | 2,875만 회 | 1,105만 시간 |

점유율은 정규화한 값(`share_norm_pct`)이다. 앱 값은 2026H1 예비 추정치에서 나온 월별 값이다. 8.4절의 주의 3에 따라, Claude의 앱 값은 과대, 웹 값은 과소일 가능성이 크다.
