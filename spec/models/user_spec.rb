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

  describe '.create_from_provider_data' do
    it 'creates user from provider data' do
      provider = OpenStruct.new(
        provider: 'google_oauth2',
        uid: '1234567890',
        info: OpenStruct.new(
          first_name: 'John',
          last_name: 'Doe',
          email: 'john@doe.com'
        )
      )

      User.create_from_provider_data(provider)

      expect(User.count).to eq(1)
      expect(User.first).to have_attributes(
        first_name: 'John',
        last_name: 'Doe',
        email: 'john@doe.com'
      )
    end

    context 'when user already exists' do
      it 'returns existing user' do
        existing_user = create(
          :user,
          first_name: 'John',
          last_name: 'Doe',
          email: 'john@doe.com',
          provider: 'google_oauth2',
          uid: '1234567890'
        )
        provider = OpenStruct.new(
          provider: 'google_oauth2',
          uid: '1234567890',
          info: OpenStruct.new(
            first_name: 'John',
            last_name: 'Doe',
            email: 'john@doe.com'
          )
        )

        found_user = User.create_from_provider_data(provider)

        expect(found_user).to eq(existing_user)
      end
    end
  end
end
