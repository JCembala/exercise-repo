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
end
