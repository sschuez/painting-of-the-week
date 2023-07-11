class ContactPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all if user.admin?
    end
  end

  def new?
    true
  end

  def create?
    new?
  end

  def show?
    user.admin?
  end

  def destroy?
    show?
  end
end
