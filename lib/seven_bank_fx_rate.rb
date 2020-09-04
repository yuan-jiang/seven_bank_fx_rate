# frozen_string_literal: true

# Easier access to the foreign exchange rate data of Seven Bank international
# money transfer service in Japan, with JPY1.00 as the base currency and unit.
#
# Example of usage:
#
# - Get meta information:
#   SevenBankFxRate.create_date
#   SevenBankFxRate.apply_date
#   SevenBankFxRate.apply_time
#   SevenBankFxRate.data_count
#
# - Get exchange rate with specific country code and currency code:
# Method patterns:
#   SevenBankFxRate.for :xx, :yyy
#   SevenBankFxRate.find 'xx', 'yyy'
#   SevenBankFxRate.country_xx_currency_yyy
# where xx is country code and yyy is currency code; both symbol and
# string can be used for either code with case-insensitive formats:
# e.g.
#   SevenBankFxRate.for :cn, :cny
#   SevenBankFxRate.for 'cn', 'usd'
#   SevenBankFxRate.for :cn, :CNY
#   SevenBankFxRate.for :CN, :usd
#   SevenBankFxRate.find :cn, :cny
#   SevenBankFxRate.find 'cn', 'usd'
#   SevenBankFxRate.country_cn_currency_cny
#   SevenBankFxRate.country_CN_currency_USD
#
# Country codes reference:
#   https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
# Currency codes reference:
#   https://en.wikipedia.org/wiki/ISO_4217
#
# - Get an array of exchange rate for all available countries and currencies:
#   SevenBankFxRate.all
#
# - Forcibly update latest data:
#   SevenBankFxRate.update!
#
module SevenBankFxRate
  require 'seven_bank_fx_rate/version'
  require 'seven_bank_fx_rate/agent'
  require 'seven_bank_fx_rate/parser'
  require 'seven_bank_fx_rate/elements/meta'
  require 'seven_bank_fx_rate/elements/country'
  require 'seven_bank_fx_rate/elements/currency'
  require 'seven_bank_fx_rate/seven_bank_fx_rate'
end
