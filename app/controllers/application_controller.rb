class ApplicationController < ActionController::Base

  # this will throw an exception every time you make a non-GET request that
  # doesn't include authenticity_token. When you use `form_for` or `form_tag`
  # in Rails, it auto generates a hidden field that contains the
  # authenticity_token.
  protect_from_forgery with: :exception

  def authenticate_user!
    redirect_to new_session_path, alert: 'please sign in' unless user_signed_in?
  end

  # Any method you define here is accessible in any controller
  def user_signed_in?
    session[:user_id].present?
  end
  helper_method :user_signed_in?

  def current_user
    User.find session[:user_id] if user_signed_in? # session[:user_id].present?
  end
  helper_method :current_user
  # adding the line above makes this methods accessible in every view file

  # turning instance as a method
  # def current_vote
  #   @current_vote ||= @question.vote_for(current_user)
  # end
  # helper_method :current_vote
end
