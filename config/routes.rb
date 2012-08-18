# When Rails >= 3.1
if defined?(Translator::Engine)
  Translator::Engine.routes.draw do
    resources :translations
  end
else
  Rails.application.routes.draw do
    resources :translations, :to => "Translator::Translations"
  end
end
