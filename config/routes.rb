Rails.application.routes.draw do
  resources :tests
  resources :articles
  resources :todos
  resources :records
  resources :translations
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get '/sign_up', to: 'registration#sign_up', as: :sign_up
  get '/sign_in', to: 'registration#sign_in', as: :sign_in
  post '/sign_in_complete', to: 'registration#sign_in_complete'
  get '/sign_out', to: 'registration#sign_out', as: :sign_out

  # user routes
  get '/roadmap', to: 'users#roadmap', as: :roadmap

  # Book endpoints
  get '/users/:user_id/books', to: 'books#user_books', as: :user_books
  get '/users/:user_id/books/new', to: 'books#new', as: :new_boks
  post '/users/:user_id/books', to: 'books#create', as: :create_books
  get '/users/:user_id/books/:books_id', to: 'books#show', as: :show_boks
  get '/users/:user_id/books/:books_id/edit', to: 'books#edit', as: :edit_books
  patch '/users/:user_id/books', to: 'books#update', as: :update_books
  delete '/users/:user_id/books/:books_id', to: 'books#destroy', as: :destroy_books

  # Translation routes
  # TODO Change next routes to /users/:user_id/books/:book_id/user_translations
  # get '/users/:user_id/books/:book_id/translations', to: 'translations#user_translations', as: :user_translations
  get '/users/:user_id/books/:book_id/examples', to: 'examples#user_examples', as: :user_examples
  # get '/users/:user_id/books/:book_id/', to: 'translations#update_translations', as: :update_translation

  get '/users/:user_id/books/:book_id/translations/:translation_id/edit', to: 'translations#edit', as: :translations_edit
  put '/users/:user_id/books/:book_id/translations/:translation_id', to: 'translations#update', as: :translations_update

  get '/users/:user_id/books/:book_id/new_user_translation', to: 'translations#new_user_translation', as: :new_user_translation
  post 'add_user_translation', to: 'translations#add_user_translation', as: :add_user_translation

  ## Books translations
  put '/books/:book_id/user_translations/:translation_id/change_learned_status', to: 'books_translations#change_learned_status', as: :change_learned_status
  delete '/books/:book_id/user_translations/:translation_id/remove_from_user_book', to: 'books_translations#remove_from_user_book', as: :remove_from_user_book
  get '/users/:user_id/books/:book_id/translations', to: 'books_translations#books_translations', as: :books_translations

  #words
  # get '/users/:user_id/books/:book_id/translations/:translation_id/words/new', to: 'words#new', as: :word_new
  delete '/users/:user_id/books/:book_id/translations/:translation_id/words/:word_id', to: 'words#destroy', as: :word_destroy

  # Accounts endpoints
  get '/users/:user_id/accounts/:account_id', to: 'accounts#show', as: :show_account
  get '/users/:user_id/accounts/:account_id/edit', to: 'accounts#edit', as: :edit_account
  patch '/users/:user_id/accounts/:account_id', to: 'accounts#update', as: :update_account

  # user vocabularies
  get '/users/:user_id/user-vocabularies', to: 'users#user_vocabularies', as: :user_vocabularies

  get 'turbo-test', to: 'books_translations#turbo_test', as: :turbo_test

  root to: 'books#user_books'
end
