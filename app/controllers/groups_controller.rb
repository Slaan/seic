class GroupsController < ApplicationController

  before_action :logged_in_user
  before_action :set_group, only: [:show, :edit, :join, :leave, :update]
  
  def new
    @group = Group.new
  end

  def show
    @group_messages = @group.group_messages.paginate(page: params[:page])
  end

  def edit
  end

  def join
    UserMessageService.send_system_group_message(current_user.name +
      " ist der Gruppe " + @group.name +
      " beigetreten.", @group)
    current_user.groups << @group
    current_user.save
    flash[:success] = "You successfully joined #{@group.name}."
    redirect_to :back
  end

  def leave
    current_user.groups.delete(@group)
    UserMessageService.send_system_group_message(current_user.name +
      " ist aus der Gruppe " + @group.name +
      " ausgetreten.", @group)
    flash[:success] = "You successfully left #{@group.name}."
    redirect_to :back
  end

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

  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_group
    if params[:id]
      @group = Group.find(params[:id])
    end
    
    if params[:group_id]
      @group = Group.find(params[:group_id])
    end
  end

  def group_params
    params.require(:group).permit(:name, :details, :picture)
  end
end
