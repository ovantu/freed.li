class ApplicationController < ActionController::Base
  # before_action :authenticate_user!
  before_action :set_locale
  # before_action :check_changes
  before_action :check_notifications
  # before_filter :authenticate

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end
  
  USERS = { "alpha" => "tester!" }

  
  # for the closed alpha version
  def authenticate
    authenticate_or_request_with_http_digest("Application") do |name|
      USERS[name]
    end
  end
  
  # # TO DO: add activities with new features
  # def last_activity(user = current_user)
  #   last_post = Post.select(:updated_at).where(creator_id: user.id, status: ["free", "in_evaluation"]).order(updated_at: :desc).first  # user can't make active, so free and in_evaluation would be his last actions; inacurate as user's post could be altered by others
  #   last_evaluation = Evaluation.select(:updated_at).where(user_id: user.id, status: ["accepted", "declined", "pass"]).order(updated_at: :desc).first  #again just checking for actions the user can actively do
  #   last_feed = Feed.select(:updated_at).where(creator_id: user.id, status: "free").order(updated_at: :desc).first
  #   timestamps = [last_post.updated_at, last_evaluation.updated_at, last_feed.updated_at, user.last_sign_in_at]
  #   last_Activity = timestamps.last
  # end
  # 
  # def check_changes(user = current_user)
  #   changed_posts = Post.where("updated_at >= :date", date: user.last_sign_in_at)
  #   some_date = Time.now
  #   Item.where("created_at >= :date OR updated_at >= :date", date: some_date.tomorrow.beginning_of_day)
  # end
  
  # reads out the params locale automatically out of URL or browser setting and compare to the available languages
  def set_locale
    if current_user
      # sets users page langauge
      I18n.locale = current_user.lang
    elsif LANGUAGES_STRING.include? params[:lang_change]  #checks on the Home page for language change
      I18n.locale = params[:lang_change]
      redirect_to root_path  # for a nicer URL
    else
      I18n.locale = params[:locale] || http_accept_language.compatible_language_from(LANGUAGES_STRING)
    end
   # I18n.locale = params[:locale] || I18n.default_locale

  end
  
  # Automatic setting and insertion of locale in link generation
  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { locale: I18n.locale }
  end

  def check_notifications
    if flash[:send_stage_notification]
      # SEND NOTIFICATIONS to contributors for change to higher Stage
      feed = Feed.find(flash[:send_stage_notification])
      User.where(id: feed.contributors).each do |contributor|
        Notifier.feed_next_stage(feed, contributor).deliver
      end
      # for testing 0.0.0.0:3000
      # Notifier.feed_next_stage(feed, User.find(7)).deliver
    end
  end

end
