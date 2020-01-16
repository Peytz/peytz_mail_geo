class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def show?
    return true if user.admin?
    user.client_id == record.client_id
  end

  def create?
    show?
  end

  def destroy?
    show?
  end
end
