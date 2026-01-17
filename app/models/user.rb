class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :investment_records, dependent: :destroy
  has_many :survey_responses, dependent: :destroy
  has_one :investment_profile, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }

  before_create :set_admin_for_first_user
  after_create :create_investment_profile

  # Admin methods
  def admin?
    is_admin
  end

  def suspended?
    suspended_at.present?
  end

  def suspend!
    update!(suspended_at: Time.current)
  end

  def unsuspend!
    update!(suspended_at: nil)
  end

  private

  def set_admin_for_first_user
    self.is_admin = true if User.count.zero?
  end

  def create_investment_profile
    build_investment_profile.save
  end
end
