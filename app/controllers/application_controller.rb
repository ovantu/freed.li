class ApplicationController < ActionController::Base
  # before_action :authenticate_user!
  before_action :set_locale
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

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


end
