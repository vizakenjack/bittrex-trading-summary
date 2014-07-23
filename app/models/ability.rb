class Ability
  include CanCan::Ability

  def initialize(current_user)
    current_user ||= User.new
    signed_in = !current_user.new_record?

    if signed_in
      can :manage, :all  if current_user.role == 'admin'
      can :manage, [OrdersHistory, Trade, Api], :user_id => current_user.id
      can :read, [OrdersHistory, Trade]
      cannot [:edit, :destroy], OrdersHistory, added_by: "API"
    end
  end
end
