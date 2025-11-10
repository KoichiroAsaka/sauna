class SaunasController < ApplicationController
  # --------------------------------------------
  # ✅ サウナ一覧表示
  # 都道府県・キーワードで絞り込み可能
  # --------------------------------------------
  def index
    @saunas = Sauna.all

    # 🌏 都道府県で絞り込み
    if params[:prefecture].present?
      @saunas = @saunas.where(prefecture: params[:prefecture])
    end

    # 🔍 キーワードで部分一致検索（サウナ名）
    if params[:keyword].present?
      @saunas = @saunas.where("name LIKE ?", "%#{params[:keyword]}%")
    end
  end

  # --------------------------------------------
  # ✅ サウナ詳細表示
  # 投稿を新しい順で6件ずつ表示（ページネーションあり）
  # --------------------------------------------
  def show
    @sauna = Sauna.find(params[:id])
    @posts = @sauna.posts
                   .includes(:user)
                   .published                 
                   .order(created_at: :desc)
                   .page(params[:page])
                   .per(6)
  end
end