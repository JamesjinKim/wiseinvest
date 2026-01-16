class Stock < ApplicationRecord
  has_many :stock_metrics, dependent: :destroy
  has_many :investment_records, dependent: :destroy
  has_many :analysis_reports, dependent: :destroy

  validates :symbol, presence: true, uniqueness: true
  validates :name, presence: true

  def latest_metric
    stock_metrics.order(data_date: :desc).first
  end

  def latest_report
    analysis_reports.where("expires_at > ?", Time.current).order(created_at: :desc).first
  end
end
