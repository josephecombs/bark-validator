class PasswordsController < ApplicationController
  require 'net/http'

  # GET /passwords/new
  def new
    # Renders the form for creating a new password
  end

  # POST /passwords
  def create
    password = params[:password]
    if password_check_service.valid_length?(password)
      if !password_check_service.pwned?(password)
        # Handle the case where the password is valid and not pwned
        # This could be redirecting to a success page, creating a user, etc.
        # For now, we'll just render a simple json response
        render json: { message: PasswordCheckService::SUCCESS_MESSAGE }, status: :ok
      else
        render json: { error: password_check_service.response_message }, status: :unprocessable_entity
      end
    else
      render json: { error: password_check_service.response_message }, status: :unprocessable_entity
    end
  end

  private

  def password_check_service
    @password_check_service ||= PasswordCheckService.new
  end
end
