require 'rails_helper'

RSpec.describe UserDecorator do
  describe '.fullname' do
    context 'with a first and last name' do
      it 'returns the full name' do
        user = create(:user, first_name: 'John', last_name: 'Smith')

        decorator = user.decorate

        expect(decorator.full_name).to eq("#{user.first_name} #{user.last_name}")
      end
    end

    context 'with a first but not last name' do
      it 'returns the full name' do
        user = create(:user, first_name: 'John', last_name: '')

        decorator = user.decorate

        expect(decorator.full_name).to eq(user.first_name.to_s)
      end
    end

    context 'with a last but not first name' do
      it 'returns the full name' do
        user = create(:user, first_name: '', last_name: 'Smith')

        decorator = user.decorate

        expect(decorator.full_name).to eq(user.last_name.to_s)
      end
    end

    context 'without a both first and last name' do
      it 'returns Anonymous name' do
        user = create(:user, first_name: '', last_name: '')

        decorator = user.decorate

        expect(decorator.full_name).to eq('Anonymous')
      end
    end

    # ...
  end
end
