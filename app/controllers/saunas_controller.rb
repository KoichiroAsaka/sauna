class SaunasController < ApplicationController
  def index
    @saunas = Sauna.all

    # ✅ 都道府県が選ばれていれば絞り込み
    if params[:prefecture].present?
      @saunas = @saunas.where(prefecture: params[:prefecture])
    end

    # ✅ キーワードが入力されていればサウナ名検索
    if params[:keyword].present?
      @saunas = @saunas.where("name LIKE ?", "%#{params[:keyword]}%")
    end
  end

  def show
    @sauna = Sauna.find(params[:id])
    @posts = @sauna.posts
                   .includes(:user)
                   .where(status: :published)
                   .order(created_at: :desc)
                   .page(params[:page])
                   .per(6)
  end
end
