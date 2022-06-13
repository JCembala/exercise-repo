class UserForm < Patterns::Form
  attribute :first_name, String
  attribute :last_name, String
  attribute :password, String
  attribute :email, String

  validates :first_name, :last_name, :password, :email, presence: true
  validates :password, length: { minimum: 8 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  private

  def persist
    if resource.email.present?
      resource.update(attributes.except(:email))
    else
      resource.update(attributes)
    end
  end
end
