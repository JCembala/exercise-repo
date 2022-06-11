require 'rails_helper'

RSpec.describe UsersController do
  context 'when user is an admin' do
    context 'when accessing /users path' do
      it 'can access /users path' do
        admin = create(:admin)
        sign_in admin

        get :show

        expect(request.path).to eq users_path
        expect(response).to be_successful
      end
    end
  end

  context 'when user is not an admin' do
    context 'when accessing /users path' do
      it 'is redirected to #index' do
        user = create(:user)
        sign_in user

        get :show

        expect(response).to redirect_to :root
      end

      it 'shows alert' do
        user = create(:user)
        sign_in user

        get :show

        expect(flash[:alert]).to be_present
      end
    end
  end
end
