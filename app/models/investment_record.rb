class InvestmentRecord < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  validates :action, presence: true, inclusion: { in: %w[buy sell] }
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :traded_at, presence: true
  validates :pre_rating, numericality: { in: 1..5 }, allow_nil: true

  scope :buys, -> { where(action: "buy") }
  scope :sells, -> { where(action: "sell") }
  scope :recent, -> { order(traded_at: :desc) }
end
