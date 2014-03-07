class HomeController < ApplicationController
  def index
    @users = User.all
    render :layout => "home"
  end

  
end
