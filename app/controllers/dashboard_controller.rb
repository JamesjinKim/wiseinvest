class DashboardController < ApplicationController
  def show
    @user = Current.user
    @profile = @user.investment_profile
    @recent_records = @user.investment_records.recent.limit(5)
    @recent_analyses = AnalysisReport.includes(:stock)
                                     .where("expires_at > ?", Time.current)
                                     .order(created_at: :desc)
                                     .limit(3)
  end
end
