# AI-effects

생성형 AI(생성형 인공지능)·LLM이 거시경제 및 노동시장에 미치는 영향을 분석하는 연구 저장소입니다.

## 연구 목표

기존 AI 관련 연구는 주로 **AI exposure**(직업/과업이 AI에 얼마나 노출되어 있는지를 사전에 추정한 지표: 예) Felten-Raj-Seamans AIOE, Eloundou et al. GPT exposure, Webb automation exposure 등)를 중심으로 이루어져 왔습니다.

이 저장소의 핵심 목표는 여기서 한 걸음 나아가, **실제 AI usage data**(예: Anthropic Economic Index, OpenAI/ChatGPT 사용량 데이터, Microsoft Copilot 사용량 데이터 등)를 exposure 지표와 연동하여, 사전적 노출도뿐 아니라 실제 사용 패턴이 거시경제·노동시장에 미치는 영향을 분석하는 것입니다.

- Exposure 데이터: "이 직업/과업이 AI에 얼마나 노출될 수 있는가" (잠재적·이론적 지표)
- Usage 데이터: "실제로 AI가 얼마나, 어떻게 사용되고 있는가" (실현된 지표)
- 두 데이터를 결합(`data/proc/merged/`)하여 exposure만으로는 포착하지 못하는 실제 채택(adoption)·활용 효과를 분석합니다.

## 폴더 구조

```
AI-effects/
├── CLAUDE.md            # 이 파일
├── log.md               # 작업 로그
├── reference/
│   ├── papers/           # 참고문헌 PDF 원본
│   ├── notes/            # 논문별 정리 노트(.md, D:/econ-wiki/sources 기반)
│   └── references.bib    # LaTeX 인용용 bib 파일
├── code/                 # Stata do 파일 (모든 데이터 구축·분석 코드)
├── data/
│   ├── raw/              # 원본(raw) 데이터, 절대 직접 수정하지 않음
│   │   ├── exposure/      # AI exposure 관련 원자료
│   │   ├── usage/         # AI usage 관련 원자료
│   │   └── macro/         # 거시경제·노동시장 원자료 (물가, 고용, 임금 등)
│   └── proc/              # 가공(processed) 데이터
│       ├── exposure/
│       ├── usage/
│       ├── macro/
│       └── merged/        # exposure + usage + macro 결합 데이터셋 (분석용 최종 데이터)
└── results/
    ├── table/             # 분석 결과표 (주로 .xlsx)
    ├── report/            # 분석 방법론·결과에 대한 1차 문헌(작업 노트/초안)
    └── paper/             # report 내용을 정리한 논문/보고서 문헌
```

### data/raw vs data/proc

- `data/raw/`: 외부에서 받은 원본 그대로 저장. 원본 파일명·형식을 유지하고 **직접 수정 금지**.
- `data/proc/`: `code/`의 do 파일이 `data/raw/`를 읽어 생성하는 가공 데이터. 재현 가능해야 하므로 수작업으로 편집하지 않고 항상 do 파일 실행 결과물로만 존재해야 합니다.
- 새로운 데이터 소스가 추가되면 `raw/`와 `proc/`에 동일한 이름의 하위 폴더를 만들어 대칭 구조를 유지합니다 (예: 새 usage 데이터 소스 추가 시 `raw/usage/` 하위에 소스별 폴더 생성).

## Stata 작업 규칙 (code/)

모든 데이터 구축·가공·분석은 Stata do 파일로 관리합니다.

- **명명 규칙**: 실행 순서를 접두 번호로 표시합니다.
  - `00_master.do` — 전체 파이프라인을 순서대로 실행하는 마스터 스크립트
  - `01_import_*.do` — raw 데이터를 읽어 최소 가공 후 `data/proc/`에 저장
  - `02_clean_*.do` — 결측치 처리, 변수 정리 등 정제
  - `03_merge_*.do` — exposure/usage/macro 데이터 결합 → `data/proc/merged/`
  - `04_analysis_*.do` — 회귀분석 등 실제 분석 → `results/table/`, `results/report/`에 출력
- **경로 관리**: 하드코딩된 절대경로 대신 `00_master.do` 상단 또는 별도 설정 파일에서 프로젝트 루트를 global로 지정하고, 이후 모든 do 파일은 이 global을 기준으로 상대경로를 사용합니다.
  ```stata
  global root "d:/research/AI_effects"
  global raw "$root/data/raw"
  global proc "$root/data/proc"
  global results "$root/results"
  ```
- **재현성**: `data/proc/`의 어떤 파일도 대응하는 do 파일 없이 존재해서는 안 됩니다. do 파일 하나로 원본부터 결과까지 재현 가능해야 합니다.
- **결과 출력**: 표는 `results/table/`에 `.xlsx`로 저장 (`putexcel`, `esttab ... using ... .xlsx` 등 활용).

## results/ 하위 폴더 구분

