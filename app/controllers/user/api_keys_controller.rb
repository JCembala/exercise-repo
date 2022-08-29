class User
  class ApiKeysController < BaseController
    def update
      if current_user.update(api_key: SecureRandom.hex)
        redirect_to edit_user_registration_path, notice: t('api_key.updated')
      else
        redirect_to edit_user_registration_path, alert: t('api_key.not_updated')
      end
    end
  end
end
