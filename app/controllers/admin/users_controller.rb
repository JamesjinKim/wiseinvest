class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [ :show, :update, :suspend, :unsuspend ]

  def index
    @page = (params[:page] || 1).to_i
    @per_page = 20
    @users = User.order(created_at: :desc).offset((@page - 1) * @per_page).limit(@per_page)
    @total_count = User.count
    @total_pages = (@total_count.to_f / @per_page).ceil
  end

  def show
  end

  def update
    if @user == Current.user
      redirect_to admin_user_path(@user), alert: "자기 자신의 권한은 변경할 수 없습니다."
      return
    end

    @user.update!(is_admin: params[:is_admin])
    redirect_to admin_user_path(@user), notice: "권한이 변경되었습니다."
  end

  def suspend
    if @user == Current.user
      redirect_to admin_user_path(@user), alert: "자기 자신은 정지할 수 없습니다."
      return
    end

    @user.suspend!
    redirect_to admin_user_path(@user), notice: "계정이 정지되었습니다."
  end

  def unsuspend
    @user.unsuspend!
    redirect_to admin_user_path(@user), notice: "계정이 활성화되었습니다."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
