class CallbacksController < ApplicationController
  def index
    omniauth_data = request.env['omniauth.auth']

    # Verify the data coming from Twitter
    # render json: omniauth_data

    # Step 1: Search for a user with the given provider & uid
    user = User.create_from_omniauth(omniauth_data)

    # Step 2: Create the user if the user is not found
    user ||= User.create_from_omniauth(omniauth_data)

    # Step 3: Sign in the user 
    session[:user_id] = user.id

    redirect_to root_path, notice: 'Thanks for signing in with Twitter!'
  end
end
