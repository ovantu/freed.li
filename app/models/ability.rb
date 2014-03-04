class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.has_role? :admin
      can :manage, :all
    elsif user != ""
      # All users, except guests:
      can :create, [Feed, Post]  
      can :read, [Feed, Post]  
    end
  end
end
