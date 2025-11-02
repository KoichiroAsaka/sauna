class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  # マイページ（自分のみ閲覧可）
  def show
    redirect_to root_path, alert: "アクセスできません" unless @user == current_user
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
    redirect_to root_path, alert: "アクセスできません" unless @user == current_user

    if @user.update(user_params)
      redirect_to profile_user_path(@user), notice: "プロフィールを更新しました。"
    else
      render :edit_profile, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :profile, :profile_image)
  end
end
