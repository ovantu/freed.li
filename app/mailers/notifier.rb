class Notifier < ActionMailer::Base
  default from: "no-reply@ovantu.com"
  
  def feed_stage_1(feed)
    @feed = feed
  end
  
  
  def welcome(user)
    @user = user
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end
  
end
