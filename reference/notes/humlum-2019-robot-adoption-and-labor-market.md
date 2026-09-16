---
title: "Robot Adoption and Labor Market Dynamics"
authors: Anders Humlum
institution: ""
year: 2019
doi: ""
category: [applied_econometrics]
source_tier: 1
pdf_path: papers/local/humlum-2019-robot-adoption-and-labor-market.pdf
pdf_filename: humlum-2019-robot-adoption-and-labor-market.pdf
verified_date: 2026-06-27
datasets_used: []
---

## One-line Summary

덴마크 행정데이터(노동자-기업-로봇 연계)를 이용해 기업의 동태적 로봇도입모형과 노동자의 동태적 직종선택모형을 일반균형으로 결합, 산업로봇이 평균 실질임금을 0.8% 높였지만 제조업 생산직 근로자의 실질임금을 6% 낮추고 기술직 근로자의 임금을 2.3% 높이는 등 뚜렷한 분배효과를 낳았음을 보이고, 로봇세(robot tax)가 이러한 분배효과를 교정하는 데 비효율적인 정책임을 보인다.

## Document Information

- 저자: Anders Humlum (Princeton University)
- 형태: Job Market Paper (Princeton University), 2019년 11월 14일
- 게재지: 없음 (워킹페이퍼/Job Market Paper)
- DOI: 없음
- papers/local/humlum-2019-robot-adoption-and-labor-market.pdf 전체 78페이지(본문+부록 A-G) 읽기로 검증함

## Key Contributions

- 덴마크 관세기록(UHDI, 6단위 HS코드 847950 Industrial Robots)과 통계청 로봇도입 설문(VITA, 2018, 응답률 97%)이라는 두 개의 신규 기업단위 마이크로데이터를 결합해 직접수입 기준 로봇도입 이벤트 454건을 식별(Table 1, p.6; Appendix A.1-A.2).
- 기업의 동태적 로봇도입모형(Section 3): CES 생산함수에 로봇이 직종별로 차별적 생산성 효과(γ_o)와 Hicks-중립적 효과(γ_H)를 미치는 구조를 부여하고(식 1-3), 로봇도입을 Rust(1987)식 최적정지(optimal stopping) 동태이산선택문제로 모형화(식 7-8, 22).
- 매칭 기반 이벤트스터디 식별전략(Section 4.2.1): 로봇도입 직전 3년간 매출·생산직 임금청구액 경로가 유사한 채택-비채택 기업을 매칭(Exact-Mahalanobis, 업종×연도 정확매칭 + 매출·생산직 임금비중 거리매칭, Appendix A.7.1)하여 비관측 생산성에 대한 선택편의를 통제하고, Imbens and Wooldridge(2007)의 potential outcomes 틀에서 unconfoundedness(A1)·overlap(A2) 조건이 모형에서 성립함을 증명(Section 4.2.1, p.14-17).
- 노동공급 블록(Section 5): Lee and Wolpin(2006)식 중첩세대 노동자가 직종(생산/기술/기타)×부문(제조업/서비스업)을 선택하는 동태적 직종선택모형을 구축하고, Traiberman(2019)의 조건부선택확률(CCP) 추정량을 적용해 직종간 전환비용을 식별(식 26-33).
- 두 블록을 임금경로(path of wages)에 대해서만 연결되는 block-separable 구조로 결합한 동태적 일반균형모형을 구축(Definition 1, Section 6.1)하고, Lee(2005)식 고정점 슈팅 알고리즘으로 해(解)를 구함(Appendix F.3).
- 로봇세(robot tax) 정책실험(Section 6.3): 영구세와 10년 한시세(둘 다 30%)를 비교해, 한시세가 단기적으로 로봇확산을 더 효과적으로 늦추지만(2029년까지 도입률 43% vs 영구세 48% vs 기준 56%, p.40) 세수 대비 후생손실이 더 크고 정책 종료 후 도입이 가속됨을 보임.

## Methodology and Data

