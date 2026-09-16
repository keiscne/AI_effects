---
title: "Scenarios for the Transition to AGI"
authors: Anton Korinek, Donghyun Suh
institution: ""
year: 2024
doi: ""
category: [macroeconomics]
source_tier: 1
pdf_path: papers/local/korinek-2024-scenarios-for-the-transition-to.pdf
pdf_filename: korinek-2024-scenarios-for-the-transition-to.pdf
verified_date: 2026-06-27
datasets_used: []
---

## One-line Summary

인간 과업을 컴퓨팅 복잡도("compute space") 공간 위의 연속체로 표현하는 컴퓨트 중심(compute-centric) 자동화 모형을 구축하여, 과업 복잡도 분포가 무한(unbounded)한지 유한(bounded)한지에 따라 임금이 영구히 상승하거나 완전자동화 도달 이전에 붕괴하는 등 AGI로의 이행 경로가 극단적으로 달라질 수 있음을 보인다.

## Document Information

- **저널/발표**: NBER Working Paper No. 32255 (2024년 3월)
- **저자**: Anton Korinek (University of Virginia, NBER), Donghyun Suh (University of Virginia)

## Key Contributions

1. **컴퓨트 중심 과업 모형**: Zeira(1998), Acemoglu and Restrepo(2018, 2022)의 과업기반 틀을 계승하면서, 과업의 자동화 가능 여부를 가르는 기준을 "복잡도"(저자들의 선호 해석상 컴퓨팅 자원, FLOP)로 명시화한다. 자동화지수(automation index) I는 외생적으로 지수적으로 성장하며, 과업 복잡도 분포 Φ(i)가 자동화 가능 과업의 누적 비중을 결정한다(Section 2.1–2.2).
2. **두 영역(region) 구분**: 주어진 자본·노동 부존자원에서 자동화지수가 임계값 Î(자본/노동 비율에 의해 결정, Lemma 1)보다 낮으면 노동이 자본에 비해 희소한 "영역 1"(노동이 미자동화 과업만 수행), 그 이상이면 노동과 자본이 마진에서 완전대체재가 되어 둘 다 동일 수익률 A를 받는 "영역 2"가 성립한다.
3. **요소가격경계(Factor Price Frontier, FPF) 분석**: 자동화 수준이 오를수록 FPF가 원점에서 멀어지며 시계방향으로 회전한다(Lemma 2). 주어진 자본집약도에서 자동화가 임금에 미치는 효과는 역U자형(처음에는 생산성효과로 임금 상승, 이후 전치효과로 임금 하락)이다(Lemma 3, 4).
4. **자동화와 자본축적의 경쟁(race)**: 동태모형에서 임금경로는 자본고정 시 하한과, 자본이 즉시 최적 수준으로 조정된다고 가정한 상한 사이에 위치한다(Proposition 5). 무한 복잡도(Pareto 분포, 감쇠율 λ) 가정 하에서, 자동화율 λg와 장기 저축률에 의해 결정되는 임계값들에 따라 세 가지 경우로 나뉜다(Proposition 7): (1) λg가 임계값을 넘으면 임금이 A로 수렴하고 노동소득분배율은 0으로, (2) 중간 구간에서는 임금이 영구히 성장하고 노동소득분배율은 1로 수렴, (3) λg가 낮으면 임금성장률이 λg/(1−σ)이고 노동소득분배율이 특정 양의 값으로 수렴.
5. **네 가지 시뮬레이션 시나리오**: business-as-usual(파레토 분포, λg=0.01/년), baseline AGI(20년 내 완전자동화), aggressive AGI(5년 내 완전자동화), 혼합 시나리오(초기 급격한 자동화 후 무한 꼬리)를 제시한다(Section 3.3, Figure 8). baseline AGI 시나리오에서는 완전자동화 도달 전에 임금이 붕괴하고, 이후 영역 2에서 연 18% 성장이 나타난다.
6. **확장 분석**: (a) 고정요소(광물 등)가 존재하면 무한 꼬리에도 불구하고 유한시간 내 영역 2에 진입해 임금이 붕괴함(Proposition 10), (b) R&D 자동화가 충분히 진행되면 유한시간 내 성장 특이점(type II singularity)이 발생할 수 있음(Proposition 11), (c) "향수적 직무"(nostalgic jobs, 의도적 비자동화)를 통해 임금성장을 극대화하는 자동화 속도가 존재함(Proposition 12), (d) 이질적 숙련 노동자 모형에서 자동화가 소수 슈퍼스타 근로자에게는 유리하고 다수에게는 불리한 양극화를 낳을 수 있음, (e) compute를 특정과업 전용 자본(putty-clay)으로 모형화하면 단기적으로 높은 수익률을 보이다가 자본축적 후 일반 자본과 같은 수익률로 수렴함(Proposition 13).

## Methodology and Data

이 논문은 순수 이론 모형 논문으로, 실증 데이터셋을 직접 사용하지 않는다. 핵심 가정은 다음과 같다.

- 생산함수: 과업 i에 대해 자본 또는 노동이 결합되는 CES 집계함수(식 1)와 과업별 선형 생산함수(식 2), 자동화지수 I 이상의 과업은 노동만 가능.
- 자동화지수 경로: I = I₀e^(gt) (지수성장, Moore의 법칙류 규칙성 반영).
- 과업 복잡도 분포 시나리오: (i) 무한 분포 — log i ~ Exp(λ)인 파레토 분포; (ii) 유한 분포 — Φ(i)=1−(1−log i/log I^max)^β (β=1)인 power function 분포, T=20년(baseline) 또는 T=5년(aggressive)에서 완전자동화.
- 수치 시뮬레이션 모수(Table 2): ρ=0.04, η=2, δ=0.1, σ=0.5, A=0.5, L=1, Φ₀=0.608, K₀=4.6 (66% 초기 노동소득분배율과 해당 기술수준의 균제상태 자본에 맞춰 보정).
- 컴퓨팅 자원 성장의 실증적 배경으로 Sevilla et al.(2022)의 frontier AI 시스템 훈련 컴퓨트 추세를 그림으로 인용(Figure 2)하나, 저자들이 직접 추정한 데이터셋은 아니다.

