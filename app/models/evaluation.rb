class Evaluation < ActiveRecord::Base
  belongs_to :feed, :class_name => "Feed", :foreign_key => "feed_id"
  belongs_to :post, :class_name => "Post", :foreign_key => "post_id"
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  
  scope :all_evaluations_of_feed, -> (feed_id){joins(:post).where(posts:{feed_id: feed_id}, status: ["accepted", "declined", "passed", "pending"])}
  scope :not_pending_evaluations_of_feed, -> (feed_id){joins(:post).where(posts:{feed_id: feed_id}, status: ["accepted", "declined", "passed"])}
  scope :pending_evaluations_of_feed, -> (feed_id){joins(:post).where(posts:{feed_id: feed_id}, status: "pending")}
  
  # all evaluations that a User still has to do
  scope :pending_evaluations_of_user, -> (user_id){where(user_id: user_id, status: "pending")}
  
end
