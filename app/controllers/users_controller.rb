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
    current_user.groups << Group.find(params[:group_id])
    current_user.save
    redirect_to groups_path
  end

  private

  def user_params
    params.require(:user).permit(:username, :name, :email, :password,
      :password_confirmation)
  end
end