## Key Results

- **무한 분포(business-as-usual) 시뮬레이션**: λg=0.01/년에서 출력은 연 약 2% 성장하며, 자본수익과 임금총액이 거의 같은 속도로 성장(노동소득분배율의 소폭 하락만 발생). 이는 Proposition 7의 case 3(자본축적이 자동화 속도를 능가하는 경우)에 해당한다.
- **baseline AGI 시나리오**: 초기에는 임금이 소폭 상승하나 완전자동화 도달 전에 붕괴하며, 이후 영역 2에서 정상상태 성장률 연 18%를 보인다.
- **aggressive AGI 시나리오**: 약 3년 후 임금 붕괴가 발생하며, 노동희소성이 더 일찍 해소되므로 성장 도약(take-off)도 더 일찍 일어난다.
- **혼합 시나리오**: 초기 급격한 자동화로 임금이 붕괴하나(영역 2 진입), 자본이 충분히 축적되면(약 9년 후) 노동이 다시 희소해져 영역 1로 복귀하고 임금이 다시 출력성장에 맞춰 상승한다.
- **고정요소 도입 시뮬레이션**: 고정요소(매물질, M) 비중 (1−α)=0.10일 때, 임금은 약 10년 후 정점을 찍고 25년 후 경제는 영역 2에 진입해 자본 K*의 균제상태로 서서히 수렴한다 — 무한 꼬리가 있어도 고정요소가 노동의 희소성 지위를 유한시간 내에 소멸시킨다.
- **임금극대화 자동화속도(Proposition 12)**: λg=(1−σ)·(A−ρ−δ)/η일 때 장기 임금성장률이 (A−ρ−δ)/η로 극대화된다. baseline AGI 시나리오를 이 속도로 늦추면(Figure 11) 14년차까지는 두 경로가 거의 일치하나 이후 임금극대화 경로는 지수적으로 계속 성장하는 반면 원래 AGI 시나리오는 붕괴하며, 자동화를 늦추는 출력 손실은 초기에는 작지만 장기적으로는 잠재 출력의 거의 100%에 달할 수 있다.

## Limitations and Future Work

- 저자들은 본 모형이 노동·자본의 조정비용, 내생적 혁신(이미 4.2절에서 일부 다루었으나 R&D 자동화와 출력 자동화를 통합한 완전한 모형은 미제시), 분배효과의 보다 완전한 분석, 거시동학·정책, 지능 폭발(intelligence explosion) 가능성에 대한 후속 연구가 필요하다고 명시한다(Conclusion).
- 컴퓨트 중심 해석이 인지 과업에는 가장 명확하지만, 신체적 과업의 자동화도 모라벡의 역설(Moravec's paradox)을 통해 유사하게 컴퓨팅 복잡도에 제약된다고 가정하며, 이를 명시적으로 다루는 확장은 "Section 4"라고 본문에서 언급되었으나(p.2) 실제로는 인지·신체 과업을 모두 포괄하는 별도 절을 본문에서 확인할 수 없었다 — Tier 3 처리.

## Related Work

- Zeira(1998): 노동자·기계 경제성장 모형 — 자동화·노동 혼합 생산함수의 직접적 선행 연구.
- Acemoglu and Restrepo(2018, 2022): 과업기반 자동화·신규과업 모형([[acemoglu-2018-the-race-between-man-and]], [[acemoglu-2022-tasks-automation-and-the-rise]]) — 본 논문은 이 틀의 "완전자동화에 근접하는 극한 사례"를 분석하는 것이 기여라고 명시(Section 1).
- Aghion, Jones, and Jones(2019): AI와 경제성장([[aghion-2017-artificial-intelligence-and-economic-growth]]) — business-as-usual 시나리오(일정 비율 자동화)의 직접적 토대.
- Eloundou et al.(2023), Felten et al.(2023): LLM의 노출(exposure) 측정 연구([[eloundou-2023-gpts-are-gpts-an-early]], [[felten-2023-how-will-language-modelers-like-chatgpt]]) — AGI 도달 이전 단계의 실증 분석으로 인용.
- Trammell and Korinek(2023): 전환적 AI 하의 경제성장 — Proposition 11(특이점)의 증명이 의존하는 부속정리의 출처.

## Glossary

- **자동화지수(automation index, I)**: 특정 시점에 자동화 가능한 과업의 최대 복잡도를 나타내는 외생 변수.
- **과업 복잡도(task complexity)**: 본 논문의 선호 해석상 기계가 해당 과업을 수행하는 데 필요한 컴퓨팅 자원(FLOP)의 양.
- **요소가격경계(Factor Price Frontier, FPF)**: 주어진 기술 수준 하에서 자본·노동의 상대적 부존비율에 따라 달성 가능한 (R, w) 조합 전체.
- **영역 1 / 영역 2(Region 1 / Region 2)**: 노동이 자본에 비해 희소한 구간(w>R) / 노동·자본이 마진에서 완전대체재가 되어 동일 수익률을 받는 구간(w=R=A).
- **향수적 직무(nostalgic jobs)**: 기술적으로 자동화 가능하지만 사회적 선택에 의해 인간 전용으로 유지되는 직무(예: 성직자, 판사).
