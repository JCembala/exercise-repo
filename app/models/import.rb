class Import < ApplicationRecord
  include AASM

  aasm do
    state :in_progress, initial: true
    state :succeded, :failed

    event :success do
      transitions from: :in_progress, to: :succeded
    end

    event :failure do
      transitions from: :in_progress, to: :failed,
                  after: proc { |e| self.error_message = e.message }
    end
  end
end
