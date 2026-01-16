class InvestmentProfile < ApplicationRecord
  belongs_to :user

  RISK_TOLERANCES = %w[conservative moderate aggressive].freeze

  validates :risk_tolerance, inclusion: { in: RISK_TOLERANCES }, allow_nil: true

  def risk_tolerance_label
    case risk_tolerance
    when "conservative" then "보수적"
    when "moderate" then "중립적"
    when "aggressive" then "공격적"
    end
  end

  def gap
    return nil unless survey_score && actual_score
    survey_score - actual_score
  end
end
