class GroupMessagesController < ApplicationController
  before_action :set_group, only: [:new, :create, :destroy]
  before_action :logged_in_user, only: [:new, :create, :destroy]

  def new
    @group_message = @group.group_messages.build
  end

  def create
    @group_message = @group.group_messages.build(group_message_params)
    @group_message.user_id = params[:user_id]
    if @group_message.save
      flash[:success] = "Group Post created!"
      redirect_to @group
    else
      render 'new'
    end
  end

  def destroy
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end
  
  def group_message_params
    params.require(:group_message).permit(:message, :group_id, :user_id)
  end
end
