class AnswersController < ApplicationController
  def create
    render json: params
    answer_params    = params.require(:answer).permit(:body)
    @answer          = Answer.new answer_params
    # @answer.question = Question.find params[:question_id]
    @question = Question.find params[:question_id]
    @answer.question = @question
    
    if @answer.save
      redirect_to question_path(params[:question_id]), notice: 'answer created!'
    else
      flash[:alert] = 'please fix errors'
      render 'questions/show'
      # if you put render :show Rails will look for answers/show
      # if you render with @answer.question = Question.find params[:question_id]
      # you will get `undefined method `title' for nil:NilClass` error
      # so you need to define @question first.
    end
  end

  def destroy
    # render json: params
    # without shallow
    # answer = Answer.find params[:id]
    # answer.destroy
    # redirect_to question_path(params[:question_id]), notice: 'Answer deleted!'
    answer = Answer.find params[:id]
    answer.destroy
    redirect_to question_path(answer.question_id), notice: 'Answer deleted!'
  end


end
