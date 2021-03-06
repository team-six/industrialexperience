Dd::Application.routes.draw do


  
  resources :password_resets
  resources :skills
  resources :users
  resources :session, only: [:new, :create, :destroy]
  resources :dashboard
  resources :settings
  resources :employees do
    collection { post :import }
  end
  resources :calls do
    collection { post :import }
  end
  resources "contacts", only: [:new, :create]
  resources "requests", only: [:new, :create]

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
    #root 'welcome#index'
    root 'session#new'
    get 'signin', to: "session#new"
    match 'signout', to: "session#destroy", via: :delete
    #get 'system_users/:id' => 'users#show'
    #get "system_users/index"
    #get "admin_users/index"
    #get "system_user/index"
    get 'administration', to: "admin_users#index", as: "administration"
    get 'employee_import', to: "employees#employee_import"
    get 'employee_active', to: "employees#active"
    get 'employee_leave', to: "employees#leave"
    get 'employee_sick', to: "employees#sick"
    get 'employee_maternity', to: "employees#maternity"
    get 'employee_compassionate', to: "employees#compassionate"
    get 'employee_retrenched', to: "employees#retrenched"
    get 'employee_active_allocate', to: "employees#active_allocate"
    match '/contacts', to: 'contacts#new', via: 'get'
    match '/requests', to: 'requests#new', via: 'get'
    get "active/new"
    





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
