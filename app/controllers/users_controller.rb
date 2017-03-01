class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user_params = params.require(:user).permit(:first_name,
                                               :last_name,
                                               :email,
                                               :password,
                                               :password_confirmation)
    @user = User.new user_params

    # all = user_params.merge(session_id: session.id)
    # render json: all
    if @user.save
      # render json: session[:user_id] # return null and we assign it with user.id

      session[:user_id] = @user.id # doing this the user keep being signed in stage
      redirect_to root_path, notice: 'Account created successfully!'
    else
      render :new
    end
  end
end
