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
    @question  = Question.new(question_params)
    if @question.save
      # render plain: 'success'
      # render :show # this will show the page but URL is wrong /questions not
      # /questions/id. So, instead of sending 200, Rails App sends 302(redirect)
      # and it will force the browser to send 302 request back to your app with
      # /questions/id and then it will hit the show action then the App sends to
      # user with URL /questions/id
      # redirect_to question_path({ id: @question.id })
      # redirect_to question_path({ id: @question })
      redirect_to question_path(@question)
    else
      # this will force Rails to render: app/views/questions/new.html.erb
      # instead of the default: app/views/questions/create.html.erb
      render :new
    end
  end

  def show
    # render json: params
    # find throw exeption(404 page) if id is not found and we want this!
    # find_by_id will return nil
    @question = Question.find params[:id]
  end

  def index
    @questions = Question.order(created_at: :desc)
  end
end
