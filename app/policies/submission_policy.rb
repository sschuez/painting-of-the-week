class SubmissionPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def new?
    true
  end

  def show?
    new?
  end

  def create?
    new?
  end

  def edit?
    user_is_owner_or_admin?
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  private

  def user_is_owner_or_admin?
    user == record.user || user&.admin
  end
end
