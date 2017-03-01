class SessionsController < ApplicationController

  def new
  end

  def create
    # render json: params
    user = User.find_by_email params[:email]
    # user.authenticate(params[:password]) returns that user object
    # user && user.authenticate(params[:password])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Signed in!'
    else
      flash.now[:alert] = 'Wrong credentials'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Signed out!'
  end

end
