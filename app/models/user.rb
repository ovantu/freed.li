class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :feeds, :class_name => "feed", :foreign_key => "creator_id"   
  has_many :evaluations    
  has_many :eval_posts, :through => :evaluations, :source => :post
  
end
