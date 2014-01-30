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
  
  
  def contributors
    posts.select(:creator_id).distinct
  end

end
