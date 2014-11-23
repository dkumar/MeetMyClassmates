class MessagesController < ApplicationController

  def new
  end

  def create
    @studygroup = Studygroup.find(params[:studygroup_id])
    @comment = @studygroup.messages.create(message_params)
    @comment.user_id = current_user.id
    @comment.save
    redirect_to studygroup_show_path(@studygroup)
  end

  private
  def message_params
    params.require(:message).permit(:body)
  end
end