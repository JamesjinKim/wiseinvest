class InvestmentRecordsController < ApplicationController
  before_action :set_record, only: [ :show, :edit, :update, :destroy ]

  def index
    @records = Current.user.investment_records.includes(:stock).recent
    @records = @records.where(action: params[:action_type]) if params[:action_type].present?
  end

  def show
  end

  def new
    @record = Current.user.investment_records.build
    @stocks = Stock.order(:name)
  end

  def edit
    @stocks = Stock.order(:name)
  end

  def create
    @record = Current.user.investment_records.build(record_params)

    if @record.save
      redirect_to investment_records_path, notice: "투자 기록이 추가되었습니다."
    else
      @stocks = Stock.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @record.update(record_params)
      redirect_to investment_records_path, notice: "투자 기록이 수정되었습니다."
    else
      @stocks = Stock.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @record.destroy
    redirect_to investment_records_path, notice: "투자 기록이 삭제되었습니다."
  end

  def import
    if request.post? && params[:file].present?
      result = CsvImportService.new(Current.user, params[:file]).import
      if result[:failed] == 0
        redirect_to investment_records_path, notice: "#{result[:success]}건이 성공적으로 업로드되었습니다."
      else
        redirect_to import_investment_records_path, alert: "성공: #{result[:success]}건, 실패: #{result[:failed]}건"
      end
    end
  end

  private

  def set_record
    @record = Current.user.investment_records.find(params[:id])
  end

  def record_params
    params.require(:investment_record).permit(:stock_id, :action, :quantity, :price, :traded_at, :pre_rating, reason_tags: [])
  end
end
