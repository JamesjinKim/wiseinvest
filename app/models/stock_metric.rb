class StockMetric < ApplicationRecord
  belongs_to :stock

  validates :data_date, presence: true
end
