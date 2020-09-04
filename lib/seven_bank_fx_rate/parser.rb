# frozen_string_literal: true

require 'rexml/document'

module SevenBankFxRate
  # Parses xml response content and convert to ruby objects
  class Parser
    # @param response the body of Net::HTTPResponse
    def initialize(response)
      @root = REXML::Document.new(response).root
      @meta = Elements::Meta.new
      @countries = []
    end

    # Parses the <header> section in original xml response
    # @return instance of SevenBankFxRate::Elements::Meta
    def meta
      return @meta unless @root

      %w[create_date apply_date apply_time data_count].each do |attr|
        @root.elements.each("header/#{attr.split('_').join}") do |e|
          @meta.send("#{attr}=".to_sym, e.text.strip)
        end
      end
      @meta
    end

    # Parses the <countries> section in original xml response
    # @return an array of SevenBankFxRate::Elements::Country
    def countries
      return @countries unless @root

      @root.elements.each('countries/country') do |country_tag|
        country = Elements::Country.new
        %w[country_code country_name].each do |attr|
          country_tag.elements.each(attr.split('_').join) do |e|
            country.send("#{attr}=".to_sym, e.text.strip)
          end
        end
        country.currencies = currencies country_tag
        @countries << country
      end
      @countries
    end

    private

    # Parses the <currencies> section in original xml response
    # @return an array of SevenBankFxRate::Elements::Currency
    def currencies(country_tag)
      currencies = []
      country_tag.elements.each('currency') do |currency_tag|
        currency = Elements::Currency.new
        %w[currency_code currency_name fx_rate].each do |attr|
          currency_tag.elements.each(attr.split('_').join) do |e|
            currency.send("#{attr}=".to_sym, e.text.strip)
          end
        end
        currencies << currency
      end
      currencies
    end
  end
end
