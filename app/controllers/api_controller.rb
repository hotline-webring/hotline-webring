class ApiController < ApplicationController
  API_TOKEN = ENV.fetch("API_TOKEN")

  protect_from_forgery with: :null_session
  before_action :authenticate

  private

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      # Compare the tokens in a time-constant manner, to mitigate
      # timing attacks.
      ActiveSupport::SecurityUtils.secure_compare(token, API_TOKEN)
    end
  end
end