- 표본: 덴마크 매칭 고용주-근로자 데이터(IDA, FIDA, FirmStat) 1995-2015/2016년, 관세기록(UHDI) 1993-2015년, 로봇도입 설문(VITA) 2018년 (Section 2, Appendix A.1-A.2).
- 로봇도입 식별 절차(Table A.1, p.51): 원자료 14,355건(firm-year)에서 (1) 사전데이터 3년 보유, (2) 도매업 제외, (3) 로봇통합업체(integrator) 제외, (4) VITA 검증비율 50% 이상 업종만 포함, (5) 단일사업장 기업만 포함의 5단계를 거쳐 최종 454건 확정(91.1백만 달러, 293개 기업).
- 생산함수(식 1): Y_jt = z_Hjt{M_jt^((σ-1)/σ) + Σ_o z_ojt^(1/σ) L_ojt^((σ-1)/σ)}^(σ/(σ-1)); σ는 과업대체엘라스티시티로, GMM 추정치 σ=0.493(s.e. 0.092), 비채택기업 표본(Table 3, p.13) — Doraszelski and Jaumandreu(2018)식 합리적기대 GMM, 도구변수는 t-1기 요소선택·가격의 2차항.
- 로봇기술 파라미터 식별(Section 4.2.1-4.2.2): 1차조건 역산으로 기업생산성 z_ojt 복원(식 13-14) 후, 매칭된 채택-비채택 기업 간 차이를 4년 시차로 비교하는 diff-in-diff(식 52, Appendix C.2.1)로 γ_o, γ_H 식별.
- 도입비용 추정(Section 4.4): 특이성 도입비용충격 ε^R_jt ~ Logistic(0,ν); 공통비용 c^R_t = exp(c0^R + c1^R×t)의 로그선형 스케줄을 Method of Simulated Moments(MSM)로 로봇확산곡선(S자형)과 채택기업 규모프리미엄에 맞춰 추정(Appendix C.4.1).
- 노동공급 추정(Section 5.1): 인적자본함수는 Mincer회귀(식 30, Appendix Table D.1), 직종전환비용은 Hotz and Miller(1993)·Arcidiacono and Miller(2011)의 CCP역산을 이용한 비선형최소제곱(NLLS, 식 31-33, Appendix D.2.1)으로 추정; 선호충격분산 ρ는 자체추정치가 기존문헌 추정치를 크게 벗어나 기존문헌(Dix-Carneiro 2014; Ashournia 2017; Artuç et al. 2010; Caliendo et al. 2019; Traiberman 2019)의 중심값 ρ=2를 사용(p.29-31).
- 일반균형 폐쇄(Section 6.1): 덴마크를 소규모개방경제로 가정, 제조업(독점적경쟁)·서비스업(콥-더글라스, 완전경쟁) 2부문, 중간재 M은 세계시장가격으로 수입, 무역수지균형(식 38), 노동시장은 직종×부문별로 청산(식 36-37).

## Key Results

- 로봇도입 이벤트 효과(Figure 1, p.19): 채택기업 매출 +20%, 임금청구총액 +8%, 생산직 임금청구액 -20%(Figure 2a), 기술직 임금청구액 +30%(Figure 2b), 4년 시차 기준.
- 추정된 로봇기술 파라미터(Table 4, p.20): γ_P(생산직)=-0.461, γ_T(기술직)=0.043, γ_O(기타직)=-0.115, γ_H(Hicks중립, 정규화)=0.066.
- 도입비용 추정치(Table C.2, p.63; Section 4.4): c0^R=1.155, c1^R=-0.026, ν=0.384; 채택기업은 2018년 비채택기업보다 평균 2.61배 큼(Section 4.4.2, p.25); 채택조건부 총도입비용은 채택기업 매출의 약 10%, 공통비용성분은 2019년 채택기업 매출의 0.9배(p.23-24).
- 일반균형 실질임금 효과(Figure 6, p.34, 2019년 가중평균 +0.76%): 산업로봇은 평균 실질임금을 0.8% 높였으나, 제조업 생산직 실질임금은 6% 하락, 제조업 기술직은 2.3% 상승, 그 외 직종은 0.3~1.2% 상승.
- 직종간 재배치가 없었다면 생산직 근로자의 실질임금 손실은 5배 더 컸을 것(p.3, 서론)이며, 노동공급을 외생적으로 고정한 반사실 시나리오(Appendix Figure G.2)에서는 제조업 생산직 실질임금이 오늘날 30% 더 낮았을 것으로 추정됨(p.35).
- 산업로봇은 1990년 이후 제조업 생산직 고용비중 하락의 25%, 기술직 고용비중 상승의 8%를 설명(Figure 10, p.39).
- 후생효과(Figure 8, p.38, 평균 +0.85%): 근로자의 90%는 잔여생애소득의 0.5~1% 이득; 제조업 생산직 근로자는 0~6% 손실, 고령 생산직에 집중(Figure 9, p.37 — 옵션가치가 청년층의 손실을 상쇄).
- 로봇세 정책실험(Table 5, p.42, 2019년 GDP 대비 할인현재가치): 한시세(10년, 30%)는 근로자 -1.21%, 세수 +2.39%, 이윤(약탈적투자외부성 제외) -4.14%; 영구세(30%)는 근로자 -1.00%, 세수 +9.41%, 이윤 -10.58%. 로봇세가 사회후생을 높이려면 생산직 근로자의 가치를 평균 근로자의 50~100배로 평가해야 함(p.42).
- 약탈적투자외부성을 포함하면(Table G.2, p.78) 한시세는 이윤효과 -1.65%(약탈외부성 +2.48%), 영구세는 -7.90%(약탈외부성 +2.67%)로, 세수 재분배가 적절히 이루어지면 로봇세가 기업가치를 오히려 높일 수 있음.

