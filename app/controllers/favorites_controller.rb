class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @favorites = current_user.favorites.includes(:sauna)
  end

  def create
    sauna = Sauna.find(params[:sauna_id])
    current_user.favorites.create!(sauna:)
    redirect_to sauna_path(sauna), notice: "お気に入りに追加しました"
  end

  def destroy
    favorite = current_user.favorites.find(params[:id]) 
    sauna = favorite.sauna                               
    favorite.destroy
    redirect_to favorites_path, notice: "お気に入りを解除しました"
  end
  
end
