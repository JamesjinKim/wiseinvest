# CLAUDE.md

이 파일은 Claude Code (claude.ai/code)가 이 저장소에서 작업할 때 참고하는 가이드입니다.

## 프로젝트 개요

WiseInvest는 Rails 8 기반 AI 투자 분석 플랫폼입니다. 워런 버핏의 가치투자 기준으로 한국 주식을 분석하고, 사용자의 투자 행동을 추적하여 인지 편향(과잉 확신, 손실 회피, 뇌동매매)을 감지합니다.

## 개발 명령어

```bash
# 개발 서버 시작 (Rails + JS + CSS 워처 동시 실행)
./bin/dev

# 데이터베이스
rails db:create db:migrate db:seed    # 초기 설정
rails db:reset                        # 삭제 후 재생성, 마이그레이션, 시드

# 테스트
rails test                            # 전체 테스트
rails test test/models/user_test.rb   # 단일 파일 테스트
rails test test/models/user_test.rb:10  # 특정 라인 테스트

# 코드 품질
bundle exec rubocop                   # Ruby 린팅 (Rails Omakase 스타일)
bundle exec brakeman                  # 보안 스캐닝
bundle exec bundler-audit             # 의존성 취약점 검사

# 에셋 수동 빌드
npm run build                         # JavaScript
npm run build:css                     # Tailwind CSS
```

## 아키텍처

### 기술 스택
- **백엔드**: Rails 8.1, PostgreSQL, Solid Queue/Cache (Redis 없음)
- **프론트엔드**: Hotwire (Turbo + Stimulus), Tailwind CSS
- **인증**: Rails 8 내장 인증 (bcrypt, Devise 없음)
- **배포**: Kamal 2 + Docker, Thruster HTTP/2 프록시

### 핵심 서비스 (app/services/)

**BuffettAnalyzer** - 7가지 기준으로 주식 점수 산정 (0-100점):
- ROE (≥15%, 20점), 부채비율 (≤50%, 15점), 영업이익률 (≥10%, 15점)
- 이익 증가 연수 (≥5년, 20점), PER (≤15, 10점), PBR (≤1.5, 10점), 경제적 해자 (10점)
- 등급: A (80+), B (60-79), C (40-59), D (<40)

**ProfileCalculator** - 설문 응답과 실제 거래 행동 비교:
- 편향 감지: 과잉 확신 (높은 별점 + 손실), 손실 회피 (매도 기피), 뇌동매매 (급격한 거래)
- InvestmentProfile에 survey_score, actual_score, risk_tolerance, biases 업데이트

**CsvImportService** - CSV 파일에서 투자 기록 일괄 임포트

### 데이터 모델 관계
```
User
├── has_many :sessions (인증)
├── has_many :investment_records → belongs_to :stock
├── has_many :survey_responses
└── has_one :investment_profile (자동 생성)

Stock
├── has_many :stock_metrics (재무 데이터, 시계열)
└── has_many :analysis_reports (BuffettAnalyzer 결과 캐시)
```

### 주요 패턴
- **Current.user**: `app/models/current.rb`를 통한 스레드 안전 사용자 컨텍스트
- **Authentication concern**: `app/controllers/concerns/authentication.rb` - 인증 필요한 컨트롤러에 include
- **서비스 객체**: 비즈니스 로직은 서비스에, 컨트롤러는 얇게 유지
- **JSONB 컬럼**: `investment_profiles.biases`, `analysis_reports.score_breakdown`에 유연한 스키마 사용

### 라우트 구조
```
/                        → dashboard#show (루트)
/stocks                  → 주식 검색
/stocks/:id              → 주식 상세
/stocks/:id/analyze      → BuffettAnalyzer 실행
/investment_records      → CRUD + CSV 임포트
/surveys                 → 10문항 투자 성향 설문
/profile                 → 설문 vs 실제 행동 비교
```

## 주요 파일

- `app/services/buffett_analyzer.rb` - 투자 점수 산정 알고리즘
- `app/services/profile_calculator.rb` - 편향 감지 로직
- `app/controllers/concerns/authentication.rb` - 인증 헬퍼
- `config/routes.rb` - 전체 엔드포인트
- `PRD.md` - 제품 요구사항
- `MVP_ARCHITECTURE.md` - 기술 설계 상세
