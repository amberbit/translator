module Translator
  class TranslationsController < ApplicationController
    before_filter :auth

    def index
      section = params[:key].present? && params[:key] + '.'
      params[:group] = "all" unless params["group"]
      @sections = Translator.keys_for_strings(:group => params[:group]).map {|k| k = k.scan(/^[a-z0-9\-_]*\./)[0]; k ? k.gsub('.', '') : false}.select{|k| k}.uniq.sort
      @keys = Translator.keys_for_strings(:group => params[:group], :filter => section)
      if params[:search]
        @keys = @keys.select {|k|
          Translator.locales.any? {|locale| I18n.translate("#{k}", :locale => locale).to_s.downcase.include?(params[:search].downcase)}
        }
      end
      @keys = paginate(@keys)
      render :layout => Translator.layout_name
    end

    def create
      Translator.current_store[params[:key]] = params[:value]
      redirect_to :back unless request.xhr?
    end

    def destroy
      key = params[:id].gsub('-','.')
      Translator.locales.each do |locale|
        Translator.current_store.destroy_entry(locale.to_s + '.' + key)
      end
      redirect_to :back unless request.xhr?
    end

    private

    def auth
      Translator.auth_handler.bind(self).call if Translator.auth_handler.is_a? Proc
    end

    def paginate(collection)
      @page = params[:page].to_i
      @page = 1 if @page == 0
      @total_pages = (collection.count / 50.0).ceil
      collection[(@page-1)*50..@page*50]
    end
  end
end

