require 'rails_helper'

RSpec.describe Admin::UserPolicy do
  describe 'permissions' do
    context 'when user is admin' do
      permissions :index?, :edit?, :update? do
        it 'grant access to #index, #edit, #update' do
          expect(described_class).to permit(create(:user, :admin), User)
        end
      end
    end

    context 'when user is not admin' do
      permissions :index?, :edit?, :update? do
        it 'denies access to #index, #edit, #update' do
          expect(described_class).to_not permit(create(:user), User)
        end
      end
    end
  end
end
