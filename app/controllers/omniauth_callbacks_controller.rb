# frozen_string_literal: true

class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # rubocop:disable Naming/VariableNumber
  def google_oauth2
    @user = User.create_from_provider_data(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, kind: 'Google') if is_navigational_format?
    else
      set_flash_message(:alert, :failure, kind: 'Google')
      redirect_to new_user_session_path
    end
  end
  # rubocop:enable Naming/VariableNumber
end
