class ProfilesController < ApplicationController
  before_action :set_user
  before_action :authenticate_user!, only: [:edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to profile_path(@user), notice: "プロフィールを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_user!
    redirect_to profile_path(@user), alert: "権限がありません" unless @user == current_user
  end
end
