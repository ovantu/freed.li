class Feed < ActiveRecord::Base
  has_many :posts, :class_name => "Post", :foreign_key => "feed_id"
end
