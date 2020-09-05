# SevenBankFxRate [![Gem Version](https://badge.fury.io/rb/seven_bank_fx_rate.svg)](https://badge.fury.io/rb/seven_bank_fx_rate)

Easier access to the foreign exchange rate data of Seven Bank international
money transfer service in Japan, with JPY1.00 as the base currency and unit.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'seven_bank_fx_rate'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install seven_bank_fx_rate

## Usage

- Require the module
```ruby
require 'seven_bank_fx_rate'
```

- Get meta information:
```ruby
SevenBankFxRate.create_date
SevenBankFxRate.apply_date
SevenBankFxRate.apply_time
SevenBankFxRate.data_count
```

- Get exchange rate with specific country code and currency code:
```ruby
# methods:
SevenBankFxRate.for :xx, :yyy
SevenBankFxRate.find 'xx', 'yyy'
SevenBankFxRate.country_xx_currency_yyy

# examples:
SevenBankFxRate.for :cn, :cny
SevenBankFxRate.for 'cn', 'usd'
SevenBankFxRate.for :cn, :CNY
SevenBankFxRate.for :CN, :usd
SevenBankFxRate.find :cn, :cny
SevenBankFxRate.find 'cn', 'usd'
SevenBankFxRate.country_cn_currency_cny
SevenBankFxRate.country_CN_currency_USD

# notes:
# * xx standards for country code and yyy standards for currency code
# * both symbol and string formats can be used for either code
# * both country code and currency code are case insensitive
# * country code reference: https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
# * currency code reference: https://en.wikipedia.org/wiki/ISO_4217
```

- Get an array of exchange rate for all available countries and currencies:
```ruby
SevenBankFxRate.all
```

- Forcibly update latest data:
```ruby
SevenBankFxRate.update!
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yuan-jiang/seven_bank_fx_rate. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/yuan-jiang/seven_bank_fx_rate/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SevenBankFxRate project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/yuan-jiang/seven_bank_fx_rate/blob/master/CODE_OF_CONDUCT.md).
