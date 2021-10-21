Rails.application.routes.draw do
  resource :password_reset
  resource :user_session
  resources :users

  get "admin/index"
  get "admin/clear_all_cache"

  get "stats/index"
  get "stats/index2"

  resources :areas do
    get :machines_per_location_report, on: :member
    get :print, on: :member
    resources :localities
  end

  resources :machines do
    get :recent, on: :collection
  end
  resources :locations, shallow: true do
    get :for_wordpress, on: :collection
    get :for_wordpress_list, on: :collection
    resources :machines
  end
  resources :localities, shallow: true do
    resources :locations
  end

  resources :titles do
    get :search, on: :collection
    get :active, on: :collection
    get :duplicate, on: :collection
    get :dupe_resolve, on: :collection
    get :idless, on: :collection
  end

  get '/wrapper' => 'home#wrapper'
  get '/noop' => 'home#noop'
  get '/login' => 'user_sessions#new'
  root controller: :areas, action: :show, id: 'seattle'
end
