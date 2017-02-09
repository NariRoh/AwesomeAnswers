class QuestionsController < ApplicationController
  def new
    # by default this will render app/views/questions/new.html.erb
    @question = Question.new
    # this will be only sitting in the memory not going to the database
  end

  def create
    # render json: params
    # render json: params[:question]
    # Question.create(params[:question])
    # if you create question like this, someone could do like
    # <input type="text" name="question[title]" id="question_title">
    # <input type="text" name="question[view_count]" id="question_title">
    # {
    #   title: "what is 0.2 + 0.1 in Ruby",
    #   view_count: "10000000",
    #   body: "hard question"
    # } => params[:question] and set the view_count.

    # this feature is called strong parameters which you only permit title and
    # body inputs from user
    question_params = params.require(:question).permit([:title, :body])
    Question.create(question_params)
  end
end
