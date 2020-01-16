class ClientPolicy < ApplicationPolicy
  def show?
    return true if user.admin?
    false
  end
end
