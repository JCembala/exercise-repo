require 'rails_helper'

RSpec.describe Admin::UsersController do
  describe 'authorize' do
    context 'when user is an admin' do
      context 'when accessing #index' do
        it 'has successfully accessed' do
          admin = create(:admin)
          sign_in admin

          get :index

          expect(request.path).to eq admin_users_path
          expect(response).to be_successful
        end
      end

      context 'when accessing #update' do
        it 'has successfully accessed' do
          admin = create(:admin)
          user = create(:user)
          sign_in admin

          get :update, params: { id: user.id }

          expect(request.path).to eq "/admin/users/#{user.id}"
        end
      end

      context 'when accessing #edit of other user' do
        it 'has successfully accessed' do
          admin = create(:admin)
          user = create(:user)
          sign_in admin

          get :edit, params: { id: user.id }

          expect(request.path).to eq "/admin/users/#{user.id}/edit"
          expect(response).to be_successful
        end
      end

      context 'when updating another user' do
        it 'is updated successfully' do
          admin = create(:admin)
          user = create(:user)
          sign_in admin

          patch :update, params: { id: user.id, user: { first_name: 'Mike', last_name: 'Bang' } }
          user.reload

          expect(response).to redirect_to '/admin/users'
          expect(user).to have_attributes(
            first_name: 'Mike',
            last_name: 'Bang'
          )
        end
      end
    end

    context 'when user is not an admin' do
      context 'when accessing #index' do
        it 'is redirected to root' do
          user = create(:user)
          sign_in user

          get :index

          expect(response).to redirect_to :root
        end

        it 'shows alert' do
          user = create(:user)
          sign_in user

          get :index

          expect(flash[:alert]).to be_present
        end
      end
      context 'when accessing #edit of other user' do
        it 'is redirected to root' do
          user = create(:user)
          other_user = create(:user)
          sign_in user

          get :edit, params: { id: other_user.id }

          expect(response).to redirect_to :root
        end

        it 'shows alert' do
          user = create(:user)
          other_user = create(:user)
          sign_in user

          get :edit, params: { id: other_user.id }

          expect(flash[:alert]).to be_present
        end
      end
    end
  end
end
