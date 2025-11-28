class UsersController < ApplicationController
  # --------------------------------------------
  # ✅ フィルタ設定
  # ログイン必須 & ユーザー情報の取得
  # --------------------------------------------
  before_action :authenticate_user!
  before_action :set_user

  # --------------------------------------------
  # 🏠 マイページ（本人のみ閲覧可）
  # /users/:id → 自分以外がアクセスしたらプロフィールへリダイレクト
  # --------------------------------------------
  def show
    redirect_to profile_user_path(@user) unless @user == current_user
    @latest_posts = Post.order(created_at: :desc).limit(3)
  end
  

  # --------------------------------------------
  # 🌐 プロフィールページ（他人も閲覧可）
  # /users/:id/profile
  # --------------------------------------------
  def profile
  end

  # --------------------------------------------
  # ✏️ プロフィール編集ページ（本人のみ）
  # --------------------------------------------
  def edit_profile
    redirect_to root_path, alert: "アクセスできません" unless @user == current_user
  end

  # --------------------------------------------
  # 💾 プロフィール更新処理
  # --------------------------------------------
  def update_profile
    unless @user == current_user
      redirect_to root_path, alert: "アクセスできません" and return
    end

    if @user.update(user_params)
      redirect_to profile_user_path(@user), notice: "プロフィールを更新しました。"
    else
      render :edit_profile, status: :unprocessable_entity
    end
  end

  # --------------------------------------------
  # 🗑️ プロフィール削除（本人のみ）
  # --------------------------------------------
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    reset_session # ログアウト
    redirect_to root_path, notice: "アカウントを削除しました。"
  end
  
  

  # --------------------------------------------
  # 🤝 フォロー一覧
  # /users/:id/followings
  # --------------------------------------------
  def followings
    @users = @user.followings
  end

  # --------------------------------------------
  # 👀 フォロワー一覧
  # /users/:id/followers
  # --------------------------------------------
  def followers
    @users = @user.followers
  end

  # --------------------------------------------
  # 📝 投稿一覧（そのユーザーの投稿）
  # --------------------------------------------
  def posts
    @posts = @user.posts
                  .includes(:sauna)
                  .order(created_at: :desc)
  end

  private

  # --------------------------------------------
  # 🧩 共通処理: ユーザー取得
  # --------------------------------------------
  def set_user
    @user = User.find(params[:id])
  end

  # --------------------------------------------
  # ✅ ストロングパラメータ
  # --------------------------------------------
  def user_params
    params.require(:user).permit(:name, :profile, :profile_image)
  end
end