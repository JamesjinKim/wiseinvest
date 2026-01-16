class SurveysController < ApplicationController
  QUESTIONS = [
    { key: "q1_risk_tolerance", text: "투자 손실이 발생했을 때 어떻게 반응하시나요?" },
    { key: "q2_loss_reaction", text: "주가가 10% 하락하면 어떻게 하시나요?" },
    { key: "q3_investment_horizon", text: "투자 기간은 보통 얼마나 되나요?" },
    { key: "q4_diversification", text: "포트폴리오 분산에 대해 어떻게 생각하시나요?" },
    { key: "q5_market_timing", text: "시장 타이밍을 맞추려고 노력하시나요?" },
    { key: "q6_research_depth", text: "종목 분석에 얼마나 시간을 투자하시나요?" },
    { key: "q7_emotional_control", text: "투자 결정 시 감정을 얼마나 통제하시나요?" },
    { key: "q8_profit_taking", text: "수익이 발생하면 어떻게 하시나요?" },
    { key: "q9_learning_attitude", text: "투자 공부에 대한 태도는 어떠신가요?" },
    { key: "q10_confidence_level", text: "본인의 투자 능력에 대해 어떻게 생각하시나요?" }
  ].freeze

  def index
    @questions = QUESTIONS
    @existing_responses = Current.user.survey_responses.index_by(&:question_key)
  end

  def create
    responses = params[:responses] || {}

    responses.each do |key, value|
      response = Current.user.survey_responses.find_or_initialize_by(question_key: key)
      response.answer_value = value.to_i
      response.save
    end

    # 프로필 점수 업데이트
    ProfileCalculator.new(Current.user).calculate

    redirect_to profile_path, notice: "설문이 완료되었습니다."
  end
end
