require_relative '../../spec_helper'

describe Translator::TranslationsController, type: :controller do

  before :each do
    Translator.current_store = Translator::RedisStore.new(Redis.new)
    I18n.backend = Translator.setup_backend(I18n::Backend::Simple.new)
    Translator.current_store.clear_database
  end

  describe 'by_locale' do
    it "has endpoint returning translations in JSON format" do
      get 'locale', loc: 'en', use_route: :translator
      json = JSON.parse(response.body)
      Translator.keys_for_strings.each do |key|
        expect(json).to have_key(key)
      end
    end
  end
end

