class UsersController < ApplicationController
  
  before_action :logged_in_user, except: [:new]
  before_action :set_user, only: [:update, :show, :edit, :messages]

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

  def messages
    @recieved_messages = @user.recieved_messages
    @send_messages = @user.send_messages
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

      # Use callbacks to share common setup or constraints between actions.
    def set_user
      if params[:id]
        @user = User.find(params[:id])
      else
        @user = current_user
      end
    end

  def user_params
    params.require(:user).permit(:username, :name, :email, :password,
      :password_confirmation, :picture)
  end
end
