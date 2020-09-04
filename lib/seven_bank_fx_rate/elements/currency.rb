# frozen_string_literal: true

module SevenBankFxRate
  module Elements
    # Corresponds to the currency tag in xml:
    # <currency>
    #   <currencycode>USD</currencycode>
    #   <currencyname>US Dollar</currencyname>
    #   <fxrate>0.0090386</fxrate>
    # </currency>
    class Currency
      attr_accessor :currency_code, :currency_name, :fx_rate
    end
  end
end
