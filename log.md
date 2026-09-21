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
