class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :feeds, :class_name => "feed", :foreign_key => "creator_id"   
  has_many :evaluations    
  has_many :eval_posts, :through => :evaluations, :source => :post
  
  scope :rated_by, -> (user_id){joins(:questions_ratings).where(questions_ratings:{creator_id: user_id})}
  
  def pending_evaluations
    e = evaluations.where(status: "pending")
  end
  
  def all_posts_to_be_evaluated
    e = eval_posts.where(evaluations:{status: "pending"})
  end
  
  def posts_to_be_evaluated_in_feed(feed_id)
    e = eval_posts.where(evaluations:{status: "pending"}).where(feed_id: feed_id)
  end
  
  def posts_in_evaluation(feed_id)
    e = eval_posts.where(status: "in_evaluation").where(feed_id: feed_id)
  end
  
end
