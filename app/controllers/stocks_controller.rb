class StocksController < ApplicationController
  before_action :set_stock, only: [ :show, :analyze ]

  def index
    @stocks = if params[:q].present?
      Stock.where("name ILIKE :q OR symbol ILIKE :q", q: "%#{params[:q]}%")
    else
      Stock.all
    end.order(:name)
  end

  def show
    @metric = @stock.latest_metric
    @report = @stock.latest_report
  end

  def analyze
    @metric = @stock.latest_metric
    @report = BuffettAnalyzer.new(@stock).analyze
  end

  private

  def set_stock
    @stock = Stock.find(params[:id])
  end
end
