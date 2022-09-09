class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  include Archivable

  has_many :following_users, foreign_key: :followed_id, class_name: 'Follow',
                             inverse_of: 'followed', dependent: :destroy
  has_many :followers, through: :following_users, source: :follower

  has_many :followed_users, foreign_key: :follower_id, class_name: 'Follow',
                            inverse_of: 'follower', dependent: :destroy
  has_many :followees, through: :followed_users, source: :followed

  has_many :posts, dependent: :destroy

  has_many_attached :feed_exports

  has_encrypted :api_key
  blind_index :api_key

  ransacker :full_name do |parent|
    Arel::Nodes::NamedFunction.new('CONCAT_WS', [
                                     Arel::Nodes.build_quoted(' '),
                                     parent.table[:first_name],
                                     parent.table[:last_name]
                                   ])
  end

  def followed_by?(user)
    followers.include? user
  end

  def owner_of?(resource)
    id == resource.user.id
  end

  protected

  def password_required?
    confirmed? ? super : false
  end
end
