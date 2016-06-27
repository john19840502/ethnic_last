Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :products do
      resources :product_option_types
    end
    delete '/product_option_types/:id', :to => "product_option_types#destroy", :as => :product_option_type
  end
end
