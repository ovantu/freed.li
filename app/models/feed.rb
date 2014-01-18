class Feed < ActiveRecord::Base
  has_many :posts, :class_name => "Post", :foreign_key => "feed_id"
  
  def contributors
    posts.select(:creator_id).distinct
  end

end
