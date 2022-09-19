RSpec.describe FollowsController do
  describe '#create' do
    it 'allows user to follow another user' do
      user = create(:user)
      follower = create(:user)
      follow = Follow.new(follower_id: follower.id, followed_id: user.id)

      expect { follow.save }.to change { Follow.count }.by(1)
    end

    context 'when follow was successfull' do
      it 'displays notice' do
        user = create(:user)
        sign_in user
        follower = create(:user)

        post :create, params: { user_id: follower.id }

        expect(flash[:notice]).to eq(I18n.t('user.follow_success', user_name: user.first_name))
      end
    end

    context 'when user is unable to follow' do
      it 'displays alert' do
        user = create(:user)
        sign_in user
        allow_any_instance_of(Follow).to receive(:save).and_return(false)

        post :create, params: { user_id: user.id }

        expect(flash[:alert]).to eq(I18n.t('user.follow_failure', user_name: user.first_name))
      end
    end

    context 'when user is trying to follow same user again' do
      it 'fails' do
        user = create(:user)
        sign_in user
        follower = create(:user)

        post :create, params: { user_id: follower.id }

        expect { post :create, params: { user_id: follower.id } }.to change { Follow.count }.by(0)
      end
    end
  end

  describe '#destroy' do
    it 'allows user to unfollow another user' do
      user = create(:user)
      sign_in user
      followed = create(:user)
      Follow.create(follower_id: user.id, followed_id: followed.id)

      expect { delete :destroy, params: { user_id: followed } }.to change { Follow.count }.by(-1)
    end

    context 'when unfollow was successfull' do
      it 'displays notice' do
        user = create(:user)
        sign_in user
        followed = create(:user)
        Follow.create(follower_id: user.id, followed_id: followed.id)

        delete :destroy, params: { user_id: followed }

        expect(flash[:notice]).to eq(I18n.t('user.unfollow_success', user_name: user.first_name))
      end
    end

    context 'when user is unable to unfollow' do
      it 'displays alert' do
        user = create(:user)
        sign_in user
        followed = create(:user)
        Follow.create(follower_id: user.id, followed_id: followed.id)
        allow_any_instance_of(Follow).to receive(:destroy).and_return(false)

        delete :destroy, params: { user_id: followed }

        expect(flash[:alert]).to eq(I18n.t('user.unfollow_failure', user_name: user.first_name))
      end
    end
  end
end
