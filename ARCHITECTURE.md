# 중요사항!! 
# 아래 WiseInvest 시스템 아키텍처는 MVP 개발 이후 참고할 시스템 업그레이드 자료이므로 지금은 사용하지 않음.
# 읽지 말고 패스할 것! 

# WiseInvest 시스템 아키텍처

## 1. 아키텍처 개요

### 1.1. 시스템 구성도

```
┌─────────────────────────────────────────────────────────────────────────┐
│                              클라이언트                                    │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐                      │
│  │   웹 브라우저  │  │  모바일 웹    │  │  PWA (향후)  │                      │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘                      │
└─────────┼────────────────┼────────────────┼─────────────────────────────┘
          │                │                │
          ▼                ▼                ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                         Thruster (HTTP/2 Proxy)                         │
│                      SSL 종료, 정적 파일 캐싱, 압축                           │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                          Rails 8 Application                            │
│  ┌───────────────────────────────────────────────────────────────────┐  │
│  │                        Hotwire (Frontend)                         │  │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────────┐    │  │
│  │  │    Turbo    │  │   Stimulus  │  │     Tailwind CSS        │    │  │
│  │  │  (Drive,    │  │ Controllers │  │                         │    │  │
│  │  │   Frames,   │  │             │  │                         │    │  │
│  │  │   Streams)  │  │             │  │                         │    │  │
│  │  └─────────────┘  └─────────────┘  └─────────────────────────┘    │  │
│  └───────────────────────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────────────────────┐  │
│  │                         Controllers                               │  │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐              │  │
│  │  │   Auth   │ │  Stocks  │ │ Analysis │ │ Profile  │              │  │
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────┘              │  │
│  └───────────────────────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────────────────────┐  │
│  │                      Business Logic Layer                         │  │
│  │  ┌────────────────┐  ┌────────────────┐  ┌────────────────┐       │  │
│  │  │    Services    │  │   Analyzers    │  │    Clients     │       │  │
│  │  │                │  │                │  │                │       │  │
│  │  │ - StockService │  │ - BuffettScore │  │ - KisClient    │       │  │
│  │  │ - SurveyService│  │ - LynchScore   │  │ - DartClient   │       │  │
│  │  │ - ProfileService│ │ - DalioScore   │  │ - OpenAIClient │       │  │
│  │  └────────────────┘  └────────────────┘  └────────────────┘       │  │
│  └───────────────────────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────────────────────┐  │
│  │                         Background Jobs                           │  │
│  │  ┌─────────────────────────────────────────────────────────────┐  │  │
│  │  │                      Solid Queue                            │  │  │
│  │  │  - StockDataSyncJob    - AnalysisJob    - ReportGenerateJob │  │  │
│  │  └─────────────────────────────────────────────────────────────┘  │  │
│  └───────────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────────┘
          │                              │                        │
          ▼                              ▼                        ▼
┌──────────────────┐  ┌──────────────────────────┐  ┌──────────────────┐
│    PostgreSQL    │  │      Solid Cache         │  │   외부 API        │
│                  │  │   (Rails 8 기본 캐시)      │  │                  │
│  - Users         │  │                          │  │  - KIS Developers│
│  - Stocks        │  │  - 주가 데이터 캐시          │  │  - OpenDart      │
│  - Records       │  │  - 분석 결과 캐시           │  │  - OpenAI        │
│  - Profiles      │  │  - API 응답 캐시           │  │                  │
└──────────────────┘  └──────────────────────────┘  └──────────────────┘
```

### 1.2. 핵심 설계 원칙

| 원칙                | 설명                               |
|--------------------|-----------------------------------|
| **Monolith First** | 마이크로서비스 없이 단일 Rails 앱으로 시작 |
| **Convention over Configuration** | Rails 규약 최대한 활용 |
| **Minimal Dependencies** | 외부 종속성 최소화 (Redis 제거) |
| **Progressive Enhancement** | Hotwire 기반 점진적 향상 |
| **Domain-Driven Design** | 도메인별 서비스 계층 분리 |

---

## 2. 디렉토리 구조

