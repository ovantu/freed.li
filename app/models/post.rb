class Post < ActiveRecord::Base
  belongs_to :feed, :class_name => "Feed", :foreign_key => "feed_id"
  belongs_to :user, :class_name => "User", :foreign_key => "creator_id"
end
