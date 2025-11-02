class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sauna, only: [:index, :show, :new, :create, :confirm, :edit, :update, :destroy]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  # 新規投稿
  def new
    @post = @sauna.posts.build(user: current_user)
  end

  # ✅ 確認ページ
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
    elsif @post.save
      @post.status = :published
      redirect_to sauna_post_path(@sauna, @post), notice: "投稿を作成しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # ✅ 編集
  def edit
  end

  # ✅ 更新
  def update
    if params[:draft]
      # 下書きとして保存する場合
      @post.status = :draft
      if @post.update(post_params)
        redirect_to drafts_posts_path, notice: "下書きを更新しました。"
      else
        render :edit, status: :unprocessable_entity
      end
    else
      # 通常更新（＝公開）
      @post.status = :published
      if @post.update(post_params)
        redirect_to sauna_post_path(@post.sauna, @post), notice: "投稿を公開しました。"
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end  

  # ✅ 下書き一覧ページ
  def drafts
    @posts = current_user.posts.where(status: :draft).includes(:sauna).order(created_at: :desc)
  end

  private

  # サウナを取得（ネストルート対応）
  def set_sauna
    @sauna = Sauna.find(params[:sauna_id])
  end

  # 投稿を取得（ネストルート対応）
  def set_post
    @post = @sauna.posts.find(params[:id])
  end

  # 権限チェック
  def authorize_user!
    redirect_to root_path, alert: "権限がありません。" unless @post.user == current_user
  end

  def post_params
    params.require(:post).permit(:sauna_id, :post, :status, :congestion_level, :day_of_week, :time_zone, :image)
  end
end
