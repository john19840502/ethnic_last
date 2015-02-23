Spree::Core::Engine.routes.draw do

  resources :impressions, :only => [:index, :show]

  namespace :admin do
    resources :impressions do
      collection do
          post :update_positions
      end

      resources :images, :controller => "impressions/images" do
        member do
          get :crop
        end
        collection do
          post :update_positions
        end
      end
    end
  end
end
