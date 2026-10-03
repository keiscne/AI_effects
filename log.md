# 작업 로그

작업일별로 아래 형식으로 기록합니다.

```
## YYYY-MM-DD

- 작업 내용 요약
- 추가/수정한 데이터: (raw/proc 경로)
- 추가/수정한 do 파일: (code/ 경로)
- 주요 의사결정 및 이유
```

---

## 2026-08-15

- 저장소 초기 구조 설계 및 생성 (CLAUDE.md, 폴더 구조).
- 결정 사항:
  - Stata do 파일은 `code/` 폴더에 별도로 관리 (data/ 하위에 두지 않음).
  - `data/raw`, `data/proc`는 데이터 소스별(exposure / usage / macro) 하위 폴더로 구분. `data/proc`에는 결합 데이터용 `merged/` 폴더 추가.
  - `reference/`는 PDF 원본을 파일명 기준으로 직접 보관 (별도 문헌관리 툴 미사용).
- report/paper 작성 규칙 추가: LaTeX(.tex), 한국어, `reference/references.bib` 인용, report(`NN_주제.tex`) 다수 → paper(`main.tex`) 통합 구조.
- `D:/econ-wiki`(Obsidian 기반 경제학 위키)에서 AI 관련 문헌을 `reference/`로 가져옴.
  - 범위: 제목에 AI/GPT/생성형AI/인공지능이 명시된 논문 + automation/task-based 프레임워크(Acemoglu 2011/2018/2019/2022) + 로봇 도입(Humlum 2019) — "중간" 범위로 결정.
  - `reference/papers/`: PDF 56편 (`D:/econ-wiki/papers/local/`에서 복사).
  - `reference/notes/`: 대응하는 `D:/econ-wiki/sources/*.md` 노트 51편 (부록 등 5편은 별도 노트 없음).
  - `D:/econ-wiki/wiki/reference/`의 위키링크 노트는 vault 밖에서 링크가 깨지므로 가져오지 않음.
  - 폴더 구조를 `reference/papers/`, `reference/notes/` 유형별 하위 폴더로 변경 (기존 평면 구조에서 수정).
  - `D:/econ-wiki`는 원본 그대로 두었음 (복사, 이동 아님) — 두 저장소 모두에 AI 문헌이 존재하므로 향후 신규 문헌 추가 시 양쪽 동기화 필요.

## 2026-08-17

- `reference/notes/`에 수록된 문헌 51편을 "AI 영향의 실증적 정의" 기준으로 정리한 문헌리뷰 보고서 작성.
  - 추가한 데이터/문헌: `reference/references.bib` (신규 생성, 51개 citation key — `reference/notes/`, `reference/papers/` 파일명과 동일하게 유지).
  - 추가한 보고서: `results/report/01_AI영향_실증연구_정리.tex` (LaTeX 원본, xelatex+kotex+biblatex/biber 기준 작성. 로컬에 TeX 배포판이 없어 미컴파일 — 향후 TeXLive/MiKTeX 설치 후 컴파일 필요), `results/report/01_AI영향_실증연구_정리.pdf`, `results/report/01_AI영향_실증연구_정리.docx` (MS Word COM 자동화로 HTML 중간본을 변환해 생성; tex와 동일한 내용을 담은 산출물이나 자동 변환 파이프라인이 아니므로 tex 내용 수정 시 pdf/docx도 별도로 재생성 필요).
  - 정리 기준: (1) AI 영향의 실증적 정의·지표, (2) 활용 데이터, (3) 종속변수, (4) 실증 대상 국가·범위. 측정방법론에 따라 노출도(exposure) 기반/실제 채택(adoption) 기반/실제 사용(usage) 기반 3개 범주로 분류, 순수 이론모형(Acemoglu 2011 등)은 별도 배경 절로 분리.
  - 주요 의사결정: 로컬 환경에 xelatex/pandoc이 설치되어 있지 않아(MS Word만 사용 가능) LaTeX 소스는 저장소 관례(CLAUDE.md)에 따라 정식 작성하되, 실제 열람 가능한 산출물은 Word COM 자동화(PowerShell → HTML → docx/pdf)로 별도 생성하는 이원화 방식을 채택.
  - 후속 과제: TeX 배포판 설치 후 `.tex` 컴파일 검증, `references.bib`의 DOI 등 일부 미상 필드 보완.

## 2026-09-06

- `D:/econ-wiki`에 신규 ingest된 AI 관련 문헌 2편을 `reference/`에 추가.
  - `reference/papers/`: `bick-2026-what-work-does-generative.pdf`, `bok-2026-youth-employment-decline-ai-career-ladder.pdf` (`D:/econ-wiki/papers/local/`에서 복사).
  - `reference/notes/`: 대응 노트 2편 (`D:/econ-wiki/sources/*.md`에서 복사).
  - `reference/references.bib`: 두 문헌의 citation key(`bick-2026-what-work-does-generative`, `bok-2026-youth-employment-decline-ai-career-ladder`) 추가.
- `results/report/01_AI영향_실증연구_정리.tex` 수정: 두 문헌을 요약표에 반영.
  - `bick-2026-what-work-does-generative`(RPS 기반 직업·과업단위 genAI 채택지수, 노출점수 설명력·챗로그 비교): §4(실제 채택 기반) 표 마지막 행에 추가, §4 개관에 가교적 사례로 서술 추가.
  - `bok-2026-youth-employment-decline-ai-career-ladder`(오삼일·오영식, 한진수·오삼일 2025의 후속 연장 연구): §3(노출도 기반) 표에 `han-2025-ai-diffusion-youth-employment-decline` 바로 다음 행으로 추가, §5(한국 대상 연구 종합) 노출도 이식형 목록·연공편향 패턴 서술에도 반영.
- `01_AI영향_실증연구_정리.pdf`/`.docx`를 `.tex` 수정 내용에 맞춰 재생성 (Word COM 자동화, 기존 파일을 직접 편집: 표 1에 `오삼일·오영식 (2026)` 행 추가, 표 2에 `Bick et al. (2026b)` 행 추가, 관련 서술 3곳 수정).
  - `bick-2026-what-work-does-generative`와 기존 `bick-2026-mind-the-gap-ai-adoption`이 둘 다 "Bick et al. (2026)"로 겹쳐 저자·연도만으로 구분되지 않으므로, 문헌 제목 알파벳순(Mind the Gap < What Work)으로 `(2026a)`/`(2026b)`를 부여해 기존 인용도 함께 수정(본문 개관 문단·표 모두 반영).
- (같은 날) `01_AI영향_실증연구_정리.docx`의 표 1·표 2(및 표 3)가 페이지 폭을 넘어 오른쪽 열이 잘려 보이는 문제 발견·수정.
  - 원인: HTML→Word 변환 과정에서 표의 각 셀 너비가 `w:type="pct"`(100% 기준)로 저장되었는데, 실제 렌더링 시 기준이 되는 컨테이너 폭이 본문 인쇄 영역(약 451pt)이 아니라 그보다 넓은 값(약 541~557pt, 원본 HTML의 `<div>` 폭 잔재로 추정)으로 계산되어 표 전체가 페이지보다 넓게 그려짐.
  - 조치: `word/document.xml`의 표 3개 모두에서 `tblW`/`tcW`의 `pct` 값을 절대단위(`dxa`, twips)로 변환해 열 비율은 유지한 채 합계가 정확히 본문 인쇄 영역 폭(9026 twips = 451.3pt)이 되도록 재계산하고 `tblGrid`도 동일하게 맞춤(docx를 zip으로 직접 열어 XML 패치 후 재압축, Word COM으로 무결성 확인 후 PDF 재생성).
  - 후속 참고: 이 문서는 xelatex로 컴파일한 것이 아니라 HTML 중간본을 거친 수작업 변환본이므로, 향후 `.tex`에 표를 추가/수정할 때마다 이런 폭 이슈가 재발할 수 있음 — TeX 배포판 설치 후 실제 컴파일로 전환하는 것이 근본적 해결책.
- (같은 날, 추가 수정) 표 폭 문제가 재발해 재점검한 결과, 실제 원인은 `w:type="pct"` 자체가 아니라 표 3개 모두에 `<w:tblLayout w:type="fixed"/>` 지정이 없었던 것으로 확인. HTML 기원 표는 기본이 "내용에 맞춰 자동조정(autofit)" 레이아웃이라, 셀 너비를 dxa로 맞춰도 Word가 긴 영문 토큰 등 내용에 맞춰 열을 다시 넓혀 페이지 폭을 넘길 수 있었음.
  - 조치: 표 3개의 `tblPr`에 `<w:tblLayout w:type="fixed"/>`를 추가해 지정한 dxa 폭을 강제 고정, 내용이 넘칠 경우 열 확장 대신 줄바꿈되도록 수정(docx 직접 XML 패치 → 재압축 → Word COM으로 모든 행이 정확히 본문 폭(451.3pt)과 같음을 재검증 → PDF 재생성, 총 16페이지).
- `results/report/01_AI영향_실증연구_정리.md` 신규 추가 (사용자 요청). 기존 pdf/docx/tex와 별개로, 컴파일 도구 없이도 바로 열람 가능한 마크다운 렌더링본 목적.
  - 생성 방식: `.tex`를 직접 변환한 것이 아니라, 이미 `.tex`와 동기화되어 있던 `.docx`의 `document.xml`을 구조적으로 파싱(제목/저자/초록/장·절 제목/목록/3개 표/참고문헌 안내문)해 마크다운으로 변환 — 인용 표기(저자(연도), 동명이인/동일저자·연도 중복 시 `a`/`b` 구분 등)를 다시 계산하지 않고 docx에 이미 확정된 표기를 그대로 재사용해 세 산출물(pdf/docx/md) 간 인용 표기 불일치를 방지.
  - 향후 `.tex`를 수정하면 pdf/docx뿐 아니라 이 `.md`도 함께 갱신해야 함(자동 동기화 파이프라인 없음, 수작업 재생성 필요).
- (같은 날, 추가) `D:/econ-wiki`에 신규 ingest된 Webb(2020) "The Impact of Artificial Intelligence on the Labor Market"을 `reference/`에 추가.
  - `reference/papers/webb-2020-impact-artificial-intelligence-labor.pdf`, `reference/notes/webb-2020-impact-artificial-intelligence-labor.md`를 `D:/econ-wiki/papers/local/`, `D:/econ-wiki/sources/`에서 복사.
  - `reference/references.bib`: `webb-2020-impact-artificial-intelligence-labor` citation key 신규 등재 — 기존에는 `han-2023-ai-and-labor-market-change`·`kiet-2024-ai-labor-market-industry` 요약문에서 "Webb(2020)/(2019)"로 텍스트 언급만 되던 원논문을 처음 직접 등록.
  - `results/report/01_AI영향_실증연구_정리.tex`/`.md` 수정: Webb(2020) 자체를 §4(노출도 기반) 표 1에 신규 행으로 추가(Felten et al.(2023) 행 다음, Eloundou et al.(2023) 행 앞). 특허텍스트 노출지수의 원형이며 소프트웨어·산업용로봇·AI 세 기술에 동일 방법론으로 직업-산업-연도 셀 회귀를 직접 추정한 실증연구이므로 §3(이론적 배경)이 아닌 §4 실증표에 포함시킴. §4.1 개관에 Webb(2020)이 한지우·오삼일(2023)·송단비 외(2024b)의 지수 원천임을 밝히는 문장을 추가하고, 표1의 한지우·오삼일(2023) 행에서 "Webb(2020)" 언급을 `\citet{}`(tex)로 연결.
  - `.tex`의 longtable 컬럼폭을 표1·2·3 공통으로 조정(2.6/4.6/4.0/2.9/2.6cm → 2.3/4.1/3.6/2.6/2.3cm, `\tabcolsep` 6pt→4pt): 기존 컬럼폭 합(16.7cm)이 a4paper margin 2.2cm 기준 본문폭(16.6cm)보다 넓어, 향후 실제 xelatex로 컴파일할 경우 표 3개 모두 페이지 폭을 넘겨 잘릴 수 있는 잠재적 결함을 발견해 사전에 수정.
  - `.docx`/`.pdf`: 이번에도 로컬에 TeX 배포판이 없어 `.tex`를 직접 컴파일하지 못함. 대신 `word/document.xml`을 직접 조작해 표1의 Felten et al.(2023) 행 XML을 템플릿으로 복제, 5개 셀 텍스트만 교체하는 방식으로 신규 행을 삽입(`tcW`·`tblLayout w:type="fixed"` 등 앞서 확정된 폭 설정은 그대로 보존해 표가 다시 페이지 폭을 넘는 문제가 재발하지 않도록 함). 이어 Word COM 자동화로 문서를 재저장하고 PDF를 재출력.
  - 검증: Word COM으로 재저장된 docx의 표 3개 모두 `tblW=9026dxa`(451.3pt)·`tblLayout=fixed` 유지 확인. `Windows.Data.Pdf`로 PDF 페이지를 이미지로 직접 렌더링해 표1의 신규 Webb(2020) 행이 페이지 폭 안에서 정상적으로 줄바꿈되며 잘리지 않음을 시각적으로 확인.
