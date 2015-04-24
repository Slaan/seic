class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to Tindbike!"
      redirect_to @user
    else
      render 'new'
    end
    #debugger
  end

  def join_group
    group = Group.find(params[:group_id])
    current_user.groups << group
    current_user.save
    flash[:success] = "You successfully joined #{group.name}."
    redirect_to :back
  end

  private

  def user_params
    params.require(:user).permit(:username, :name, :email, :password,
      :password_confirmation)
  end
end