```
wiseinvest/
├── app/
│   ├── controllers/
│   │   ├── concerns/
│   │   ├── sessions_controller.rb
│   │   ├── registrations_controller.rb
│   │   ├── dashboard_controller.rb
│   │   ├── stocks_controller.rb
│   │   ├── analyses_controller.rb
│   │   ├── investment_records_controller.rb
│   │   ├── surveys_controller.rb
│   │   └── profiles_controller.rb
│   │
│   ├── models/
│   │   ├── concerns/
│   │   │   ├── scorable.rb              # 점수 계산 공통 로직
│   │   │   └── cacheable.rb             # 캐싱 공통 로직
│   │   ├── user.rb
│   │   ├── session.rb                   # Rails 8 인증
│   │   ├── stock.rb
│   │   ├── stock_financial.rb           # 재무제표 데이터
│   │   ├── stock_price.rb               # 시세 데이터
│   │   ├── investment_record.rb
│   │   ├── investment_profile.rb
│   │   ├── survey_response.rb
│   │   ├── analysis_report.rb
│   │   └── user_rating.rb               # 사용자 별점
│   │
│   ├── services/                        # 비즈니스 로직 계층
│   │   ├── stocks/
│   │   │   ├── search_service.rb
│   │   │   ├── sync_service.rb
│   │   │   └── financial_service.rb
│   │   ├── analysis/
│   │   │   ├── orchestrator_service.rb  # 분석 총괄
│   │   │   ├── buffett_analyzer.rb
│   │   │   ├── lynch_analyzer.rb        # Phase 2+
│   │   │   └── dalio_analyzer.rb        # Phase 2+
│   │   ├── profile/
│   │   │   ├── survey_processor.rb
│   │   │   ├── behavior_analyzer.rb
│   │   │   └── correction_engine.rb
│   │   └── reports/
│   │       ├── generator_service.rb
│   │       └── ai_summarizer.rb
│   │
│   ├── clients/                         # 외부 API 클라이언트
│   │   ├── base_client.rb
│   │   ├── kis_client.rb                # 한국투자증권 API
│   │   ├── dart_client.rb               # OpenDart API
│   │   └── openai_client.rb             # OpenAI API
│   │
│   ├── jobs/                            # Solid Queue 작업
│   │   ├── application_job.rb
│   │   ├── stock_data_sync_job.rb
│   │   ├── analysis_job.rb
│   │   ├── report_generate_job.rb
│   │   └── daily_summary_job.rb
│   │
│   ├── views/
│   │   ├── layouts/
│   │   │   ├── application.html.erb
│   │   │   └── _navbar.html.erb
│   │   ├── dashboard/
│   │   ├── stocks/
│   │   ├── analyses/
│   │   ├── investment_records/
│   │   ├── surveys/
│   │   └── profiles/
│   │
│   ├── components/                      # ViewComponent (선택)
│   │   ├── score_card_component.rb
│   │   ├── rating_star_component.rb
│   │   └── chart_component.rb
│   │
│   └── javascript/
│       ├── controllers/                 # Stimulus Controllers
│       │   ├── application.js
│       │   ├── rating_controller.js
│       │   ├── chart_controller.js
│       │   ├── search_controller.js
│       │   └── csv_upload_controller.js
│       └── application.js
│
├── config/
│   ├── routes.rb
│   ├── database.yml
│   ├── cache.yml                        # Solid Cache 설정
│   ├── queue.yml                        # Solid Queue 설정
│   └── initializers/
│       ├── solid_cache.rb
│       ├── solid_queue.rb
│       └── clients.rb                   # API 클라이언트 초기화
│
├── db/
│   ├── migrate/
│   └── seeds.rb
│
├── lib/
│   └── tasks/
│       ├── stocks.rake                  # 주식 데이터 관련 태스크
│       └── analysis.rake                # 분석 관련 태스크
│
└── test/
    ├── models/
    ├── controllers/
    ├── services/
    └── clients/
```

---

## 3. 데이터베이스 스키마

### 3.1. ERD (Entity Relationship Diagram)

