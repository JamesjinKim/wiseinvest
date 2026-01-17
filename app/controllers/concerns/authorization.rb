module Authorization
  extend ActiveSupport::Concern

  private

  def require_admin
    unless Current.user&.admin?
      redirect_to root_path, alert: "관리자 권한이 필요합니다."
    end
  end
end
