RSpec.describe 'Feeds', type: :request do
  describe 'GET /index' do
    context 'when user is authenticated' do
      it 'renders a successful response' do
        user = create(:user)
        sign_in user

        get '/feeds'

        expect(response).to be_successful
        expect(response).to render_template(:index)
      end

      it 'displays followed users posts' do
        user = create(:user)
        sign_in user
        followee_1 = create(:user)
        followee_2 = create(:user)
        Follow.create(follower_id: user.id, followed_id: followee_1.id)
        Follow.create(follower_id: user.id, followed_id: followee_2.id)
        create(:post, user: followee_1)
        create(:post, user: followee_2)

        get '/feeds'

        assert_select 'ul#posts' do |elements|
          elements.each do |element|
            assert_select element, 'li', 2
          end
        end
      end

      it 'displays followed users posts title' do
        user = create(:user)
        sign_in user
        followee_1 = create(:user)
        followee_2 = create(:user)
        Follow.create(follower_id: user.id, followed_id: followee_1.id)
        Follow.create(follower_id: user.id, followed_id: followee_2.id)
        create(:post, title: 'followee_1 post title', user: followee_1)
        create(:post, title: 'followee_2 post title', user: followee_2)

        get '/feeds'

        expect(response.body).to include('followee_1 post title')
        expect(response.body).to include('followee_2 post title')
      end

      it 'displays followed users posts content' do
        user = create(:user)
        sign_in user
        followee_1 = create(:user)
        followee_2 = create(:user)
        Follow.create(follower_id: user.id, followed_id: followee_1.id)
        Follow.create(follower_id: user.id, followed_id: followee_2.id)
        create(:post, content: 'followee_1 post content', user: followee_1)
        create(:post, content: 'followee_2 post content', user: followee_2)

        get '/feeds'

        expect(response.body).to include('followee_1 post content')
        expect(response.body).to include('followee_2 post content')
      end

      it 'does not display posts of not followed users' do
        user = create(:user)
        sign_in user

        user_1 = create(:user)
        user_2 = create(:user)
        create(:post, title: 'user_1 post title', user: user_1)
        create(:post, title: 'user_2 post title', user: user_2)

        get '/feeds'

        assert_select 'ul#posts' do |elements|
          elements.each do |element|
            assert_select element, 'li#post', false, 'This page must contain no posts'
          end
        end
      end

      it 'does not display user own posts' do
        user = create(:user)
        sign_in user

        create(:post, title: 'user post 1 title', user: user)

        get '/feeds'

        assert_select 'ul#posts' do |elements|
          elements.each do |element|
            assert_select element, 'li#post', false, 'This page must contain no posts'
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
