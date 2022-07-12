require 'rails_helper'

RSpec.describe Admin::UsersController do
  describe 'GET /index' do
    context 'when user is not logged in' do
      it 'redirects to /users/sign_in and returns 302' do
        user = create(:user)
        get :edit, params: { id: user.id }

        expect(response).to redirect_to '/users/sign_in'
        expect(response.status).to eq(302)
      end
    end

    context 'when user is logged in' do
      context 'when user is an admin' do
        it 'returns 200' do
          admin = create(:user, :admin)
          sign_in admin

          get :index

          expect(response).to be_successful
        end

        context 'when user is not an admin' do
          it 'redirects to root_path' do
            user = create(:user)
            sign_in user

            get :index

            expect(response).to redirect_to :root
            expect(response.status).to eq(302)
          end

          it 'displays an alert' do
            user = create(:user)
            sign_in user

            get :index

            expect(flash[:alert]).to eq(I18n.t('not_authorized'))
          end
        end
      end
    end
  end

  describe 'GET /{user.id}/edit' do
    context 'when user is an admin' do
      it 'returns 200' do
        admin = create(:user, :admin)
        user = create(:user)
        sign_in admin

        get :edit, params: { id: user.id }

        expect(request.path).to eq "/admin/users/#{user.id}/edit"
        expect(response.status).to eq(200)
      end
    end

    context 'when user is not an admin' do
      it 'redirects to root and returns 302' do
        user = create(:user)
        other_user = create(:user)
        sign_in user

        get :edit, params: { id: other_user.id }

        expect(response).to redirect_to :root
        expect(response.status).to eq(302)
      end

      it 'displays an alert with not_authorized message' do
        user = create(:user)
        other_user = create(:user)
        sign_in user

        get :edit, params: { id: other_user.id }

        expect(flash[:alert]).to eq(I18n.t('not_authorized'))
      end
    end
  end

  describe 'PATCH /update' do
    context 'when user is an admin' do
      it 'updates successfully other user' do
        admin = create(:user, :admin)
        user = create(:user, first_name: 'Joe', last_name: 'Ben')
        sign_in admin

        patch :update, params: { id: user.id, user: { first_name: 'Mike', last_name: 'Bang' } }
        user.reload

        expect(user).to have_attributes(
          first_name: 'Mike',
          last_name: 'Bang'
        )
      end

      it 'display an notice with message user.updated' do
        admin = create(:user, :admin)
        user = create(:user, first_name: 'Joe', last_name: 'Ben')
        sign_in admin

        patch :update, params: { id: user.id, user: { first_name: 'Mike', last_name: 'Bang' } }
        user.reload

        expect(flash[:notice]).to eq(I18n.t('user.updated'))
      end
    end

    context 'when user is not an admin' do
      it 'returns 302' do
        user = create(:user)
        user_to_patch = create(:user, first_name: 'Joe', last_name: 'Ben')
        sign_in user

        patch :update, params: {
          id: user_to_patch.id,
          user: { first_name: 'Mike', last_name: 'Bang' }
        }
        user_to_patch.reload

        expect(response).to redirect_to :root
        expect(response.status).to eq(302)
      end

      it 'displays an alert with not_authorized message' do
        user = create(:user)
        user_to_patch = create(:user, first_name: 'Joe', last_name: 'Ben')
        sign_in user

        patch :update, params: {
          id: user_to_patch.id,
          user: { first_name: 'Mike', last_name: 'Bang' }
        }
        user_to_patch.reload

        expect(flash[:alert]).to eq(I18n.t('not_authorized'))
      end
    end
  end
end