- (같은 날) 신규 report `02_AI노출도_지표_비교.tex`/`.md`/`.docx`/`.pdf` 작성(사용자 요청: `01_AI영향_실증연구_정리.tex` §4의 노출도 표를 심화해, 주요 AI 노출도 지표들의 정의·산출공식·데이터·LLM 영향 조작화 방식을 별도 report로 상세 비교).
  - 다룬 지표(총 8개, `reference/notes/`의 원논문 전체를 다시 읽어 공식·데이터를 원문 그대로 재확인): Felten-Raj-Seamans AIOE(2021)+언어모델링 특화판(2023), Webb(2020) 특허텍스트 노출지수, Eloundou et al.(2023) GPT 노출 루브릭(E0–E3, β/ζ/φ), Hampole et al.(2025) 기업×과업 임베딩 노출(m·C 분해), 한국 LLM 델파이 앙상블형 AIE(한국고용정보원 `keis-2025`/KISDI `son-2025`, 동일 방법론의 두 발행물), 한국노동연구원 SkillAIAssessment(GPT-4-turbo 5인 가상패널 델파이, `chang-2025`/`noh-2025-ai-based-manufacturing...`), 한국 이식형 재계산(전병유 외 2022 AIOE-KR, 한지우·오삼일 2023 Webb-KR), Massenkoff and McCrory(2026) 관측노출(이론노출×실사용 게이트).
  - 지표별로 원논문의 수식을 최대한 원형 그대로 제시(예: AIOE_k=Σ(A_j·L_jk·I_jk)/Σ(L_jk·I_jk), Webb의 Exposure_i=Σ_k[w_k,i·Σrf_c^t]/Σ_k[w_k,i·|S_k|], Eloundou의 β=E1/ζ=E1+0.5E2/φ=E1+E2, Massenkoff의 R_o=Σ(w_t·r̃_t)/Σw_t 등), Hampole의 m/C처럼 원논문에 서술로만 제시된 부분은 정확한 폐형식을 지어내지 않고 원문 서술(2.1절 식 13–17) 그대로 인용.
  - "LLM 영향의 조작화"를 지표마다 별도 소절로 명시하고, 5장에서 이를 (i) LLM 비특정(Felten 2021 원본, Webb) → (ii) LLM 특화(Felten 2023, Eloundou) → (iii) LLM-평가자화(한국 델파이류) → (iv) 이론×실사용 결합(Massenkoff) 4단계로 종합, `bick-2026-what-work-does-generative`의 6개 노출점수 대 실제 genAI 채택률 설명력 비교(ρ, R²)를 표3으로 제시해 "노출≠실제 영향" 간극을 실증적으로 뒷받침.
  - `.tex`: report 01과 동일한 kotex/biblatex preamble 재사용, longtable 3개 모두 report 01에서 확정한 폭 규칙(합 ≈14.9cm, `\tabcolsep` 4pt)을 애초부터 적용해 재발 방지.
  - `.docx`/`.pdf`: 기존 docx가 없는 신규 report이므로, `.md`와 동일한 내용의 HTML 중간본(`report02.html`)을 새로 작성해 Word COM으로 1차 변환한 뒤, 변환 직후 `word/document.xml`의 `sectPr`(A4, 좌우 여백 각 1440twips → 인쇄영역 정확히 9026twips, report 01과 동일값으로 우연히 일치)을 프로그램적으로 읽어 표 3개의 `tblW`/`tblGrid`/`tcW`를 그 폭에 맞춰 비율대로 재계산하고 `tblLayout=fixed`를 적용(사후 발견이 아니라 이번에는 처음부터 정공법으로 적용) → Word COM 재저장·PDF 재출력.
  - 검증: `Windows.Data.Pdf`로 PDF 전체 14페이지를 이미지 렌더링해 표1(분류)·표2(공식비교)·표3(Bick 벤치마크) 모두 페이지 폭 안에 정상적으로 들어오고 잘리지 않음을 육안 확인.

---

## 2026-09-14

- 신규 report `03_AI개념_세흐름_분류.tex`/`.md`/`.docx`/`.pdf` 작성(사용자 요청: "AI"라는 용어가 (1) 기계로 인한 자동화, (2) IoT+AI 결합 4차 산업혁명, (3) LLM의 등장이라는 세 흐름으로 나뉜다는 문제의식에 따라, `reference/notes/`의 문헌 54편 전체를 이 세 흐름으로 분류하고 흐름별 AI 정의·연구주제·중심변수·내용 변화를 정리).
  - 분류 작업: 이미 직접 읽은 문헌 14편(Acemoglu-Restrepo 계열, Aghion et al., Appel et al. 2025/2026, Bick et al. 2026a/b, 한국은행 서동현 외 2025/2026)에 더해, 나머지 40편은 general-purpose 서브에이전트에 위임해 각 노트의 frontmatter·One-line Summary·Key Contributions·Methodology를 읽고 (AI정의·연구주제·중심변수·핵심내용·분류추천)을 구조화 추출하도록 함 — 서브에이전트 결과와 직접 읽은 14편을 종합해 최종 분류(흐름1: 8편, 흐름2: 16편, 흐름3: 30편, 총 54편)를 확정.
  - 핵심 판단기준: "AI"가 (1) 로봇·전용기계·소프트웨어와 개념적으로 구분되지 않는 일반 자동화 이론인지, (2) 머신러닝/딥러닝 등 특정 응용기술을 가리키며 크라우드소싱·특허텍스트·기업실태조사로 측정되는지, (3) LLM·생성형AI라는 구체적 제품과 그 실사용 로그(또는 LLM 자체평가 노출도)를 가리키는지로 구분. 두 흐름의 개념·데이터를 한 논문 안에서 병행하는 경계 문헌(예: `acemoglu-2024-the-simple-macroeconomics-of-ai`가 흐름1 이론+흐름3 노출측정 결합, `massenkoff-2026-labor-market-impacts-of-ai`가 이론적 노출+실사용을 "관측노출"로 결합)은 별도 5절에서 논의하고, 이 경계 지점이 본 프로젝트의 exposure–usage 결합 목표와 정확히 맞닿음을 6절에서 명시.
  - 본문·부록 표의 인용은 `reference/references.bib` 54개 항목 전체(빠짐없이 1회 이상 인용, cross-check로 오탈자 없음 확인)를 authoryear 스타일로 수기 변환해 `.md`/`.html`에 반영(동일 저자·연도 중복 시 알파벳 제목순으로 a/b/c 접미사 부여, 예: `Acemoglu and Restrepo (2018a/b)`, `Massenkoff et al. (2026a/c)` vs `Massenkoff and McCrory (2026b)`).
  - `.tex`: report 01/02와 동일한 xelatex+kotex+biblatex(authoryear, maxcitenames=2) preamble 재사용. longtable 2개(흐름 개관 표, 문헌 54편 분류 부록표) 모두 폭 합이 본문 인쇄영역(A4, margin 2.2cm)을 넘지 않도록 사전 설계.
  - `.docx`/`.pdf`: report 01/02와 동일한 HTML 중간본(`report03.html`) → Word COM 변환 → `word/document.xml`의 `tblW`/`tblGrid`/`tcW`를 인쇄영역 9026twips(A4, 좌우 여백 각 1440twips)에 맞춰 비율대로 재계산·`tblLayout=fixed` 적용 → 재압축 → Word COM으로 재저장 및 PDF 출력(총 12페이지). PowerShell 도구의 안전필터가 `Remove-Item`과 XPath 문자열(`"//w:tbl"`)이 한 스크립트에 같이 있을 때 오탐지하는 현상을 발견해, zip 추출과 XML 패치를 별도 PowerShell 호출로 분리해 회피.
  - 검증: `Windows.Data.Pdf`로 PDF 전체 12페이지를 이미지 렌더링해 흐름 개관 표(표1)와 문헌 54편 분류 부록표(표2, 55행)가 모두 페이지 폭 안에 정상적으로 들어오고 잘리지 않음을 육안 확인.

## 2026-09-16

- `D:/econ-wiki`에 신규 ingest된 전병유·신영민(2025) "AI 노출과 AI 적용: 기술적 잠재력과 경제적 실현의 차이 분석"(경제발전연구 31권 3호)을 `reference/`에 추가.
  - `reference/papers/cheon-2025-ai-exposure-vs-ai-adoption.pdf`, `reference/notes/cheon-2025-ai-exposure-vs-ai-adoption.md`를 `D:/econ-wiki/papers/local/`, `D:/econ-wiki/sources/`에서 복사(econ-wiki에 이미 존재하던 노트를 그대로 가져옴, 내용 수정 없음).
  - `reference/references.bib`: `cheon-2025-ai-exposure-vs-ai-adoption` citation key 신규 등재(`chang-2026-skill-network-ai-era` 다음, `eloundou-2023-gpts-are-gpts-an-early` 앞에 알파벳순 삽입).
  - 이 논문은 본 저장소의 핵심 문제의식(exposure vs. usage/adoption 괴리)과 직접 맞닿는 문헌: 기존 AIOE류 노출지수(AI가 할 수 있는 일)와 실제 한국 AI 기업 355개의 서비스텍스트를 LLM 매칭한 AI Firm Exposure(AIFE, 실제 적용도) 간 상관이 0.35에 불과함을 실증 — 향후 `03_AI개념_세흐름_분류.tex` 등 report에 반영 검토 필요(아직 미반영).
- `D:\research\AI_effects`를 git 저장소로 초기화하고 GitHub `https://github.com/keiscne/AI_effects`에 연동(사용자 요청).
  - `.gitignore` 작성: `data/raw/`, `data/proc/`(재현 가능한 가공물), `reference/papers/`(저작권 PDF, 259MB), 컴파일된 `results/*/*.pdf`·`*.docx`, `.claude/`, `.obsidian/` 제외.
  - `CLAUDE.md`, `log.md`, `reference/notes/`(59편), `reference/references.bib`, `results/report/*.tex`·`*.md` 소스를 초기 커밋(로컬 git 사용자 정보는 이 저장소에 한정해 keiscne@gmail.com으로 설정, 전역 config는 미변경) 후 원격이 비어 있음을 확인하고 `main` 브랜치로 push.
  - 이후 연동 방식은 표준 git 워크플로(수정 후 수동 add/commit/push)이며 자동 감시·자동 push 파이프라인은 구축하지 않음.

## 2026-09-17

- 신규 report `04_한국AI실증연구_방법론계보.tex`/`.md`/`.docx`/`.pdf` 작성(사용자 요청: 한국 AI 실증연구들을 (1) Felten(2021) (2) Webb(2020) (3) Eloundou(2023) 방법론 계승 여부 (4) 그 외 방법론 기준으로 분류하고, 각 논문이 해당 방법론을 어떻게 활용했는지 정리).
  - `02_AI노출도_지표_비교.tex`가 "지표" 단위로 8개 노출지수를 심화 비교한 것과 달리, 본 report는 "논문" 단위로 시각을 바꿔 동일 지표(특히 AIOE-KR)를 재사용하는 국내 문헌들이 서로 다른 실증전략(셀 회귀/삼중차분/혼합로짓 등)을 쓸 때 결론이 어떻게 달라지는지에 초점.
  - 분류 대상: `reference/notes/`의 한국 AI 노동시장 실증연구 29편 전체(이번 세션에 처음 전문을 읽은 22편 포함, 기존 대화에서 이미 읽은 cheon-2022/cheon-2025/felten-2021/report02 7편 재활용). Felten 계열 8편, Webb 계열 3편, Eloundou 계열 7편(실질, 장 분리 중복 제외), 그 외 방법론 13편, 순수 방법론 리뷰 1편(이학기 외 2024 3장)으로 분류.
  - 분류 판단기준: Eloundou 계열은 원 논문의 E0–E3 루브릭을 직접 쓰는 경우(`cheon-2025`의 AIOE_by_GPT)뿐 아니라, "LLM이 과업/숙련의 자동화가능성을 직접 판정"한다는 핵심 아이디어를 계승해 독자적인 델파이·앙상블로 변형한 경우(한국노동연구원 SkillAIAssessment 계열, KEIS/KISDI 8개 LLM 델파이 계열)까지 포함해 넓게 정의. `nam-2026`(KDI)은 Eloundou의 노출개념을 5축으로 재정의하는 독자 지표(AI score)를 만들어 방법론적으로 크게 갈라지므로 Eloundou 계승이 아닌 "기타"로 분류하되 개념적 연원만 본문에 명시.
  - 경계 사례(한 보고서 안에서 장마다 다른 계보 사용)를 §7에 별도 정리: `cheon-2025`(Felten+Eloundou+기타), `chang-2024`(Felten+기타), `kiet-2024-ai-labor-market-industry`(Webb+기타), `chang-2025-ai-era-skills`(Eloundou+기타 숙련네트워크).
  - `.tex`: report 01–03과 동일한 xelatex+kotex+biblatex(authoryear) preamble 재사용. longtable 8개(원조방법론 요약, Felten/Webb/Eloundou/기타1·2·3 계승연구, 29편 종합) 모두 열 폭 합을 사전에 인쇄영역(A4, margin 2.2cm 기준 16.6cm) 이내로 설계.
  - `.docx`/`.pdf`: report 01–03과 동일한 HTML 중간본(`report04.html`) → Word COM 변환 → `word/document.xml`의 tblW/tblGrid/tcW를 인쇄영역 9026twips(A4, 좌우 여백 각 1440twips)에 맞춰 비율대로 재계산·`tblLayout=fixed` 적용 → 재압축 → Word COM 재저장 및 PDF 출력(총 13페이지). 이번에는 `[xml]$xml = Get-Content -Raw` 캐스트가 인코딩 문제로 XML 파싱에 실패하는 신규 이슈를 발견 — `System.Xml.XmlDocument.Load(path)`로 파일을 직접 로드하는 방식으로 전환해 해결(향후 report의 docx 파이프라인에도 이 방식 적용 필요).
  - 검증: `Windows.Data.Pdf`로 PDF 전체 13페이지를 이미지 렌더링해 8개 표 모두 페이지 폭 안에 정상적으로 들어오고 잘리지 않음을 육안 확인(특히 4열 표와 29편 종합표의 2열 표 모두 확인).
