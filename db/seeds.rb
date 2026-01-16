# db/seeds.rb
# 샘플 데이터 생성

puts "Seeding database..."

# 1. 한국 주식 샘플 데이터
stocks_data = [
  { symbol: "005930", name: "삼성전자", sector: "전기전자" },
  { symbol: "000660", name: "SK하이닉스", sector: "전기전자" },
  { symbol: "035420", name: "NAVER", sector: "서비스업" },
  { symbol: "035720", name: "카카오", sector: "서비스업" },
  { symbol: "005380", name: "현대차", sector: "운수장비" },
  { symbol: "051910", name: "LG화학", sector: "화학" },
  { symbol: "006400", name: "삼성SDI", sector: "전기전자" },
  { symbol: "068270", name: "셀트리온", sector: "의약품" },
  { symbol: "028260", name: "삼성물산", sector: "유통업" },
  { symbol: "012330", name: "현대모비스", sector: "운수장비" }
]

stocks_data.each do |stock_data|
  Stock.find_or_create_by!(symbol: stock_data[:symbol]) do |stock|
    stock.name = stock_data[:name]
    stock.sector = stock_data[:sector]
  end
end

puts "Created #{Stock.count} stocks"

# 2. 재무 지표 샘플 데이터
metrics_data = {
  "005930" => { roe: 15.2, debt_ratio: 42.0, operating_margin: 12.3, per: 11.2, pbr: 1.2, profit_growth_years: 3 },
  "000660" => { roe: 22.5, debt_ratio: 35.0, operating_margin: 18.5, per: 8.5, pbr: 1.8, profit_growth_years: 5 },
  "035420" => { roe: 8.5, debt_ratio: 28.0, operating_margin: 15.2, per: 25.0, pbr: 2.5, profit_growth_years: 2 },
  "035720" => { roe: 5.2, debt_ratio: 55.0, operating_margin: 8.5, per: 45.0, pbr: 3.2, profit_growth_years: 0 },
  "005380" => { roe: 12.8, debt_ratio: 65.0, operating_margin: 7.5, per: 6.5, pbr: 0.5, profit_growth_years: 4 },
  "051910" => { roe: 18.5, debt_ratio: 48.0, operating_margin: 14.2, per: 15.0, pbr: 2.0, profit_growth_years: 4 },
  "006400" => { roe: 20.2, debt_ratio: 38.0, operating_margin: 16.8, per: 12.0, pbr: 2.2, profit_growth_years: 5 },
  "068270" => { roe: 10.5, debt_ratio: 32.0, operating_margin: 22.5, per: 35.0, pbr: 4.5, profit_growth_years: 3 },
  "028260" => { roe: 6.8, debt_ratio: 72.0, operating_margin: 5.2, per: 18.0, pbr: 0.8, profit_growth_years: 1 },
  "012330" => { roe: 11.2, debt_ratio: 45.0, operating_margin: 6.8, per: 7.8, pbr: 0.6, profit_growth_years: 3 }
}

metrics_data.each do |symbol, metrics|
  stock = Stock.find_by(symbol: symbol)
  next unless stock

  stock.stock_metrics.find_or_create_by!(data_date: Date.current) do |metric|
    metric.roe = metrics[:roe]
    metric.debt_ratio = metrics[:debt_ratio]
    metric.operating_margin = metrics[:operating_margin]
    metric.per = metrics[:per]
    metric.pbr = metrics[:pbr]
    metric.profit_growth_years = metrics[:profit_growth_years]
  end
end

puts "Created #{StockMetric.count} stock metrics"

# 3. 테스트 사용자 생성
test_user = User.find_or_create_by!(email_address: "test@wiseinvest.com") do |user|
  user.password = "password123"
  user.name = "테스트 투자자"
end

puts "Created test user: #{test_user.email_address}"

# 4. 테스트 사용자의 투자 기록
if test_user.investment_records.empty?
  samsung = Stock.find_by(symbol: "005930")
  sk = Stock.find_by(symbol: "000660")
  kakao = Stock.find_by(symbol: "035720")

  [
    { stock: samsung, action: "buy", quantity: 10, price: 72000, traded_at: 5.days.ago, pre_rating: 4, reason_tags: ["저평가", "실적호조"] },
    { stock: sk, action: "buy", quantity: 5, price: 180000, traded_at: 7.days.ago, pre_rating: 3, reason_tags: ["AI수혜", "기술력"] },
    { stock: kakao, action: "sell", quantity: 20, price: 52000, traded_at: 10.days.ago, reason_tags: ["손절"] }
  ].each do |record_data|
    test_user.investment_records.create!(record_data)
  end
end

puts "Created #{test_user.investment_records.count} investment records"

# 5. 테스트 사용자의 설문 응답
if test_user.survey_responses.empty?
  survey_answers = {
    "q1_risk_tolerance" => 3,
    "q2_loss_reaction" => 4,
    "q3_investment_horizon" => 4,
    "q4_diversification" => 3,
    "q5_market_timing" => 2,
    "q6_research_depth" => 4,
    "q7_emotional_control" => 3,
    "q8_profit_taking" => 3,
    "q9_learning_attitude" => 5,
    "q10_confidence_level" => 4
  }

  survey_answers.each do |key, value|
    test_user.survey_responses.create!(question_key: key, answer_value: value)
  end
end

puts "Created #{test_user.survey_responses.count} survey responses"

# 6. 테스트 사용자의 투자 프로필 업데이트
test_user.investment_profile.update!(
  survey_score: 72,
  actual_score: 58,
  risk_tolerance: "conservative",
  biases: {
    overconfidence: true,
    loss_aversion: false,
    herding: false
  }
)

puts "Updated investment profile"

# 7. 분석 리포트 생성
analysis_data = {
  "005930" => { total_score: 72, score_breakdown: { roe: 18, debt_ratio: 15, operating_margin: 15, profit_growth: 12, per: 8, pbr: 6, moat: 5 } },
  "000660" => { total_score: 85, score_breakdown: { roe: 20, debt_ratio: 15, operating_margin: 15, profit_growth: 20, per: 10, pbr: 5, moat: 7 } },
  "035420" => { total_score: 56, score_breakdown: { roe: 10, debt_ratio: 15, operating_margin: 15, profit_growth: 8, per: 3, pbr: 2, moat: 8 } }
}

analysis_data.each do |symbol, data|
  stock = Stock.find_by(symbol: symbol)
  next unless stock

  stock.analysis_reports.find_or_create_by!(created_at: Date.current.beginning_of_day..) do |report|
    report.total_score = data[:total_score]
    report.score_breakdown = data[:score_breakdown]
    report.expires_at = 24.hours.from_now
  end
end

puts "Created #{AnalysisReport.count} analysis reports"

puts "Seeding completed!"
