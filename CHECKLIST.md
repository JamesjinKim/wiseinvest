# WiseInvest MVP 개발 체크리스트

> Rails 8 기반 AI 주식 투자 분석 플랫폼 개발 진행 체크리스트

---

## Phase 1: 프로젝트 초기 설정

### 1.1. Rails 8 프로젝트 생성
- [x] Ruby 3.3+ 설치 확인
- [x] Rails 8 설치 (`gem install rails`)
- [x] 프로젝트 생성
  ```bash
  rails new wiseinvest -d postgresql -c tailwind -j esbuild
  ```
- [x] PostgreSQL 데이터베이스 생성 및 연결 확인
- [x] `rails db:create` 실행
- [x] 개발 서버 구동 테스트 (`rails s`)

### 1.2. Git 저장소 설정
- [x] `.gitignore` 설정 (credentials, .env 등)
- [x] 초기 커밋
- [ ] GitHub 저장소 연결 (https://github.com/JamesjinKim/wiseinvest.git)

### 1.3. 기본 설정
- [x] `config/database.yml` 환경별 설정
- [x] 타임존 설정 (`config/application.rb` - Asia/Seoul)
- [x] 한글 로케일 설정 (`config/locales/ko.yml`)
- [x] Tailwind CSS 설정 확인

---

## Phase 2: 인증 시스템

### 2.1. Rails 8 Built-in Authentication
- [x] 인증 생성기 실행
  ```bash
  rails generate authentication
  ```
- [x] User 마이그레이션 수정 (name 필드 추가)
- [x] `rails db:migrate` 실행
- [x] Session 컨트롤러 확인

### 2.2. 인증 화면 구현
- [x] 로그인 페이지 (`webui/login.html` 참조)
  - [x] `app/views/sessions/new.html.erb`
- [x] 회원가입 페이지 (`webui/register.html` 참조)
  - [x] `app/views/registrations/new.html.erb`
- [x] 로그아웃 기능 테스트
- [x] 로그인 상태 유지 (Remember me)

### 2.3. 레이아웃 설정
- [x] `app/views/layouts/application.html.erb` (메인 레이아웃)
- [x] 사이드바 partial (`app/views/shared/_sidebar.html.erb`)
- [x] 모바일 헤더 partial (`app/views/shared/_mobile_header.html.erb`)
- [x] 모바일 네비게이션 partial (`app/views/shared/_mobile_nav.html.erb`)
- [x] 인증용 레이아웃 (로그인/회원가입용)

---

## Phase 3: 데이터베이스 모델

### 3.1. Stock 모델
- [x] 마이그레이션 생성
  ```bash
  rails g model Stock symbol:string name:string sector:string
  ```
- [x] 인덱스 추가 (symbol - unique)
- [x] 모델 유효성 검사 추가
- [x] `rails db:migrate`

### 3.2. StockMetric 모델
- [x] 마이그레이션 생성
  ```bash
  rails g model StockMetric stock:references roe:decimal debt_ratio:decimal \
    operating_margin:decimal per:decimal pbr:decimal profit_growth_years:integer data_date:date
  ```
- [x] 모델 관계 설정 (`belongs_to :stock`)
- [x] Stock 모델에 `has_many :stock_metrics` 추가
- [x] `latest_metric` 메서드 추가
- [x] `rails db:migrate`

### 3.3. InvestmentRecord 모델
- [x] 마이그레이션 생성
  ```bash
  rails g model InvestmentRecord user:references stock:references \
    action:string quantity:integer price:decimal traded_at:datetime \
    reason_tags:string pre_rating:integer
  ```
- [x] `reason_tags`를 array로 설정 (PostgreSQL)
- [x] 모델 관계 설정
- [x] 유효성 검사 (action: buy/sell)
- [x] `rails db:migrate`

### 3.4. InvestmentProfile 모델
- [x] 마이그레이션 생성
  ```bash
  rails g model InvestmentProfile user:references survey_score:integer \
    actual_score:integer risk_tolerance:string biases:jsonb
  ```
- [x] 모델 관계 설정 (`belongs_to :user`, `has_one` from User)
- [x] `rails db:migrate`

### 3.5. SurveyResponse 모델
- [x] 마이그레이션 생성
  ```bash
  rails g model SurveyResponse user:references question_key:string answer_value:integer
  ```
- [x] 모델 관계 설정
- [x] 유효성 검사
- [x] `rails db:migrate`

### 3.6. AnalysisReport 모델
- [x] 마이그레이션 생성
  ```bash
  rails g model AnalysisReport stock:references total_score:integer \
    score_breakdown:jsonb expires_at:datetime
  ```
- [x] 모델 관계 설정
- [x] `rails db:migrate`

### 3.7. 시드 데이터
- [x] `db/seeds.rb` 작성
  - [x] 샘플 종목 데이터 (삼성전자, SK하이닉스, NAVER 등)
  - [x] 샘플 재무지표 데이터
- [x] `rails db:seed` 실행

---

## Phase 4: 핵심 서비스 구현

### 4.1. BuffettAnalyzer 서비스
- [x] `app/services/buffett_analyzer.rb` 생성
- [x] 7가지 지표 점수 계산 로직
  - [x] ROE 점수 (20점)
  - [x] 부채비율 점수 (15점)
  - [x] 영업이익률 점수 (15점)
  - [x] 이익 증가 지속성 점수 (20점)
  - [x] PER 점수 (10점)
  - [x] PBR 점수 (10점)
  - [x] 경제적 해자 점수 (10점) - MVP 기본값
- [x] 등급 산정 로직 (A/B/C/D)
- [ ] 단위 테스트 작성

### 4.2. ProfileCalculator 서비스
- [x] `app/services/profile_calculator.rb` 생성
- [x] 설문 점수 계산 로직
- [x] 실제 행동 점수 계산 로직
- [x] 편향 감지 로직
  - [x] 과잉 확신 (Overconfidence)
  - [x] 손실 회피 (Loss Aversion)
  - [x] 뇌동 매매 (Herding)
- [ ] 단위 테스트 작성

### 4.3. CsvImportService 서비스
- [x] `app/services/csv_import_service.rb` 생성
- [x] CSV 파싱 로직
- [x] 에러 핸들링 (잘못된 형식, 없는 종목 등)
- [x] 결과 리포트 반환 (성공/실패 건수)
- [ ] 단위 테스트 작성

---

## Phase 5: 컨트롤러 및 라우팅

### 5.1. 라우팅 설정
- [x] `config/routes.rb` 작성
  ```ruby
  root 'dashboard#show'
  get 'dashboard', to: 'dashboard#show'
  resources :stocks, only: [:index, :show] do
    member { get :analyze }
  end
  resources :investment_records do
    collection { post :import }
  end
  resource :profile, only: [:show]
  resources :surveys, only: [:index, :create]
  ```

### 5.2. DashboardController
- [x] `app/controllers/dashboard_controller.rb` 생성
- [x] `show` 액션 구현
  - [x] 투자 요약 데이터
  - [x] 최근 분석 종목
  - [x] 최근 투자 기록

### 5.3. StocksController
- [x] `app/controllers/stocks_controller.rb` 생성
- [x] `index` 액션 (검색 기능 포함)
- [x] `show` 액션 (종목 상세)
- [x] `analyze` 액션 (버핏 분석 실행)

### 5.4. InvestmentRecordsController
- [x] `app/controllers/investment_records_controller.rb` 생성
- [x] CRUD 액션 구현
- [x] `import` 액션 (CSV 업로드)

### 5.5. ProfilesController
- [x] `app/controllers/profiles_controller.rb` 생성
- [x] `show` 액션 (성향 리포트)
- [ ] `edit/update` 액션 (프로필 수정)

### 5.6. SurveysController
- [x] `app/controllers/surveys_controller.rb` 생성
- [x] `index` 액션 (설문 페이지)
- [x] `create` 액션 (설문 제출)

---

## Phase 6: 뷰 템플릿 구현

### 6.1. 대시보드 (`webui/dashboard.html` 참조)
- [x] `app/views/dashboard/show.html.erb`
- [x] 4개 요약 카드 (투자금, 수익률, 승률, 성향)
- [x] 최근 분석 종목 리스트
- [x] 최근 투자 기록 테이블
- [x] 빠른 실행 버튼
- [x] 오늘의 조언

### 6.2. 종목 분석 (`webui/stocks.html` 참조)
- [x] `app/views/stocks/index.html.erb` (검색)
- [x] `app/views/stocks/show.html.erb` (상세)
- [x] 종목 검색 폼 (Stimulus 컨트롤러)
- [x] 6가지 지표 스코어바
- [x] 종합 점수 및 등급 표시
- [x] 별점 평가 시스템
- [x] 투자 근거 태그 선택

### 6.3. 투자 기록 (`webui/records.html` 참조)
- [x] `app/views/investment_records/index.html.erb`
- [x] `app/views/investment_records/new.html.erb`
- [x] `app/views/investment_records/edit.html.erb`
- [x] 투자 기록 테이블
- [x] 수동 입력 폼
- [x] CSV 업로드 모달
- [ ] 필터링 기능

### 6.4. 성향 리포트 (`webui/profile.html` 참조)
- [x] `app/views/profiles/show.html.erb`
- [x] 설문 점수 vs 실제 점수 비교
- [ ] 레이더 차트 (Chart.js)
- [x] 편향 감지 카드
- [x] AI 맞춤형 조언 섹션

### 6.5. 투자 설문 (`webui/survey.html` 참조)
- [x] `app/views/surveys/index.html.erb`
- [x] 10단계 설문 UI
- [ ] 진행률 표시바
- [ ] 결과 모달 (Turbo Frame)

---

## Phase 7: Hotwire 통합

### 7.1. Turbo 설정
- [x] Turbo Drive 활성화 확인
- [ ] Turbo Frames 적용
  - [ ] 종목 검색 결과
  - [ ] 투자 기록 리스트
  - [ ] 설문 단계별 전환
- [ ] Turbo Streams 적용
  - [ ] 투자 기록 추가/삭제
  - [ ] 별점 변경 실시간 반영

### 7.2. Stimulus 컨트롤러
- [x] `app/javascript/controllers/` 디렉토리 확인
- [ ] `search_controller.js` (종목 검색)
- [ ] `rating_controller.js` (별점 평가)
- [ ] `csv_upload_controller.js` (CSV 드래그앤드롭)
- [ ] `survey_controller.js` (설문 진행)
- [ ] `sidebar_controller.js` (모바일 사이드바 토글)

---

## Phase 8: 외부 API 연동 (선택)

### 8.1. KIS Developers API
- [ ] API 키 발급 (한국투자증권 가입)
- [ ] `app/clients/kis_client.rb` 생성
- [ ] 종목 검색 API 연동
- [ ] 현재가 조회 API 연동
- [ ] 재무정보 API 연동
- [ ] API 응답 캐싱 (Solid Cache)

### 8.2. 캐싱 전략
- [ ] `config/environments/production.rb` 캐시 설정
- [ ] 종목 데이터 캐싱 (24시간)
- [ ] 재무지표 캐싱 (24시간)

---

## Phase 9: 스타일링 완성

### 9.1. Tailwind CSS 설정
- [x] `tailwind.config.js` 커스터마이징
- [x] 커스텀 색상 정의
  ```javascript
  colors: {
    primary: '#2563eb',
    success: '#10b981',
    danger: '#ef4444',
    warning: '#f59e0b',
    navy: '#0f172a'
  }
  ```
- [x] `app/assets/stylesheets/application.tailwind.css`

### 9.2. 커스텀 CSS
- [x] `webui/css/style.css` 내용 통합
- [x] 등급 배지 스타일 (grade-a, grade-b, etc.)
- [x] 별점 스타일
- [x] 스코어바 스타일
- [x] 애니메이션 (fade-in, slide-up)

### 9.3. 반응형 디자인
- [x] 데스크탑 레이아웃 확인 (>1024px)
- [ ] 태블릿 레이아웃 확인 (768-1024px)
- [x] 모바일 레이아웃 확인 (<768px)
- [x] 사이드바/하단 네비게이션 전환

---

## Phase 10: 테스트

### 10.1. 모델 테스트
- [ ] User 모델 테스트
- [ ] Stock 모델 테스트
- [ ] InvestmentRecord 모델 테스트
- [ ] 관계 테스트

### 10.2. 서비스 테스트
- [ ] BuffettAnalyzer 테스트
- [ ] ProfileCalculator 테스트
- [ ] CsvImportService 테스트

### 10.3. 컨트롤러 테스트
- [ ] 인증 플로우 테스트
- [ ] CRUD 동작 테스트
- [ ] 권한 테스트 (로그인 필요 페이지)

### 10.4. 시스템 테스트
- [ ] 회원가입 → 설문 → 대시보드 플로우
- [ ] 종목 검색 → 분석 → 별점 기록 플로우
- [ ] CSV 업로드 플로우

---

## Phase 11: 배포 준비

### 11.1. 프로덕션 설정
- [ ] `config/environments/production.rb` 검토
- [ ] 시크릿 키 설정 (`rails credentials:edit`)
- [ ] 데이터베이스 URL 설정
- [ ] 에셋 프리컴파일 확인

### 11.2. Kamal 2 배포 설정 (선택)
- [ ] `config/deploy.yml` 작성
- [ ] Docker 이미지 빌드 테스트
- [ ] 서버 환경 준비

### 11.3. 법적 준비
- [ ] 이용약관 페이지
- [ ] 개인정보처리방침 페이지
- [ ] 투자 면책조항 표시

---

## 진행 상황 요약

| Phase | 상태 | 완료 항목 |
|-------|:----:|----------|
| 1. 프로젝트 초기 설정 | ✅ | 10/11 |
| 2. 인증 시스템 | ✅ | 12/12 |
| 3. 데이터베이스 모델 | ✅ | 14/14 |
| 4. 핵심 서비스 | 🟡 | 12/15 |
| 5. 컨트롤러/라우팅 | 🟡 | 9/10 |
| 6. 뷰 템플릿 | 🟡 | 14/17 |
| 7. Hotwire 통합 | 🟡 | 2/8 |
| 8. 외부 API (선택) | ⬜ | 0/6 |
| 9. 스타일링 | ✅ | 8/9 |
| 10. 테스트 | ⬜ | 0/10 |
| 11. 배포 준비 | ⬜ | 0/6 |

---

## 권장 개발 순서

```
1. Phase 1 → 2 → 3 (기초 설정 및 모델) ✅ 완료
   ↓
2. Phase 4 (핵심 비즈니스 로직) ✅ 완료
   ↓
3. Phase 5 → 6 (컨트롤러 + 뷰) 🟡 진행중
   ↓
4. Phase 7 → 9 (Hotwire + 스타일링)
   ↓
5. Phase 10 (테스트)
   ↓
6. Phase 8 → 11 (API 연동 + 배포)
```

---

## 참조 파일

- **PRD:** [PRD.md](PRD.md)
- **MVP 아키텍처:** [MVP_ARCHITECTURE.md](MVP_ARCHITECTURE.md)
- **UI 템플릿:** [webui/](webui/)
  - `login.html` - 로그인
  - `register.html` - 회원가입
  - `dashboard.html` - 대시보드
  - `stocks.html` - 종목 분석
  - `records.html` - 투자 기록
  - `profile.html` - 성향 리포트
  - `survey.html` - 투자 설문

---

**마지막 업데이트:** 2026-01-16
