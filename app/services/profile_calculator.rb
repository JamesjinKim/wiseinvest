class ProfileCalculator
  def initialize(user)
    @user = user
    @records = user.investment_records
    @surveys = user.survey_responses
  end

  def calculate
    survey_score = calculate_survey_score
    actual_score = calculate_actual_score
    biases = detect_biases

    @user.investment_profile.update!(
      survey_score: survey_score,
      actual_score: actual_score,
      risk_tolerance: determine_risk_tolerance(actual_score),
      biases: biases
    )
  end

  private

  def calculate_survey_score
    return nil if @surveys.empty?

    # 10개 질문, 각 1-5점 → 최대 50점 → 100점으로 환산
    total = @surveys.sum(&:answer_value)
    max_possible = @surveys.count * 5
    (total.to_f / max_possible * 100).round
  end

  def calculate_actual_score
    return nil if @records.empty?

    # 실제 투자 행동을 분석하여 점수화
    scores = []

    # 1. 분산 투자 점수 (보유 종목 수)
    unique_stocks = @records.select(&:stock_id).uniq.count
    diversification_score = [ unique_stocks * 10, 25 ].min
    scores << diversification_score

    # 2. 보유 기간 점수 (평균 보유 기간이 길수록 높음)
    holding_score = calculate_holding_score
    scores << holding_score

    # 3. 손절/익절 비율 점수
    profit_loss_score = calculate_profit_loss_score
    scores << profit_loss_score

    # 4. 사전 별점과 실제 결과 일치도
    rating_accuracy_score = calculate_rating_accuracy
    scores << rating_accuracy_score

    scores.sum
  end

  def calculate_holding_score
    buys = @records.buys.order(:traded_at)
    sells = @records.sells.order(:traded_at)

    return 25 if sells.empty? # 아직 매도 안 함 → 장기 투자 가정

    # 평균 보유 기간 계산 (간단히)
    avg_days = 30 # 기본값
    if buys.any? && sells.any?
      first_buy = buys.first.traded_at
      last_sell = sells.last.traded_at
      avg_days = (last_sell - first_buy).to_i / 1.day rescue 30
    end

    case avg_days
    when 0..7 then 5     # 단타
    when 8..30 then 10   # 단기
    when 31..90 then 15  # 중기
    when 91..365 then 20 # 중장기
    else 25              # 장기
    end
  end

  def calculate_profit_loss_score
    # MVP: 간단한 평가
    sells = @records.sells
    return 25 if sells.empty?

    # 매도 기록이 있으면 중간 점수
    15
  end

  def calculate_rating_accuracy
    rated_records = @records.where.not(pre_rating: nil)
    return 25 if rated_records.empty?

    # MVP: 별점 부여 자체에 점수
    rated_records.count >= 3 ? 25 : 15
  end

  def detect_biases
    biases = {}

    # 과잉 확신 감지: 높은 별점(4-5점) 종목의 비율
    high_rated = @records.where(pre_rating: [ 4, 5 ]).count
    total_rated = @records.where.not(pre_rating: nil).count
    if total_rated > 0 && (high_rated.to_f / total_rated) > 0.7
      biases[:overconfidence] = true
    end

    # 손실 회피 감지: 손절 기록이 거의 없음
    if @records.sells.count < (@records.buys.count * 0.3)
      biases[:loss_aversion] = true
    end

    # 뇌동 매매 감지: 짧은 기간 내 같은 종목 매수/매도 반복
    # MVP에서는 간단히 처리
    rapid_trades = @records.group(:stock_id).having("count(*) > 3").count
    biases[:herding] = true if rapid_trades.any?

    biases
  end

  def determine_risk_tolerance(score)
    return "moderate" unless score

    case score
    when 0..40 then "aggressive"
    when 41..70 then "moderate"
    else "conservative"
    end
  end
end
