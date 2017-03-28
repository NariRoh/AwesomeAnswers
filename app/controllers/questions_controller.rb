class QuestionsController < ApplicationController
  # order of before_action matters!
  before_action :authenticate_user!, except: [:show, :index]
  # this will execute the method `find_question` before it executes the action
  # if you give it `only` or `except` options then it will only include or only
  # exclude certain actions
  # remember that `before_action` methods get executed within the same
  # request/response cycle which means if you define an instance variable in
  # the `before_action` method, the variable will be available in the action
  # it's like defining middle ware
  # before_action(:find_question, { only: [:show, :edit, :destroy, :update] })
  # using string for method name here 🖕 instead of symbol: when you care about
  # value and you will change the method?
  before_action :find_question, only: [:show, :edit, :destroy, :update]
  before_action :authorize, only: [:edit, :update, :destroy]

  def new
    # by default this will render app/views/questions/new.html.erb
    @question = Question.new
    # this will be only sitting in the memory not going to the database
  end

  def create
    # byebug
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


    @question  = Question.new(question_params)
    @question.user = current_user
    if @question.save

      if @question.tweet_this
        # Adding :: in front of a constant garantees that you are
        # getting the version of the constant from the global namespace
        # (e.g. 👇 Twitter below was being detected as part of a module
        # name after this controller, QuestionsController, by using ::
        # in front of we were able to get Twitter constant from the gem)
        client = ::Twitter::REST::Client.new do |c|
          c.consumer_key = ENV['TWITTER_API_KEY']
          c.consumer_secret = ENV['TWITTER_API_SECRET']
          c.access_token = current_user.oauth_token
          c.access_token_secret = current_user.oauth_secret
        end
        client.update @question.title
      end
      # render plain: 'success'
      # render :show # this will show the page but URL is wrong /questions not
      # /questions/id. So, instead of sending 200, Rails App sends 302(redirect)
      # and it will force the browser to send 302 request back to your app with
      # /questions/id and then it will hit the show action then the App sends to
      # user with URL /questions/id
      # redirect_to question_path({ id: @question.id })
      # redirect_to question_path({ id: @question })
      # if you send a sucess message using @ variable, it will be gone since you
      # will send back to browser to force send 302 request so here you should
      # use session but it will stay even if user click other pages
      # session[:message] = 'Question created successfully'
      # Use Rails built in hepler method flash
      # this designed to use with redirect_to. It works with next cycle. skip
      # at the next cycle then works for the next one
      flash[:notice] = 'Question created successfully'
      redirect_to question_path(@question)
    else
      flash.now[:alert] = 'Please fix errors below'
      # this will force Rails to render: app/views/questions/new.html.erb
      # instead of the default: app/views/questions/create.html.erb
      render :new
    end
  end

  def show
    @answer = Answer.new
    # render json: params
    # find throw exeption(404 page) if id is not found and we want this!
    # find_by_id will return nil
    @vote = @question.vote_for(current_user)
    # respond_to enables us to send different responses depending on the format
    # of the request
    respond_to do |format|
      # `html` is the default format. Render will just render `show.html.erb`
      format.html { render }
      # this will render `show.json.erb`
      # format.json { render }

      # with every ActiveRecord object we have a `to_json` method that returns
      # a JSON object with attributes of every single attribute in the
      # ActiveRecord object
      format.json { render json: @question.to_json }
    end
  end

  def index
    @questions = Question.order(created_at: :desc)
  end

  def edit
  end

  def update
    # by default friendly_id won't update the slug of question, so one way to
    # force friendly_id to update the slug is by setting the slug to `nil`
    # before updating the question
    @question.slug = nil # force to regenerate new slug
    if @question.update question_params
      redirect_to question_path(@question), notice: 'Question updated!'
                                            # 🖕 this only works for redirect_to
    else
      flash.now[:alert] = 'Please fix errors below'
      render :edit
    end
  end

  # def update
  #   # render json: params
  #   @question = Question.find params[:id]
  #   question_params = params.require(:question).permit([:title, :body])
  #   if @question.update question_params
  #     redirect_to question_path(@question)
  #   else
  #     render :edit
  #   end
  # end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Question deleted!'
  end

  # if it's not an action it's better to make it as a private method
  private

  def question_params
    # this feature is called strong parameters which you only permit title and
    # body inputs from user
    # question_params = params.require(:question).permit([:title, :body])
    # question_params = params.require(:question).permit(:title, :body)
    # this feature is called strong parameters (introduced in Rails 4+)

    # { tag_ids: [] } will tell Rails to accept and array of value for `tag_ids`
    # instead of a single value
    params.require(:question).permit([:title, :body, :image, :tweet_this, { tag_ids: [] }])
  end

  def find_question
    @question = Question.find params[:id]
  end

  def authorize
    # if session[:user_id] != @question.user_id
    # if current_user != @question.user_id // without cancancan

    # `can?` and `cannot?` are helper methods that are available in controllers
    # and views that came from the `cancancan` gem and it will check in the
    # `ability.rb` file for a matching rule.
    # can? is a helper method that is available in controllers and views that
    #  came from the `cancancan` gem and it will check in the `ability.rb` file
    # for a matching rule.
    # unless can?(:manage, @question)
    if cannot?(:manage, @question)
      redirect_to root_path, alert: 'Not authorized!'
    end
  end

end
