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
