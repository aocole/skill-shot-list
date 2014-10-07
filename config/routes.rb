Skillshot::Application.routes.draw do
  resource :password_reset
  resource :user_session
  resources :users

  get "admin/index"
  get "admin/clear_all_cache"

  get "stats/index"

  resources :areas do
    get :print, :on => :member
    resources :localities
  end

  resources :machines do
    get :recent, :on => :collection
  end
  resources :locations, :shallow => true do
    get :for_wordpress, :on => :collection
    get :for_wordpress_list, :on => :collection
    resources :machines
  end
  resources :localities, :shallow => true do
    resources :locations
  end

  resources :titles do
    get :search, :on => :collection
    get :active, :on => :collection
    get :duplicate, :on => :collection
    get :dupe_resolve, :on => :collection
  end

  get '/wrapper' => 'home#wrapper'
  get '/noop' => 'home#noop'
  get '/login' => 'user_sessions#new'
  root :controller => :areas, :action => :show, :id => 'seattle'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
