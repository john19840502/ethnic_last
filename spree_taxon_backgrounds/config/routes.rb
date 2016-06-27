Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :backgrounds do
      collection do
        post :update_positions
      end
    end
  end
end
