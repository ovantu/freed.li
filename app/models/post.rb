class Post < ActiveRecord::Base
  belongs_to :feed, :class_name => "Feed", :foreign_key => "feed_id"
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  has_many :evaluations
  has_many :evaluators, :through => :evaluations, :source => :user
  
  scope :free_posts, -> (feed_id){where(feed_id: feed_id, status: "free")}
  scope :active_posts, -> (feed_id){where(feed_id: feed_id, status: "active")}
  scope :in_evaluation_posts, -> (feed_id){where(feed_id: feed_id, status: "in_evaluaiton")}
  
  # this should be nil, becuase accepted or rejected feeds should change all "pending" to "too_late"
  scope :broken_evaluations, -> {where(status: ["accepted", "rejected"]).joins(:evaluations).where(evaluations:{status: "pending"})}
  
  def all_evaluators
    evals = evaluations.all
    c = []
    evals.each do |ev|
      # create an array of all contributor ids
      c.push (ev.user_id) 
    end
    c
  end
  
  def users_evaluation(user_id)
    evaluations.where(user_id: user_id).first
  end
  
  # all remaining pending evaluations for this post get status "too_late"
  def too_late_evaluations
    evaluations.where(status: ["pending"]).each do |ev|
      ev.update(status: "too_late")
    end
  end
  
  
end
