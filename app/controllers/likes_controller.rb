class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_like, only: [:destroy]
  before_action :find_question, only: [:create]
  before_action :authorize, except: [:index]

  def index
    # render json: params
    @user = User.find params[:user_id]
    @questions = @user.liked_questions
  end


  def create
    # render json: params ==> question_id
    # if cannot? :like, @question
    #   redirect_to question_path(@question), alert: 'Liking your own Question isn\'t allowed'
    #   # redirect_to and render does not prevent the rest of method from executing
    #   # calling redirect_to and/or render twice or more in an action will cause
    #   # an error
    #   # 👇 do an early return in an action if the rest of the code should not be
    #   # executed
    #   return
    # end

    like = Like.new user: current_user, question: @question


    if like.save
      redirect_to question_path(@question), notice: 'Question liked! 💖'
    else
      redirect_to question_path(@question), alert: 'Couldn\'t like question!'
    end

  end

  def destroy
    # render json: params ==> like id

    if @like.destroy
      redirect_to question_path(@like.question), notice: 'Question un liked!'
      # question_path(@like.id.question)
    else
      redirect_to question_path(@like.question), alert: @like.errors.full_messages.join(', ')
    end
  end

  private

  def find_like
    @like ||= Like.find params[:id]
  end

  def find_question
    @question ||= Question.find params[:question_id]
  end

  def authorize
    if cannot? :like, @question
      redirect_to question_path(@question), alert: 'Cannot like your own Question'
    end
  end

end