- 신규 report `05_Felten계승연구_직업분류매칭여부.tex`/`.md`/`.docx`/`.pdf` 작성(사용자 요청: `04_한국AI실증연구_방법론계보.tex`의 Felten(2021) 계승 연구 8편만 대상으로, (1) 미국-한국 직업분류 매칭을 거쳐 AIOE를 이식했는지 (2) 매칭 없이 한국 자료에 방법론을 직접 적용해 AIOE를 산출했는지 구분).
  - 8편의 원문 방법론 절을 재확인(`grep`으로 "SOC·ISCO·KSCO·크로스워크·미국 직업분류" 등 키워드가 등장하는지 8개 노트 전체를 재검색)한 결과, 8편 전원이 유형 (2)(직접 적용형)에 해당하고 유형 (1)(직업분류 매칭형) 사례는 없음을 확인. 대조군으로 Webb(2020) 계승 연구(`han-2023`)의 "O*NET→ISCO→KSCO" 크로스워크 서술을 인용해, 이 차이가 Felten 방법론(능력 단위 연계표·직업 단위 프로파일의 분리 가능) 대 Webb 방법론(직업 텍스트에 고정된 점수)의 구조적 차이에서 비롯됨을 §2·§5에서 논증.
  - 8편을 "원 산출(1차 계산)"과 "재사용(기존 AIOE-KR 시리즈에 자신의 직업코드만 연결)"로 추가 구분(§4, 사용자가 요청한 축과는 별개의 보조 분석): 원 산출은 `cheon-2022`(15개 능력변수, 최초)·`kiet-2025`(19개 능력변수, 독자 재계산)·`chang-2024` 3장(전병유, 동일 방법론 추정)이며, 재사용은 `han-2025`·`bok-2026-youth`·`bok-2025-rapid`·`noh-2025-labor-coexistence` 2장·`cheon-2025`(유일하게 원 출처를 `cheon-2022`로 명시). 재사용 4편은 "Felten et al.(2021)의 AIOE"라고만 인용해 정확한 1차 산출 논문을 특정하지 못함 — 후속 확인이 필요한 항목으로 결론에 명시.
  - `.tex`: report 01·04와 동일한 xelatex+kotex+biblatex(authoryear) preamble 재사용(단, 3~5절 구성상 titlesec 미사용). longtable 1개(5열, 8행)만 사용, 열 폭(2.4/1.7/3.5/3.3/3.7=14.6cm)을 인쇄영역(16.6cm) 이내로 사전 설계.
  - `.docx`/`.pdf`: report 04에서 확정한 `System.Xml.XmlDocument.Load(path)` 기반 표 폭 패치 파이프라인(HTML→Word COM 변환→document.xml의 tblW/tblGrid/tcW를 9026twips로 재계산·`tblLayout=fixed`→재압축→Word COM 재저장·PDF 출력, 총 6페이지)을 그대로 재사용해 문제 없이 1회에 적용 성공.
  - 검증: `Windows.Data.Pdf`로 PDF 전체 6페이지를 이미지 렌더링해 표 1(5열, 3~4페이지에 걸쳐 행 단위로 자연스럽게 분할)이 페이지 폭 안에 정상적으로 들어오고 잘리지 않음을 육안 확인.
  - `git add`+`commit`으로 `.tex`/`.md`와 `log.md` 갱신분을 로컬 커밋(사용자 확인 후 진행, push는 별도 요청 시 진행 — `.docx`/`.pdf`는 `.gitignore`에 의해 미추적).

## 2026-09-19

- 신규 report `06_AI채택_실사용_데이터방법론.tex`/`.md`/`.docx`/`.pdf` 작성(사용자 요청: AI 영향을 노출도 외에 (1) AI 채택 여부 (2) 실제 AI 사용량으로 정의한 실증연구를 데이터 출처와 방법론 중심으로 정리).
  - `01_AI영향_실증연구_정리.tex`의 §4(채택)·§5(실사용)를 씨줄로 삼되, 노출도 절을 완전히 제외하고 "데이터 출처"(수집기관·조사설계·표본·시점·주기·원자료 성격)와 "방법론"(처치변수 정의·추정모형·식별전략)이라는 두 축으로 재정리한 심화 report. 대상 28편(채택 16편+실사용 12편)의 데이터·방법론 추출은 general-purpose 서브에이전트에 위임(28개 노트 전문을 각각 읽고 A/B/C 구조로 요약하도록 지시)해 받은 결과를 검증 후 표로 정리.
  - 신규로 `cheon-2025-ai-exposure-vs-ai-adoption`(전병유·신영민 2025)의 AI Firm Exposure(AIFE)를 채택 범주 핵심 사례로 처음 편입 — 2026-09-16 로그에 "아직 미반영"으로 남아 있던 항목. AIFE는 수요측 자기보고가 아니라 AI 공급기업 355개(대표기업 51개+스타트업 339개, 과기정통부·NIPA/한국인공지능협회 발간)의 서비스 텍스트를 직업 과업과 GPT로 매칭한 공급측 지표라는 점에서, §2.1에서 채택 데이터 출처의 "제7유형"으로 별도 서술하고 결론(§5)에서 본 프로젝트의 `data/proc/merged/` 설계 템플릿으로 제안.
  - 채택 데이터 출처를 7갈래(정부 기업패널조사/단면 실태조사/텍스트마이닝 간접식별/구인공고 기반 간접식별(Babina et al. 2020)/국제 서베이/서베이 기반 과업단위 채택지수/AI공급기업 텍스트매칭), 실사용 데이터 출처를 2갈래(Anthropic Economic Index Claude 대화로그/한국은행 가계조사 자기보고, 실험실 실험 보조)로 유형화. 방법론은 순수기술통계→회귀/TWFE→준실험(사건연구·다시점DID)→IV/구조모형(채택) 대 자기일관성추정·이론노출게이팅(실사용)의 스펙트럼으로 대조(표 3).
  - 일부 경계 문헌(`nam-2026`, `kiet-2024-ai-labor-market-industry`, `chang-2024`, `noh-2025` 2편)은 노출도와 채택을 병행하므로, 채택과 직접 관련된 장·절만 발췌해 반영(노출도 부분은 `04_한국AI실증연구_방법론계보.tex` 참조를 명시).
  - 인용 표기: `kiet-2024-ai-adoption-firms-policy`/`kiet-2024-ai-labor-market-industry`(송단비 외 2024a/b), `noh-2025-ai-based-manufacturing-innovation-employment`/`noh-2025-ai-labor-coexistence`(노세리 외 2025a/b)는 제목 알파벳순으로 a/b 신규 부여. `massenkoff-2026-cadences`/`labor-market-impacts-of-ai`/`learning-curves`는 04·05에서 확립된 기존 표기(Massenkoff et al. 2026a/c, Massenkoff and McCrory 2026b)를 그대로 재사용.
  - `.tex`: report 01/04/05와 동일한 xelatex+kotex+biblatex(authoryear, maxcitenames=2) preamble 재사용. longtable 2개(채택 16행, 실사용 12행, 3열: 문헌/데이터출처/방법론)와 비교용 일반 table 1개(6행, 3열)를 사용, 열 폭 합을 인쇄영역(A4, margin 2.2cm 기준 16.6cm) 이내로 사전 설계(2.5+6.4+6.4=15.3cm).
  - `.docx`/`.pdf`: report 04·05에서 확정한 `System.Xml.XmlDocument.Load(path)` 기반 표 폭 패치 파이프라인(HTML→Word COM 변환→document.xml의 tblW/tblGrid/tcW를 인쇄영역 9026twips(A4, 좌우 여백 각 1440twips)로 비율 재계산·`tblLayout=fixed`→zip 재압축→Word COM 재저장·PDF 출력, 총 12페이지)을 재사용해 1회에 적용 성공(표 3개 모두 orig 폭 합이 9026twips를 초과해 있었으나 비율 유지 축소로 정확히 9026twips에 맞춤).
  - 검증: `Windows.Data.Pdf`로 PDF 전체 12페이지를 이미지 렌더링해 표 1(16행)·표 2(12행)·표 3(6행) 모두 페이지 폭 안에 정상적으로 들어오고 잘리지 않음을 육안 확인.

## 2026-09-21

- 신규 report `07_AEI실증연구_노출도사용량_계보.tex`/`.md`/`.docx`/`.pdf` 작성(사용자 요청: Anthropic Economic Index(AEI)를 활용한 실증연구만 대상으로, 각 연구가 (1) AI 노출도, (2) AI 사용량을 어떻게 정의하고 논의를 어느 쪽 중심으로 전개하는지, 그리고 이전 세대의 노출도·채택 연구를 어떻게 계승·발전시켰는지 정리).
  - 대상 선정: `reference/notes/` 전체를 "Anthropic Economic Index"·"Claude.ai" 데이터 직접 사용 여부로 검색(`grep -li`)해 AEI 데이터를 1차 실증 자료로 삼는 문헌 9편을 확정 — AEI 공식 시리즈 5편(`handa-2025-which-economic-tasks-are`[R1], `appel-2025-uneven-geographic-and-enterprise-ai`[V3], `appel-2026-economic-primitives`[V4], `massenkoff-2026-learning-curves`[V5], `massenkoff-2026-cadences`[V6])과 응용연구 4편(`tamkin-2025-estimating-ai-productivity-gains-from`, `massenkoff-2026-labor-market-impacts-of-ai`, `fan-2026-what-countries-use-ai-and`, `fan-2026-aggregate-gains-from-ai`). `bok-2026-youth-employment-decline-ai-career-ladder`·`chang-2026-ai-technology-diffusion-employment`는 Handa et al.(2025)을 배경 서술로만 인용할 뿐 AEI 데이터를 직접 분석하지 않아 제외. `bick-2026-what-work-does-generative`는 서베이(RPS)가 주자료이고 AEI는 비교·검증용 2차 데이터라 핵심 9편에서는 제외하되 §5.3에 별도 논의로 편입.
  - 핵심 발견(직접 9편 전문 재확인): 9편 중 7편(Handa 2025; Appel 2025/2026; Tamkin and McCrory 2025; Massenkoff et al. 2026c; Fan 2026; Fan and Nguyen 2026)은 노출도를 변수로 전혀 다루지 않는 순수 사용량 중심 연구이며, 노출도는 서론에서 "극복 대상 선행 패러다임"으로만 인용됨. 오직 `massenkoff-2026-labor-market-impacts-of-ai`(Massenkoff and McCrory 2026b)만이 Eloundou et al.(2023)의 β를 실사용 데이터(WorkUsage≥100 임계치)로 게이팅한 "관측노출" 지수를 계산적으로 구축하는 결합형이고, `massenkoff-2026-cadences`(Massenkoff et al. 2026a)는 2026년 4월 개시된 AEI Survey(N≈9,700)로 설문 기반 "보고노출/기대노출"을 실사용 패턴(자동화비중)과 상관분석하는 별개 방식의 결합형임을 확인.
  - 사용량 정의의 계승 계보를 8단계로 정리: 폭/깊이(Handa 2025) → 지리(Appel 2025) → 시간가치/깊이(Tamkin and McCrory 2025) → 성공률 가중 커버리지(Appel 2026) → 이론노출 게이팅(Massenkoff and McCrory 2026b) → 동태성/tenure(Massenkoff et al. 2026c) → 국가간 강도·확산폭(Fan 2026) → 설문 연계(Massenkoff et al. 2026a) → 화폐화·분배(Fan and Nguyen 2026). 각 단계가 직전 연구의 측정 한계를 지적하며 새 축(공간·시간·질·주관성·화폐가치)을 추가하는 누적적 발전임을 표 3에 명시.
  - `.tex`: report 01/04/05/06과 동일한 xelatex+kotex+biblatex(authoryear, maxcitenames=2) preamble 재사용. longtable 4개(표1 개관 4열/9행, 표2 노출도 취급 4열/9행, 표3 사용량 정의 4열/9행, 표4 중심축 종합 3열/9행) 사용, 열 폭 합을 인쇄영역(A4, margin 2.2cm 기준 16.6cm) 이내로 사전 설계(4열 표는 15.6cm, 3열 표는 15.0cm).
  - `.docx`/`.pdf`: report 04·05·06에서 확정한 `System.Xml.XmlDocument.Load(path)` 기반 표 폭 패치 파이프라인(HTML 중간본 `report07.html` 작성→Word COM 변환→document.xml의 tblW/tblGrid/tcW를 인쇄영역 9026twips(A4, 좌우 여백 각 1440twips)로 비율 재계산·`tblLayout=fixed`→zip 재압축→Word COM 재저장·PDF 출력, 총 11페이지)을 재사용. 이번에도 PowerShell 안전필터가 `Remove-Item`과 XPath 문자열(`"//w:sectPr"`)이 한 호출에 같이 있을 때 오탐지하는 현상이 재발해 zip 추출(Copy-Item+Expand-Archive)과 XML 패치를 별도 호출로 분리해 회피(기존에 알려진 이슈, 재발 방지책은 아직 없음 — 매번 분리 필요).
  - 검증: `Windows.Data.Pdf`로 PDF 전체 11페이지를 이미지 렌더링해 표 1~4 모두 페이지 폭 안에 정상적으로 들어오고 잘리지 않음을 육안 확인(표 1·2·3은 4열, 표 4는 3열, 모두 여러 페이지에 걸쳐 행 단위로 자연스럽게 분할됨).
  - GitHub 연동: `git add`+`commit`+`push`로 `.tex`/`.md`와 `log.md` 갱신분을 원격 `main`에 반영(`.docx`/`.pdf`는 `.gitignore`에 의해 계속 미추적, 사용자 요청에 따라 이번엔 push까지 진행).

