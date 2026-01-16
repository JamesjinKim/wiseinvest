class SurveyResponse < ApplicationRecord
  belongs_to :user

  validates :question_key, presence: true
  validates :answer_value, presence: true, numericality: { in: 1..5 }
  validates :question_key, uniqueness: { scope: :user_id }
end
