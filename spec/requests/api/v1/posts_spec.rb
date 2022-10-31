require 'rails_helper'

RSpec.describe 'Api::V1::Posts', type: :request do
  describe 'GET /index' do
    context 'when request is authenticated' do
      it 'returns list of users posts' do
        user = create(:user, api_key: '4050d1d2dfc9e0b0f3d331825cc64e3d')
        post_1 = create(:post, title: 'First test post', user: user)
        post_2 = create(:post, title: 'Second test post', user: user)
        create(:post, title: 'Third test post')

        get api_v1_posts_path, headers: { Authorization: 'Token token=4050d1d2dfc9e0b0f3d331825cc64e3d' }

        expect(response.status).to eq 200
        expect(json_body).to contain_exactly(
          {
            'content' => 'Valid content',
            'id' => post_1.id,
            'title' => 'First test post'
          },
          {
            'content' => 'Valid content',
            'id' => post_2.id,
            'title' => 'Second test post'
          }
        )
      end
    end

    context 'when token is not provided' do
      it 'returns 401' do
        get api_v1_posts_path

        expect(response.status).to eq 401
      end
    end

    context 'when token does not match' do
      it 'returns 401' do
        create(:user, api_key: '4050d1d2dfc9e0b0f3d331825cc64e3d')

        get api_v1_posts_path, headers: { Authorization: 'Token token=00000000000000000000000000000000' }

        expect(response.status).to eq 401
      end
    end
  end

  describe 'GET /show' do
    context 'when request is authenticated' do
      context 'when post belongs to user' do
        it 'returns users post' do
          user = create(:user, api_key: '4050d1d2dfc9e0b0f3d331825cc64e3d')
          post = create(:post, title: 'First test post', user: user)

          get api_v1_post_path(post.id), headers: { Authorization: 'Token token=4050d1d2dfc9e0b0f3d331825cc64e3d' }

          expect(response.status).to eq 200
          expect(json_body).to contain_exactly(
            ['content', 'Valid content'],
            ['id', post.id],
            ['title', 'First test post']
          )
        end
      end

      context 'when post does not belong to user' do
        it 'returns 404' do
          _autorized_user = create(:user, api_key: '4050d1d2dfc9e0b0f3d331825cc64e3d')
          post = create(:post, title: 'First test post', user: create(:user))

          get api_v1_post_path(post.id), headers: { Authorization: 'Token token=4050d1d2dfc9e0b0f3d331825cc64e3d' }

          expect(response.status).to eq 404
        end
      end
    end

    context 'when token is not provided' do
      it 'returns 401' do
        user = create(:user, api_key: nil)
        post = create(:post, title: 'First test post', user: user)

        get api_v1_post_path(post.id)

        expect(response.status).to eq 401
      end
    end

    context 'when token does not match' do
      it 'returns 401' do
        user = create(:user, api_key: '4050d1d2dfc9e0b0f3d331825cc64e3d')
        post = create(:post, title: 'First test post', user: user)

        get api_v1_post_path(post.id), headers: { Authorization: 'Token token=00000000000000000000000000000000' }

        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE /api/v1/posts/:id' do
    context 'when request is authenticated' do
      context 'when post belongs to user' do
        it 'deletes post' do
          user = create(:user, api_key: '4050d1d2dfc9e0b0f3d331825cc64e3d')
          post = create(:post, title: 'First test post', user: user)

          delete api_v1_post_path(post.id), headers: { Authorization: 'Token token=4050d1d2dfc9e0b0f3d331825cc64e3d' }

          expect(response.status).to eq 200
          expect(json_body).to contain_exactly(
            ['message', 'Post was deleted']
          )
          expect(Post.count).to eq 0
        end
      end

      context 'when post does not belong to user' do
        it 'returns 404' do
          _autorized_user = create(:user, api_key: '4050d1d2dfc9e0b0f3d331825cc64e3d')
          post = create(:post, title: 'First test post', user: create(:user))

          delete api_v1_post_path(post.id), headers: { Authorization: 'Token token=4050d1d2dfc9e0b0f3d331825cc64e3d' }

          expect(response.status).to eq 404
        end
      end
    end

    context 'when token is not provided' do
      it 'returns 401' do
        user = create(:user, api_key: nil)
        post = create(:post, title: 'First test post', user: user)

        delete api_v1_post_path(post.id)

        expect(response.status).to eq 401
      end
    end

    context 'when token does not match' do
      it 'returns 401' do
        user = create(:user, api_key: '4050d1d2dfc9e0b0f3d331825cc64e3d')
        post = create(:post, title: 'First test post', user: user)

        delete api_v1_post_path(post.id), headers: { Authorization: 'Token token=00000000000000000000000000000000' }

        expect(response.status).to eq 401
      end
    end
  end

  describe 'PATCH /api/v1/posts/:id' do
    context 'when request is authenticated' do
      context 'when post belongs to user' do
        it 'updates post' do
          user = create(:user, api_key: '4050d1d2dfc9e0b0f3d331825cc64e3d')
          post = create(:post, title: 'First test post', user: user)

          patch api_v1_post_path(post.id),
                headers: { Authorization: 'Token token=4050d1d2dfc9e0b0f3d331825cc64e3d' },
                params: { post: { title: 'Updated title' } }

          expect(response.status).to eq 200
          expect(json_body).to contain_exactly(
            ['content', 'Valid content'],
            ['id', post.id],
            ['title', 'Updated title']
          )
        end
      end

      context 'when params are not valid' do
        it 'renders a response with 422 status' do
          user = create(:user, api_key: '4050d1d2dfc9e0b0f3d331825cc64e3d')
          post = create(:post, title: 'First test post', user: user)

          patch api_v1_post_path(post.id),
                headers: { Authorization: 'Token token=4050d1d2dfc9e0b0f3d331825cc64e3d' },
                params: { post: { content: 'This content is longer than 160 characters
                  This content is longer than 160 characters This content is longer than 160 characters
                  This content is longer than 160 characters This content is longer than 160 characters' } }

          expect(response.status).to eq 422
          expect(json_body).to contain_exactly(
            ['message', I18n.t('post.not_updated')]
          )
        end
      end

      context 'when post does not belong to user' do
        it 'returns 404' do
          _autorized_user = create(:user, api_key: '4050d1d2dfc9e0b0f3d331825cc64e3d')
          post = create(:post, title: 'First test post', user: create(:user))

          patch api_v1_post_path(post.id),
                headers: { Authorization: 'Token token=4050d1d2dfc9e0b0f3d331825cc64e3d' },
                params: { post: { title: 'Updated title' } }

          expect(response.status).to eq 404
        end
      end
    end

    context 'when token is not provided' do
      it 'returns 401' do
        user = create(:user, api_key: nil)
        post = create(:post, title: 'First test post', user: user)

        patch api_v1_post_path(post.id), params: { post: { title: 'Updated title' } }

        expect(response.status).to eq 401
      end
    end

    context 'when token does not match' do
      it 'returns 401' do
        user = create(:user, api_key: '4050d1d2dfc9e0b0f3d331825cc64e3d')
        post = create(:post, title: 'First test post', user: user)

        patch api_v1_post_path(post.id),
              headers: { Authorization: 'Token token=00000000000000000000000000000000' },
              params: { post: { title: 'Updated title' } }

        expect(response.status).to eq 401
      end
    end
  end

  describe 'POST /create' do
    context 'when request is authenticated' do
      it 'creates post' do
        user = create(:user, api_key: '4050d1d2dfc9e0b0f3d331825cc64e3d')

        post api_v1_posts_path,
             headers: { Authorization: 'Token token=4050d1d2dfc9e0b0f3d331825cc64e3d' },
             params: { post: { title: 'Post title', content: 'Some valid content' } }

        expect(response.status).to eq 200
        expect(json_body).to contain_exactly(
          ['content', 'Some valid content'],
          ['id', user.posts.first.id],
          ['title', 'Post title']
        )
        expect(Post.count).to eq 1
      end
    end

    context 'when title is missing' do
      it 'renders a response with 422 status' do
        create(:user, api_key: '4050d1d2dfc9e0b0f3d331825cc64e3d')

        post api_v1_posts_path,
             headers: { Authorization: 'Token token=4050d1d2dfc9e0b0f3d331825cc64e3d' },
             params: { post: { content: 'Some valid content' } }

        expect(response.status).to eq 422
        expect(json_body).to contain_exactly(
          ['message', I18n.t('post.not_created')]
        )
      end
    end

    context 'when content is missing' do
      it 'renders a response with 422 status' do
        create(:user, api_key: '4050d1d2dfc9e0b0f3d331825cc64e3d')

        post api_v1_posts_path,
             headers: { Authorization: 'Token token=4050d1d2dfc9e0b0f3d331825cc64e3d' },
             params: { post: { title: 'Post title' } }

        expect(response.status).to eq 422
        expect(json_body).to contain_exactly(
          ['message', I18n.t('post.not_created')]
        )
      end
    end

    context 'when token is not provided' do
      it 'returns 401' do
        user = create(:user, api_key: nil)
        post = create(:post, title: 'First test post', user: user)

        post api_v1_posts_path(post.id), params: { post: { title: 'Post title', content: 'Some valid content' } }

        expect(response.status).to eq 401
      end
    end

    context 'when token does not match' do
      it 'returns 401' do
        user = create(:user, api_key: '4050d1d2dfc9e0b0f3d331825cc64e3d')
        post = create(:post, title: 'First test post', user: user)

        post api_v1_posts_path(post.id),
             headers: { Authorization: 'Token token=00000000000000000000000000000000' },
             params: { post: { title: 'Post title', content: 'Some valid content' } }

        expect(response.status).to eq 401
      end
    end
  end
end