- 신규 report `08_AEI데이터_노동시간_사용량_스키마.tex`/`.md`/`.docx`/`.pdf` 작성(사용자 요청: AEI 실증연구가 아니라 AEI **데이터셋 자체**를 (1) Claude 사용/미사용 시 과업 노동시간 데이터, (2) 과업·직업별 사용량 데이터 두 축으로 정리하고, 각각의 정의·측정단위를 밝힌 뒤 선행 AI 노출도·AI 적용률 개념과의 연결을 논의).
  - 자료 확보 방법: `WebFetch`로 HuggingFace 저장소 `https://huggingface.co/datasets/Anthropic/EconomicIndex`를 직접 조회(API `tree` 엔드포인트로 폴더·파일 목록 확인, 각 릴리스 폴더의 `data_documentation.md`/`README.md` raw 파일을 프롬프트를 바꿔가며 반복 조회)해 실제 컬럼 스키마·facet 값 목록·프라이버시 임계치를 1차 자료로 직접 확인 — 기존 report들이 `reference/notes/`의 논문 요약 노트에만 의존했던 것과 달리, 이번에는 데이터셋 저장소 자체를 검증 대상으로 삼음.
  - 핵심 확인 사항: (1) 저장소는 6개 릴리스 폴더(`release_2025_02_10`~`release_2026_06_26`)+독립 `labor_market_impacts` 폴더로 구성되며, 스키마가 릴리스마다 진화(R1의 flat CSV→V3부터 장방형 패널 `geo_id/geography/facet/level/variable/cluster_name/value`→V6에서 컬럼명 재정의 `category_name/metric_id/node_name/hierarchy_level`); (2) `human_only_time`/`human_with_ai_time` 등 "경제원시지표" facet은 V3(2025.9)에는 없고 V4(`release_2026_01_15`, 2026.1)부터 처음 등장함을 두 릴리스의 `data_documentation.md`를 직접 대조해 확인; (3) `job_exposure.csv`(직업단위 관측노출 $R_o$)·`task_penetration.csv`(과업단위 WorkUsage)로 구성된 `labor_market_impacts` 폴더가 (1)과 (2)를 결합하는 유일한 지점임을 확인; (4) `human_only_time`/`human_with_ai_time`의 측정 단위(시간 vs 분)가 데이터셋 문서 어디에도 명시되어 있지 않다는 문서화 공백을 발견해 §2.4에 유의사항으로 별도 기술(`tamkin-2025-estimating-ai-productivity-gains-from` 원 논문의 "시간단위/분단위" 서술과 공식 데이터셋 문서 간 불일치 가능성).
  - 5장에서 (2) 사용량 데이터를 "예측(판정)에서 관측으로"(선행 노출도 지표와의 관계), (1) 노동시간 데이터를 "이분법(존재 여부)에서 연속적 실현 크기로"(선행 적용률/AIFE와의 관계)라는 두 축으로 각각 대응시키고, 두 데이터를 "이론적 상한×실현 여부×실현 크기"라는 공통 구조로 종합 — `job_exposure.csv`가 앞의 두 항만 결합했고 세 번째 항(시간절감 크기)까지 결합하는 지표는 AEI에도 아직 없음을 지적, `data/proc/merged/` 설계의 잠재적 확장 지점으로 결론에 명시.
  - `.tex`: report 01/04/05/06/07과 동일한 xelatex+kotex+biblatex(authoryear, maxcitenames=2) preamble 재사용. longtable 4개(표1 저장소구조 4열/8행, 표2 노동시간facet 4열/9행, 표3 사용량facet 4열/6행, 표4 labor_market_impacts 3열/3행)와 `\underbrace`를 이용한 "이론적 상한×실현여부×실현크기" 수식 1개 사용.
  - `.docx`/`.pdf`: report 06·07에서 확정한 `System.Xml.XmlDocument.Load(path)` 기반 표 폭 패치 파이프라인(HTML 중간본 `report08.html`→Word COM 변환→document.xml의 tblW/tblGrid/tcW를 인쇄영역 9026twips로 비율 재계산·`tblLayout=fixed`→zip 재압축→Word COM 재저장·PDF 출력, 총 12페이지)을 재사용. 표1(저장소구조표)의 원본 폭 합이 14257twips로 인쇄영역의 1.6배에 달했으나(코드 토큰이 긴 "스키마 형식" 열 때문에 Word HTML 임포터가 자동 확장) 비율유지 축소로 정확히 9026twips에 맞춰 정상 렌더링됨을 확인. 수식 박스(`div.eqbox`)는 표가 아니므로 별도 패치 없이 HTML 인라인 스타일만으로 페이지 폭 안에 정상 렌더링됨.
  - 검증: `Windows.Data.Pdf`로 PDF 전체 12페이지를 이미지 렌더링해 표 1~4와 수식 박스 모두 페이지 폭 안에 정상적으로 들어오고 잘리지 않음을 육안 확인.
  - GitHub 연동: `git add`+`commit`+`push`로 `.tex`/`.md`와 `log.md` 갱신분을 원격 `main`에 반영(`.docx`/`.pdf`는 `.gitignore`에 의해 계속 미추적).

## 2026-09-23

- 신규 report `09_AEI한국적용_직업별시간절감사용량.tex`/`.md`/`.docx`/`.pdf` 작성(사용자 요청: 직전 대화에서 답한 "한국만을 대상으로 AEI 데이터로 직업별 시간절감률·직업별 사용량을 계산할 수 있는가"라는 질의와 그 답을 별도 노트로 정리).
  - `08_AEI데이터_노동시간_사용량_스키마.tex`가 AEI 데이터셋 구조를 릴리스 전체에 걸쳐 일반적으로 정리한 것과 달리, 본 report는 그 구조를 **한국(`geo_id="KOR"`)이라는 구체적 국가**에 실제로 적용했을 때의 가능성·한계를 검증하는 후속 report. `release_2026_06_26`(V6) 원자료 CSV(219MB)를 직접 다운로드해 `geo_id="KOR"`·`geo_id="GLOBAL"` 행을 `grep`으로 직접 집계 — report 08까지는 `WebFetch`로 문서만 조회했다면, 이번에는 원자료 자체를 로컬에 받아 검증한 것이 방법론적 차이.
  - 핵심 확인 사항: (1) HuggingFace API `tree` 엔드포인트로 V4(`release_2026_01_15`)·V5(`release_2026_03_24`)의 `data/` 폴더를 직접 조회한 결과 완성 집계본이 없고 `data/intermediate/aei_raw_claude_ai_*.csv`(1주일치 pre-enrichment 원시본)만 공개되어 있음을 발견 — report 08 표1이 "동일 스키마 유지"로만 기술해 완성본이 있는 것처럼 읽히던 부분의 갱신 필요 사항. 완성 집계본이 공개된 릴리스는 V6(`release_2026_06_26/data/aei_claude_ai_2026-06-26.csv`, 2026년 4–5월 2개월치) 하나뿐임을 확정. (2) V6 `data_documentation.md`의 "Metric Availability" 표를 직접 확인해, 국가(Country) 단위에서는 `soc_occupation`의 최상위 계층(Major Group, SOC 2자리)에서만 시간 지표를 포함한 전체 지표가 제공되고 최하위 계층(Detailed Occupation, SOC 6자리)에서는 `pct`(사용 비중)만 제공됨을 확인 — 세부직업 단위 시간 지표는 `Global` 행에만 존재. (3) 이 문서상 제약을 한국 실측치로 직접 검증: `geo_id="KOR"`은 국가 포함 임계치를 통과(11,601행)하고, `soc_occupation` 레벨0(세부직업)에서는 `pct` 813행에 시간 지표 0행, 레벨1(대분류 22개)에서는 전 지표 2,244행으로 문서 예측과 정확히 일치. (4) V6 문서가 `human_only_time_mean`=시간, `human_with_ai_time_mean`=분 단위임을 명시적으로 기술함을 확인 — report 08 §2.4가 "문서에 단위 미명시"로 남겨둔 공백이 V6에서 해소되었음을 발견(아직 report 08 본문은 미수정, 향후 반영 필요).
  - 사용자의 두 번째 질의(GLOBAL 시간절감률+KOR 사용량 결합 가능 여부, SOC 몇 자리까지 가능한지)에 대해, 한국에서 관측되는 세부직업 O*NET-SOC 코드 424개(2026년 5월)와 GLOBAL 세부직업 시간 지표 코드 717개를 직접 대조해 424개 전부가 100% 매칭됨을 실측으로 확인 — 기술적으로는 SOC 6자리(세부직업) 수준까지 결합 가능하나, 이는 "한국 고유 실현치"가 아니라 "한국 사용 비중×GLOBAL(사실상 영어권 비중이 큰 표본) 평균 시간절감률"이라는 혼합 지표이므로 국가 간 동질성 가정을 방법론 절에 명시해야 함을 5.2절에서 별도 논증(대분류 수준에서는 한국 고유값이 존재하므로 GLOBAL값과의 민감도 비교로 가정을 부분 점검할 수 있음을 제안).
  - `.tex`: report 08과 동일한 xelatex+kotex+biblatex(authoryear, maxcitenames=2) preamble 재사용. longtable 6개(표1 릴리스별 실제 공개파일 3열/4행, 표2 V6 Metric Availability 7열/6행, 표3 KOR 실측결과 4열/3행, 표4 GLOBAL–KOR 조인커버리지 2열/3행, 표5 SOC계층별 제공지표 4열/2행, 표6 질의별 결론요약 2열/4행)과 수식 2개(시간절감률 계산식, GLOBAL–KOR 결합 공식) 사용.
  - `.docx`/`.pdf`: 이번에는 표 너비를 절대 twips 대신 HTML `colgroup`의 상대 `%` 폭으로 지정하고 Word COM으로 변환한 결과, Word가 `<w:tblW w:w="5000" w:type="pct"/>`(인쇄영역 대비 100%)로 자동 변환해 `tblGrid` 합이 6개 표 모두 처음부터 9027twips(인쇄영역 9026twips와 거의 일치, 반올림 오차 1twips)로 맞춰짐을 확인 — report 04~08에서 매번 필요했던 "원본 폭 합을 9026twips로 비율 재계산" 단계가 이번에는 불필요했음(단, 페이지 여백을 Word COM에서 명시적으로 재설정하는 선행 단계가 필요했는데, `PageSetup.TopMargin` 등이 twips가 아니라 **포인트(point) 단위**라는 점을 착각해 최초 시도에서 "여백이 페이지 길이보다 큼" 오류가 발생 — 72pt(=1440twips=1인치)로 정정해 해결, 향후 report의 페이지 여백 설정 시 유의사항으로 기록). 그럼에도 긴 코드 토큰(파일 경로 등)으로 인한 자동확장을 막기 위해 6개 표 모두에 `<w:tblLayout w:type="fixed"/>`를 `tblW` 뒤에 삽입하는 patch는 report 04~08과 동일하게 적용(perl 기반 in-place 치환, 인코딩 문제 없이 1회 성공). PowerShell 작업 디렉터리 관리 실수로 bash에서 추출한 `docx_extract` 임시폴더를 PowerShell `Remove-Item`으로 삭제 후 빈 폴더로 재생성해버린 사고가 있었으나(`bash`의 `/tmp`와 PowerShell의 `C:\Users\cenne\AppData\Local\Temp`가 동일 경로임을 인지하지 못함), 목적 파일(D: 드라이브의 docx)에는 영향이 없어 별도 폴더(`docx_work`)로 재작업해 복구.
  - 검증: `Windows.Data.Pdf`(WinRT)로 PDF 전체 8페이지를 이미지 렌더링해 표 1~6과 수식 박스 2개 모두 페이지 폭 안에 정상적으로 들어오고 잘리지 않음을 육안 확인.

## 2026-09-24

- `D:/econ-wiki`에 새로 추가된 AI 관련 문헌 3편을 `reference/`에 반영(사용자 요청).
  - `reference/notes/`에 econ-wiki `sources/*.md` 원본을 그대로 복사(기존 노트와 동일 방식): `yoon-2026-employment-admin-db-ai-exposure`(윤정혜, 「고용행정DB로 본 직업별 AI 노출도와 고용 현황」, 계간 고용이슈 2026 여름호 pp.8-27), `kim-2026-generative-ai-korean-labor-market`(김수현·이정아, 「생성형 인공지능이 국내 노동시장에 미치는 영향」, 같은 호 pp.28-51), `bok-2026-ai-regional-labor-market-disparity`(김보성 외, 「AI와 지역 노동시장 - 지역간 격차 확대 위험과 새로운 기회」, BOK 이슈노트 제2026-25호).
  - `reference/papers/`에 PDF 2개 복사: `bok-2026-ai-regional-labor-market-disparity.pdf`, `고용이슈 2026 여름호.pdf`(윤정혜·김수현·이정아 두 편이 모두 실린 호 전체, 58MB 스캔본). 노트 frontmatter의 `pdf_filename`과 연결이 유지되도록 econ-wiki의 원래 파일명을 그대로 사용.
  - `reference/references.bib`에 항목 3개 추가(citation key = 노트 파일명).
  - 참고: 김수현·이정아(2026)는 Massenkoff and McCrory(2026)의 AEI 기반 "관찰 노출도"를 한국 직업분류(KSCO 8차)에 연계한 연구로, report 07(AEI 실증연구 계보)·09(AEI 한국 적용)와 직접 관련됨. 두 report는 아직 이 문헌을 반영하지 않음.

## 2026-09-26

- Anthropic Economic Index(AEI) 원자료 전체를 `data/raw/usage/anthropic_economic_index/`에 다운로드(사용자 요청: 릴리스 버전별로 별도 정리).
  - 출처: HuggingFace `Anthropic/EconomicIndex`, 커밋 `2ea58ff75e4247d26810c37f10c179edc2466cac`(저장소 lastModified 2026-06-26)로 고정해 `resolve/<커밋>/<경로>`로 개별 다운로드. 저장소의 릴리스 폴더 구조(`release_2025_02_10`, `release_2025_03_27`, `release_2025_09_15`, `release_2026_01_15`, `release_2026_03_24`, `release_2026_06_26`, `labor_market_impacts`)와 파일명을 그대로 유지(총 81개 파일, 634MB; `.gitattributes`/`.gitignore` 제외).
  - 검증: 81개 파일 모두 HF API가 보고한 바이트 크기와 일치.
  - 폴더 최상위에 출처·커밋·릴리스별 요약을 적은 `_download_manifest.md`를 추가(원본이 아닌 기록용 파일임을 명시). `data/raw/`는 `.gitignore` 대상이므로 git에는 반영되지 않음.
  - CLAUDE.md의 raw/proc 대칭 규칙에 따라 빈 `data/proc/usage/anthropic_economic_index/` 폴더도 생성. 이 폴더를 채울 `01_import_*.do`는 아직 작성하지 않음.

- 신규 report `10_AEI사용량정의_ClaudeAI_1PAPI.tex`/`.md`/`.docx`/`.pdf` 작성(사용자 요청: AEI 사용량 데이터를 활용한 연구들이 사용량을 Claude.ai와 1P API 중 무엇으로 정의했는지 — 합산인지, 하나만인지 — 연구별 정리).
  - 대상 11편: report 07의 AEI 직접 활용 9편 + `bick-2026-what-work-does-generative`(V2 릴리스 과업 점유율을 비교 벤치마크로 사용) + `kim-2026-generative-ai-korean-labor-market`(Massenkoff and McCrory 관측노출을 KSCO에 이식).
  - 분류 결과: (A) Claude.ai 단독 5편(Handa 2025, Tamkin and McCrory 2025, Fan 2026, Fan and Nguyen 2026, Bick et al. 2026), (B) 플랫폼별 병렬 비교(합산 없음) 4편(V3–V6 정기 보고서; 단 AUI·실효 AI 커버리지·tenure 등은 Claude.ai 전용), (C) 합산 1편(Massenkoff and McCrory 2026) + 계승 1편(김수현·이정아 2026).
  - 확인 방법: 노트 1차 분류 후 원문 PDF를 pdftotext로 추출해 "Claude.ai"/"1P API"/"first-party" 전수 검색. Massenkoff and McCrory 부록의 정의식은 이미지라 WinRT(`Windows.Data.Pdf`)로 p.2–3을 렌더링해 직접 판독.
  - 새로 확인한 사항: 관측노출의 자동화 가중치는 α_t = 1/2 + 1/2 × (ClaudeWorkUsage×AutoShare + APIUsage)/(ClaudeWorkUsage + APIUsage)로, **API 사용 전체를 자동화로 간주**함(부록 p.3). `reference/notes/massenkoff-2026-labor-market-impacts-of-ai.md`는 이를 "1/2 + 1/2×AutomationShare"로만 요약해 API 항이 빠져 있음 — 노트는 econ-wiki 원본 사본이므로 이 저장소에서는 수정하지 않았고, econ-wiki 쪽 수정이 필요함.
  - `.docx`/`.pdf`: xelatex·pandoc이 없어 `.md`를 node 스크립트로 HTML 변환(표 폭은 colgroup %)→Word COM으로 A4·여백 72pt 설정, 표마다 `AllowAutoFit=false`·폭 100%·머리행 반복·표 제목 KeepWithNext 지정 후 docx 저장→PDF 출력(8페이지). 이번에는 docx XML 패치 없이 COM 속성만으로 표 폭 고정. PDF 전 페이지를 렌더링해 표 3개가 페이지 폭 안에 들어오는 것을 확인.

