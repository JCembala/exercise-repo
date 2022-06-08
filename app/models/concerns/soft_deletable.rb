module SoftDeletable
  extend ActiveSupport::Concern

  included do
    default_scope { where(deleted_at: nil) }
    scope :only_deleted, -> { unscope(where: :deleted_at).where.not(deleted_at: nil) }
    scope :all_with_deleted, -> { unscope(where: :deleted_at) }
  end

  def delete
    update(deleted_at: Time.now.utc) if has_attribute? :deleted_at
  end

  def destroy
    delete
  end

  def self.included(klass)
    klass.extend Callbacks
  end

  module Callbacks
    def self.extended(klass)
      klass.define_callbacks :restore
      klass.define_singleton_method('before_restore') do |*args, &block|
        set_callback(:restore, :before, *args, &block)
      end
      klass.define_singleton_method('around_restore') do |*args, &block|
        set_callback(:restore, :around, *args, &block)
      end
      klass.define_singleton_method('after_restore') do |*args, &block|
        set_callback(:restore, :after, *args, &block)
      end
    end
  end

  def restore!
    self.class.transaction do
      run_callbacks(:restore) do
        update(deleted_at: nil)
      end
    end
    self
  end

  alias restore restore!
end