- `table/`: 분석에서 산출된 표. 엑셀 파일(.xlsx)과, 논문에 바로 삽입할 LaTeX 표(.tex, `esttab ... using ... .tex` 등으로 생성)를 함께 둡니다.
- `report/`: 분석 방법론과 결과에 대한 1차적인 작업 문헌(초안, 메모 수준). 분석 단위별로 나누어 작성합니다.
- `paper/`: `report/`의 내용을 종합·정리한 논문/보고서 최종본.

## reference/

- `papers/`: 참고문헌 PDF 원본을 파일명 기준으로 직접 보관합니다 (예: `Author_Year_Title.pdf`).
- `notes/`: 논문별 정리 노트(.md). `D:/econ-wiki`(Obsidian 기반 경제학 위키)의 `sources/*.md`에서, AI/생성형AI 관련 문헌에 한해 가져온 것입니다. 각 노트는 출처 페이지 인용을 포함한 자기완결적 요약이며, frontmatter의 `pdf_filename`이 `papers/`의 대응 PDF를 가리킵니다.
  - `D:/econ-wiki`에는 이 노트 외에도 `wiki/reference/{주제}/*.md`라는 짧은 위키링크 기반 노트가 있으나, 다른 노트로의 `[[...]]` 링크가 많아 vault 밖으로 꺼내면 링크가 끊어지므로 가져오지 않았습니다. 필요하면 `D:/econ-wiki`를 직접 참조합니다.
  - 일부 PDF(부록 파일 등)는 대응하는 별도 노트가 없을 수 있습니다.
- `references.bib`: LaTeX 인용을 위한 bib 파일. 새 문헌을 추가할 때는 PDF(및 가능하면 노트)와 bib 항목(citation key 포함)을 함께 등록합니다.
- 별도 문헌관리 툴(Zotero 등)은 사용하지 않습니다.
- 새 AI 관련 문헌은 `D:/econ-wiki`에도 함께 축적되고 있으므로, 두 저장소 중 어느 한쪽에만 추가되지 않도록 유의합니다.

## 논문/보고서 작성 규칙 (report/, paper/)

이 저장소의 최종 목적은 논문 또는 보고서 작성이므로, `report/`와 `paper/`는 다음 규칙을 따릅니다.

### 형식

- 모든 문서는 **LaTeX(.tex)**로 작성합니다.
- 작성 언어는 **한국어**를 기본으로 합니다.
- 한글 조판을 위해 XeLaTeX 또는 LuaLaTeX 엔진과 `kotex` 계열 패키지(`kotex`, `xetexko` 등) 사용을 권장합니다. 특정 학술지 양식(투고 규정)이 있으면 해당 템플릿의 documentclass를 그대로 따릅니다.
- 인용은 `reference/references.bib`을 참조하는 `\cite{}` 계열 명령을 사용합니다(biblatex/natbib 등 프로젝트 내 통일된 방식 사용).
- 표는 가능한 한 `results/table/*.tex`를 `\input{}`으로 불러와 삽입하고, 수치를 본문에 직접 하드코딩하지 않습니다(재현성 유지).

### report/ ↔ paper/ 관계

- `report/`에는 분석 단위별 작업 문헌을 개별 파일로 둡니다. 파일명은 `code/`의 단계 구분과 맞추어 `NN_주제.tex` 형식을 사용합니다 (예: `01_exposure_review.tex`, `02_usage_data.tex`, `03_merge_analysis.tex`).
  - 각 report 파일은 해당 분석의 배경, 데이터, 방법론, 결과, 잠정 해석을 담은 독립적인 작업 노트입니다.
- `paper/`는 여러 `report/` 파일의 내용을 통합·정제하여 하나의 완결된 논문으로 작성하는 공간입니다.
  - `paper/main.tex`를 마스터 파일로 두고, 절(section) 단위 `.tex` 파일을 `\input{}`/`\include{}`로 구성합니다.
  - `paper/`로 옮겨진 내용은 report의 초안 성격을 벗어나 논문 형식(서론-데이터-방법론-결과-결론 등)에 맞게 다시 쓰는 것을 전제로 합니다. report를 그대로 복사하지 않습니다.

### 버전 관리

- 이 저장소는 git으로 관리되지 않으므로, 파일명에 `_v1`, `_v2`, `_final` 같은 버전 접미사를 붙이지 않습니다.
- 대신 문서의 주요 개정 사항(구조 변경, 결과 갱신, 큰 폭의 재작성 등)은 `log.md`에 날짜와 함께 기록합니다.

## log.md

작업 로그. 날짜별로 무엇을 했는지, 어떤 데이터/do 파일을 추가·수정했는지, 주요 의사결정 사항을 기록합니다. 형식은 `log.md` 참고.

## 작업 시 유의사항

- 데이터 구축 관련 코드는 반드시 `code/` 하위 do 파일로 작성/수정하며, 수작업 데이터 편집은 지양합니다.
- 새로운 결정(폴더 구조 변경, 데이터 소스 추가 방식 등)이 필요한 경우, 먼저 사용자에게 확인합니다.
- exposure 지표와 usage 데이터를 연결할 때는 매칭 키(직업 코드, 산업 코드, 시점 등)를 `log.md` 또는 do 파일 주석에 명시하여 추후 추적 가능하도록 합니다.
