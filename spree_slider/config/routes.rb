Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :sliders
  end
end
