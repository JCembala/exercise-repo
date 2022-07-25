require 'rails_helper'

RSpec.describe FollowedUsersController do
  describe 'GET #index' do
    it 'contains @followees variable with users that follow signed user' do
      user = create(:user)
      sign_in user
      follower_1 = create(:user)
      Follow.create(follower_id: user.id, followed_id: follower_1.id)
      follower_2 = create(:user)
      Follow.create(follower_id: user.id, followed_id: follower_2.id)

      get :index

      expect(assigns(:followees)).to eq([follower_1, follower_2])
    end

    it 'renders index template' do
      user = create(:user)
      sign_in user

      get :index

      expect(response).to render_template('index')
    end

    context 'with render_views' do
      render_views

      describe 'GET #index' do
        it 'displays user followers first name and last name' do
          user = create(:user)
          sign_in user
          follower_1 = create(:user, first_name: 'Andy', last_name: 'Frost')
          Follow.create(follower_id: user.id, followed_id: follower_1.id)
          follower_2 = create(:user, first_name: 'Jake', last_name: 'Peralta')
          Follow.create(follower_id: user.id, followed_id: follower_2.id)

          get :index

          expect(response.body).to include('<td>Andy</td>')
          expect(response.body).to include('<td>Frost</td>')
          expect(response.body).to include('<td>Jake</td>')
          expect(response.body).to include('<td>Peralta</td>')
        end
      end
    end
  end
end
