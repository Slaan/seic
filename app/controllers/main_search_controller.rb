class MainSearchController < ApplicationController

  def index
    unless params[:search_text] != ""
      redirect_to :back
    end
    @users, @groups = MainSearch.for(params[:search_text])
    @group_membership = User.group_membership(current_user)
  end
  
end
