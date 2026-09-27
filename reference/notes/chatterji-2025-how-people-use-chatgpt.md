---
title: "How People Use ChatGPT"
authors: Aaron Chatterji, Thomas Cunningham, David J. Deming, Zoe Hitzig, Christopher Ong, Carl Yan Shan, Kevin Wadman
institution: "NBER (OpenAI, Duke University, Harvard University)"
year: 2025
doi: ""
category: [labor_economics]
source_tier: 1
pdf_path: reference/papers/chatterji-2025-how-people-use-chatgpt.pdf
pdf_filename: chatterji-2025-how-people-use-chatgpt.pdf
verified_date: 2026-09-27
datasets_used: []
acquisition: "Claude가 2026-09-27 NBER(https://www.nber.org/system/files/working_papers/w34255/w34255.pdf)에서 직접 내려받음. econ-wiki 규칙(0.1절)상 Claude가 받은 원문은 Tier 2로 인정되지 않아, 사용자 결정에 따라 AI-effects에만 등록하고 D:/econ-wiki에는 등록하지 않음. 이 노트는 econ-wiki sources 형식을 따라 AI-effects에서 새로 작성함."
---

## One-line Summary
OpenAI 내부 자료로 소비자용 ChatGPT(Free·Plus·Pro)의 성장과 사용 내용을 처음으로 분석한 경제학 논문. 2025년 7월 주간 이용자 7억 명(세계 성인의 약 10%)이 주당 메시지 180억 건을 보냈고, 비업무 메시지 비중이 53%에서 70%를 넘는 수준으로 늘었으며, 사용의 약 80%가 실용적 조언·정보 검색·글쓰기에 집중됨을 보임.

## Document Information
- **유형**: NBER Working Paper No. 34255
- **발행**: 2025년 9월 (NBER, 동료심사 전 논문)
- **저자 소속**: Chatterji(Duke Fuqua·OpenAI), Cunningham(OpenAI), Deming(Harvard Kennedy School·NBER), Hitzig(OpenAI·Harvard Society of Fellows), Ong(Harvard·OpenAI), Shan(OpenAI), Wadman(OpenAI)
- **JEL 코드**: J01, O3, O4
- **윤리**: Harvard IRB 승인(IRB25-0983). 연구진은 메시지 원문을 보지 않음(p.5)
- **분량**: 본문 36쪽 + 참고문헌 + 부록 A(분류 프롬프트)·B(검증)·C(모델 출시 일정)·D(GWA×직업 교차표)

## Key Contributions
1. 챗봇 사용 자료를 이용한 첫 경제학 논문으로, OpenAI 내부 메시지 자료를 사용(p.36).
2. 개인정보 보호형 자동 분류 파이프라인: 메시지에서 개인식별정보를 LLM 도구로 지운 뒤 LLM 분류기만으로 분류하고, 사람은 분류 결과만 봄(p.7, Figure 1).
3. 새 분류 체계 "Asking/Doing/Expressing"(정보·조언 요청 / 작업 수행 요청 / 감정·의견 표현)을 도입(p.3, 5.3절).
4. 데이터 클린룸에서 이용자의 공개 직업·학력 정보를 집계 단위로만 연결해 교육·직업별 사용 차이를 분석(3.3절, 6.4–6.5절).

