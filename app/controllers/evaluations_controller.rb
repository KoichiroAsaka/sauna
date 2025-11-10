class EvaluationsController < ApplicationController
  before_action :authenticate_user!

  def create
    @scene = Scene.find(params[:scene_id])
    @evaluation = current_user.evaluations.find_or_initialize_by(scene: @scene)

    # 押されたボタンの値（"Good" or "Bad"）
    new_result = params[:result]

    if @evaluation.persisted? && @evaluation.result == new_result
      # 同じボタンをもう一度押した場合 → 評価を削除（解除）
      @evaluation.destroy
      message = "#{new_result}評価を取り消しました。"
    else
      # 新規 or 違う評価を押した場合 → 更新または作成
      @evaluation.result = new_result
      @evaluation.save
      message = "評価を「#{new_result}」に変更しました。"
    end

    redirect_to scenes_path, notice: message
  end
end