## Limitations and Future Work

- 저자가 명시한 한계(Section 7 결론, p.43): 모형은 직종·산업·근속·숙련·연령에 따른 근로자간 이질적 로봇노출은 포착하지만, 로봇을 채택한 기업 내부 기존 근로자(incumbent workers)가 차별적으로 받는 영향은 추상화함; Bessen et al.(2019)과 같은 매칭 근로자-기업-로봇 데이터를 이용해 이를 실증적으로 보완하는 것이 향후 과제로 제시됨.
- 기업특유 임금·해고효과를 블록분리성(block separability)을 깨지 않고 일반균형모형에 도입하는 것이 향후 이론적 과제로 제시되며, 저자는 Appendix E에서 Card et al.(2018)식 무작위효용 사업장선호모형을 노동공급블록에 결합한 한 가지 확장(기업별 임금이 우상향 노동공급곡선에서 결정되는 모형, 식 64-77)을 제시함.
- 저자는 본 논문의 정량적 틀이 자율주행 트럭 등 다른 기술충격에도 적용될 수 있다고 제안하며(Council of Economic Advisers 2016 인용, 미국 트럭운전자 130만 명이 2026년까지 자율주행기술과 경쟁할 것으로 전망됨을 언급), 재훈련 보조금의 효과에 대해서는 별도 논문 Humlum(2019, "Retraining and Occupational Choice")을 참고하라고 명시함.

## Related Work

- Acemoglu and Restrepo(2019b, Journal of Political Economy, "Robots and Jobs")의 미국 통근권(commuting zone) 단위 축소형 추정과 비교하며, 본 논문의 제조업부문 평균 임금효과(-0.4%)가 해당 추정치와 부합함을 확인하되, 본 논문의 전체경제 평균 실질임금 상승(+0.8%) 결과는 소비자물가 효과·산업연관 파급효과를 포함하기 때문에 통근권 단위 축소형 분석에서는 차분되어 사라지는 채널이라고 설명(p.38-39).
- Koch, Manuylov, and Smolka(2019, CESifo Working Paper)의 스페인 제조업 기업 단위 추정(로봇도입 시 매출 20-25% 증가, 단위노동비용 하락)이 본 논문의 Figure 1 축소형 추정과 부합함을 확인(p.20).

## Glossary

- **매칭 기반 이벤트스터디(matching-based event study)**: 로봇도입 직전 요소선택 경로가 유사한 채택-비채택 기업을 매칭한 뒤 도입 이후 격차를 추적해 인과효과를 식별하는 식별전략 (Section 4.2.1, p.14-17).
- **블록분리성(block separability)**: 기업과 근로자의 동태적 의사결정이 임금경로에만 의존해 서로 분리되어 풀릴 수 있는 일반균형모형의 구조적 성질, 차원의 저주를 회피하게 함 (Section 6.1, p.32-33).
- **조건부선택확률(CCP) 추정량**: Hotz and Miller(1993)·Arcidiacono and Miller(2011)식으로 관측된 선택확률에서 비관측 지속가치(continuation value)를 역산해 동태적 이산선택모형의 파라미터를 식별하는 추정법 (Section 5.1.2, p.28-29).
- **약탈적투자외부성(predatory investment externality)**: 로봇채택기업의 이윤증가 일부가 경쟁기업의 시장점유율을 빼앗는 데서 발생하는 금전적 외부성으로, 로봇세가 이를 내부화하면 기업가치를 오히려 높일 수 있음 (Appendix G.2.1, p.77-78).
- **로봇 확산곡선(robot diffusion curve)의 S자형**: Hicks중립적 기준생산성의 정규분포(Gaussian baseline productivity)와 생산성 임계값을 넘으면 도입하는 모형구조가 결합해 자연스럽게 생성되는 기술확산의 S자형 패턴 (Griliches 1957 인용, Figure 3, p.24).