## Methodology and Data
- **성장 자료(Growth)**: 2022년 11월–2025년 9월 소비자 플랜 전체 이용자의 **이용자×일 단위 메시지 수**와 기본 속성(첫 사용 시점, 계정 국가, 플랜, 자기보고 연령). 기업용 플랜(Business, Enterprise, Education)은 제외(3.1절, p.5–6). 이 자료 자체는 공개되지 않음.
- **분류 메시지 표본(전체 이용자)**: 2024년 5월–2025년 6월(정확히는 5월 15일–6월 26일) 약 110만 개 대화를 균등 추출하고, 대화마다 메시지 1개를 뽑아 분류. 학습 사용 거부자, 18세 미만, 삭제 대화, 정지 계정, 로그아웃 이용자는 제외(3.2절, p.6).
- **분류 메시지 표본(이용자 부분집합)**: 약 13만 명 이용자의 메시지. ① 대화 단위 추출 158만 개(이용자 비중이 메시지 양에 비례), ② 이용자 단위 추출(이용자당 최대 6개)(p.6).
- **대화의 정의**: "a conversation is a series of messages between the user and chatbot"(p.6).
- **분류 방식**: 분류 대상 메시지 앞의 최대 10개 메시지를 문맥으로 포함, 메시지는 5,000자로 자름. gpt-5-mini로 분류(상호작용 품질만 gpt-5)(p.7).
- **분류기 5종**: 업무 관련 여부, 대화 주제(24개 범주 → 7개 주제), Asking/Doing/Expressing, O*NET IWA(332개 + Ambiguous), 상호작용 품질(Good/Bad/Unknown). 프롬프트는 부록 A(품질 분류기는 비공개).
- **검증**: 공개 WildChat 대화에 사람이 붙인 라벨과 비교. 모델-사람 다수결 일치도(Cohen's κ): 업무 여부 0.83, Asking/Doing/Expressing 0.74, 대화 주제 0.56, 상호작용 품질 0.14. IWA는 Fleiss's κ 0.47(GWA 집계 0.40)(부록 B.1, p.53–56).
- **고용 자료**: 약 13만 명 이용자의 공개 직업·학력 정보를 외부 업체가 데이터 클린룸에서 집계. 100명 미만 셀은 공개하지 않음(3.3절, p.8).

## Key Results
- **규모**: 2025년 7월 주간 이용자 7억 명이 주당 메시지 180억 건을 보냄(세계 성인의 약 10%)(p.1). 결론에서는 "700 million users … more than 2.5 billion messages per day, or about 29,000 messages per second"(p.36).
- **하루 메시지 수(정확한 측정값, 표 1, p.2)**: 2024년 6월 4.51억 건(비업무 2.38억·53%, 업무 2.13억·47%) → 2025년 6월 26.27억 건(비업무 19.11억·73%, 업무 7.16억·27%). 6월 26일로 끝나는 7일 평균. 전체 건수는 소비자 플랜 전체의 정확한 값이고, 업무/비업무 구분은 표본 분류로 추정한 값.
- **주간 활성 이용자(WAU)**: 출시 1년 후 1억 명 이상, 2년 후 약 3.5억 명, 2025년 7월 말 7억 명 이상(Figure 3, p.10). 계정 수 기준이라 한 사람이 여러 계정을 쓰면 중복 계산될 수 있음(각주 20).
- **메시지 증가**: 2024년 7월–2025년 7월 사이 전체 메시지가 5배 넘게 증가(Figure 4, p.10).
- **이용자당 사용 강도(Figure 5, p.12)**: 가입 시기별 "주간 활성 이용자 1인당 하루 메시지 수"를 보여 주나 **지수(Q1 2023 코호트 첫 값 = 기준)로만 표시**되어 절대 수준은 알 수 없음. 먼저 가입한 코호트일수록 이용자당 메시지가 많고, 모든 코호트에서 시간이 지나며 증가.
- **업무 비중**: 비업무 메시지 53%(2024.6) → 73%(2025.6). 업무 비중 하락은 주로 기존 이용자 코호트 안에서의 사용 변화 때문(p.2, 5.1절).
- **주제**: 실용적 조언(Practical Guidance)·정보 검색(Seeking Information)·글쓰기(Writing)가 약 77–78%. 실용적 조언은 약 29%로 일정, 글쓰기 36%(2024.7) → 24%(2025.7), 정보 검색 14% → 24%, 기술 지원 12% → 약 5%. 프로그래밍 4.2%, 관계·개인 성찰 1.9%, 게임·롤플레이 0.4%(5.2절, p.14–16). 튜터링·교육 요청 10.2%.
- **업무 메시지 주제**: 2025년 7월 업무 메시지의 약 40%가 글쓰기(결론에서는 전체 기간 평균 42%)(p.14, p.36). 글쓰기 메시지의 약 3분의 2는 이용자가 준 글을 고치는 요청.
- **Asking/Doing/Expressing**: 전체 49%/40%/11%. 2025년 6월 말 51.6%/34.6%/13.8%. 업무 메시지는 Doing 약 56%, Asking 35%, Expressing 9%(5.3절, p.17–19). (결론 p.36은 Expressing을 "1%"로 적었으나 본문 수치와 맞지 않는 오기로 보임.)
- **O*NET GWA**: 전체 메시지의 45.2%가 정보 획득(19.3%)·정보 해석(13.1%)·정보 기록(12.8%). 업무 메시지는 상위 7개 GWA가 약 81%(5.4절, p.20).
- **인구학적 특성**: 전형적 남성 이름 비중이 초기 약 80%에서 2025년 6월 48%로 하락. 18–25세가 메시지의 약 46%. 저·중소득국에서 빠르게 성장(6.1–6.3절).
- **교육·직업**: 업무 메시지 비중은 학사 미만 37%, 학사 46%, 대학원 48%. 직업별로 컴퓨터 관련 57%, 경영·사업 50%, 공학·과학 48%, 기타 전문직 44%, 비전문직 40%(6.4–6.5절, p.28–31).

## Limitations and Future Work
- 소비자 플랜만 대상이며 기업용 플랜(Business, Enterprise, Education)과 API 사용은 제외(각주 5, 27).
- 로그아웃 이용자는 2025년 3월부터만 자료가 있어 전부 제외(각주 16).
- 분류는 LLM 추정이며 주제·품질 분류는 사람 간 일치도도 낮은 편(부록 B).
- 이용자×일 단위 메시지 자료를 보유하고 있으나 이용자당 메시지 수의 절대 수준이나 대화당 메시지 수는 보고하지 않음(Figure 5는 지수).
- 계정 기준 이용자 수는 한 사람의 복수 계정을 중복 계산할 수 있음(각주 20).

## Related Work
- [[handa-2025-which-economic-tasks-are]] — Claude 대화 기반 과업 사용 분석. 본 논문은 ChatGPT의 프로그래밍 비중(4.2%)이 Handa et al.의 Claude(업무 대화의 약 33–37%가 컴퓨터·수학)와 크게 다르다고 비교(p.2, 각주 8).
- [[eloundou-2023-gpts-are-gpts-an-early]] — OpenAI 연구진의 과업 노출도 연구. 본 논문은 노출이 아니라 실제 사용을 측정.
- [[bick-2026-what-work-does-generative]] — 설문 기반 과업별 생성형 AI 사용 측정. OpenAI 자료가 메시지 1개를 채팅 1건으로 센다는 점을 지적.
- [[fan-2026-aggregate-gains-from-ai]] — AEI 사용 자료로 LCE를 추정하며 이용자당 하루 3건의 대화를 출처 없이 가정. 본 논문의 메시지 수·이용자 수는 이 가정을 점검하는 외부 근거가 됨.
- [[acemoglu-2024-the-simple-macroeconomics-of-ai]] — 본 논문이 AI의 거시경제 효과 논의의 맥락으로 인용.

## Glossary
- **메시지(message)**: 이용자가 챗봇에 보낸 입력 1개. 본 논문의 기본 분석 단위.
- **대화(conversation)**: 이용자와 챗봇이 주고받은 메시지의 연쇄(p.6). 분류 표본은 대화를 먼저 뽑고 대화 안에서 메시지 1개를 뽑음.
- **WAU(weekly active users)**: 한 주 동안 활동한 계정 수. 로그인 이용자는 이메일, 로그아웃 이용자는 브라우저 쿠키 기준(각주 20).
- **Asking/Doing/Expressing**: 정보·조언 요청 / 모델이 산출물을 만들어 주는 작업 요청 / 정보나 작업 요청 없이 의견·감정을 표현.
- **데이터 클린룸(DCR)**: 서로의 원자료를 보지 않고 사전 승인된 집계 계산만 허용하는 보안 분석 환경.
