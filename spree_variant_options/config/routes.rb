Spree::Core::Engine.routes.append do

  namespace :admin do
    resources :option_values do
      collection do
        post :update_positions
      end
      member do
        post :delete_image
      end
    end

    resources :products do
      resources :variants do
        collection do
          post :generate_for_option_types
          post :delete_all
          post :update_multiple
        end
      end
    end

  end

end
