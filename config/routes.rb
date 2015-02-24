Rails.application.routes.draw do
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end
  
  mount Spree::Core::Engine, at: '/'

  scope module: 'spree' do
    get '/collection', to: 'products#index', as: 'collection'
    get '/country/set', to: 'country#set', as: 'set_country'
    get '/country/set_currency', to: 'country#set_currency', as: 'set_currency'
    get 'new_information_requests', to: 'information_requests#new', as: 'new_information_request'
    get 'create_information_requests', to: 'information_requests#create', as: 'create_information_request'
  end

  get '/404_custom', to: 'errors#not_found'
  
end
