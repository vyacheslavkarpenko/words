class RegistrationController < ApplicationController
  before_action :check_registration, except: %i[sign_up sign_in sign_in_complete]

  def sign_up

    @user = User.new
  end

  def sign_in
    # binding.pry
  end

  def sign_in_complete
    # binding.pry
    user = User.find_by(email: params[:email], password: params[:password])

    redirect_to sign_in_path and return unless user

    session[:email] = params[:email]

    redirect_to user_books_path(user) and return
  end

  def sign_out
    session.delete(:email)

    redirect_to sign_in_path and return
  end
end
