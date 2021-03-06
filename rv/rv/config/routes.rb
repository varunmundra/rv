Rv::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  root :to => 'static_pages#index'
  get "academics/video"
  get "academics/videos"
  get "academics/images"
  get "academics/videoteaser"
  get "transactions/karvy1"
  get "transactions/cams1"
  match '/',    to: 'static_pages#index',    via: 'get'
  match '/',    to: 'static_pages#index',    via: 'post'
  match '/home',    to: 'static_pages#home',    via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/products', to: 'static_pages#products', via: 'get'
  match '/account', to: 'static_pages#account', via: 'get'
  match '/sip_registration', to: 'static_pages#sip_registration', via: 'get'
  match '/import_sip_registration', to: 'static_pages#import_sip_registration', via: 'post'
  match '/import_sip_transaction', to: 'static_pages#import_sip_transaction', via: 'post'
  match '/sip_transactions', to: 'static_pages#sip_transactions', via: 'get'
  match '/portfolio', to: 'static_pages#portfolio', via: 'get'
  match '/contacts',     to: 'contacts#new',             via: 'get'
  resources "contacts", only: [:new, :create]
  get "contacts/welcome_email"
  resources :kycs
  resources :kyc_steps
  resources :funds
  post "kycs/update_holding_type"
  post "kycs/new"
  resources :banks
  resources :transactions do 
    collection do
      get :investment
      post :invoice
      post :edit_individual
      post :update_individual
      get :ru
      post :ru
      post :confirmation
      post :cams_upload_feed
      post :cams_import_feed
      post :transact
      get :switch
      post :switch_transact
      post :karvy_upload_feed
    end
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

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
