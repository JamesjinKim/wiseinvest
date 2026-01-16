class BuffettAnalyzer
  CRITERIA = {
    roe:              { weight: 20, min: 15 },
    debt_ratio:       { weight: 15, max: 50 },
    operating_margin: { weight: 15, min: 10 },
    profit_growth:    { weight: 20, min: 5 },
    per:              { weight: 10, max: 15 },
    pbr:              { weight: 10, max: 1.5 },
    moat:             { weight: 10 }
  }.freeze

  def initialize(stock)
    @stock = stock
    @metrics = stock.latest_metric
  end

  def analyze
    return empty_result unless @metrics

    scores = calculate_scores
    total = scores.values.sum
    grade = determine_grade(total)

    result = {
      total_score: total,
      breakdown: scores,
      grade: grade
    }

    save_report(result)
    result
  end

  private

  def calculate_scores
    {
      roe: score_roe,
      debt_ratio: score_debt_ratio,
      operating_margin: score_operating_margin,
      profit_growth: score_profit_growth,
      per: score_per,
      pbr: score_pbr,
      moat: 5 # MVP에서는 기본값
    }
  end

  def score_roe
    return 0 unless @metrics.roe
    if @metrics.roe >= 15
      20
    else
      (@metrics.roe / 15.0 * 20).round.clamp(0, 20)
    end
  end

  def score_debt_ratio
    return 0 unless @metrics.debt_ratio
    if @metrics.debt_ratio <= 50
      15
    elsif @metrics.debt_ratio <= 100
      ((100 - @metrics.debt_ratio) / 50.0 * 15).round.clamp(0, 15)
    else
      0
    end
  end

  def score_operating_margin
    return 0 unless @metrics.operating_margin
    if @metrics.operating_margin >= 10
      15
    else
      (@metrics.operating_margin / 10.0 * 15).round.clamp(0, 15)
    end
  end

  def score_profit_growth
    return 0 unless @metrics.profit_growth_years
    if @metrics.profit_growth_years >= 5
      20
    else
      (@metrics.profit_growth_years / 5.0 * 20).round.clamp(0, 20)
    end
  end

  def score_per
    return 0 unless @metrics.per
    if @metrics.per <= 15
      10
    elsif @metrics.per <= 25
      ((25 - @metrics.per) / 10.0 * 10).round.clamp(0, 10)
    else
      0
    end
  end

  def score_pbr
    return 0 unless @metrics.pbr
    if @metrics.pbr <= 1.5
      10
    elsif @metrics.pbr <= 3
      ((3 - @metrics.pbr) / 1.5 * 10).round.clamp(0, 10)
    else
      0
    end
  end

  def determine_grade(total)
    case total
    when 80..100 then "A"
    when 60..79 then "B"
    when 40..59 then "C"
    else "D"
    end
  end

  def save_report(result)
    @stock.analysis_reports.create!(
      total_score: result[:total_score],
      score_breakdown: result[:breakdown],
      expires_at: 24.hours.from_now
    )
  end

  def empty_result
    { total_score: 0, breakdown: {}, grade: "N/A" }
  end
end
