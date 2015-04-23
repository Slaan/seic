class GroupsController < ApplicationController
  def new
  end

  def index
    @group_membership = current_user.groups.map { |group| group.id }
    @groups = Group.all
  end
end
