class Notifier < ActionMailer::Base
  default from: "no-reply@ovantu.com"
  
  def feed_next_stage(feed, user)
    # change language for translation files

    @feed = feed
    @user = user
    @evaluations = @user.posts_to_be_evaluated_in_feed(@feed.id)
    I18n.with_locale(@user.lang) do
      mail(to: @user.email, subject: t("fns_subject") + @feed.stage.to_s)
    end
  end
  
  
  def welcome(user)
    @user = user
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end
  
end
