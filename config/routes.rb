Rails.application.routes.draw do
  # you map a HTTP verb / URL combo to a controller + action (method)

  # get({ '/' => 'welcome#index'})
  # get '/' => 'welcome#index'
  root 'welcome#index'

  # dashboard_index_path	GET	/dashboard(.:format) admin/dashboard#index
  # resources :dashboard, only: [:index], controller: 'admin/dashboard'
  
  # this will make the url structure follow the folder structure of the
  # controllers inside. For instance, the code below will generate a url that
  # looks like `/admin/dashboard` that will map to `admin/dashboard` controller
  # admin_dashboard_index_path	GET	/admin/dashboard(.:format) admin/dashboard#index
  namespace :admin do
    resources :dashboard, only: [:index]
  end

  # the above route maps any 'GET' request with '/' URL to the index action
  # within the WelcomeController (action is a method defined within the
  # controller class)
  # the above can be called DSL (Domain Specific Language). It's just Ruby it's
  # not a special programming language, just Ruby. The Ruby is written in a way
  # that looks like its own language

  get '/contact' => 'welcome#contact_us'
  post '/contact_submit' => 'welcome#contact_submit'

  get '/about' => 'welcome#about_us', as: :aboutus

  # as helper only cares about generating URL not HTTP verbs
  # get    '/questions/new'      => 'questions#new', as: :new_question
  # post   '/questions'          => 'questions#create', as: :questions
  # # here /:id can be anything so /new shoul be upper than /:id
  # get    '/questions/:id'      => 'questions#show', as: :question
  # get    '/questions'          => 'questions#index'
  # get    '/questions/:id/edit' => 'questions#edit', as: :edit_question
  # patch  '/questions/:id'      => 'questions#update'
  # delete '/questions/:id'     => 'questions#destroy'

  # resources :questions, only: [:create, :update]
  # resources :questions, except: [:index]
  # For answers associated with questions
  # post '/questions/:question_id/answers' => 'answers#create'
  # delete '/questions/:question_id/answers/:id' => 'answers#destroy'

  # post '/questions/search' => 'questions#search'
  # shallow: true option makes it so nested routes only include '/questions/:question_id'
  # for the create action and not for `destroy` for instance. This is because
  # when deleting a nested resouces you may not need to know about the parent
  # resource because you can get it from the Database. In our case, we can
  # get the question_id of an answer from the database
  resources :questions, shallow: true do
    # post :search # /questions/:question_id/search(.:format) looks like answers
    # post :search, on: :member # /questions/:id/search(.:format) looks like edit
    # post :search, on: :collection # /questions/search(.:format)

    # this creates a set of `answers` routes nested within the `questions`
    # routes. This will make all the `answers` routes prefixed with
    # `/questions/:question_id`
    resources :answers, only: [:create, :destroy]
  end

  resources :users, only: [:new, :create]
  # resources :sessions, only: [:new, :create, :destroy]
  # since you don't need :id /sessions/:id for destroy action,
  resources :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
  end


end
