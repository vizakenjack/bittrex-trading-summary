class Ability
  include CanCan::Ability

  def initialize(current_user)
    current_user ||= User.new
    signed_in = !current_user.new_record?

    if signed_in
      can :manage, [OrdersHistory, Trade, Api], :user_id => current_user.id
      cannot [:edit, :destroy], OrdersHistory, added_by: "API"
      can :manage, :all  if current_user.role == 'admin'
    end
    can :read, [OrdersHistory, Trade]

  end
end
