module Archivable
  extend ActiveSupport::Concern

  included do
    scope :archived, -> { where.not(archived_at: nil) }
    scope :active, -> { where(archived_at: nil) }
  end

  def archive
    update(archived_at: Time.now.utc)
  end

  def restore
    update(archived_at: nil)
  end
end
