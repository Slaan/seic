class UsersController < ApplicationController

  before_action :set_user, only: [:update, :show, :edit]

  def show
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

  def edit
  end

  def join_group
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

  
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        pry
        format.html { render :show }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  private

      # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

  def user_params
    params.require(:user).permit(:username, :name, :email, :password,
      :password_confirmation, :picture)
  end
end
