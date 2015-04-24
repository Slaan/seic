class GroupsController < ApplicationController
  def new
  end

  before_action :authenticate_user!
  def index
    @group_membership = User.group_membership(current_user)
    @groups = Group.all
  end
end