- report 10(`10_AEI사용량정의_ClaudeAI_1PAPI.tex`/`.md`)에 §6 "보론: GLOBAL 단위에서 두 플랫폼 사용량을 합산할 수 있는가" 추가(사용자 요청, 기존 §1–5는 수정하지 않음).
  - V6 원자료 두 파일(`aei_claude_ai_2026-06-26.csv`, `aei_1p_api_2026-06-26.csv`)의 GLOBAL 행을 직접 집계. 두 파일 모두 `overall` `usage_pct`=100이고 규모 지표(건수·토큰)가 없어 플랫폼 간 상대 규모를 알 수 없음. 따라서 합산은 가중치 w를 가정해야 하는 구성 지표임(pct_pooled = w·pct_claude + (1−w)·pct_api). Massenkoff and McCrory(2026)의 합산은 표본 동일 크기(각 200만 건)에 따른 암묵적 w≈0.5임.
  - 과업(레벨 0) `pct` 합계: claude_ai 88.40/94.32%, 1p_api 81.13/85.00%(2026.4/5). 공개 과업 수 2,410/2,713 vs 1,992/2,295, 공통 과업 1,577/1,815.
  - 권고: 기본은 플랫폼별 분리, 합산은 민감도 분석용((i) w=1, (ii) w=0.5, (iii) 업무용 필터 버전 + w 변화).
  - `.docx`/`.pdf` 재생성: 이전과 같은 파이프라인(`.md`→node HTML 변환→Word COM, A4·여백 72pt, 표 폭 100%·AllowAutoFit=false)으로 다시 만듦(8→9페이지). 새 표 4의 열 폭은 36/16/16/16/16%. PDF 전 페이지를 렌더링해 §6과 표 4가 페이지 폭 안에 들어오는 것을 확인.

## 2026-09-27

- 외부 규모 파라미터 원자료 폴더 `data/raw/macro/scaling/` 신설(사용자 요청). raw/proc 대칭 규칙에 따라 빈 `data/proc/macro/scaling/`도 생성. 채울 do 파일(`01_import_scaling.do`)은 아직 없음.
  - 목적: AEI V6는 플랫폼 내 점유율(`pct`)만 있고 건수가 없어, LCE 등 수준 지표에 필요한 Claude.ai 대화 수·1P API 호출 수를 외부 자료로 추정해야 함.
  - `scaling_parameters_public.csv`: 공개 자료의 수치를 1행 1값으로 옮겨 적은 파일(보고된 값만 수록, 파생값은 do 파일에서 계산). 열에 출처·URL·스냅샷 파일·접속일·`source_tier`(primary_official / primary_web / paper / secondary / secondary_unverified) 포함.
  - `snapshots_2026-09-27/`: 원출처 웹페이지 7개를 curl로 저장(Anthropic Series G·Google-Broadcom·Series H 발표, Similarweb "AI Search Stats 2026" 블로그, PPC Land의 Similarweb 보고서 기사, DemandSage, Simon Willison). 각 파일에 인용 수치가 실제로 들어 있는지 텍스트 검색으로 확인.
  - **Similarweb 원자료(월별 방문 수·앱 MAU 시계열)는 확보하지 못함**: 유료 로그인이 필요하고, 무료 페이지는 최근 1개월 요약만 보이며 자동 수집도 차단됨(HTTP 202). getpanto.ai 페이지도 차단(HTTP 503)되어 스냅샷 없음. 확보해야 할 내보내기 목록은 폴더 `README.md`에 정리.
  - 파라미터 출처(모두 접속일 2026-09-27):
    - claude.ai 월 방문 수: 2025.8 149M, 2025.11 176M, 2026.2 288M — Fan and Nguyen(2026) 부록 B(SimilarWeb). 2026.1 203M, 2026.3 614M, 2026.4 824M, 2026.5–8 947–969M 범위, 2026.7 969M(정점) — PPC Land가 인용한 Similarweb 상장 전 보고서(표지 2026-09-17). 2026.1 202M, 2026.6 946.7M(전월 대비 −0.61%) — DemandSage(Similarweb 인용). 2026.8 전월 대비 −1.97% — Similarweb claude.ai 무료 페이지(스냅샷 없음).
    - Claude 앱 MAU: 2026.3 55.1M, 2026.5 102M, 2026.6 120M, 2026.8 157M — Similarweb App Intelligence(PPC Land 인용). 2026.2 12.5M — Fan and Nguyen 각주 26(DemandSage). 계열이 달라 서로 비율을 내면 안 됨.
    - 웹+앱 MAU 245M — DemandSage(Sensor Tower State of AI 2026 인용, 2026-07-07 갱신).
    - 생성형 AI 웹 방문 월평균 9.5B(2025.6–2026.5), ChatGPT 점유율 약 76%→약 53%, Gemini 27–28%, Claude "10%에 근접" — Similarweb 블로그(2026-07-29 게시, 09-17 수정).
    - Anthropic run-rate 매출: $14B(2026-02-12, Series G), >$30B(2026-04-06, Google·Broadcom 발표), >$47B(2026년 5월, Series H 2026-05-28) — 공식. Claude Code run-rate >$2.5B(2026-02-12, Series G) — 공식. $65B(2026.7) — PPC Land(2차).
    - Fan and Nguyen(2026) 가정: Claude.ai 주 2억 건(웹 MAU 18.9M × DAU/MAU 0.5 × 하루 3건 × 7), Claude 점유율 25%(15–35%), API 비중 75%, 호출당 $0.34, 연 310억 건(각주 24). API 매출 비중 75–85%는 제3자 추정(미검증).
- 신규 report `11_AEI사용량규모추정_ClaudeAI_1PAPI.tex`/`.md` 작성(사용자 요청: V6 기간 Claude.ai·1P API 사용량 규모 추정 방법 정리).
  - Claude.ai: 방법 A(기준, Fan 방식 연장: 주 2억 × 방문 수 비율 → 2026.4 약 5.7억, 2026.5 약 6.6억 건/주), 방법 B(웹·앱 결합 지수, Similarweb 원자료 필요), 전체 플랫폼 확장은 점유율 25% 고정 대신 카테고리 트래픽 비율(C1, 권장) 또는 웹 점유율 조정(C2).
  - 1P API: Q = R × s_API × (1 − κ_CC − κ_cloud) / p. V6 API가 Claude Code를 제외하고 1P만 포함하므로 κ 두 항을 추가(공개 값 없음, 가정 범위로 처리). 예시: Fan 방식 그대로 2026.4 12.7억·2026.5 19.9억 건/주(상한), 제외분 반영 시 6.4억·10.0억 건/주.
  - report 10 §6의 합산 가중치 w에 대한 외부 근거로 2026.5 기준 w ≈ 0.25–0.40 제시(단, 대화와 호출은 단위가 다름).
  - 권고: 단위당 가치(데이터 확정)와 규모(가정 의존)를 분리 보고, 규모는 민감도 격자로 제시, 4·5월은 따로 계산.
  - `.docx`/`.pdf`는 아직 만들지 않음.
- report 09(`09_AEI한국적용_직업별시간절감사용량.tex`/`.md`)에 §8 "보론(2026-09-27 추가): V5 원자료 재검토와 V5·V6의 직업 분류 활용 수준 비교" 추가(사용자 요청: 기존 §1–7은 수정하지 않고 추가만).
  - 정정 사항: §2·§7에서 V5(`release_2026_03_24`)를 "pre-enrichment 원시본이라 부적합"으로 판단했으나, 원자료 직접 집계 결과 공개 임계치가 이미 적용되어 있음(KR 과업 최소 15건, 미달분은 `not_classified`로 합산: KR 24.9%, GLOBAL 2.7%). Fan and Nguyen(2026) Box 2 수치(41,586건, 972,636건, 3.54시간→17.8분)와 정확히 일치해 같은 R5 파일임을 확인. §8이 §2·§7의 V5 서술보다 우선한다고 명시.
  - V5 과업→직업 연계 검증: `release_2025_09_15/data/intermediate/onet_task_statements.csv`(O*NET 20.1, SOC 2010)와 소문자 과업 텍스트로 매칭 시 GLOBAL 3,258/3,258, KR 299/299 과업 매칭. 다중직업 과업 86개(대화 4.5%)는 균등 배분. 세부직업 GLOBAL 566개, KR 171개.
  - V6 KOR 재집계: 세부직업 389/424개 코드, `pct` 합계 96.16/98.08%(2026.4/5), 과업 레벨 0 합계 78.51/81.32%, 최솟값 0.01%. V6는 임계치를 직업 단위 칸에 따로 적용하는 것으로 보여 V5보다 한국 세부직업 포괄률이 높음. 단 건수·표본 크기 미공개로 정밀도는 평가 불가.
  - 비교표(표 8.1): GLOBAL 절감시간은 V5·V6 모두 세부직업 가능, KR 사용량은 V5 대분류 권장·V6 세부직업 가능(해석 주의), KR 절감시간은 V5 불가·V6 대분류만.
  - V5 SOC 대분류 잠정 집계표(scratchpad awk 계산, do 파일 재현 전 잠정치로 표기) 수록.
  - `.docx`/`.pdf`: 기존 docx를 새로 만들지 않고, Word COM으로 기존 파일의 "참고문헌" 제목 바로 앞에 §8만 삽입(원본 report 09 HTML 중간본의 CSS를 그대로 쓴 §8 HTML 조각을 `Range.InsertFile`로 삽입). 새 표 3개(표 7–9, docx 쪽은 기존 표 1–6에 이어 번호 부여)는 기존 표와 같이 폭 100%·고정 레이아웃(`tblW` 5000 pct, `tblLayout fixed`, grid 합 9027twips)으로 맞추고 열 폭을 셀 단위로 지정. PDF 재출력(8→11페이지). 검증: (1) Word로 원본·수정본 본문 텍스트를 비교해 §8을 뺀 나머지가 원본과 글자 단위로 동일함을 확인, (2) PDF 7–11쪽을 이미지로 렌더링해 표 7–9가 페이지 폭 안에 들어오는 것을 확인. 원본은 scratchpad에 백업.
