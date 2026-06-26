# 스크린샷 캡처 체크리스트

`index.html` 의 빈 placeholder(`<figure class="shot ratio">…<span class="shot-cam">📷 16:9</span>`)에
들어갈 스크린샷 11개의 캡처 현황. 비율은 모두 **16:9 (1280×720)**.

자동 캡처는 Playwright 스크립트로 처리했고(아래 ✅), 로그인·상호작용·로컬 툴이 필요한 항목은
직접 캡처해서 같은 폴더(`screenshots/`)에 **권장 파일명**으로 저장하면 됩니다.

> 캡처 후 활용: index.html에서 해당 placeholder `<figure class="shot ratio"><div class="shot-inner">…</div></figure>` 를
> `<figure class="shot filled"><img src="./screenshots/<파일명>" alt="<설명>" loading="lazy"></figure>` 로 교체.
> (이미 채워진 quali-fit 3장이 같은 패턴이니 참고)

---

## ✅ 자동 캡처 완료 (4장)

| 상태 | 화면 | URL | 저장 파일명 |
|---|---|---|---|
| ✅ | Sentinel 정상 모니터링 대시보드 | https://sentinel.bit-habit.com | `sentinel-dashboard.png` |
| ✅ | Daily Seongsu MLOps 가이드북 | https://daily-seongsu.bit-habit.com | `daily-seongsu-handbook.png` |
| ✅ | Seoul APT 10단계 ML 시뮬레이터 | https://seoul-apt.bit-habit.com | `seoul-apt-simulator.png` |
| ✅ | Viz 선형대수 시각화 | https://viz.bit-habit.com | `viz-linear-algebra.png` |

> 참고: Sentinel은 헤드리스 환경이라 "No microphone found"로 마이크가 없지만,
> 볼륨 미터 + "QUIET(정상)" 상태가 보이는 정상 대시보드 구도는 그대로 잡혔습니다.

---

## ⬜ 수동 캡처 필요 (7장)

각 항목의 "원하는 구도"는 index.html placeholder의 `shot-desc` 원문입니다.

### Sentinel — 경고 발생 순간
- 권장 파일명: `sentinel-alert.png`
- URL: https://sentinel.bit-habit.com
- 구도: 볼륨이 임계치를 넘어 경고/알림이 뜬 상태. 경고 배지나 알림 토스트가 명확히 보이게.
- 방법: 마이크 권한 허용 → Record → 일부러 큰 소리를 내 임계 초과 시점에 캡처. (자동화 불가: 실제 마이크 입력 필요)

### BookToss — 통합 검색 결과
- 권장 파일명: `booktoss-search.png`
- URL: https://booktoss.bit-habit.com
- 구도: 한 번의 검색으로 여러 도서관의 소장/대출 가능 여부가 한 화면에 나열된 결과 리스트.
- 방법: 책 제목(예: "코스모스") 검색 → 결과 리스트 화면 캡처. (Solar API로 재구축 중이라 동작 여부 먼저 확인)

### BookToss — 지도 + 경로
- 권장 파일명: `booktoss-map.png`
- URL: https://booktoss.bit-habit.com
- 구도: 가까운 도서관까지의 실제 경로(폴리라인)와 거리/소요시간 배지가 표시된 지도 화면.
- 방법: 검색 후 결과에서 지도/경로 보기로 이동해 캡처.

### BitHabit — 타임랩스 인증 화면
- 권장 파일명: `habit-timelapse.png`
- URL: https://habit.bit-habit.com
- 구도: 웹캠 프리뷰 + 공부 타이머가 돌아가는 "공부 중" 상태. 캡처가 누적되는 모습이면 더 좋음.
- 방법: **Email OTP 로그인** 후 공부 세션 시작 화면 캡처. (자동화 불가: 로그인 + 웹캠 필요)

### BitHabit — 실시간 채팅 / 주간 보드
- 권장 파일명: `habit-chat.png`
- URL: https://habit.bit-habit.com
- 구도: 생성된 GIF 인증이 공유된 채팅방 + 멤버 목록, 또는 주간 보드·개인 캘린더 화면.
- 방법: 로그인 후 채팅방 또는 주간 보드 화면 캡처.

### Infra — ArgoCD 대시보드
- 권장 파일명: `infra-argocd.png`
- 구도: 14개 서비스가 모두 Synced / Healthy 상태인 애플리케이션 목록 화면.
- 방법: ArgoCD UI 로그인(내부망/인증). 직접 노출돼 있지 않다면
  `kubectl -n argocd port-forward svc/argocd-server 8080:443` 후 https://localhost:8080 접속 → 앱 목록 캡처.

### Infra — 클러스터 맵 / 아키텍처
- 권장 파일명: `infra-cluster.png`
- 구도: Headlamp·k9s의 노드·파드 토폴로지, 또는 전체 인프라 아키텍처 다이어그램.
- 방법: 로컬 툴이라 URL 캡처 불가. `k9s` 실행 화면 또는 Headlamp를 OS 스크린샷으로 캡처,
  혹은 아키텍처 다이어그램 이미지를 직접 만들어 사용.

---

## 기존 PNG 재활용 검토

`screenshots/` 에 이미 있는 아래 파일들은 placeholder에 연결돼 있지 않습니다.
일부는 위 항목과 같은 화면일 수 있으니 새로 찍기 전에 먼저 열어보고 재활용을 검토하세요:
`sentinel.png`, `booktoss.png`, `infra.png`, `bithabit.png`, `seoul-apt.png`, `viz.png`,
`daily-seongsu.png`, `bit-habit-home.png`.
