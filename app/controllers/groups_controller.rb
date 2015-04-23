class GroupsController < ApplicationController
  def new
  end

  before_action :authenticate_user!
  def index
    @group_membership = current_user.groups.map { |group| group.id }
    @groups = Group.all
  end
end
