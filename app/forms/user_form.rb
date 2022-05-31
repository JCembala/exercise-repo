class UserForm < Patterns::Form
  attribute :first_name, String
  attribute :last_name, String
  attribute :password, String
  attribute :email, String

  validates :first_name, :password, :email, presence: true
  validates :password, length: { minimum: 8 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  private

  def persist
    update_user
  end

  def update_user
    resource.update(attributes)
  end
end
