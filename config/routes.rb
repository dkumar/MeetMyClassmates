Rails.application.routes.draw do
  # You can have the root of your site routed with "root"
  root 'welcome#index'
  get 'welcome/index' => 'welcome#index'

  devise_for :users, :controllers => {:confirmations => 'confirmations'}

  as :user do
      patch '/user/confirmation' => 'confirmations#update', :via => :patch, :as => :update_user_confirmation
  end

  mount FullcalendarEngine::Engine => '/fullcalendar_engine'

  resource :studygroups, only: [:new]
  post 'studygroups/add' => 'studygroups#add'
  get 'studygroups/:id' => 'studygroups#show', as: :studygroup_show
  post '/users/delete_studygroup' => 'users#delete_studygroup', as: :delete_studygroup

  get 'users/:id' => 'users#show', as: :user_show

  post 'users/enroll_course' => 'users#enroll_course', as: :enroll_course
  post 'users/unenroll_course' => 'users#unenroll_course', as: :unenroll_course

  post 'users/join_studygroup' => 'users#join_studygroup', as: :join_studygroup
  post 'users/leave_studygroup' => 'users#leave_studygroup', as: :leave_studygroup

  get 'unscheduled-group/show/:id' => 'studygroups#show_unscheduled'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

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
