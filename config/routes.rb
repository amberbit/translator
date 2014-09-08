Translator::Engine.routes.draw do
  resources :translations do
    collection do
      get :export
      post :import
      get 'locale/:loc', to: 'translations#locale', as: :by_locale, defaults: { format: 'json' }
    end
  end
end
