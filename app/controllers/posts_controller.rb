class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sauna, only: [:index, :show, :new, :create]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  # 投稿一覧（公開済み）
  def index
    @posts = Post.includes(:user, :sauna)
                 .where(status: :published)
                 .order(created_at: :desc)
                 .page(params[:page])
  end

  # 投稿詳細
  def show; end

  # 新規投稿
  def new
    @post = @sauna.posts.build(user: current_user)
  end

  # 確認ページ
  def confirm
    @post = @sauna.posts.build(post_params)
    @post.user = current_user
    render :confirm
  end

  # 作成処理
  def create
    @post = @sauna.posts.build(post_params)
    @post.user = current_user
  
    if params[:back]
      render :new
    elsif params[:draft]
      @post.status = :draft
      if @post.save
        redirect_to drafts_posts_path, notice: "下書きとして保存しました。"
      else
        render :new, status: :unprocessable_entity 
      end
    else
      @post.status = :published
      if @post.save
        redirect_to sauna_post_path(@sauna, @post), notice: "投稿を作成しました。"
      else
        render :new, status: :unprocessable_entity  # ← 変更なし
      end
    end
  end
  

  # 編集
  def edit; end

  # 更新
  def update
    if params[:draft]
      @post.status = :draft
      if @post.update(post_params)
        redirect_to drafts_posts_path, notice: "下書きを更新しました。"
      else
        render :edit, status: :unprocessable_entity
      end
    else
      @post.status = :published
      if @post.update(post_params)
        redirect_to sauna_post_path(@post.sauna, @post), notice: "投稿を公開しました。"
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  # 下書き一覧
  def drafts
    @posts = current_user.posts
                         .where(status: :draft)
                         .includes(:sauna)
                         .order(created_at: :desc)
  end

  # 自分の投稿一覧
  def my_posts
    @posts = current_user.posts
                         .where(status: :published)
                         .includes(:sauna)
                         .order(created_at: :desc)
  end

  # 投稿削除
  def destroy
    @post.destroy
    redirect_to my_posts_posts_path, notice: "投稿を削除しました。"
  end

  private

  def set_sauna
    @sauna = Sauna.find(params[:sauna_id])
  end

  def set_post
    if params[:sauna_id]
      @sauna = Sauna.find(params[:sauna_id])
      @post = @sauna.posts.find(params[:id])
    else
      @post = Post.find(params[:id])
    end
  end

  # アクセス制御：投稿者以外の編集禁止
  def authorize_user!
    redirect_to root_path, alert: "権限がありません。" unless @post.user == current_user
  end

  # ストロングパラメータ
  def post_params
    params.require(:post).permit(:sauna_id, :post, :status, :congestion_level, :day_of_week, :time_zone, :image)
  end
end
