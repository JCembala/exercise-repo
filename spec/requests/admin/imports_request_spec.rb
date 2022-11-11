require 'csv'

RSpec.describe 'Admin::Imports', type: :request do
  describe 'GET /index' do
    context 'when user is authenticated' do
      context 'when user is and admin' do
        it 'renders a successful response' do
          user = create(:user, :admin)
          sign_in user

          get '/admin/imports'

          expect(response).to be_successful
          expect(response).to render_template(:index)
        end

        it 'displays imports' do
          user = create(:user, :admin)
          sign_in user
          3.times { Import.create }

          get '/admin/imports'

          assert_select 'tbody' do |elements|
            elements.each do |element|
              assert_select element, 'th', 3
            end
          end
        end

        it 'displays imports id, state' do
          user = create(:user, :admin)
          sign_in user
          import = Import.create

          get '/admin/imports'

          expect(response.body).to include(import.id.to_s)
          expect(response.body).to include('in_progress')
        end

        context 'when import failed' do
          it 'displays provided error message' do
            user = create(:user, :admin)
            sign_in user
            import = Import.create
            import.failure(OpenStruct.new(message: 'Something went wrong'))
            import.save

            get '/admin/imports'

            expect(import.error_message).to eq('Something went wrong')
            expect(response.body).to include('Something went wrong')
          end
        end
      end

      context 'when user is not an admin' do
        it 'redirects to root and returns 302' do
          user = create(:user)
          sign_in user

          get '/admin/imports'

          expect(response).to redirect_to root_path
          expect(response.status).to eq(302)
        end
      end
    end

    context 'when user is unauthenticated' do
      it 'redirects to /users/sign_in and returns 302' do
        get '/admin/imports'

        expect(response).to redirect_to '/users/sign_in'
        expect(response.status).to eq(302)
      end
    end
  end

  describe 'POST /create' do
    context 'when user is authenticated' do
      context 'with valid parameters' do
        it 'creates new Users from imported csv' do
          user = create(:user)
          sign_in user

          post admin_imports_url, params: { import: fixture_file_upload('spec/fixtures/import/users_valid_fixture.csv', 'text/csv') }

          expect(User.count).to eq(2)
          expect(User.last).to have_attributes(
            first_name: 'Adam',
            last_name: 'Bob',
            email: 'adam@bob.com',
            admin: false
          )
        end

        it 'redirects to imports list' do
          user = create(:user)
          sign_in user

          post admin_imports_url, params: { import: fixture_file_upload('spec/fixtures/import/users_valid_fixture.csv', 'text/csv') }

          expect(response).to redirect_to(admin_imports_url)
        end

        it 'creates new Import with succeded state' do
          user = create(:user)
          sign_in user

          post admin_imports_url, params: { import: fixture_file_upload('spec/fixtures/import/users_valid_fixture.csv', 'text/csv') }

          expect(Import.last).to have_attributes(aasm_state: 'succeded')
        end

        it 'display flash notice' do
          user = create(:user)
          sign_in user

          post admin_imports_url, params: { import: fixture_file_upload('spec/fixtures/import/users_valid_fixture.csv', 'text/csv') }

          expect(flash[:notice]).to eq(I18n.t('import.success'))
        end
      end

      context 'with invalid parameters' do
        it 'does not import any Users' do
          user = create(:user)
          sign_in user

          post admin_imports_url, params: { import: fixture_file_upload('spec/fixtures/import/users_invalid_fixture.csv', 'text/csv') }

          expect(User.count).to eq(1)
        end

        it 'renders a response with 422 status' do
          user = create(:user)
          sign_in user

          post admin_imports_url, params: { import: fixture_file_upload('spec/fixtures/import/users_invalid_fixture.csv', 'text/csv') }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(flash[:alert]).to eq(I18n.t('import.failure'))
        end

        it 'creates new Import with failed state' do
          user = create(:user)
          sign_in user

          post admin_imports_url, params: { import: fixture_file_upload('spec/fixtures/import/users_invalid_fixture.csv', 'text/csv') }

          expect(Import.last).to have_attributes(aasm_state: 'failed')
          expect(Import.last.error_message).to be_present
        end
      end
    end

    context 'when user is unauthenticated' do
      it 'redirects to /users/sign_in and returns 302' do
        post admin_imports_url, params: { import: fixture_file_upload('spec/fixtures/import/users_valid_fixture.csv', 'text/csv') }

        expect(response).to redirect_to '/users/sign_in'
        expect(response.status).to eq(302)
      end
    end
  end
end
