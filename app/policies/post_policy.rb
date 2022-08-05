class PostPolicy < ApplicationPolicy
  def update?
    user.owner_of?(@record)
  end

  def edit?
    user.owner_of?(@record)
  end

  def destroy?
    user.owner_of?(@record)
  end
end
