# frozen_string_literal: true

module SevenBankFxRate
  class << self
    # Methods to access meta attributes of the latest exchange rate data
    %i[create_date apply_date apply_time data_count].each do |attr|
      define_method attr do
        data.meta.send attr
      end
    end

    # @return exchange rate for given country code and currency code or nil
    #
    # if either country or currency code is invalid or when there is no
    # exchange rate data available for the country and currency combination
    def for(country_code, currency_code)
      country = all.find do |c|
        c.country_code == country_code.to_s.upcase
      end
      return unless country

      currency = country.currencies.find do |c|
        c.currency_code == currency_code.to_s.upcase
      end
      currency&.fx_rate
    end

    alias find for

    # @return exchange rate data for all available countries
    #
    # as an array of SevenBankFxRate::Elements::Country
    def all
      data.countries
    end

    # Upon accessing of any of the public methods, the exchange rate data are
    # fetched once and then cached for the lifetime of the module, because the
    # remote xml source is updated only 3 times a day based on the website.
    #
    # However, this method still allows fetching the latest data when needed.
    def update!
      @data = Data.new
      true
    end

    private

    def data
      @data ||= Data.new
    end

    def method_missing(method_name, *arguments, &block)
      if /\Acountry_[A-Za-z]{2}_currency_[A-Za-z]{3}\z/ =~ method_name.to_s
        _, country_code, _, currency_code = method_name.to_s.split('_')
        send :for, country_code, currency_code
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      method_name.to_s.start_with?('country_') || super
    end
  end

  # Holds the parsed exchange rate data represented by
  # ruby objects converted from original xml content
  class Data
    attr_reader :meta, :countries

    def initialize
      parser = Parser.new Agent.response
      @meta = parser.meta
      @countries = parser.countries
    end
  end
end
