Rails.application.routes.draw do

  resources :projects do
    put "tasks/delete_all"=>"tasks#delete_all"
    get "tasks/delete_all"=>"tasks#delete_all"
    resources :tasks do 
       collection { post :import }
      #  collection do
        #  post :import
         # delete :delete_all
      #  end
    end
  end
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'projects#index'
end
