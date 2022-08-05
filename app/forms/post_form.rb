class PostForm < Patterns::Form
  attribute :title, String
  attribute :content, String
  attribute :user_id, Integer

  validates :title, :content, presence: true
  validates :content, length: { maximum: 160 }, allow_blank: false

  private

  def persist
    if resource.user_id.present?
      resource.update(attributes.except(:user_id))
    else
      resource.update(attributes)
    end
  end
end
