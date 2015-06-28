class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create]
  before_action :set_user, only: [:update, :show, :edit, :messages]

  CONNECTOR = ConnectorFactory.connection

  def show
    @group_membership = User.group_membership(current_user)
    @groups = @user.groups
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.validate and
       CONNECTOR.create_user(@user) and
        @user.save
      log_in @user
      flash[:success] = "Welcome to Tindbike!"
      redirect_to @user
    else
      flash[:danger] = @user.errors_backend.map{ |error| error[:text] }.join("</br>").html_safe
      render 'new'
    end
  end

  def edit
  end

  def messages
    @recieved_messages = @user.recieved_messages
    @send_messages = @user.send_messages
  end

  def update
    respond_to do |format|
      old_user = @user.dup
      @user.assign_attributes(user_params)
      if @user.validate and
          CONNECTOR.connection(old_user).update_user(old_user.username, old_user, @user) and
          @user.save
        format.html { redirect_to @user }
        flash[:success] = 'User was successfully updated.'
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
