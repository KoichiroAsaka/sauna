class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sauna, only: [:index, :show, :new, :create]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  # サウナごとの投稿一覧
  def index
    if @sauna
      @posts = @sauna.posts.includes(:user)
                     .order(created_at: :desc)
                     .page(params[:page])
                     .per(6)
    else
      @posts = Post.includes(:user, :sauna)
                   .order(created_at: :desc)
                   .page(params[:page])
                   .per(6)
    end
  end

  # 投稿詳細
  def show; end

  # 新規投稿
  def new
    @post = @sauna ? @sauna.posts.build(user: current_user) : current_user.posts.build
  end

  # 投稿作成
  def create
    @post = @sauna ? @sauna.posts.build(post_params.merge(user: current_user)) : current_user.posts.build(post_params)

    if @post.save
      redirect_to sauna_post_path(@post.sauna, @post), notice: "投稿を作成しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # 投稿編集
  def edit; end

  # 投稿更新
  def update
    if @post.update(post_params)
      redirect_to sauna_post_path(@post.sauna, @post), notice: "投稿を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # 投稿削除
  def destroy
    sauna = @post.sauna
    @post.destroy
    redirect_to sauna_posts_path(sauna), notice: "投稿を削除しました。"
  end

  private

  # サウナを取得（ネストルート対応）
  def set_sauna
    @sauna = Sauna.find(params[:sauna_id]) if params[:sauna_id].present?
  end

  # 投稿を取得
  def set_post
    @post = Post.find(params[:id])
  end

  # 権限チェック
  def authorize_user!
    redirect_to sauna_posts_path(@post.sauna), alert: "権限がありません。" unless @post.user == current_user
  end

  # パラメータ許可
  def post_params
    params.require(:post).permit(:sauna_id, :post, :status, :congestion_level, :day_of_week, :time_zone, :image)
  end
end
