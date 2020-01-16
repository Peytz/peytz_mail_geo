class Client < ApplicationRecord
  before_validation :generate_api_key, :set_default_role

  enum role: { admin: 0, client: 1 }

  validates :role, presence: true, inclusion: { in: roles.keys }
  validates :name, presence: true, uniqueness: true
  validates :api_key, presence: true, uniqueness: true

  def authenticate!(api_key)
    raise ActiveRecord::RecordNotFound if self.api_key != api_key
    self
  end

  def self.authenticate!(name, api_key = nil)
    sa = Client.find_by!(name: name)
    sa.authenticate!(api_key)
  end

  private

  def generate_api_key
    begin
      self.api_key ||= SecureRandom.urlsafe_base64
    end while self.class.exists?(api_key: self.api_key)
  end

  def set_default_role
    self.role ||= 1
  end
end
