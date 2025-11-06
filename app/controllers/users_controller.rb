class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  # /users/:id → 自分のマイページ（非公開）
  # /users/:id/profile → 他人も閲覧OK
  def show
   redirect_to profile_user_path(@user) unless @user == current_user
  end

  # プロフィールページ（他人も閲覧可）
  def profile
  end

  # プロフィール編集ページ（自分のみ）
  def edit_profile
    redirect_to root_path, alert: "アクセスできません" unless @user == current_user
  end

  # プロフィール更新処理
  def update_profile
    redirect_to root_path, alert: "アクセスできません" and return unless @user == current_user

    if @user.update(user_params)
      redirect_to profile_user_path(@user), notice: "プロフィールを更新しました。"
    else
      render :edit_profile, status: :unprocessable_entity
    end
  end

  # ✅ プロフィール削除
  def destroy_profile
    redirect_to root_path, alert: "アクセスできません" and return unless @user == current_user

    @user.update(profile: nil, profile_image: nil)
    redirect_to root_path, notice: "プロフィールを削除しました。"
  end

  # フォロー一覧
  def followings
    user = User.find(params[:id])
    @users = user.followings
  end

  # フォロワー一覧
  def followers
    user = User.find(params[:id])
    @users = user.followers
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :profile, :profile_image)
  end
end