```
┌─────────────────┐       ┌─────────────────┐       ┌─────────────────┐
│      users      │       │    sessions     │       │ survey_responses│
├─────────────────┤       ├─────────────────┤       ├─────────────────┤
│ id              │──┐    │ id              │       │ id              │
│ email           │  │    │ user_id     ────┼───────│ user_id     ────┼──┐
│ password_digest │  │    │ ip_address      │       │ question_key    │  │
│ name            │  │    │ user_agent      │       │ answer_value    │  │
│ created_at      │  │    │ created_at      │       │ created_at      │  │
│ updated_at      │  │    └─────────────────┘       └─────────────────┘  │
└─────────────────┘  │                                                   │
         │           │    ┌─────────────────┐       ┌─────────────────┐  │
         │           │    │investment_profiles      │ investment_records │
         │           │    ├─────────────────┤       ├─────────────────┤  │
         │           └────│ user_id     ────┼───────│ user_id     ────┼──┤
         │                │ survey_score    │       │ stock_id    ────┼──┼──┐
         │                │ actual_score    │       │ action(buy/sell)│  │  │
         │                │ corrected_score │       │ quantity        │  │  │
         │                │ risk_tolerance  │       │ price           │  │  │
         │                │ investment_style│       │ invested_at     │  │  │
         │                │ biases (jsonb)  │       │ reason_tags     │  │  │
         │                │ updated_at      │       │ pre_rating      │  │  │
         │                └─────────────────┘       │ created_at      │  │  │
         │                                          └─────────────────┘  │  │
         │                                                               │  │
         │    ┌─────────────────┐       ┌─────────────────┐              │  │
         │    │   user_ratings  │       │ analysis_reports│              │  │
         │    ├─────────────────┤       ├─────────────────┤              │  │
         └────│ user_id         │       │ id              │              │  │
              │ stock_id    ────┼───┐   │ user_id     ────┼──────────────┘  │
              │ rating (1-5)    │   │   │ stock_id    ────┼─────────────────┤
              │ reason_tags     │   │   │ analyzer_type   │                 │
              │ created_at      │   │   │ score           │                 │
              └─────────────────┘   │   │ details (jsonb) │                 │
                                    │   │ ai_summary      │                 │
                                    │   │ created_at      │                 │
                                    │   └─────────────────┘                 │
                                    │                                       │
                                    │   ┌─────────────────┐                 │
                                    │   │     stocks      │                 │
                                    │   ├─────────────────┤                 │
                                    └───│ id              │◄────────────────┘
                                        │ symbol          │
                                        │ name            │
                                        │ market (KRX/US) │
                                        │ sector          │
                                        │ created_at      │
                                        └────────┬────────┘
                                                 │
                        ┌────────────────────────┼────────────────────────┐
                        │                        │                        │
                        ▼                        ▼                        ▼
              ┌─────────────────┐      ┌─────────────────┐      ┌─────────────────┐
              │ stock_financials│      │  stock_prices   │      │  stock_metrics  │
              ├─────────────────┤      ├─────────────────┤      ├─────────────────┤
              │ stock_id        │      │ stock_id        │      │ stock_id        │
              │ fiscal_year     │      │ date            │      │ per             │
              │ revenue         │      │ open            │      │ pbr             │
              │ operating_income│      │ high            │      │ roe             │
              │ net_income      │      │ low             │      │ debt_ratio      │
              │ total_assets    │      │ close           │      │ operating_margin│
              │ total_equity    │      │ volume          │      │ calculated_at   │
              │ total_debt      │      │ created_at      │      │ created_at      │
              │ created_at      │      └─────────────────┘      └─────────────────┘
              └─────────────────┘
```

### 3.2. 주요 테이블 설계

