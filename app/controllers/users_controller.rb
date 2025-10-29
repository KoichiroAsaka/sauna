class UsersController < ApplicationController
  before_action :authenticate_user!  # 🔒 ログインしていないとアクセスできない

  def show
    @user = current_user
  end
end
