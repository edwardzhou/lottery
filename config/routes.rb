Lottery::Application.routes.draw do

  resource :sessions

  get "home/user"
  get "home/index"
  get "rule_info", :to => "home#rule_info"
  get "logout", :to => "sessions#logout"

  resources :home do
    collection do
      get "bet_list"
      get "bet_stat"
      get "test"
      get "history"
      get "credit_info"
      get "change_password"
      post "update_password"
    end
  end

  get "ten_minute/index"

  get "ten_minute/bet"

  resources :gaming do
    member do
      match 'analyst' => :analyst, :iva => [:get, :post]
    end
  end

  namespace :admin do
    root :to => "users#index"
    resources :users do
      member do
        match 'lock' => :lock, :via => [:get, :post]
        match 'unlock' => :unlock, :via => [:get, :post]
        match 'reset_credit' => :reset_credit, :via => [:get, :post]
        match 'bet_list' => :bet_list, :via => :get
      end
    end
    resources :games
    resources :lottery_defs do
      member do
        get "betting"
      end

      resources :odds_levels
    end

    resources :bet_rules
    resources :tasks do
      collection do
        get :reset_av_credit
      end
    end

    resources :daily_stats do
      member do
        get :detail_stat
      end
    end
  end

  namespace :agent do
    root :to => "users#index"
    resources :users do
      member do
        match 'lock' => :lock, :via => [:get, :post]
        match 'unlock' => :unlock, :via => [:get, :post]
        match 'reset_credit' => :reset_credit, :via => [:get, :post]
        match 'bet_list' => :bet_list, :via => :get
      end
    end
    resources :odds_levels
    resources :daily_stats do
      member do
        get :detail_stat
      end
    end
  end

  root :to => "sessions#new"

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
  # just remember to delete public/index2.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
