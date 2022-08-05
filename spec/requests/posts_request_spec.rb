RSpec.describe '/posts', type: :request do
  describe 'GET /index' do
    context 'when user is authenticated' do
      it 'renders a successful response' do
        user = create(:user)
        sign_in user
        create(:post, user_id: user.id)

        get posts_url

        expect(response).to be_successful
      end

      it 'displays user posts' do
        user = create(:user)
        sign_in user
        create(:post, user_id: user.id)
        create(:post, user_id: user.id)

        get posts_url

        assert_select 'ul#posts' do |elements|
          elements.each do |element|
            assert_select element, 'li#post', 2
          end
        end
      end

      it 'displays user posts title and content' do
        user = create(:user)
        sign_in user
        create(:post, title: 'user post 1 title', content: 'user post 1 content', user_id: user.id)
        create(:post, title: 'user post 2 title', content: 'user post 2 content', user_id: user.id)

        get posts_url

        expect(response.body).to include('user post 1 title')
        expect(response.body).to include('user post 2 title')
        expect(response.body).to include('user post 1 content')
        expect(response.body).to include('user post 2 content')
      end

      it 'does not display other users posts' do
        user = create(:user)
        sign_in user

        user_1 = create(:user)
        user_2 = create(:user)
        create(:post, title: 'user_1 post title', user_id: user_1.id)
        create(:post, title: 'user_2 post title', user_id: user_2.id)

        get posts_url

        assert_select 'ul#posts' do |elements|
          elements.each do |element|
            assert_select element, 'li#post', false, 'This page must contain no posts'
          end
        end
      end
    end

    context 'when user is unauthenticated' do
      it 'redirects to /users/sign_in and returns 302' do
        get posts_url

        expect(response).to redirect_to '/users/sign_in'
        expect(response.status).to eq(302)
      end
    end
  end

  describe 'GET /show' do
    context 'when user is authenticated' do
      it 'renders a newly created post and successful response' do
        user = create(:user)
        sign_in user
        post = create(:post, title: 'Prison Escapes', user_id: user.id)

        get post_url(post)

        expect(response).to be_successful
        expect(response.body).to include('<strong>Title:</strong>')
        expect(response.body).to include('Prison Escapes')
        expect(response.body).to include('<strong>Content:</strong>')
      end

      it 'returns 401 when trying to render other user post' do
        user = create(:user)
        other_user = create(:user)
        sign_in user
        post = create(:post, title: 'Prison Escapes', user_id: other_user.id)

        get post_url(post)

        expect(response.status).to eq 401
      end
    end

    context 'when user is unauthenticated' do
      it 'redirects to /users/sign_in and returns 302' do
        post = create(:post)

        get post_url(post)

        expect(response).to redirect_to '/users/sign_in'
        expect(response.status).to eq(302)
      end
    end
  end

  describe 'GET /new' do
    context 'when user is authenticated' do
      it 'renders a successful response' do
        user = create(:user)
        sign_in user

        get new_post_url

        expect(response).to be_successful
      end
    end

    context 'when user is unauthenticated' do
      it 'redirects to /users/sign_in and returns 302' do
        get new_post_url

        expect(response).to redirect_to '/users/sign_in'
        expect(response.status).to eq(302)
      end
    end
  end

  describe 'GET /:id/edit' do
    context 'when user is authenticated' do
      it 'renders a form and successful response' do
        user = create(:user)
        sign_in user
        post = create(:post, title: 'Update Post', content: 'I will update this post', user_id: user.id)

        get edit_post_url(post)

        expect(response).to be_successful
        expect(response.body).to include('<h1>Editing post</h1>')
        expect(response.body).to include('Update Post')
        expect(response.body).to include('I will update this post')
      end
    end

    context 'when user is unauthenticated' do
      it 'redirects to /users/sign_in and returns 302' do
        post = create(:post)

        get edit_post_url(post)

        expect(response).to redirect_to '/users/sign_in'
        expect(response.status).to eq(302)
      end
    end
  end

  describe 'POST /create' do
    context 'when user is authenticated' do
      context 'with valid parameters' do
        it 'creates a new Post' do
          user = create(:user)
          sign_in user

          expect do
            post posts_url, params: { post: { title: 'My Title', content: 'My content' } }
          end.to change(Post, :count).from(0).to(1)
        end

        it 'redirects to posts list' do
          user = create(:user)
          sign_in user

          post posts_url, params: { post: { title: 'My Title', content: 'My content' } }

          expect(response).to redirect_to(posts_url)
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new Post' do
          user = create(:user)
          sign_in user

          params = { post:
            {
              title: 'My Title',
              context: 'Too long content Too long content Too long content
                      Too long content Too long content Too long content
                      Too long content Too long content Too long content'
            } }

          expect { post posts_url, params: params }.not_to change(Post, :count)
        end

        it 'renders a response with 422 status' do
          user = create(:user)
          sign_in user
          params = { post:
            {
              title: 'My Title',
              context: 'Too long content Too long content Too long content
                      Too long content Too long content Too long content
                      Too long content Too long content Too long content'
            } }

          post posts_url, params: params

          expect(response).to have_http_status(:unprocessable_entity)
          expect(flash[:alert]).to eq('The post was not created')
        end
      end
    end

    context 'when user is unauthenticated' do
      it 'redirects to /users/sign_in and returns 302' do
        post posts_url, params: { post: { title: 'My Title', content: 'My content' } }

        expect(response).to redirect_to '/users/sign_in'
        expect(response.status).to eq(302)
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'when user is authenticated' do
      it 'destroys the requested post' do
        user = create(:user)
        sign_in user
        post = create(:post, user_id: user.id)

        expect { delete post_url(post) }.to change(Post, :count).by(-1)
      end

      it 'redirects to the posts list' do
        user = create(:user)
        sign_in user
        post = create(:post, user_id: user.id)

        delete post_url(post)

        expect(response).to redirect_to(posts_url)
      end
    end

    context 'when user is unauthenticated' do
      it 'redirects to /users/sign_in and returns 302' do
        post = create(:post)

        delete post_url(post)

        expect(response).to redirect_to '/users/sign_in'
        expect(response.status).to eq(302)
      end
    end
  end

  describe 'PATCH /update' do
    context 'when user is authenticated' do
      it 'updates post' do
        user = create(:user)
        sign_in user
        post = create(:post, user_id: user.id, title: 'Title', content: 'Content')

        patch post_url(post), params: { post: { title: 'Updated title', content: 'Updated content' } }
        post.reload

        expect(post).to have_attributes(
          title: 'Updated title',
          content: 'Updated content'
        )
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to /users/sign_in and returns 302' do
        post = create(:post)

        patch post_url(post)

        expect(response).to redirect_to '/users/sign_in'
        expect(response.status).to eq(302)
      end
    end
  end
end
