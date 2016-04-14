Rails.application.routes.draw do
  mount Spree::Core::Engine, at: '/'

  get '/edwardvanvliet', to: redirect('/search/brands/edward%20van%20vliet')

  scope module: 'spree' do
    get '/brands/:brand_name/*filter', to: "search#brands_redirect", as: 'brand_redirector'
    get '/collection', to: 'products#index', as: 'collection'
    post '/do_search', to: 'search#do_search'
    get '/country/set', to: 'country#set', as: 'set_country'
    get '/country/set_currency', to: 'country#set_currency', as: 'set_currency'
    get 'new_information_requests', to: 'information_requests#new', as: 'new_information_request'
    post 'create_information_requests', to: 'information_requests#create', as: 'create_information_request'
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
  get '/search', to: 'search#result', as: 'product_search'
  get '/search/*filters', to: 'search#result', as: 'product_search_filtered'
end
