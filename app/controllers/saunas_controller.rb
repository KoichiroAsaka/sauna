class SaunasController < ApplicationController
  def index
    @saunas = Sauna.all.order(:prefecture, :name)
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
