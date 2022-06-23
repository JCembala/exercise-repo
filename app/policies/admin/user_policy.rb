module Admin
  class UserPolicy < ApplicationPolicy
    def index?
      user.admin?
    end

    def update?
      user.admin?
    end

    def edit?
      user.admin?
    end

    def show?
      false
    end

    def create?
      false
    end

    def destroy?
      false
    end
  end
end