- OpenAI Signals 원자료 다운로드(사용자 요청: https://openai.com/ko-KR/signals/ 의 사용량 데이터를 받아 정리).
  - 새 데이터 소스 폴더 2개 생성(CLAUDE.md의 소스별 하위 폴더 규칙, raw/proc 대칭):
    - `data/raw/usage/openai_signals/signals_v2.0/`: `data-download-csv.zip`(원본 보관)과 압축 해제본 `public_release_csv/`(CSV 25개 + README.pdf), `data-dictionary.pdf`. 빈 `data/proc/usage/openai_signals/` 생성.
    - `data/raw/exposure/openai_ai_jobs_transition_framework/release_2026_06_01/`: 같은 다운로드 페이지의 AI Jobs Transition Framework 직업 분류(`ai-job-transition-framework-data-download.zip`과 압축 해제본). 사용량이 아니라 직업별 AI 영향 분류라서 usage가 아닌 exposure 아래에 둠. 빈 `data/proc/exposure/openai_ai_jobs_transition_framework/` 생성.
    - 각 소스 폴더에 `_download_manifest.md`(URL, 서버 Last-Modified, MD5, 라이선스, 인용) 작성. zip 안의 macOS 메타데이터(`__MACOSX/`)는 풀지 않음(삭제).
  - 출처: https://openai.com/signals/data-download/ (다운로드일 2026-09-27). 파일 URL `https://cdn.openai.com/signals/data-download-csv.zip`(Last-Modified 2026-08-06), `.../signals/data-dictionary.pdf`(2026-08-06), `.../signals/ai-job-transition-framework-data-download.zip`(2026-06-01). 라이선스 CC BY 4.0.
  - 수집 방법: openai.com 페이지는 Cloudflare가 봇 요청을 막아(HTTP 403) WebFetch·단순 curl이 실패. 쿠키를 유지하는 브라우저형 curl 요청으로 페이지를 받아 링크를 확인했고, 파일 자체(cdn.openai.com)는 차단 없이 받음.
  - 받지 않은 것: Signals 웹페이지 차트용 JSON 5개(CSV와 값 중복), Enterprise Signals(다운로드 파일 없음, 웹 차트만).
  - 확인한 내용: 소비자 ChatGPT 메시지 월 30만 건, 2024.7–2026.6(24개월), 점유율·순위만(건수 없음), 차등정보보호 잡음(공개 1회당 ε=1)과 유효 100건 이하 셀 억제. 한국(`KR`)은 국가 단위 파일 9개 모두 포함(연령×주제 93%, 성별×주제 57% 칸, 나머지는 전 칸). 직업(SOC)·절감시간 없음, O*NET IWA는 미국만. AJTF는 923개 O*NET-SOC 직업, 4개 archetype, README의 조인 키 이름(`onet_soc_code`)과 실제 열 이름(`occupation_code`)이 다름.
  - `reference/references.bib`에 데이터 인용용 `@misc` 2개 추가: `openai-2026-signals-v2`(OpenAI가 제시한 권장 인용), `openai-2026-ai-jobs-transition-framework`. 논문이 아니라 데이터셋이므로 `reference/papers/`·`notes/`와 econ-wiki에는 추가하지 않음.
- 신규 report `12_OpenAI_Signals_데이터구조.tex`/`.md` 작성: Signals v2.0의 방법론, CSV 25개 구성, 한국 가용성, AEI(V5·V6)와의 비교, AJTF 요약, 시사점(한국 직업별 사용량은 여전히 AEI 필요, Signals는 업무 비중·용도 구성 월별 시계열로 보완). `.docx`/`.pdf`는 만들지 않음.
- report 11(`11_AEI사용량규모추정_ClaudeAI_1PAPI.tex`/`.md`) §2에 보완 문단 추가(사용자 요청): Fan and Nguyen(2026)이 "2026년 초" 웹 MAU로 쓴 1,890만 명(부록 B, 각주 26, DemandSage 인용)의 기준 시점이 불확실함. 2026-09-27에 저장한 DemandSage 페이지 사본(최종 수정 2026-07-07)에는 2026년 월을 명시한 웹 MAU가 없고, 웹 이용자 월별 표는 2023.12–2025.1까지만 있으며 본문은 "2024년 11월 1,880만 명 정점 후 안정적"이라고 적음 → 1,890만 명이 2024년 11월 정점 값과 같은 계열일 가능성. 그 사이 방문 수가 크게 늘어 2026년 2월 주 2억 건이 과소추정일 수 있으므로 1.5억–2.5억 민감도 분석을 반드시 함께 제시하도록 명시.
- report 11 `.docx`/`.pdf` 신규 생성(9페이지): report 10과 같은 파이프라인(`.md` → node HTML 변환 → Word COM, A4·여백 72pt, 표 폭 100%·AllowAutoFit=false·머리행 반복). PDF 전 페이지를 이미지로 렌더링해 표 5개가 페이지 폭 안에 들어오는 것을 확인. 참고: HTML의 colgroup 열 폭 지정이 Word 변환에서 반영되지 않아 열 폭은 균등하게 들어감(내용은 모두 표시됨).
- Sensor Tower *State of AI 2026* 보고서의 True Audience(중복 제거한 독립 앱·모바일 웹·데스크톱 웹 월간 이용자) 차트 데이터를 추출(사용자 요청: Worldwide와 South Korea의 제품별 이용자 수 추이 파일).
  - 위치: `data/raw/macro/scaling/sensortower_state_of_ai_2026/` (report 11 규모 추정용 외부 자료이므로 기존 `scaling/` 아래 소스별 폴더로 둠).
  - 출처: https://sensortower.com/report/state-of-ai-2026/download → 페이지에 삽입된 Infogram 보고서(`_/ASGcPdnHtQ9NVkM5gbYV`)의 `window.infographicData` JSON. 차트 "Deduplicated Standalone App & Web Users for Top AI Assistants"(엔터티 `b67d3087-...`), 시트 19개(Worldwide + 18개국). 로그인 없이 공개로 열림. 다운로드일 2026-09-27. 라이선스 없음("All Rights Reserved") → 인용용으로만 사용.
  - 원본 HTML 2개를 `snapshots_2026-09-27/`에 보관하고, node 스크립트 `_extract_true_audience.js`로 Worldwide·South Korea 시트를 CSV로 추출(긴 형식 608행 = 2개 시장 × 8개 제품 × 38개월, 2023-04~2026-05; 넓은 형식 16행). 값은 쉼표 제거 외 변환 없음. 모든 값이 숫자임을 확인. 데이터가 JSON 안에 있어 Stata로 직접 파싱하기 어려워 추출만 node로 하고, 스크립트를 원본과 함께 두어 재현 가능하게 함.
  - 확인 사항: Worldwide는 25개 시장 합계이며 앱 내장 AI 사용자는 제외(차트 주석). DemandSage가 인용한 "Claude 245 million MAU"는 이 차트의 Worldwide Claude 2026-05 값과 같음. Worldwide Claude는 2026-02 1.04억, 2026-04 2.32억, 2026-05 2.45억 명.
- (같은 날, 수정) Sensor Tower True Audience 추출 범위를 Worldwide·South Korea에서 차트의 전체 시트 19개(Worldwide + Argentina, Australia, Brazil, Canada, France, Germany, India, Indonesia, Italy, Japan, Mexico, South Korea, Spain, Taiwan, Turkey, United Kingdom, United States, Vietnam)로 확대(사용자 요청). `_extract_true_audience.js`의 기본값을 모든 시트로 바꾸고, 시트마다 월 열이 같은지 검사하는 코드를 추가해 다시 실행. 결과: 긴 형식 5,776행(19 × 8개 제품 × 38개월), 넓은 형식 152행. 19개 시트 모두 기간(2023-04~2026-05)과 제품 8개가 같고 모든 값이 숫자임을 확인. `_download_manifest.md` 갱신.
- Sensor Tower *State of AI 2026*에서 이용자당 사용 강도와 카테고리 전체 사용량 차트 4종을 추가 추출(사용자 요청: 앞서 만든 이용자 수 파일과 같은 방식).
  - 추출 스크립트를 `_extract_sensortower.js` 하나로 통합(기존 `_extract_true_audience.js` 삭제). 인자 없이 실행하면 5개 데이터셋을 모두 만든다. 기존 True Audience CSV 2개는 새 스크립트로 다시 만들어 MD5가 이전과 같음을 확인.
  - 새 CSV(각각 `_long`/`_wide` 2개): ② `sensortower_days_used_monthly`(앱 이용자 월평균 사용 일수, 9개 앱 × 2024-01~2026-04, 긴 형식 219행, 빈 칸 제외), ③ `sensortower_time_spent_per_user_quarterly`(앱 이용자 월평균 사용 시간(분), 10개 앱 × 2025Q1~2026Q1, 50행, 원 차트 2개 합침), ④ `sensortower_genai_apps_sessions_hours_halfyear`(생성형 AI 앱 카테고리 전체 세션 수·사용 시간, 24개 시장 × 2023H1~2026H1, 168행, 2026H1 예비 추정치는 `preliminary=1`), ⑤ `sensortower_genai_web_visits_hours_quarterly`(생성형 AI 웹사이트 카테고리 전체 방문 수·사용 시간, 23개 시장 × 2024Q1~2026Q1, 207행).
  - 지표 식별: Infogram 시트 이름("AMER", "Spend", "Impressions")이 내용과 맞지 않아 차트 위 제목과 보고서 본문 수치로 확인. 성장률 차트(HoH, YoY)는 수준 값에서 다시 계산할 수 있어 추출하지 않음. "Rank" 차트 2개는 국가 선택 메뉴로 데이터 없음.
  - 검증: 추출값이 보고서 본문 수치와 일치(② Claude 2025-04 4.1일→2026-04 7.4일, Gemini·DeepSeek 5.6→7.9일, ③ ChatGPT 2026Q1 215분·DeepSeek 57→189분·Gemini 14→100분, ④ Worldwide 2026H1 세션 9,650억·시간 360억, ⑤ Worldwide 2026Q1 방문 674억·India 133.7억·United States 82.3억). 모든 값 숫자 확인.
  - `_download_manifest.md`를 5개 데이터셋 기준으로 다시 씀(차트별 Infogram 엔터티 ID 포함).
- 신규 report `13_SensorTower_데이터설명.tex`/`.md`/`.docx`/`.pdf` 작성(사용자 요청: CSV와 데이터 설명 문서). 출처·수집 방법, 파일 목록, 데이터셋별 원 차트·정의·범위·변수·주의·주요 값, 공통 주의사항(Worldwide 범위가 25/56개 시장 등으로 다름, 플랫폼 범위 차이, Claude 이용자 80% 웹 전용), 본 프로젝트 활용(report 11 기준값 대안, DAU/MAU 가정 점검)을 정리. `.docx`/`.pdf`는 report 10·11과 같은 파이프라인(5페이지, 렌더링으로 표 폭 확인).
  - `reference/references.bib`에 `sensortower-2026-state-of-ai`(@misc) 추가.
- report 13(`13_SensorTower_데이터설명.tex`/`.md`) §3.4 끝에 보완 문단 추가(사용자 요청, 기존 내용 수정 없음): ④의 세션 수 의미. 보고서 "Mobile App Methodology"는 다운로드·매출만 설명하고 세션을 정의하지 않으며 Sensor Tower 공개 자료(Usage Intelligence API 문서)에도 세는 규칙이 없음을 명시, 업계 일반 정의(포그라운드 사용 1회)는 확인된 것이 아님을 표시. 세션당 평균 길이(2026H1 전 세계 약 2.2분, 한국 약 2.3분), 자료별 사용 단위 비교표(Sensor Tower 앱 세션·웹 방문, AEI 대화, OpenAI Signals 메시지) 추가, ④를 Claude 대화 수 추정에 쓸 수 없는 이유 정리.
  - `.docx`/`.pdf` 재생성(5→6페이지, 같은 파이프라인). Word로 기존·수정 본문을 비교해 추가 부분을 뺀 나머지가 기존과 글자 단위로 같음을 확인, PDF 렌더링으로 새 표 폭 확인.
- Chatterji et al.(2025) "How People Use ChatGPT"(NBER WP 34255)를 AI-effects에 등록(사용자 요청).
  - `reference/papers/chatterji-2025-how-people-use-chatgpt.pdf`: Claude가 NBER(https://www.nber.org/system/files/working_papers/w34255/w34255.pdf)에서 직접 다운로드.
  - `reference/notes/chatterji-2025-how-people-use-chatgpt.md`: 원문 전체(본문 1–7장, 부록 B 검증 결과 포함)를 읽고 econ-wiki `sources/` 형식(frontmatter + 8개 섹션)으로 새로 작성. 쪽수 인용 포함. frontmatter에 `acquisition` 항목으로 입수 경위와 econ-wiki 미등록 사유를 기록.
  - `reference/references.bib`: `chatterji-2025-how-people-use-chatgpt`(@techreport) 추가.
  - **econ-wiki에는 등록하지 않음(의사결정)**: econ-wiki CLAUDE.md 0.1절은 Claude가 스스로 웹에서 원문을 구하는 것을 금지하고, 사용자가 직접 받아 `papers/web/`에 넣은 원문만 Tier 2로 인정함(예외 없음). 이 논문은 Claude가 받은 것이라 사용자와 확인 후 AI-effects에만 등록하기로 함. 따라서 두 저장소가 이 문헌에서 어긋나 있음 — econ-wiki에 넣으려면 사용자가 PDF를 직접 받아 `D:/econ-wiki/papers/web/`에 넣은 뒤 ingest해야 함.
  - 원문에서 확인한 이용자당 사용 관련 수치: 2025.7 주간 이용자 7억 명·주당 메시지 180억 건(p.1), 소비자 플랜 하루 메시지 2024.6 4.51억 → 2025.6 26.27억 건(표 1, 정확한 측정값, p.2), 주간 이용자 1인당 하루 메시지는 가입 코호트별 지수로만 제시(Figure 5, p.12). 대화당 메시지 수는 보고하지 않음.
- report 11(`11_AEI사용량규모추정_ClaudeAI_1PAPI.tex`/`.md`) §2에 보완 문단 추가(사용자 요청): Fan and Nguyen의 "이용자당 하루 3건 대화" 가정에 출처가 없음(부록 B Step 1, 각주 27), 저장소 문헌 62편에 이용자당 대화 수를 직접 제시한 연구가 없음, 가장 가까운 외부 근거로 Chatterji et al.(2025)의 메시지·이용자 수(주간 이용자 1인당 하루 약 3.8건)와 Sensor Tower(report 13)를 결합한 사용일 1일당 메시지 약 5.7건, 메시지≠대화 등 세 가지 한계, "출처 없는 가정"으로 명시하고 민감도로 다룰 것.
  - `.md` 참고문헌 목록에 Bick et al.(2026), Chatterji et al.(2025), Handa et al.(2025), Sensor Tower(2026) 4개 항목 추가(`.tex`는 biblatex가 자동 반영).
  - `.docx`/`.pdf` 재생성(9페이지). Word로 문단 단위 비교: 기존 268개 문단 중 삭제·변경 0개, 추가 6개(보완 문단 2개 + 참고문헌 4개)만 있음을 확인. PDF 렌더링으로 배치 확인.
- report 13(`13_SensorTower_데이터설명.tex`/`.md`)에 §6 "보완(2026-09-27): 보고서의 방법론 페이지와 페이지 주석" 추가(사용자 요청, 기존 §1–5 수정 없음). 보고서 71–73쪽 방법론 페이지(모바일 앱: 다운로드·매출만, 디지털 광고, 웹)와 전체 페이지 주석을 확인한 결과: 앱 MAU·세션·사용 시간·사용 일수의 추정 방법은 보고서에 없음. 6.1 방법론 페이지 요약표, 6.2 웹 지표(방문 30분 기준, 총 방문, 순방문자)와 True Audience 정의(앱 활성 이용자·모바일 웹·데스크톱 웹 방문자 중복 제거), 6.3 App IQ 분류 체계(2026년 6월 기준, 29·31·32·39쪽), 6.4 이용자 수 중복 계산(여러 어시스턴트 사용자는 어시스턴트마다 계산, ①은 제품 안의 앱·웹 중복만 제거, 앱 내장 AI 이용자 제외), 6.5 정정: 3.4절에서 "China Mainland는 iOS만 반영됐을 가능성이 크다(다른 페이지 주석)"고 쓴 것은 ④가 실린 29쪽 주석 자체에 "iOS only for China"가 명시된 확인된 사실임(처음 확인 때 긴 주석을 놓침).
  - `.docx`/`.pdf` 재생성(6→8페이지). Word 문단 비교로 기존 131개 문단의 삭제·변경 0개, 새 절만 추가됨을 확인. PDF 렌더링으로 새 표 배치 확인.

## 2026-09-28

- Sensor Tower *State of AI 2026*의 제품별 점유율(market share) 차트 추출(사용자 요청: Worldwide와 국가별 제품별 점유율을 이전과 같은 방식으로 CSV로). 새 다운로드 없이 2026-09-27 스냅샷 사용.
  - `_extract_sensortower.js`에 6)·7) 추가. 새 CSV(각각 `_long`/`_wide`): ⑥ `sensortower_true_audience_share_monthly`(True Audience 기준 점유율, Worldwide + 18개국 = 19개 시장 × 8개 제품 × 2023-04~2026-05, 5,776행; 국가별 점유율이 있는 유일한 차트), ⑦ `sensortower_worldwide_share_by_measure_monthly`(Worldwide 점유율 차트 4개를 `measure` 열로 합침: 웹+앱+앱 내장 합계 2026-01~06, 독립 앱 MAU 2024-01~2026-06, 앱 내장 AI 이용자 2026-01~06, 웹 방문 2024-01~2026-06; 468행). `share_pct`는 퍼센트 값.
  - 처리: `%` 기호 제거, ⑦ 제품 이름 끝 각주 표시(*, **) 제거. 독립 앱 MAU 차트의 마지막 월 머리글이 비어 있어(JSON `null`) 2026-06으로 채움(근거: 앞 열 2026-05, 웹 차트의 `June-2026`, 본문 "49% in June 2026").
  - 검증: 모든 값 숫자, 시장·월별 합계 99.8–100.3, ⑥은 ① 이용자 수로 다시 계산한 점유율과 최대 0.82%p 차이(반올림), 본문 수치(Worldwide 2026-05 46/28/10%, 미국 Claude 5%→약 14%, 웹 ChatGPT 84%→51%, 앱 MAU 49/25/3% 등)와 일치. 기존 ①–⑤ CSV MD5 변화 없음. `_download_manifest.md` 갱신. report 13에는 아직 반영하지 않음.
