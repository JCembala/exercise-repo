require 'rails_helper'

RSpec.describe User do
  describe '#archive' do
    it 'marks user as archived by setting archived_at' do
      user = create(:user)

      user.archive

      expect(user.archived_at).not_to be(nil)
    end
  end

  describe '#restore' do
    it 'restores user by setting archived_at with nil' do
      user = create(:user, :archived)

      user.restore

      expect(user.archived_at).to be(nil)
    end
  end
end
