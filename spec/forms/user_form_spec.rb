RSpec.describe UserForm do
  describe '#save' do
    context 'when adding new user by form' do
      it 'persists user in database' do
        user = User.new
        form = UserForm.new(
          user,
          first_name: 'Jake',
          last_name: 'Drew',
          password: 'this-is-my-password',
          email: 'jake.drew@drew.com'
        )

        result = form.save

        expect(result).to be true
        expect(user).to be_persisted
        expect(user).to have_attributes(
          first_name: 'Jake',
          last_name: 'Drew',
          email: 'jake.drew@drew.com'
        )
        expect(user.encrypted_password).to be_present
      end
    end

    context 'when modifying existing user data'
    it 'updates existing user except its email' do
      user = create(
        :user,
        first_name: 'Mark',
        last_name: 'Done',
        email: 'mark.done@done.com'
      )
      form = UserForm.new(
        user,
        first_name: 'Bob',
        last_name: 'Doe',
        email: 'bob.doe@doe.com'
      )

      result = form.save

      expect(result).to be true
      expect(user).to be_persisted
      expect(user).to have_attributes(
        first_name: 'Bob',
        last_name: 'Doe',
        email: 'mark.done@done.com'
      )
    end
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
        "Last name can't be blank",
        "Email can't be blank",
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
        'Email is invalid',
        'Password is too short (minimum is 8 characters)'
      ]
    end
  end
end
