# frozen_string_literal: true

module SevenBankFxRate
  module Elements
    # Corresponds to the country tag in xml:
    # <country>
    #   <countrycode>CN</countrycode>
    #   <countryname>China</countryname>
    #   <currency>
    #     <currencycode>CNY</currencycode>
    #     <currencyname>Chinese Yuan Renminbi</currencyname>
    #     <fxrate>0.0636548</fxrate>
    #   </currency>
    #   <currency>
    #     <currencycode>USD</currencycode>
    #     <currencyname>US Dollar</currencyname>
    #     <fxrate>0.0093211</fxrate>
    #   </currency>
    # </country>
    class Country
      attr_accessor :country_code, :country_name, :currencies
    end
  end
end
