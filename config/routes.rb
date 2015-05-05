Rails.application.routes.draw do
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end

  mount Spree::Core::Engine, at: '/'

  scope module: 'spree' do
    get '/collection', to: 'products#index', as: 'collection'
    # search
    get '/search', to: 'search#result', as: 'product_search'
    post '/do_search', to: 'search#do_search'
    get '/search/*filters', to: 'search#result', as: 'product_search_filtered'

    get '/country/set', to: 'country#set', as: 'set_country'
    get '/country/set_currency', to: 'country#set_currency', as: 'set_currency'
    get 'new_information_requests', to: 'information_requests#new', as: 'new_information_request'
    get 'create_information_requests', to: 'information_requests#create', as: 'create_information_request'
    get '/about', to: 'about_us#show', as: 'about'

    namespace :api, defaults: { format: 'json' } do
      resources :shipping_rates, only: [:index]
    end
  end

  get '/404_custom', to: 'errors#not_found'
end

Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :information_requests
    resources :collection_images
  end
  resources :favorites, only: [] do
    collection do
      post :send_email
    end
  end
end
