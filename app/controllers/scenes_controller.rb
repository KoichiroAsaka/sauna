class ScenesController < ApplicationController
  before_action :authenticate_user!

  def index
    # 全シーンを評価情報込みで取得
    @scenes = Scene.includes(:evaluations).all

    # 現在のユーザーが各シーンに対して行った評価をハッシュ化（scene_id => evaluation）
    @user_evaluations = current_user.evaluations.index_by(&:scene_id)
  end

  def show
    # 対象シーンを取得
    @scene = Scene.find(params[:id])

    # 各評価数を集計
    @good_count = @scene.evaluations.where(result: "Good").count
    @bad_count  = @scene.evaluations.where(result: "Bad").count

    # コメント一覧をユーザー情報込みで取得
    @comments = @scene.comments.includes(:user)
  end
end