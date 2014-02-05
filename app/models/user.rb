class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :feeds, :class_name => "Feed", :foreign_key => "creator_id"
  has_many :posts, :class_name => "Post", :foreign_key => "creator_id"  
  has_many :evaluations    
  has_many :eval_posts, :through => :evaluations, :source => :post
  
  scope :rated_by, -> (user_id){joins(:questions_ratings).where(questions_ratings:{creator_id: user_id})}
  
  # shows all evaluations which are still pending
  def pending_evaluations
    e = evaluations.where(status: "pending")
  end
  
  # shows all posts that the user has to evaluate and still have to be evaluated
  def all_posts_to_be_evaluated
    e = eval_posts.where(evaluations:{status: "pending"})
  end
  
  # shows all posts for a FEED that the user has to evaluate and haven't been evaluated
  def posts_to_be_evaluated_in_feed(feed_id)
    e = eval_posts.where(evaluations:{status: "pending"}).where(feed_id: feed_id)
  end
  
  # shows all posts of a FEED that the user has to evaluate and are in_evaluation
  def posts_in_evaluation(feed_id)
    e = eval_posts.where(status: "in_evaluation").where(feed_id: feed_id)
  end
  
  def own_posts_in_evaluation_and_feed(feed_id)
    p = posts.where(status: "free", feed_id: feed_id)
  end
  
end
