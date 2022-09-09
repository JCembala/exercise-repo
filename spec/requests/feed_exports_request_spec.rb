RSpec.describe 'FeedExports', type: :request do
  describe 'GET /user/feed_exports' do
    context 'when user is authenticated' do
      it 'renders a successful response' do
        user = create(:user)
        sign_in user

        get '/user/feed_exports'

        expect(response).to be_successful
        expect(response).to render_template(:index)
      end

      it 'displays users files' do
        user = create(:user, :with_attached_file)
        sign_in user

        get '/user/feed_exports'

        assert_select 'ul#blobs' do |elements|
          elements.each do |element|
            assert_select element, 'li', 1
          end
        end
      end

      it 'displays filename' do
        user = create(:user, :with_attached_file)
        sign_in user

        get '/user/feed_exports'

        expect(response.body).to include('Filename:')
        expect(response.body).to include('feed_test.csv')
      end

      it 'displays download link' do
        user = create(:user, :with_attached_file)
        sign_in user

        get '/user/feed_exports'

        expect(response.body).to include('Download')
      end

      it 'does not display files of other users' do
        user = create(:user)
        sign_in user

        create(:user, :with_attached_file)

        get '/user/feed_exports'

        assert_select 'ul#blobs' do |elements|
          elements.each do |element|
            assert_select element, 'li', false, 'This page must contain no other users exports'
          end
        end
      end
    end

    context 'when user is unauthenticated' do
      it 'redirects to /users/sign_in and returns 302' do
        get '/user/feed_exports'

        expect(response).to redirect_to '/users/sign_in'
        expect(response.status).to eq(302)
      end
    end
  end

  describe 'POST /user/feed_exports' do
    context 'when user is authenticated' do
      it 'enqueue Generate CSV job' do
        user = create(:user)
        sign_in user

        expect { post '/user/feed_exports' }.to change { GenerateCsvJob.jobs.size }.by(1)
      end

      it 'redirects to feed exports index' do
        user = create(:user)
        sign_in user

        post '/user/feed_exports'

        expect(response).to redirect_to user_feed_exports_path
      end

      it 'displays the notice' do
        user = create(:user)
        sign_in user

        post '/user/feed_exports'

        expect(flash[:notice]).to eq(I18n.t('feed.export_enqueued'))
      end
    end

    context 'when user is unauthenticated' do
      it 'redirects to /users/sign_in and returns 302' do
        post '/user/feed_exports'

        expect(response).to redirect_to '/users/sign_in'
        expect(response.status).to eq(302)
      end
    end
  end
end
