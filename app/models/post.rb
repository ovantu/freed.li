class Post < ActiveRecord::Base
  belongs_to :feed, :class_name => "Feed", :foreign_key => "feed_id"
  belongs_to :user, :class_name => "User", :foreign_key => "creator_id"
  has_many :evaluations
  has_many :evaluators, :through => :evaluations, :source => :user
  
  scope :free_posts, -> (feed_id){where(feed_id: feed_id, status: "free")}
  
end