class AnalysisReport < ApplicationRecord
  belongs_to :stock

  validates :total_score, presence: true, numericality: { in: 0..100 }

  def grade
    case total_score
    when 80..100 then "A"
    when 60..79 then "B"
    when 40..59 then "C"
    else "D"
    end
  end

  def expired?
    expires_at.present? && expires_at < Time.current
  end
end
