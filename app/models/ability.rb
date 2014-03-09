class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.has_role? :admin
      can :manage, :all
    elsif user != ""
      # All users, except guests:
      can :create, [Feed, Post]  
      # should work with if user.trustworthiness[0] < TRUST_STAGE[Post.feed.stage]
      can :read, [Feed, Post]  
      # can :update, User, :id => user.id 
    end
  end
end
