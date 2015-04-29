class GroupsController < ApplicationController
  
  def new
    @group = Group.new
  end

  def show
    @group = Group.find(params[:id])
  end

  def join
    group = Group.find(params[:group_id])
    members = group.users.pluck(:id)
    UserMessageService.send_messages(current_user.name +
      " ist der Gruppe " + group.name +
      " beigetreten.", members)
    current_user.groups << group
    current_user.save
    flash[:success] = "You successfully joined #{group.name}."
    redirect_to :back
  end

  def leave
    group = Group.find(params[:group_id])
    current_user.groups.delete(group)
    members = group.users.pluck(:id)
    UserMessageService.send_messages(current_user.name +
      " ist aus der Gruppe " + group.name +
      " ausgetreten.", members)
    flash[:success] = "You successfully left #{group.name}."
    redirect_to :back
  end



  before_action :authenticate_user!
  def index
    @group_membership = User.group_membership(current_user)
    @groups = Group.all
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      @group.users << current_user
      @group.save
      flash[:success] = "Group #{@group.name} was successfully created."
      redirect_to @group
    else
      render 'new'
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, :details, :picture)
  end
end
