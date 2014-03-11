class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
         
  validates :name, presence: true
  validates :feedlang, presence: true
  
  serialize :feedlang
  serialize :parameters
         
  has_many :feeds, :class_name => "Feed", :foreign_key => "creator_id"
  has_many :posts, :class_name => "Post", :foreign_key => "creator_id"  
  has_many :evaluations    
  has_many :eval_posts, :through => :evaluations, :source => :post
  
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
  
  # shows all posts user created and are active
  def active_posts
    posts.where(status: "active")
  end
  
  # shows all posts user created and are declined
  def rejected_posts
    posts.where(status: "rejected")
  end
  
  # shows all posts of a FEED that the user has to evaluate and are in_evaluation
  def posts_in_evaluation(feed_id)
    e = eval_posts.where(status: "in_evaluation").where(feed_id: feed_id)
  end
  
  def own_posts_in_evaluation_and_feed(feed_id)
    p = posts.where(status: "free", feed_id: feed_id)
  end
  
  def trustworthiness(amount = TRUST_POST_NUMBER.to_i)
     # LIMIT geht irgednwie nicht
    # post_stati = posts.where(status: ["active","rejected"]).group(:status).last(amount).count
    last_posts = posts.where(status: ["active","rejected"]).last(amount)
    ac = 0.0
    re = 0.0
    total = 0.0
    last_posts.each do |lp|
      if lp.status == "active"
        ac = ac + 1
      elsif lp.status == "rejected"
        re = re + 1
      end
      total = total + 1
    end
    if total > 0  # to avoid division by 0
      trust = ac.to_f / total.to_f
    else
      trust = 1.0
    end
    [trust, ac.to_i, re.to_i]
  end
  
end
