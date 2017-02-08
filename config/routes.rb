Rails.application.routes.draw do
  # you map a HTTP verb / URL combo to a controller + action (method)

  # get({ '/' => 'welcome#index'})
  get '/' => 'welcome#index'
  # the above route maps any 'GET' request with '/' URL to the index action
  # within the WelcomeController (action is a method defined within the
  # controller class)
  # the above can be called DSL (Domain Specific Language). It's just Ruby it's
  # not a special programming language, just Ruby. The Ruby is written in a way
  # that looks like its own language

  get '/contact' => 'welcome#contact_us'

  post '/contact_submit' => 'welcome#contact_submit'

  # get '/about' => 'welcome#about_us' as: :aboutus


end
