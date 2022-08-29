RSpec.describe 'Followed Users', type: :request do
  describe 'GET /index' do
    context 'when user is authenticated' do
      it 'renders a successful response' do
        user = create(:user)
        sign_in user

        get '/followed_users'

        expect(response).to be_successful
        expect(response).to render_template(:index)
      end

      it 'displays user followers first name and last name' do
        user = create(:user)
        sign_in user
        follower_1 = create(:user, first_name: 'Andy', last_name: 'Frost')
        Follow.create(follower_id: user.id, followed_id: follower_1.id)
        follower_2 = create(:user, first_name: 'Jake', last_name: 'Peralta')
        Follow.create(follower_id: user.id, followed_id: follower_2.id)
        create(:user, first_name: 'Mark', last_name: 'Dope')

        get '/followed_users'

        expect(response.body).to include('<td>Andy</td>')
        expect(response.body).to include('<td>Frost</td>')
        expect(response.body).to include('<td>Jake</td>')
        expect(response.body).to include('<td>Peralta</td>')
      end

      it 'displays table with followees' do
        user = create(:user)
        sign_in user
        follower_1 = create(:user, first_name: 'Andy', last_name: 'Frost')
        Follow.create(follower_id: user.id, followed_id: follower_1.id)
        follower_2 = create(:user, first_name: 'Jake', last_name: 'Peralta')
        Follow.create(follower_id: user.id, followed_id: follower_2.id)
        create(:user, first_name: 'Mark', last_name: 'Dope')

        get '/followed_users'

        assert_select 'tbody' do |elements|
          elements.each do |element|
            assert_select element, 'tr#followee', 2
          end
        end
      end

      it 'does not display anything when user has no followee' do
        user = create(:user)
        sign_in user

        get '/followed_users'

        assert_select 'tbody' do |elements|
          elements.each do |element|
            assert_select element, 'tr#followee', false, 'This page must contain no followee'
          end
        end
      end
    end

    context 'when user is unauthenticated' do
      it 'redirects to /users/sign_in and returns 302' do
        get '/feeds'

        expect(response).to redirect_to '/users/sign_in'
        expect(response.status).to eq(302)
      end
    end
  end
end
