require 'rails_helper'

RSpec.describe UserForm do
  describe '#save' do
    it 'persists user in database' do
      user = User.new
      form = UserForm.new(
        user,
        first_name: 'Jake',
        last_name: 'Pop',
        password: '12345678',
        email: 'jake.pop@example.com'
      )

      result = form.save

      expect(result).to be true
      expect(user).to be_persisted
      expect(user).to have_attributes(
        first_name: 'Jake',
        last_name: 'Pop',
        password: '12345678',
        email: 'jake.pop@example.com'
      )
    end

    it 'updates existing user' do
      user = User.create(
        first_name: 'Jake',
        last_name: 'Pop',
        password: '12345678',
        email: 'jake.pop@example.com'
      )

      form = UserForm.new(
        user,
        first_name: 'Jake',
        last_name: 'Updated',
        password: '12345678',
        email: 'jake.updated@example.com'
      )

      result = form.save

      expect(result).to be true
      expect(user).to be_persisted
      expect(user).to have_attributes(
        first_name: 'Jake',
        last_name: 'Updated',
        password: '12345678',
        email: 'jake.updated@example.com'
      )
    end

    describe 'validations' do
      it 'returns errors when missing params provided' do
        user = User.new
        form = UserForm.new(
          user,
          first_name: nil,
          last_name: nil,
          password: nil,
          email: nil
        )

        result = form.save

        expect(result).to be false
        expect(user).not_to be_persisted
        expect(form.errors.full_messages).to eq [
          "First name can't be blank",
          "Password can't be blank",
          "Email can't be blank",
          'Password is too short (minimum is 8 characters)',
          'Email is invalid'
        ]
      end

      it 'returns errors when invalid params provided' do
        user = User.new
        form = UserForm.new(
          user,
          first_name: 'Jake',
          last_name: 'Abby',
          password: '123456',
          email: 'invalid_email'
        )

        result = form.save

        expect(result).to be false
        expect(user).not_to be_persisted
        expect(form.errors.full_messages).to eq [
          'Password is too short (minimum is 8 characters)',
          'Email is invalid'
        ]
      end
    end
  end
end
