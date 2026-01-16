class ProfilesController < ApplicationController
  def show
    @user = Current.user
    @profile = @user.investment_profile
    @survey_responses = @user.survey_responses
    @records = @user.investment_records.includes(:stock)
  end
end
