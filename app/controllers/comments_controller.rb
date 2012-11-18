class CommentsController < ApplicationController
  layout false
  before_filter :authenticate_user!

  def create
    @comment = Comment.new(params[:comment])

    unless [@comment.bid.bidder, @comment.bid.requestor].include?(current_user)
      render json: {error: 'Unauthorized'}, status: :unauthorized
      return
    end

    @comment.user = current_user

    if @comment.save
      CommentNotifier.new_comment(@comment).deliver
      render partial: 'comment', locals: {comment: @comment}, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to comments_url }
      format.json { head :no_content }
    end
  end
end
