class AnswersController < ApplicationController
  def create
    answer_params    = params.require(:answer).permit(:body)
    @answer          = Answer.new answer_params
    # @answer.question = Question.find params[:question_id]
    @question = Question.find params[:question_id]
    @answer.question = @question

    respond_to do |format|
      if @answer.save
        # AnswersMailer.notify_question_owner(@answer).deliver_now
        AnswersMailer.notify_question_owner(@answer).deliver_later
        format.html { redirect_to question_path(params[:question_id]), notice: 'answer created!' }
        # format.js   { render js: 'alert(\'success\');' }
        format.js   { render :success }

      else
        flash[:alert] = 'please fix errors'
        format.html { render 'questions/show' }
        # format.js   { render js: 'alert(\'failure\');' }
        format.js   { render :failure }

        # if you put render :show Rails will look for answers/show
        # if you render with @answer.question = Question.find params[:question_id]
        # you will get `undefined method `title' for nil:NilClass` error
        # so you need to define @question first.
      end
    end
  end

  def destroy
    # render json: params
    # without shallow
    # answer = Answer.find params[:id]
    # answer.destroy
    # redirect_to question_path(params[:question_id]), notice: 'Answer deleted!'
    @answer = Answer.find params[:id]
    @answer.destroy
    respond_to do |format|
      format.html do
        redirect_to question_path(@answer.question_id), notice: 'Answer deleted!'
      end
      format.js { render }
    end
  end


end
