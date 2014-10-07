class HomeController < ApplicationController
  def index
    @users = User.all
    render :layout => "home"
  end

  def trust
    render :layout => "application"
  end
  
end
