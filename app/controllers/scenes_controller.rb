class ScenesController < ApplicationController
  before_action :authenticate_user!

  def index
    @scenes = Scene.all.includes(:evaluations)
    @user_evaluations = current_user.evaluations.index_by(&:scene_id)
  end

  def show
    @scene = Scene.find(params[:id])
    @good_count = @scene.evaluations.where(result: "Good").count
    @bad_count = @scene.evaluations.where(result: "Bad").count
    @comments = @scene.comments.includes(:user)
  end
end
