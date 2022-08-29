RSpec.describe 'ApiKey', type: :request do
  describe 'PATCH /update' do
    context 'when user is authenticated' do
      it 'updates api key' do
        user = create(:user)
        sign_in user

        patch user_api_keys_path(user)

        expect(user.api_key).not_to be(nil)
      end

      context 'and accessing other users api key' do
        it 'redirects to /users/edit and returns 302' do
          user = create(:user)
          user_2 = create(:user)
          sign_in user

          patch user_api_keys_path(user_2)

          expect(response).to redirect_to '/users/edit'
          expect(response.status).to eq(302)
        end
      end

      context 'and user has API key' do
        it 'generates a new API key and overrides old one' do
          user = create(:user, api_key: 'test_api_key')
          sign_in user

          patch user_api_keys_path(user)

          expect(user.api_key).not_to eq('test_api_key')
        end
      end
    end

    context 'when user is not authenticated' do
      it 'returns 401' do
        user = create(:user)

        patch user_api_keys_path(user)

        expect(response.status).to eq(401)
      end
    end

    context 'when user did not generate API key for the first time' do
      it 'is empty' do
        user = create(:user)

        expect(user.api_key).to be(nil)
      end
    end
  end
end
