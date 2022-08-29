module Api
  module V1
    class BaseController < ApplicationController
      before_action :authenticate

      private

      def authenticate
        authenticate_or_request_with_http_token do |token, _options|
          @user = User.find_by(api_key: token)
        end
      end
    end
  end
end
