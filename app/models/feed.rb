class Feed < ActiveRecord::Base
  has_paper_trail :ignore => [:last_activity, :contributor_count, :updated_at, :status]
  has_many :evaluations, :class_name => "Evaluation", :foreign_key => "feed_id"
  has_many :posts, :class_name => "Post", :foreign_key => "feed_id"
  
  validates :goal, length: { in: 10..160 }
  validates :rule1, length: { in: 10..160 }
  validates :rule2, length: { in: 10..160 }
  validates :rule3, length: { in: 0..160 }
  validates :rule4, length: { in: 0..160 }
  validates :rule5, length: { in: 0..160 }
  
  scope :all_active, -> {where(status: "active")}
  scope :all_free, -> {where(status: "free")}
  scope :all_contributed_feeds, -> (user_id){joins(:posts).where(posts:{creator_id: user_id}).distinct}
  
  # to show the user in the index view
  scope :all_feeds_user_needs_to_evaluate, -> (user_id){joins(:evaluations).where(evaluations:{status: "pending", user_id: user_id}).distinct(:feed)}
  
  # for the search controller
  scope :search, -> (query){where("goal LIKE ? OR rule1 LIKE ? OR rule2 LIKE ? OR rule3 LIKE ? OR rule4 LIKE ? OR rule5 LIKE ?", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%")}
  
  
  # returns an array with all the user_ids of unique contributors depending on the past status of the feed
  def contributors(status = self.status)
    if status == "free"
      stati = ["active", "free", "in_evaluation"]
    elsif status == "active"
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
  
  # returns an array with all the data (name, email, lang) of unique contributors depending on the past status of the feed
  def contributor_data
    User.select(:id, :name, :email, :lang).where(id: contributors)
  end
  
   # returns the Stage based on status and contributors
  def stage
    con = contributor_count
    case 
    when con >= STAGE_0_1
      if self.status == "free"
        1
      else
        2
      end
    when con >= STAGE_2
      3
    when con >= STAGE_3
      4
    when con >= STAGE_4
      5
    else
      if self.status == "free"
        0
      else
        1
      end
    end
  end
  
  # checks if the contributor is new; takes the real contributor count (a fresh created "in_evaluation" post does not increase contributor count in active feeeds)
  # used at post creation (contributors only change on "free" feeds) and post evaluation (acceptance and rejection)
  def update_stats(user_id, contributor_array = contributors)
    unless contributor_array.include? user_id
      self.contributor_count = contributor_array.count
    end
    self.last_activity = Time.now
    self.save
  end

  # This method updates the status of the feed if necessary from free to active; USED IN evaluations_controller
  def check_status_change_to_active
    c = posts.where(status: "active").select(:creator_id).distinct.size
    if c >= STAGE_0_1
      self.update(status: "active")
    end
  end

  def active_posts
    posts.where(status: "active")
  end
  

end