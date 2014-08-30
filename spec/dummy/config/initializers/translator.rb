if Rails.env.development?
  Translator.current_store = Translator::RedisStore.new(Redis.new)

  I18n.backend = Translator.setup_backend(I18n::Backend::Simple.new)
end

#Translator.auth_handler = proc {
#  authenticate_or_request_with_http_basic do |user_name, password|
#    user_name == 'some' && password == 'user'
#  end
#}

