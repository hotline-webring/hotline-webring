class AdminController < ApplicationController
  layout "admin"
  before_action :authenticate

  private

  def authenticate
    http_basic_authenticate_or_request_with(
      name: ENV.fetch("ADMIN_USERNAME"),
      password: ENV.fetch("ADMIN_PASSWORD")
    )
  end
end
