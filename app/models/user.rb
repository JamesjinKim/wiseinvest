class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :investment_records, dependent: :destroy
  has_many :survey_responses, dependent: :destroy
  has_one :investment_profile, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }

  after_create :create_investment_profile

  private

  def create_investment_profile
    build_investment_profile.save
  end
end
