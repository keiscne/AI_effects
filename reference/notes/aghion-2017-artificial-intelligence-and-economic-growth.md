---
title: "Artificial Intelligence and Economic Growth"
authors: Philippe Aghion, Benjamin F. Jones, Charles I. Jones
institution: ""
year: 2017
doi: ""
category: [macroeconomics]
source_tier: 1
pdf_path: papers/local/aghion-2017-artificial-intelligence-and-economic-growth.pdf
pdf_filename: aghion-2017-artificial-intelligence-and-economic-growth.pdf
verified_date: 2026-06-23
datasets_used: []
---

## One-line Summary

AI를 200여 년에 걸친 자동화 과정의 최신 형태로 모델링하고, Baumol의 "비용질병(cost disease)" 통찰을 Zeira(1998)·Acemoglu-Restrepo(2016) 자동화 모형에 결합해 완전자동화에서도 자본분배율이 일정 수준에서 안정되는 균형성장 경로의 충분조건을 도출하며, 특이점(singularity) 가능성과 기업 차원의 함의까지 다룬다.

## Document Information

- 저자: Philippe Aghion (Collège de France), Benjamin F. Jones (Northwestern University, Kellogg School of Management), Charles I. Jones (Stanford University, Graduate School of Business)
- 발행: NBER Working Paper No. 23928, 2017년 10월
- JEL 분류: O3, O4

## Key Contributions

- Zeira(1998) 과업기반 자동화 모형과 Acemoglu and Restrepo(2016, 미발표)의 신규과업 모형을 확장해 Baumol의 "비용질병"을 대체탄력성<1인 CES 생산함수에 결합, 완전자동화(θ_t→1)에서도 자본분배율이 약 1/3 수준에서 점근적으로 안정되는 균형성장 경로의 충분조건을 도출 (Section 2.2, Figure 1, p.10-12).
- "Type I" 특이점(성장률이 무한히 커지지만 임의 시점에서는 유한)과 "Type II" 특이점(유한 시간 내 소득이 무한)을 구분하고, Cobb-Douglas 생산함수에서는 완전자동화 없이 부분 자동화만으로도 η>1 조건 하에서 Type II 특이점이 발생할 수 있음을 증명 (Section 4.1, Example 3, 식 36-40, p.24-26).
- 슘페터식 창조적 파괴 부록 모형에서, 초지능(super-AI)이 2단계 혁신과정 중 기계가 수행 가능한 1단계를 무한히 빠르게(μ→∞) 만들면 인간 R&D가 필요한 2단계에 대한 투자 인센티브가 0으로 떨어져 성장이 멈출 수 있음(g→0)을 보임 (Appendix A.2, p.53-56).
- 시장구조(경쟁·모방이 혁신에 미치는 역U자 효과), 사업조직(R&D 집약적 기업에서 저숙련 근로자에게 돌아가는 임금 프리미엄), 자기고용 확대 등 AI의 기업 차원 함의를 정리 (Section 5, p.31-42).

## Methodology and Data

- Section 2-4는 순수 이론 모형이며 저자 자신의 실증분석은 수행하지 않음. Zeira식 과업기반 생산함수(식 1-3)에 대체탄력성<1(σ<0)인 CES를 결합한 Baumol 비용질병 모형(식 5-15)을 구축하고 시뮬레이션(Figure 1-3)으로 균형성장 경로를 예시 (p.7-17).
- Section 6의 실증 근거는 저자 자신의 추정이 아니라 타 연구의 기존 데이터를 인용·재구성한 것: 미국 KLEMS 자료(Jorgenson, Ho, and Samuels 2017)의 산업별 자본분배율을 HP필터(평활화 파라미터 400)로 평활화 (Figure 6, p.43).
- EU-KLEMS 프로젝트 자료(Jäger 2016 방법론 설명)를 이용해 운송장비 제조업의 미국·프랑스·독일·이탈리아·스페인·영국 자본분배율(1970-2015년)을 비교 (Figure 7, p.44).
- Acemoglu and Restrepo(2017)의 International Federation of Robotics 기반 산업용 로봇 데이터(2004-2014년, 산업별)와 Jorgenson, Ho, and Samuels(2017) 자본분배율 변화의 산업별 상관을 시각화 (Figure 8, p.45).

## Key Results

