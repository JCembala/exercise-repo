require 'rails_helper'

RSpec.describe SoftDeletable do
  describe '#delete' do
    it 'marks user as deleted by setting deleted_at' do
      user = create(:user)

      user.delete

      expect(user.deleted_at).not_to be(nil)
    end
  end

  describe '#destroy' do
    it 'marks user as deleted by setting deleted_at' do
      user = create(:user)

      user.destroy

      expect(user.deleted_at).not_to be(nil)
    end
  end

  describe '#restore' do
    it 'restores user by setting deleted_at with nil' do
      user = create(:user)

      user.delete
      user.restore

      expect(user.deleted_at).to be(nil)
    end
  end
end
