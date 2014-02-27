class Feed < ActiveRecord::Base
  has_many :evaluations, :class_name => "Evaluation", :foreign_key => "feed_id"
  has_many :posts, :class_name => "Post", :foreign_key => "feed_id"
  validates :goal, length: { in: 10..160 }
  validates :rule1, length: { in: 10..160 }
  validates :rule2, length: { in: 10..160 }
  validates :rule3, length: { in: 0..160 }
  validates :rule4, length: { in: 0..160 }
  validates :rule5, length: { in: 0..160 }
  
  scope :all_adolescent, -> {where(status: "adolescent")}
  scope :all_toddlers, -> {where(status: "toddler")}
  scope :all_contributed_feeds, -> (user_id){joins(:posts).where(posts:{creator_id: user_id}).distinct}
  
  
  # returns an array with all the user_ids of unique contributors depending on the past status of the feed
  def contributors(status)
    if status == "toddler"
      stati = ["active", "free", "in_evaluation"]
    elsif status == "adolescent"
      stati = "active"
    end
    p = posts.where(status: stati).select(:creator_id).distinct
    c = []
    p.each do |post|
      # create an array of all contributor ids
      c.push (post.creator_id) 
    end
    c
  end
  

  # This method updates the status of the feed if necessary from toddler to adolescent; USED IN evaluations_controller
  def check_status_change_to_adolescence
    c = posts.where(status: "active").select(:creator_id).distinct.count
    if c >= MIN_CONTR_LVL1
      self.update(status: "adolescent")
    end
  end

  def active_posts
    posts.where(status: "active")
  end
  

end