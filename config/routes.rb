Skillshot::Application.routes.draw do
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

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