```ruby
# db/migrate/XXXXXX_create_users.rb
create_table :users do |t|
  t.string :email, null: false
  t.string :password_digest, null: false
  t.string :name
  t.timestamps

  t.index :email, unique: true
end

# db/migrate/XXXXXX_create_stocks.rb
create_table :stocks do |t|
  t.string :symbol, null: false
  t.string :name, null: false
  t.string :market, null: false  # 'KRX', 'NYSE', 'NASDAQ'
  t.string :sector
  t.string :industry
  t.boolean :active, default: true
  t.timestamps

  t.index [:symbol, :market], unique: true
  t.index :name
end

# db/migrate/XXXXXX_create_investment_profiles.rb
create_table :investment_profiles do |t|
  t.references :user, null: false, foreign_key: true
  t.integer :survey_score        # 설문 기반 점수 (1-100)
  t.integer :actual_score        # 실제 행동 기반 점수
  t.integer :corrected_score     # 보정된 최종 점수
  t.string :risk_tolerance       # conservative, moderate, aggressive
  t.string :investment_style     # value, growth, mixed
  t.jsonb :biases, default: {}   # 발견된 편향들
  t.jsonb :recommendations, default: []
  t.timestamps

  t.index :user_id, unique: true
end

# db/migrate/XXXXXX_create_investment_records.rb
create_table :investment_records do |t|
  t.references :user, null: false, foreign_key: true
  t.references :stock, null: false, foreign_key: true
  t.string :action, null: false  # 'buy', 'sell'
  t.integer :quantity, null: false
  t.decimal :price, precision: 15, scale: 2, null: false
  t.datetime :traded_at, null: false
  t.string :reason_tags, array: true, default: []
  t.integer :pre_rating          # 매수 전 사용자 별점 (1-5)
  t.text :memo
  t.decimal :realized_profit, precision: 15, scale: 2  # 매도 시 실현 손익
  t.timestamps

  t.index [:user_id, :traded_at]
  t.index :stock_id
end

# db/migrate/XXXXXX_create_analysis_reports.rb
create_table :analysis_reports do |t|
  t.references :stock, null: false, foreign_key: true
  t.references :user, foreign_key: true  # null이면 공용 분석
  t.string :analyzer_type, null: false   # 'buffett', 'lynch', 'dalio'
  t.integer :total_score, null: false
  t.jsonb :score_breakdown, default: {}  # 각 지표별 점수
  t.jsonb :details, default: {}          # 상세 분석 데이터
  t.text :ai_summary                     # AI 생성 요약
  t.datetime :expires_at                 # 캐시 만료 시간
  t.timestamps

  t.index [:stock_id, :analyzer_type]
  t.index :expires_at
end
```

---

## 4. 핵심 컴포넌트 설계

### 4.1. 서비스 계층 (Service Layer)

```ruby
# app/services/analysis/buffett_analyzer.rb
module Analysis
  class BuffettAnalyzer
    CRITERIA = {
      roe: { weight: 20, threshold: 15 },
      debt_ratio: { weight: 15, threshold: 50, inverse: true },
      operating_margin: { weight: 15, threshold: 10 },
      profit_growth_5y: { weight: 20, threshold: 0 },
      per: { weight: 10, compare: :sector_average },
      pbr: { weight: 10, threshold: 1.5, inverse: true },
      moat: { weight: 10, qualitative: true }
    }.freeze

    def initialize(stock)
      @stock = stock
      @metrics = stock.latest_metrics
      @financials = stock.financials.recent(5)
    end

    def analyze
      scores = calculate_scores

      {
        total_score: scores.values.sum,
        breakdown: scores,
        grade: determine_grade(scores.values.sum),
        details: build_details(scores),
        analyzed_at: Time.current
      }
    end

    private

    def calculate_scores
      CRITERIA.each_with_object({}) do |(criterion, config), scores|
        scores[criterion] = calculate_criterion(criterion, config)
      end
    end

    def determine_grade(score)
      case score
      when 80..100 then 'A'  # 매우 매력적
      when 60..79  then 'B'  # 관심 종목
      when 40..59  then 'C'  # 신중 검토
      else              'D'  # 투자 비권장
      end
    end
  end
end
```

```ruby
# app/services/profile/correction_engine.rb
module Profile
  class CorrectionEngine
    BIAS_DETECTORS = [
      :overconfidence,      # 과잉 확신
      :loss_aversion,       # 손실 회피
      :herding,             # 군중 심리
      :recency_bias,        # 최근 편향
      :confirmation_bias    # 확인 편향
    ].freeze

    def initialize(user)
      @user = user
      @profile = user.investment_profile
      @records = user.investment_records.includes(:stock)
      @ratings = user.user_ratings
    end

    def analyze_and_correct
      survey_profile = analyze_survey
      actual_profile = analyze_actual_behavior
      biases = detect_biases(survey_profile, actual_profile)

      corrected = calculate_corrected_profile(
        survey_profile,
        actual_profile,
        biases
      )

      @profile.update!(
        survey_score: survey_profile[:score],
        actual_score: actual_profile[:score],
        corrected_score: corrected[:score],
        risk_tolerance: corrected[:risk_tolerance],
        investment_style: corrected[:style],
        biases: biases,
        recommendations: generate_recommendations(biases)
      )

      corrected
    end

    private

    def detect_biases(survey, actual)
      BIAS_DETECTORS.each_with_object({}) do |bias, result|
        detector = "detect_#{bias}".to_sym
        if respond_to?(detector, true)
          detected = send(detector, survey, actual)
          result[bias] = detected if detected[:detected]
        end
      end
    end

    def detect_overconfidence(survey, actual)
      # 사용자 별점과 실제 수익률 비교
      high_ratings_with_losses = @ratings.joins(stock: :investment_records)
        .where(rating: 4..5)
        .where('investment_records.realized_profit < 0')
        .count

      {
        detected: high_ratings_with_losses > 3,
        severity: calculate_severity(high_ratings_with_losses),
        message: "높은 확신을 가졌던 #{high_ratings_with_losses}개 종목에서 손실 발생"
      }
    end
  end
end
```