- 균형성장 시뮬레이션(Figure 1, p.12): 자동화 비율 θ_t가 1(완전자동화)에 점근해도 자본분배율은 약 1/3에서 안정적으로 수렴, 노동분배율은 약 2/3 유지 — "본질적이나 개선이 어려운" 노동 과업이 가격은 비싸지지만 GDP 비중을 유지하는 Baumol 효과로 설명.
- 일정 자본분배율을 유지하면서도 성장률이 가속되는 사례(Figure 2, p.14): 식(18) g_Yt=g_A+θ_t·g_Kt 조건 하에서, A_t의 외생적 성장(연 2%)이 결합되면 자본분배율 일정 + 성장률 상승이 동시에 가능함을 시뮬레이션으로 제시.
- 컴퓨팅 속도는 제2차 세계대전 이후 약 10^11배 증가했으나(1943년 Colossus 5×10^5 FLOPS → 2016년 Sunway TaihuLight 9×10^16 FLOPS), 같은 기간 경제성장률은 가속되지 않았다는 사실을 Moore의 법칙에 대한 경고적 사례로 제시 (각주 16, p.28).
- 실증 섹션(Section 6, 타 연구 데이터 재구성): 2014년 신규 구매된 산업용 로봇의 56%를 초과하는 비중이 자동차산업에 설치되었고, 2위인 컴퓨터·전자제품 산업은 12% 미만 (p.45-46).
- 운송장비 제조업의 자본분배율(2014년 기준)은 미국에서 50%를 초과했고, 영국에서는 약 20%로 가장 낮음 (Figure 7 본문 설명, p.44).
- 2004-2014년 자본분배율 변화와 로봇 보급(부가가치 대비) 변화 사이에는 뚜렷한 상관관계가 나타나지 않음(Figure 8, p.45); Graetz and Michaels(2017)의 EU-KLEMS+IFR 로봇 데이터(1993-2007) 재인용 결과 역시 로봇 도입과 요소분배율 사이에 체계적 관계가 없으나 노동생산성 증가와는 연관된다고 보고 (p.45-46).

## Limitations and Future Work

- 저자가 명시한 한계: (1) 자동화 비율 θ_t를 전 구간에서 외생적으로 취급하며, 내생적 자동화·AI 도입 인센티브 분석을 향후 중요한 연구방향으로 명시 (Section 2.2.2 말미, p.11; Conclusion, p.47); (2) 자본분배율과 자동화 간 실증적 연관성이 약하며, 시장집중도·노조화율·구성효과 등 다른 경제적 힘이 더 중요하게 작용할 수 있음을 인정 (Section 6, p.43, p.48); (3) "초지능에 의한 특이점" 논의는 명시적으로 사변적(speculative)인 시나리오 분석이라고 밝힘 (Section 4 서두, p.20-21).

## Related Work

- Zeira (1998) "Workers, Machines, And Economic Growth" — 본 논문 자동화 모형(식 1-3)의 직접적 출발점.
- Acemoglu and Restrepo (2016, 미발표; 이후 2018년 American Economic Review "The Race between Man and Machine"으로 발전) — 본 논문이 명시적으로 확장하는 자동화·신규과업 모형의 토대. 같은 저자들의 후속 논문인 [[acemoglu-2019-automation-and-new-tasks-how]] (2019, JEP)와 과업 기반 분석틀을 공유하나 별개 논문.
- Acemoglu and Restrepo (2017) "Robots and Jobs: Evidence from US Labor Markets" — Section 6 Figure 8의 로봇 데이터 출처.
- Hemous and Olsen (2016); Agrawal, McHale, and Oettl (2017) — 관련 과업기반·재조합 성장 모형으로 본문에서 비교 검토.

## Glossary

- **비용질병(Baumol's cost disease)**: 생산성이 빠르게 증가하는 부문은 GDP 비중이 줄고, 생산성 증가가 더딘("본질적이나 개선이 어려운") 부문이 비중을 키운다는 통찰 (Baumol 1967; 본문 Section 2.2, p.6-7).
- **Type I 특이점**: 성장률이 시간이 지남에 따라 무한히 커지지만 어느 유한한 시점에서도 그 값 자체는 유한한 성장 체제 (p.21).
- **Type II 특이점**: 유한한 시간 내에 소득(또는 생산성)이 무한해지는 수학적 특이점 (p.21).
- **η (식 36)**: Cobb-Douglas 생산함수에서 재화생산 자동화율 α과 아이디어생산 자동화율 β로 정의되는 결합 파라미터로, η>1이면 부분 자동화만으로도 Type II 특이점이 발생 (p.25).