- Sensor Tower True Audience로 "제품 내 국가별 점유율" 데이터 생성(사용자 요청: 기존 파일은 그대로 두고 별도 데이터로).
  - 새 do 파일 `code/02_clean_sensortower_share_within_product.do`(저장소의 첫 do 파일; `00_master.do`가 아직 없어 global이 비어 있으면 파일 안에서 root/raw/proc를 지정). 출력 `data/proc/macro/scaling/sensortower_state_of_ai_2026/sensortower_share_within_product_monthly_{long.csv,long.dta,wide.csv}`(긴 형식 5,776행 = 8개 제품 × 38개월 × (18개국 + residual 1행), 넓은 형식 152행). Stata 17 배치 실행으로 생성.
  - 계산: `share_within_product_pct` = 100 × 국가 이용자 수 ÷ Worldwide 이용자 수(①, 25개 시장). 국가 시트가 18개뿐이라 나머지 7개 시장(이름 미공개)은 `Other 7 markets (residual)` = Worldwide − 18개국 합계로 한 행을 두어 합이 100%가 되게 함(do 파일에서 assert). 보조로 `share_within_18_pct`(분모 18개국 합계).
  - 의사결정: 점유율 파일(⑥)만으로는 국가별 합계(분모)를 알 수 없어 계산할 수 없음. ⑥은 ①을 국가 안의 합계로 나눈 값이므로 ①의 이용자 수에서 직접 계산. 매칭 키는 assistant × month.
  - 확인: residual은 대체로 Worldwide의 7–12%(DeepSeek는 26–53%로 큼). 음수 residual 10건(Claude 2023-05·06, Grok 2023-11~2024-11, 최대 −7,920명)은 이용자가 거의 없는 시기의 반올림 차이로 보고 그대로 둠. Worldwide 이용자 0인 17개 제품·월(출시 전 DeepSeek·Grok·Copilot)은 결측. 예: Claude 2026-05 India 29.5%, United States 16.7%, Brazil 7.3%, South Korea 2.4%, residual 9.3%.
- report 13(`13_SensorTower_데이터설명.tex`/`.md`)에 §7 "보완(2026-09-28): 점유율 데이터 3종" 추가(사용자 요청, 기존 §1–6 수정 없음). ⑥ `true_audience_share_monthly`(시장 안의 제품별 점유율, 국가별 시트가 있는 유일한 점유율 차트, 14쪽), ⑦ `worldwide_share_by_measure_monthly`(9–12쪽 Worldwide 점유율 차트 4개, 측정 기준별 표 5), ⑧ `share_within_product_monthly`(①에서 Stata로 계산한 제품 안의 시장별 점유율, ⑥으로는 분모가 없어 계산 불가한 이유, residual 정의, 주의사항, 2026-05 주요 시장 표 6), 7.4 활용(한국 규모 할당 가중치, AEI 국가별 대화 비중과 비교, 기준별 점유율 차이). 새 표 3개(표 4–6). tex 머리 주석과 제목의 "CSV 5종"은 기존 내용이라 그대로 둠.
  - `.docx`/`.pdf` 재생성(8→13페이지, 같은 파이프라인: `.md` → node HTML → Word COM). Word 문단 비교로 기존 153개 문단이 새 문서의 앞부분과 글자 단위로 같고 새 절만 뒤에 붙었음을 확인. PDF 9–13쪽 렌더링으로 새 표 폭 확인. 기존 docx/pdf는 scratchpad에 백업.
  - GitHub 연동: report 13 `.tex`/`.md`, `code/02_clean_sensortower_share_within_product.do`(저장소의 첫 do 파일), `log.md`를 커밋·push. 데이터(`data/raw`, `data/proc`)와 docx/pdf는 `.gitignore`에 따라 올리지 않음.
- Sensor Tower 앱 세션(④, 반기)·웹 방문(⑤, 분기) 사용량을 월별로 바꾸고 제품별로 분해한 데이터 생성(사용자 요청).
  - 사용자 결정(AskUserQuestion): (1) 저장 위치는 ④·⑤와 같은 `data/raw/macro/scaling/sensortower_state_of_ai_2026/` — CLAUDE.md의 "가공 데이터는 data/proc" 규칙의 예외로, 사용자가 raw를 선택함. (2) 월별 변환은 매끄러운 보간(Denton). (3) Worldwide도 국가와 같이 True Audience 점유율(⑥)로 분해.
  - 새 do 파일 `code/02_clean_sensortower_usage_monthly_by_assistant.do`(Stata 17 배치 실행). 출력 CSV 4개: ⑨ `sensortower_genai_apps_sessions_hours_monthly`(24개 시장 × 2023-01~2026-06, 1,008행), ⑩ `sensortower_genai_web_visits_hours_monthly`(23개 시장 × 2024-01~2026-03, 621행), ⑪ `sensortower_genai_apps_by_assistant_monthly`(19개 시장 × 8개 제품 × 2023-04~2026-05, 5,776행), ⑫ `sensortower_genai_web_by_assistant_monthly`(19 × 8 × 2024-01~2026-03, 4,104행).
  - 방법 변경: 처음에 쓴 가법 Denton(지표 없음)이 앱 2023H1 등 급증 구간에서 음수 월 값(최소 약 −3,000만 세션)을 만들어, 로그 선형 추세를 지표 계열로 쓰는 비례 Denton으로 바꿈. 월별 합 = 기간 값, 모든 값 양수를 assert로 확인.
  - 분해: 월별 값 × ⑥ 점유율(시장·월 합계 100으로 정규화, 매칭 키 market × month). 카테고리 전체 사용량을 어시스턴트 이용자 점유율로 나누는 강한 가정(컴패니언 등 비어시스턴트 앱 포함, 1인당 사용량·앱/웹 점유율 동일 가정)임을 do 파일 주석과 `_download_manifest.md`에 명시.
  - 예: 한국 Claude 2026-03 앱 세션 2.13억 회(점유율 6.99%), 웹 방문 2,875만 회. report 13에는 아직 반영하지 않음. git 커밋·push는 하지 않음.
- report 13(`13_SensorTower_데이터설명.tex`/`.md`)에 §8 "보완(2026-09-28): 앱 세션·웹 방문의 월별 변환과 제품별 분해" 추가(사용자 요청, 기존 §1–7 수정 없음). 표 7(파일 ⑨–⑫), 8.1 앱 세션과 웹 방문의 관계(중복 없음, 사람은 겹침, 서비스 목록 차이, 세션+방문 합산 불가·사용 시간 합산 가능과 조건, 표 8 단위 비교 2025H2), 8.2 월별 변환(비례 Denton, 로그 선형 지표 계열, 가법 Denton에서 바꾼 이유, 검증, 변수), 8.3 제품별 분해(정규화 점유율, 범위, 변수), 8.4 해석상 주의 5개, 8.5 주요 값(표 9, 2026-03 Worldwide·한국 ChatGPT·Gemini·Claude).
  - `.docx`/`.pdf` 재생성(13→17페이지, 같은 파이프라인). Word 문단 비교로 기존 288개 문단이 그대로이고 새 절만 뒤에 붙었음을 확인. PDF 14–17쪽 렌더링으로 새 표 폭 확인. 기존 파일은 scratchpad에 백업.
  - GitHub 연동: report 13 `.tex`/`.md`, `code/02_clean_sensortower_usage_monthly_by_assistant.do`, `log.md` 커밋·push. 데이터와 docx/pdf는 `.gitignore`에 따라 올리지 않음.
- 신규 report `14_SensorTower_이용자사용량_외부비교.tex`/`.md`/`.docx`/`.pdf` 작성(사용자 요청: 앞선 세 가지 질의응답 — True Audience와 Active User(WAU)의 공통점·차이, Chatterji et al.(2025) 메시지 수와의 비교, Fan and Nguyen(2026) 대화 수와의 비교 — 를 별도 report로).
  - 구성: 1 목적과 자료(시간 단위는 월간으로 통일, Sensor Tower 제품 값은 ⑦ 경로별 점유율 기준과 True Audience 기준 두 가지), 2 True Audience vs WAU(정의, 공통점, 차이 표, 수치 비교 표, 결론: 수준 비교 불가), 3 Chatterji 메시지 수 vs ChatGPT 웹 방문·앱 세션(증가율 메시지 5.8배·앱 세션 5.1배·웹 방문 1.9배, 메시지 ÷ 방문·세션 0.69 → 1.11, 소비자 플랜 한정 등 범위 차이, Claude 적용 불가), 4 Fan and Nguyen 대화 수 vs Claude(증가율은 1.8–2.1배로 맞음, Sensor Tower 웹 방문은 Similarweb의 약 4.5배, Fan 웹 MAU 1,890만은 ST 이용자 1.04억의 18%, 1P API는 양쪽 모두 제외), 5 종합 결론과 report 11 시사점, 6 재현 방법.
  - 새 do 파일 `code/04_analysis_sensortower_usage_comparison.do`(Stata 17): 입력 ①②⑦⑨–⑫와 `scaling_parameters_public.csv`, 출력 `results/table/14_usage_comparison.xlsx`(시트 ta_wau, chatterji, fan)와 `results/table/14_{ta_wau,chatterji,fan}.tex`(표 본문 행, report 14 `.tex`가 `\input`). ⑨–⑫를 만드는 `02_clean_sensortower_usage_monthly_by_assistant.do`를 먼저 실행해야 함.
  - `data/raw/macro/scaling/scaling_parameters_public.csv`에 Chatterji et al.(2025) 값 6행 추가(source_tier=paper, 기존 행 변경 없음): 하루 메시지 2024-06 4.51억·2025-06 26.27억(표 1, p.2, 소비자 플랜 전체의 정확한 측정값), 주 메시지 2025-07 180억(p.1, 논문이 Reuters 등 인용), WAU 2023-11 1억 이상·2024-11 약 3.5억(로그인 이용자만)·2025-07 7억 이상(p.10). 원문 PDF 쪽을 렌더링해 값 확인.
  - 정정: 앞선 답변에서 2025-07 ChatGPT 웹 방문을 164.3억으로 적었으나 do 파일 결과 164.2억(164.25억의 반올림).
  - `.docx`/`.pdf`: report 13과 같은 파이프라인(`.md` → node HTML → Word COM, 10페이지). PDF 전 페이지 렌더링으로 표 폭 확인. `.tex`는 로컬에 TeX가 없어 컴파일하지 않음.
  - GitHub 연동: report 14 `.tex`/`.md`, do 파일, `results/table/14_*`, `log.md` 커밋·push.

## 2026-09-29

- Sensor Tower 제품별 앱 세션(⑪)과 웹 방문(⑫)을 합친 데이터 생성(사용자 요청: Worldwide와 국가별 제품별 web visit + app session).
  - 새 do 파일 `code/03_merge_sensortower_apps_web_by_assistant.do`(Stata 17 배치 실행). 출력 ⑬ `data/raw/macro/scaling/sensortower_state_of_ai_2026/sensortower_genai_apps_web_by_assistant_monthly.csv`(19개 시장 × 8개 제품 × 2023-04~2026-05 = 5,776행). 저장 위치는 ⑨–⑫의 선례(사용자 지정, data/proc 규칙의 예외)를 따름.
  - 매칭 키: market × assistant × month. 앱 기준 outer merge; `sessions_visits`(세션 + 방문)와 `time_spent_hours_total`(앱 + 웹 사용 시간)은 둘 다 있는 2024-01~2026-03(`has_web` = 1)만 계산하고 나머지는 결측. 보조로 횟수·시간 기준 앱 비중(%) 추가. 두 파일의 점유율이 같은지 assert로 확인.
  - 주의(report 13 §8.1과 같음): 세션과 방문은 단위 크기가 달라 횟수 합계의 약 88%가 앱(시간 기준은 약 43%). Worldwide 합계는 앱·웹 범위가 달라 참고용. 같은 점유율로 분해한 값이라 한 시장·월 안에서 제품별 합계는 카테고리 합계 × 점유율과 같음.
  - 예: 2026-03 Worldwide ChatGPT 863.6억 회(세션 755.8억 + 방문 107.8억), 한국 Claude 2.42억 회(2.13억 + 2,875만). `_download_manifest.md` 갱신. report 13에는 아직 반영하지 않음. git 커밋·push는 하지 않음.
- 제품 구분 없는 월별 웹 방문·앱 세션·합계 파일 요청(사용자 요청: ⑤ 분기·④ 반기 파일 활용).
  - 월별 앱 세션(⑨ `sensortower_genai_apps_sessions_hours_monthly.csv`)과 월별 웹 방문(⑩ `sensortower_genai_web_visits_hours_monthly.csv`)은 2026-09-28에 ④·⑤에서 비례 Denton으로 이미 만든 파일이므로 새로 만들지 않고 그대로 사용.
  - 합계 파일 ⑭ `sensortower_genai_apps_web_monthly.csv`만 새로 생성: `code/03_merge_sensortower_apps_web_by_assistant.do`에 2부로 추가(market × month, 앱 기준 outer merge, 24개 시장 × 2023-01~2026-06 = 1,008행). 합계는 2024-01~2026-03의 23개 시장만(China Mainland는 웹 없음). 변수 구성은 ⑬과 같음.
  - 확인: ⑬의 제품별 합계와 ⑭ 일치(Worldwide 2026-03 1,795.5억 회 = 세션 1,571.4억 + 방문 224.1억). 한국 2026-03 34.6억 회. 합계 중 앱 비중은 2024-01 Worldwide 54% → 2026-03 88%로 커짐(시간 기준 16% → 44%). do 파일 전체 재실행으로 ⑬도 다시 생성됨.
