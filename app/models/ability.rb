class Ability
  include CanCan::Ability

  # CanCanCan will automatically initialize this class for you with every
  # request, so you don't have to instantiate the class yourself. CanCanCan
  # exepct that you have a method defined called `current_user` that will return
  # the user object of the currently signed in user or `nil` if the user is not
  # signed in.
  def initialize(user)

    # this will insantiate the `user` variable to a new `User` object if it's
    # nil or undefined
    user ||= User.new

    # this gives super powers to the admin. The admin here can do anything
    if user.is_admin?
      can :manage, :all
    end

    # this defines an ability that declares that the user can `manage` meaning
    # do any action (edit, update, destroy, read...etc) on an instance of the
    # Question class if `q.user == user` meaning if the owner of the question
    # is the currently signed in user
    # this line 👇 allows you to do can?(:manage, @question) in questions_controller.rb
    # and questions show page
    can :manage, Question do |q|
      # you should put an expression here that returns true / false. It should
      # return true when the user should be able to do the opertaion, which is
      # `manage` in this case
      q.user == user # <- currently signed user
      # even if user is not signed in 🖕 this user is User.new not nil
    end

    # cannot only defines the ability for the cannot?() method
    cannot :like, Question do |q|
      user == q.user
    end

    # can defines the ability for the can?() method
    can :like, Question do |q|
      user != q.user
    end

    can :vote, Question do |q|
      user != q.user
    end

    cannot :vote, Question do |q|
      user == q.user
    end

    can :manage, Vote do |v|
      user == v.user
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
