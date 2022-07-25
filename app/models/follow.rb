class Follow < ApplicationRecord
  # User is following someone
  belongs_to :follower, class_name: 'User'

  # User is being followed by another user
  belongs_to :followed, class_name: 'User'

  validates :follower, uniqueness: { scope: :followed }
end