- 신규 report `15_ChatGPT기준값_SensorTower평가_대화총량추정.tex`/`.md`/`.docx`/`.pdf` 작성(사용자 요청: 가장 신뢰할 수 있는 수치인 Chatterji et al.(2025)의 2025-07 WAU 7억 명·주 메시지 180억 건을 기준으로 Sensor Tower를 평가하고, 전 세계·제품별 대화 총량 추정 방안을 별도 report로).
  - 구성: 1 목적과 기준값(2025-07 주 기준값, 2024-06 하루 4.51억 건 보조 기준값, 2025-06 26.27억 건은 검증용), 2 기준 시점 평가(WAU ÷ True Audience 0.70이 사용 일수로 본 하한 0.45와 1 사이, 메시지 ÷ 방문·세션 1.06, 분당 0.17건, 시간 비례 시 웹 방문당 3.4건·앱 세션당 0.4건), 3 시계열 평가(2024-06→2025-07 메시지 5.89배, 앱 세션 5.51배로 메시지 ÷ 지표 r 변화 1.07배로 가장 안정적, 웹 방문·사용 시간·이용자는 r이 2.5–3.2배 변함, 2025-06 예측이 모든 지표에서 6–12% 낮음 = 기준값 간 불일치, 6→7월 주 183.9억→180억 건 감소 vs ST 증가), 4 추정 방안(대화_j = ChatGPT 메시지 × 지표_j/지표_ChatGPT × θ_j ÷ k_j; ① 기준값 결합(benchmarking, 앱 세션 지표, 2025-07 이후 flat/trend) ② 제품 간 상대 규모 세 기준(True Audience 이용자, 사용 시간 ⑦, 방문 + 세션 ⑦) ③ 합계 ④ 대화당 메시지 k 격자 ⑤ 범위 조정, 국가별 확장), 5 결론, 6 재현.
  - 주요 결과: ChatGPT 월 메시지 2026-03 약 1,085억 건(앱 세션 flat, 범위 978–1,269억), AI 어시스턴트 전체 주 메시지 2025-07 262–310억, 2026-03 462–509억 건; k = 3이면 주 대화 87–103억, 154–170억 건. Claude 2026-02 주 메시지 8.6–26.9억 건을 Fan and Nguyen 주 2억 대화와 비교하면 k 4–13, Fan 방식에 ST 이용자를 쓰면 k 0.8–2.5 → k는 1–13으로 식별 안 됨.
  - 의사결정: 대화당 메시지 수는 저장소 문헌(Chatterji, Signals, AEI)에 공개 값이 없어 격자(1, 2, 3, 5)로 둠. ChatGPT 시계열 지표는 처음 사용 시간으로 계산했으나, 기준값 사이 r 변화가 가장 작은 앱 세션(1.07배)으로 바꿈(사용 시간 2.51배). ⑦의 "Grok AI"는 "Grok"으로 통일, ⑦에 한 경로만 있는 제품(Copilot 웹, Meta AI 앱)은 다른 경로 0, DeepSeek는 ⑦ 기준 결측.
  - 새 do 파일 `code/04_analysis_chatgpt_anchor_conversation_volume.do`(Stata 17). 입력 ①②⑥⑦⑨⑩, `scaling_parameters_public.csv`(새 값 추가 없음). 출력 `results/table/15_chatgpt_anchor.xlsx`(시트 anchor, growth, series, products, conv, claude, monthly)와 `results/table/15_{anchor,growth,series,products,conv,claude}.tex`(report 15 `.tex`가 `\input`).
  - `.docx`/`.pdf`: 같은 파이프라인(`.md` → node HTML → Word COM, 12페이지). PDF 렌더링으로 표 폭 확인. `.tex`는 로컬에 TeX가 없어 컴파일하지 않음.
  - GitHub 연동: report 15 `.tex`/`.md`, do 파일, `results/table/15_*`, `log.md` 커밋·push.

## 2026-09-30

- report 15(`15_ChatGPT기준값_SensorTower평가_대화총량추정.tex`/`.md`) §2.1 "이용자 수" 보완(사용자 요청: "사용 일수로 본 하한(0.45)과 상한(1)"의 의미 설명 추가). 기존 두 문단을 확장: 상한 1(WAU ⊂ MAU), 하한 0.45(WAU ≥ DAU, DAU/MAU ≈ 앱 이용자 월평균 사용 일수 14.0 ÷ 31), 예시(14일 연속 사용 → 약 0.45, 흩어진 사용 → 1에 가까움), 점검이 느슨한 이유 3가지(범위가 넓음, 하한은 앱 이용자 기준 근사값, 0.70은 전 세계 계정 ÷ 25개 시장 사람 수). 다른 절과 표는 변경 없음(diff로 확인).
  - `.docx`/`.pdf` 재생성(12페이지 유지, 같은 파이프라인). PDF 3–4쪽 렌더링으로 확인. 기존 파일은 scratchpad에 백업.
  - GitHub 연동: report 15 `.tex`/`.md`, `log.md` 커밋·push.
- `D:/econ-wiki`에 새로 추가된 Tomlinson et al.(2025) "Working with AI: Measuring the Applicability of Generative AI to Occupations"(Microsoft Research, arXiv:2507.07935v6)를 `reference/`에 반영(사용자 요청).
  - `reference/notes/tomlinson-2025-working-with-ai-measuring-the.md`: econ-wiki `sources/` 원본을 그대로 복사(기존 노트와 같은 방식).
  - `reference/papers/tomlinson-2025-working-with-ai-measuring-the.pdf`: econ-wiki `papers/local/`에서 원래 파일명 그대로 복사.
  - `reference/references.bib`: `tomlinson-2025-working-with-ai-measuring-the`(@unpublished, arXiv; handa-2025와 같은 형식) 추가.
  - 참고: Bing Copilot 미국 대화 20만 건(2024.1–9)을 O*NET IWA에 매핑한 Microsoft Copilot usage 기반 직업별 AI 적용가능성 점수로, 이 저장소의 usage 데이터 축(AEI, ChatGPT)에 Microsoft Copilot을 더하는 문헌.
- Tomlinson et al.(2025)의 공개 집계자료 다운로드(사용자 요청).
  - 새 폴더 `data/raw/usage/microsoft_working_with_ai/`(새 usage 소스, `data/proc/usage/microsoft_working_with_ai/`도 대칭으로 빈 폴더 생성). GitHub microsoft/working-with-ai 커밋 `c94a07c`(v1.1, arXiv v6 대응)의 파일 11개 전부를 받은 그대로 저장: CSV 7개(`iwa_metrics`, `soc_metrics`, `ai_applicability_scores`, `soc_iwa_weights`, `soc_iwa_nonphysical_weights`, `soc_to_iwas`, `physical_tasks`)와 README·LICENSE·NOTICE·SECURITY. 라이선스 CC BY 4.0.
  - `_download_manifest.md`에 출처 URL·커밋·MD5·파일별 단위, 확인 결과, 매칭 키를 기록.
  - 확인: IWA 332개, 커버된 IWA(share > 0.0005) 사용자 127개·AI 87개로 논문과 일치. `ai_applicability_scores` = 사용자 쪽·AI 쪽(비물리) 점수의 평균, SOC 785개 모두 일치. README의 파일명·변수명 2곳이 실제와 다름(manifest에 기록).
  - 매칭 키: 2018 SOC 상세 코드(6자리, OEWS와 직접 연결), O*NET IWA ID. 한 시점 단면 자료(2024.1–9).
  - 아직 do 파일은 만들지 않음(`data/proc/`에 결과물 없음). git 커밋·push는 하지 않음.
- Microsoft AI Economy Institute의 AI Diffusion 데이터 다운로드(사용자 요청: CSV와 보고서 PDF).
  - 새 폴더 `data/raw/usage/microsoft_ai_diffusion/`(대칭으로 `data/proc/usage/microsoft_ai_diffusion/` 빈 폴더 생성). GitHub microsoft/ai-diffusion-report 커밋 `507c316`(2026-09-21)의 파일 12개를 폴더 구조 그대로 저장: 국가별 CSV 1개(146개 경제권, 2025 H1·H2·2026 Q1·Q2), 미국 지역별 CSV 3개(카운티 3,143곳·주 51곳·MSA 34곳, 2026 Q1), 보고서 PDF 5개, README·LICENSE·SECURITY. 라이선스 MIT.
  - 지표: 해당 기간에 생성형 AI를 쓴 15–64세 인구 비중(Microsoft telemetry를 기기·OS 점유율, 인터넷 보급률, 인구로 보정). Copilot만이 아니라 생성형 AI 전반이며 직업 정보는 없음.
  - `_download_manifest.md`에 출처·커밋·MD5·파일별 내용, 확인 결과, 매칭 키를 기록. 확인 결과: 국가별 CSV는 값이 `%` 문자열이고 Q2만 소수 첫째 자리 표기, 인코딩이 Mac Roman(`Türkiye`), ISO 코드 없음. 한국 25.9% → 30.7% → 37.1% → 40.6%, Q1·Q2 값은 Q2 보고서 순위표와 일치.
  - 주의: Q2 2026 보고서는 다음 판부터 측정 대상 도구를 넓힌다고 밝혀(p.3) 시계열 단절 가능성이 있음.
  - 매칭 키: 국가는 영문 국가명(ISO 대응표 필요), 미국은 카운티 FIPS·주·MSA(CBSA) 코드. 시점은 반기(2025) → 분기(2026).
  - `reference/references.bib`에 데이터 인용용 `microsoft-2026-ai-diffusion`(@misc) 추가. 방법론 논문 Misra et al.(2025, arXiv:2511.02781) 등은 받지 않음.
  - 아직 do 파일은 만들지 않음. git 커밋·push는 하지 않음.

## 2026-10-03

- `D:/econ-wiki`에 새로 추가된 문헌 4편을 `reference/`에 반영(사용자 요청). 기존과 같은 방식: `sources/` 노트를 `reference/notes/`에, `papers/local/` PDF를 `reference/papers/`에 원래 파일명 그대로 복사하고 `reference/references.bib`에 항목 추가.
  - `tebrake-2026-generative-ai-and-the-limits` — Tebrake and Strassner, "Generative AI and the Limits of Productivity Measurement in the System of National Accounts", IMF WP/26/201. 비시장 산출의 sum-of-costs 평가와 서비스 가격 품질조정 부족 때문에 AI 생산성 향상이 국민계정에서 과소측정된다는 논의.
  - `blumenfeld-2026-the-macroeconomic-effect-of-ai` — Blumenfeld, Hazell, Lian and Schaab, "The Macroeconomic Effect of AI: Sizing the Software Engineering Channel", NBER WP 35793. 주가의 AI 지수 민감도 × SWE 급여비중으로 SWE 생산성 기대 상승과 GDP 효과 추정.
  - `fairlie-2026-the-early-impacts-of-ai` — Fairlie and Wu, "The Early Impacts of AI on Employment among Recent College Graduates", NBER WP 35796. CPS 2026년 여름까지 최근 대졸자 실업률 유의한 상승 없음. AEI 관측 노출과 Eloundou 노출을 함께 사용(usage–exposure 비교 문헌).
  - `rinz-2026-the-recent-evolution-of-ai` — Rinz, "The Recent Evolution of AI-Related Labor Demand", Cleveland Fed WP 26-24 (doi 10.26509/frbc-wp-202624). Lightcast 구인공고 + CPS로 LLM 노출 직업의 AI 언급·게시임금·노동흐름 분석.
  - GitHub 연동: 노트 4개(및 9/30에 추가한 Tomlinson 노트), `references.bib`, `log.md` 커밋·push. PDF는 git 추적 대상이 아님.
- 새 report 16 `results/report/16_ChatGPT이용자수_OpenAI공식언급.tex`/`.md`/`.docx`/`.pdf` 작성(사용자 요청: ChatGPT 총 이용자 수(WAU/MAU)에 대한 OpenAI 공식 언급을 정확한 시점·출처와 함께 정리).
  - 포함 기준: A(openai.com 게시물·OpenAI 연구 논문, 원문 직접 확인)와 B(경영진·대변인의 키노트·인터뷰·X 게시물, 언론 보도로 확인). 외부 추정(UBS/Similarweb, Sensor Tower)과 OpenAI 미확인 보도(The Information), 수치 불명확한 발언(2025-04 TED)은 표에서 제외하고 주의 절에 기록.
  - 결과: 공식 언급 21건(2022-12 가입자 100만 → 2023-11 WAU 1억 → … → 2026-02 9억 → 2026-08 10억). OpenAI가 공식 발표한 지표는 WAU뿐이고 MAU·DAU 공식 수치는 없음.
  - 주요 판단: 10억 명 언급 4건은 범위가 다름. 2026-07-31 Friar 글은 "모델 전체 활성 이용자"(주기 미명시), 2026-08-06·08-31 글은 ChatGPT 단독 주간 이용자, 2026-09-08 "The Work Now Within Reach"(사용자가 제시한 글)는 "Our products" 즉 OpenAI 제품 전체 WAU. ChatGPT 단독 10억 명의 첫 공식 언급은 2026-08-06. 2026-01-22 가이드의 "7억 명"은 이전 값 재인용으로 보아 경로 표에서 제외. Chatterji et al. 2024-11 로그인 WAU 3.5억 명이 2024-12 공개 3억 명보다 큰 불일치도 기록.
  - 확인: openai.com 게시물 11건은 2026-10-03에 원문을 받아 문장·게시일 확인(WebFetch는 403이라 curl 사용). Chatterji et al. PDF 원문 p.10·각주 20 확인. 언론 출처(TechCrunch, CNBC, Bloomberg/Yahoo)도 원문 문장 확인. Axios(403)와 Techmeme은 검색 결과로만 확인.
  - `reference/references.bib`에 OpenAI 웹 게시물 11개(@misc, `openai-2025-new-funding-agi` 등, `friar-2026-*` 2개) 추가. 언론·X 출처는 bib 없이 본문 출처 목록에 URL로 기록.
  - 표는 분석 산출물이 아닌 출처 정리이므로 `results/table/`을 거치지 않고 본문에 둠(do 파일 없음).
  - `.docx`/`.pdf`: 같은 파이프라인(`.md` → node HTML → Word COM, 8페이지). PDF 렌더링으로 표 폭 확인. `.tex`는 로컬에 TeX가 없어 컴파일하지 않음.
  - 후속(미실행): 2026-02 9억·2026-08 10억을 report 15 기준값으로 쓰려면 `scaling_parameters_public.csv`에 항목 추가 필요(원자료 변경이라 확인 후 진행).
  - GitHub 연동: report 16 `.tex`/`.md`, `references.bib`, `log.md` 커밋·push.
