class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    # 投稿対象のシーンを特定
    @scene = Scene.find(params[:scene_id])

    # current_userとsceneを紐づけてコメント作成
    @comment = @scene.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to scene_path(@scene), notice: "コメントを投稿しました。"
    else
      redirect_to scene_path(@scene), alert: "コメントの投稿に失敗しました。"
    end    
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
