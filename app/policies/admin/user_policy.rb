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

    def new?
      user.admin?
    end
  end
end
