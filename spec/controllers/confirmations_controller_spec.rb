RSpec.describe ConfirmationsController do
  describe '#show' do
    it 'generates reset password token' do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = create(:user, :unconfirmed, reset_password_token: nil)

      get :show, params: { confirmation_token: user.confirmation_token.to_s }
      user.reload

      expect(user.reset_password_token).to be_present
    end

    it 'redirects to password setting form' do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = create(:user, :unconfirmed)

      get :show, params: { confirmation_token: user.confirmation_token.to_s }

      expect(response.status).to eq(302)
      expect(response.body).to include('/users/password/edit?reset_password_token=')
    end
  end
end
