class ApplicationController < ActionController::Base
  before_action :check_registration
  before_action :current_user
  before_action :languages
  before_action :current_account
  before_action :user_to_learn_language, :user_native_language, :is_need_redirect_ater_translation_update?

  def current_user
    # binding.pry
    @current_user ||= if session[:email]
      User.find_by(email: session[:email])
    else
      false
    end
  end

  def current_account
    # binding.pry
    return unless @current_user
    @current_account ||= @current_user.account
  end

  def languages
    @languages ||= Language.all().to_a.map{|key, value| { id: key[:id], name: key[:detailed_attributes][:name], icon: key[:detailed_attributes][:icon]}}
  end

  def user_native_language
    return unless @current_user
    language = Language.find(@current_account.languages[:native])
    @user_native_language ||= { id: language.id.to_s, name: language[:detailed_attributes][:name], icon: language[:detailed_attributes][:icon] }
  end

  def user_to_learn_language
    return unless @current_user
    language = Language.find(@current_account.languages[:to_learn])
    @user_to_learn_language ||= { id: language.id.to_s, name: language[:detailed_attributes][:name], icon: language[:detailed_attributes][:icon] }
  end

  def is_need_redirect_ater_translation_update?
    # binding.pry
    @is_need_redirect_ater_translation_update ||= current_account&.redirect_ater_translation_update
  end

  private

  def check_registration
    redirect_to sign_in_path and return if session[:email].blank?
  end
end
