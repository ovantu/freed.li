class Feed < ActiveRecord::Base
  has_many :posts, :class_name => "Post", :foreign_key => "feed_id"
  validates :goal, length: { in: 10..160 }
  validates :rule1, length: { in: 10..160 }
  validates :rule2, length: { in: 0..160 }
  validates :rule3, length: { in: 0..160 }
  validates :rule4, length: { in: 0..160 }
  validates :rule5, length: { in: 0..160 }
  
  scope :all_actives, -> {where(status: "active")}
  scope :all_toddlers, -> {where(status: "toddler")}
  
  
  # returns an array with all the user_ids of unique contributors of "active" or "free" posts
  def contributors
    p = posts.where(status: ["active", "free"]).select(:creator_id).distinct
    c = []
    p.each do |post|
      # create an array of all contributor ids
      c.push (post.creator_id) 
    end
    c
  end

end
