require 'spec_helper'

describe Translator do
  before :all do
    conn = Mongo::Connection.new.db("translator_test").collection("translations")
    Translator.current_store = Translator::MongoStore.new(conn)
    I18n.backend = Translator.setup_backend(I18n::Backend::Simple.new)
  end

  it "should list all keys by default" do
    Translator.keys_for_strings.should include("hello.world")
    Translator.keys_for_strings.should include("helpers.submit.update")
  end

  it "should list only keys that their values are Strings in Yaml files" do
    Translator.keys_for_strings.should_not include("date.month_names")
  end

  it "should be possible to list framework keys with option" do
    Translator.keys_for_strings(:group => :framework).should_not include("hello.world")
    Translator.keys_for_strings(:group => :framework).should include("helpers.submit.update")
  end

  it "should be possible to list all keys with option" do
    Translator.keys_for_strings(:group => :all).should include("hello.world")
    Translator.keys_for_strings(:group => :all).should include("helpers.submit.update")
  end

  describe 'blacklist' do
    after :each do
      Translator::blacklisted_keys = []
    end

    it "should be possible to blacklist keys" do
      Translator.keys_for_strings(:group => :all).should include("hello.world")
      Translator.blacklisted_keys = ['hello.']
      Translator.keys_for_strings(:group => :all).should_not include("hello.world")
    end

    it "should only match keys from the beginning" do
      Translator.blacklisted_keys = ['world']
      Translator.keys_for_strings(:group => :all).should include("hello.world")
    end
  end
end