### 4.2. API 클라이언트

```ruby
# app/clients/base_client.rb
class BaseClient
  include HTTParty

  class ApiError < StandardError; end
  class RateLimitError < ApiError; end

  def initialize
    @cache = Rails.cache
  end

  private

  def with_cache(key, expires_in: 1.hour)
    @cache.fetch(key, expires_in: expires_in) do
      yield
    end
  end

  def handle_response(response)
    case response.code
    when 200..299
      response.parsed_response
    when 429
      raise RateLimitError, "API 요청 한도 초과"
    else
      raise ApiError, "API 오류: #{response.code}"
    end
  end
end

# app/clients/kis_client.rb
class KisClient < BaseClient
  base_uri 'https://openapi.koreainvestment.com:9443'

  def initialize
    super
    @app_key = Rails.application.credentials.kis[:app_key]
    @app_secret = Rails.application.credentials.kis[:app_secret]
    @token = fetch_or_refresh_token
  end

  def stock_price(symbol)
    with_cache("kis:price:#{symbol}", expires_in: 5.minutes) do
      response = self.class.get('/uapi/domestic-stock/v1/quotations/inquire-price', {
        headers: auth_headers.merge('tr_id' => 'FHKST01010100'),
        query: {
          FID_COND_MRKT_DIV_CODE: 'J',
          FID_INPUT_ISCD: symbol
        }
      })
      handle_response(response)
    end
  end

  def financial_statements(symbol, years: 5)
    with_cache("kis:financials:#{symbol}", expires_in: 1.day) do
      # 재무제표 API 호출
    end
  end

  private

  def auth_headers
    {
      'content-type' => 'application/json',
      'authorization' => "Bearer #{@token}",
      'appkey' => @app_key,
      'appsecret' => @app_secret
    }
  end
end
```

### 4.3. 백그라운드 작업

```ruby
# app/jobs/stock_data_sync_job.rb
class StockDataSyncJob < ApplicationJob
  queue_as :default

  # 실패 시 재시도 (최대 3회, 지수 백오프)
  retry_on KisClient::RateLimitError, wait: :polynomially_longer, attempts: 3

  def perform(stock_id)
    stock = Stock.find(stock_id)
    client = KisClient.new

    # 시세 동기화
    price_data = client.stock_price(stock.symbol)
    stock.stock_prices.create!(
      date: Date.current,
      open: price_data['stck_oprc'],
      high: price_data['stck_hgpr'],
      low: price_data['stck_lwpr'],
      close: price_data['stck_prpr'],
      volume: price_data['acml_vol']
    )

    # 지표 계산
    Stocks::MetricsCalculator.new(stock).calculate!

    Rails.logger.info "[StockDataSyncJob] #{stock.symbol} 동기화 완료"
  end
end

# app/jobs/analysis_job.rb
class AnalysisJob < ApplicationJob
  queue_as :analysis

  def perform(stock_id, analyzer_type = 'buffett', user_id: nil)
    stock = Stock.find(stock_id)

    analyzer = case analyzer_type
               when 'buffett' then Analysis::BuffettAnalyzer.new(stock)
               when 'lynch'   then Analysis::LynchAnalyzer.new(stock)
               when 'dalio'   then Analysis::DalioAnalyzer.new(stock)
               end

    result = analyzer.analyze

    AnalysisReport.create!(
      stock: stock,
      user_id: user_id,
      analyzer_type: analyzer_type,
      total_score: result[:total_score],
      score_breakdown: result[:breakdown],
      details: result[:details],
      expires_at: 24.hours.from_now
    )
  end
end
```

