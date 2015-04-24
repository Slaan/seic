class GroupsController < ApplicationController
  def new
  end

  def show
    @group = Group.find(params[:id])
  end

  before_action :authenticate_user!
  def index
    @group_membership = User.group_membership(current_user)
    @groups = Group.all
  end
end
