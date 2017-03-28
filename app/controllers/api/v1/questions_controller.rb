 class Api::V1::QuestionsController < Api::BaseController
  # # this will not throw an exception if an authenticity token is not passed
  # # however, it will just clear the sessions by deleting all the cookies that
  # # came as part of the request. In many cases of using APIs we don't use
  # # cookies so it's ok for us to have no cookeis and consquently empty session
  # protect_from_forgery with: :null_session
  #
  # before_action :authenticate
  PER_PAGE = 10

  def index
    current_page   = params.fetch(:page, 0).to_i
    # offset         = PER_PAGE * params.fetch(:page, 0)
    offset         = PER_PAGE * current_page


    @questions = Question.order(created_at: :desc)
                         .limit(PER_PAGE)
                         .offset(offset)

    @more_questions = (Question.count - ((current_page + 1) * PER_PAGE)) > 0
    # render json: { greeting: 'Hello' }
    # render xml: @questions.to_xml
    # render json: @questions.to_json

    # This will use the built-in `to_json` method that comes with Rails which
    # sends all the attributes without associations
    # render json: @questions.to_json

    # This will use ActiveModel Serializer class: QuestionSerializer which, as
    # we defined it, will serve the question with answers the it will include
    # the creator name.
    # render json: @questions

    # the default behaviour is to render `index.json.jbuilder` which will render
    # JSON as we defined it in the `/app/views/api/v1/questions/index.json.jbuilder`
  end

  def show
    question = Question.find params[:id]
    # in we have ActiveModel Serializer set up for the Question model then when
    # we invoke `render json: question` it will use the ActiveModel Serializer
    # class to render the json instead of the default `to_json` that is built-in
    # with Rails
    render json: question
  end

  def create
    # ActionController::ParameterMissing (param is missing or the value is empty: question):
    # require(:question) expects to have { question: } key
    # so we need to send params like this:
    # question[title]
    # question[body]
    question_params = params.require(:question).permit(:title, :body)
    question  = Question.new question_params
    # render json: { greeting: 'Hello' }
    question.user = @user
    if question.save
      # You don't need success. Up to you
      render json: { success: true, id: question.id }
    else
      render json: { success: false, errors: question.errors.full_messages }
    end
  end

  # private
  #
  # def authenticate
  #   # Rails.logger.info ">>>>>>>>>>>>>>>>>>>>"
  #   # Rails.logger.info request.headers["HTTP_API_KEY"]
  #   # Rails.logger.info ">>>>>>>>>>>>>>>>>>>>"
  #
  #   @user = User.find_by_api_key params[:api_key]
  #   head :unauthorized unless @user.present?
  # end

end