---

## 5. Hotwire 기반 프론트엔드

### 5.1. Turbo Frames 활용

```erb
<!-- app/views/stocks/show.html.erb -->
<div class="container mx-auto p-4">
  <h1 class="text-2xl font-bold"><%= @stock.name %> (<%= @stock.symbol %>)</h1>

  <!-- 실시간 분석 결과 (Turbo Frame) -->
  <%= turbo_frame_tag "analysis_result", src: stock_analysis_path(@stock), loading: :lazy do %>
    <div class="animate-pulse bg-gray-200 h-48 rounded"></div>
  <% end %>

  <!-- 사용자 별점 입력 -->
  <%= turbo_frame_tag "user_rating" do %>
    <%= render "user_ratings/form", stock: @stock %>
  <% end %>

  <!-- 다른 사용자 별점 비교 (별점 입력 시 Turbo Stream으로 업데이트) -->
  <div id="rating_comparison">
    <%= render "stocks/rating_comparison", stock: @stock %>
  </div>
</div>
```

### 5.2. Turbo Streams 실시간 업데이트

```ruby
# app/controllers/user_ratings_controller.rb
class UserRatingsController < ApplicationController
  def create
    @rating = current_user.user_ratings.build(rating_params)

    if @rating.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("user_rating",
              partial: "user_ratings/show",
              locals: { rating: @rating }),
            turbo_stream.update("rating_comparison",
              partial: "stocks/rating_comparison",
              locals: { stock: @rating.stock })
          ]
        end
        format.html { redirect_to @rating.stock }
      end
    end
  end
end
```

### 5.3. Stimulus Controller

```javascript
// app/javascript/controllers/rating_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["star", "input", "systemScore"]
  static values = { rating: Number }

  connect() {
    this.updateStars()
  }

  select(event) {
    this.ratingValue = parseInt(event.currentTarget.dataset.value)
    this.inputTarget.value = this.ratingValue
    this.updateStars()
    this.showComparison()
  }

  updateStars() {
    this.starTargets.forEach((star, index) => {
      star.classList.toggle("text-yellow-400", index < this.ratingValue)
      star.classList.toggle("text-gray-300", index >= this.ratingValue)
    })
  }

  showComparison() {
    const systemScore = parseInt(this.systemScoreTarget.dataset.score)
    const diff = this.ratingValue - (systemScore / 20) // 100점 만점을 5점으로 변환

    if (diff >= 2) {
      this.showWarning("시스템 분석보다 높은 기대치입니다. 객관적 지표를 다시 확인해보세요.")
    }
  }
}
```

---

## 6. 캐싱 전략

### 6.1. Solid Cache 설정

```yaml
# config/cache.yml
default: &default
  database: cache
  store_options:
    max_age: <%= 1.week.to_i %>
    max_size: <%= 256.megabytes %>
    namespace: wiseinvest

development:
  <<: *default

production:
  <<: *default
  max_size: <%= 1.gigabyte %>
```

### 6.2. 캐싱 계층

| 데이터 | TTL | 전략 |
|--------|-----|------|
| 실시간 시세 | 5분 | Write-through |
| 재무제표 | 24시간 | Lazy loading |
| 분석 결과 | 24시간 | Background refresh |
| 사용자 프로필 | 1시간 | Invalidation on update |
| 정적 데이터 (종목 목록) | 1주 | Manual refresh |

```ruby
# app/models/concerns/cacheable.rb
module Cacheable
  extend ActiveSupport::Concern

  class_methods do
    def cache_key_for(id, suffix = nil)
      key = "#{model_name.cache_key}/#{id}"
      key += "/#{suffix}" if suffix
      key
    end
  end

  def cache_key_with_version
    "#{cache_key}-#{updated_at.to_i}"
  end
end
```

---

## 7. 보안 설계

### 7.1. 인증 (Rails 8 Built-in)

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include Authentication

  before_action :require_authentication

  private

  def require_authentication
    redirect_to new_session_path unless authenticated?
  end
end
```

### 7.2. API 키 관리

```yaml
# config/credentials.yml.enc (암호화됨)
kis:
  app_key: xxx
  app_secret: xxx

