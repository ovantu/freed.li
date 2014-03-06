class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @contributed_feeds = Feed.all_contributed_feeds(params[:id])
  end
  
  def update
    authorize! :update, @user, :message => 'Not authorized as an administrator.'
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user], :as => :admin)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end
    
  def destroy
    authorize! :destroy, @user, :message => 'Not authorized as an administrator.'
    user = User.find(params[:id])
    unless user == current_user
      user.destroy
      redirect_to users_path, :notice => "User deleted."
    else
      redirect_to users_path, :notice => "Can't delete yourself."
    end
  end
  
  def set_feed_languages
    # authorize! :update, current_user, :message => 'Not authorized as an administrator.'
    if params[:id]
      user = User.find(params[:id])
    else
      user = current_user
    end
    if user.update(feedlang: params[:lang])
      redirect_to feeds_path, :notice => "Languages for feed updated."
    else
      redirect_to edit_user_registration_path, :alert => "Unable to update user."
    end
  end
  
end