openai:
  api_key: xxx

dart:
  api_key: xxx
```

### 7.3. 데이터 보호

```ruby
# app/models/investment_record.rb
class InvestmentRecord < ApplicationRecord
  # 민감 데이터 암호화
  encrypts :memo
  encrypts :price

  # 사용자 본인만 접근
  scope :for_user, ->(user) { where(user: user) }
end
```

---

## 8. 배포 아키텍처 (Kamal 2)

### 8.1. 배포 구성

```yaml
# config/deploy.yml
service: wiseinvest

image: wiseinvest

servers:
  web:
    hosts:
      - 123.45.67.89
    labels:
      traefik.http.routers.wiseinvest.rule: Host(`wiseinvest.com`)
  job:
    hosts:
      - 123.45.67.89
    cmd: bin/jobs

proxy:
  ssl: true
  host: wiseinvest.com

registry:
  server: ghcr.io
  username:
    - KAMAL_REGISTRY_USERNAME
  password:
    - KAMAL_REGISTRY_PASSWORD

env:
  clear:
    RAILS_ENV: production
    SOLID_QUEUE_IN_PUMA: false
  secret:
    - RAILS_MASTER_KEY
    - DATABASE_URL

accessories:
  db:
    image: postgres:16
    host: 123.45.67.89
    port: 5432
    env:
      secret:
        - POSTGRES_PASSWORD
    directories:
      - data:/var/lib/postgresql/data
```

### 8.2. 인프라 구성도

```
┌─────────────────────────────────────────────────────────┐
│                    Production Server                    │
│  ┌─────────────────────────────────────────────────┐    │
│  │              Traefik (Reverse Proxy)            │    │
│  │            SSL 인증서, 로드 밸런싱                  │    │
│  └────────────────────┬────────────────────────────┘    │
│                       │                                 │
│  ┌────────────────────┼────────────────────────────┐    │
│  │                    ▼                            │    │
│  │  ┌──────────────────────┐  ┌──────────────────┐ │    │
│  │  │   Thruster + Puma    │  │   Solid Queue    │ │    │
│  │  │   (Web Container)    │  │ (Job Container)  │ │    │
│  │  └──────────────────────┘  └──────────────────┘ │    │
│  │              Docker Containers                   │    │
│  └──────────────────────────────────────────────────┘    │
│                       │                                  │
│  ┌────────────────────┼────────────────────────────┐    │
│  │                    ▼                            │    │
│  │  ┌──────────────────────┐  ┌──────────────────┐ │    │
│  │  │     PostgreSQL       │  │    Solid Cache   │ │    │
│  │  │    (Main + Cache)    │  │   (DB 기반 캐시)   │ │    │
│  │  └──────────────────────┘  └──────────────────┘ │    │
│  └──────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────┘
```

---

## 9. 모니터링 및 로깅

### 9.1. 로깅 전략

```ruby
# config/environments/production.rb
config.log_level = :info
config.log_tags = [:request_id, :remote_ip]
config.logger = ActiveSupport::TaggedLogging.new(
  ActiveSupport::Logger.new(STDOUT)
)
```

### 9.2. 헬스체크

```ruby
# app/controllers/health_controller.rb
class HealthController < ApplicationController
  skip_before_action :require_authentication

  def show
    checks = {
      database: database_connected?,
      cache: cache_connected?,
      queue: queue_healthy?
    }

    status = checks.values.all? ? :ok : :service_unavailable
    render json: checks, status: status
  end
end
```

---

## 10. 확장 계획

### 10.1. Phase별 아키텍처 변화

| Phase | 아키텍처 변화 |
|-------|-------------|
| **MVP** | 단일 서버, Monolith |
| **Phase 2** | 웹/잡 서버 분리 |
| **Phase 3** | 읽기 복제본 추가 |
| **Phase 4** | CDN 추가, 서버 수평 확장 |

### 10.2. 향후 고려사항

- **API 분리:** 모바일 앱 출시 시 API 전용 엔드포인트
- **WebSocket:** 실시간 시세 업데이트 (ActionCable)
- **분석 엔진 분리:** 고부하 시 별도 서비스로 분리
- **데이터 파이프라인:** 대량 데이터 처리 시 별도 ETL 구성
