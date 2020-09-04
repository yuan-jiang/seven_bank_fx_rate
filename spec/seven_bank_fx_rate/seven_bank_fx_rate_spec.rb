# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SevenBankFxRate do
  before :all do
    WebMock.disable_net_connect!
  end

  after :all do
    WebMock.enable_net_connect!
  end

  after :each do
    WebMock.reset!
  end

  context 'with successful http response for xml data' do
    before :each do
      stub_request(
        :get,
        SevenBankFxRate::SOURCE_URL
      ).to_return(
        status: 200,
        body: File.open(File.expand_path('../fixtures/fx_rate_full.xml', __dir__)).read
      )
      SevenBankFxRate.update!
    end

    describe 'meta attribute methods' do
      it 'returns meta attribute values as expected' do
        expect(SevenBankFxRate.create_date).to eq '20200901'
        expect(SevenBankFxRate.apply_date).to eq '20200902'
        expect(SevenBankFxRate.apply_time).to eq '0800'
        expect(SevenBankFxRate.data_count).to eq '0288'
      end
    end

    describe '.for' do
      it 'returns fx_rate for given country code and currency code' do
        expect(SevenBankFxRate.for(:cn, :cny)).to eq '0.0636548'
      end

      [['CN', :Cny], [:CN, 'cny'], ['cn', :CNY], [:cN, 'CNY']].each do |country_code, currency_code|
        it "returns fx_rate when country code=#{country_code.inspect} and currency code=#{currency_code.inspect}" do
          expect(SevenBankFxRate.for(country_code, currency_code)).to eq '0.0636548'
        end
      end

      it 'returns nil for unknown country code or currency code' do
        expect(SevenBankFxRate.for(:xx, :cny)).to be_nil
        expect(SevenBankFxRate.for(:cn, :yyy)).to be_nil
        expect(SevenBankFxRate.for(:xx, :yyy)).to be_nil
      end
    end

    describe '.find' do
      it 'returns fx_rate for given country code and currency code' do
        expect(SevenBankFxRate.find(:cn, :usd)).to eq '0.0093211'
      end
    end

    describe '.country_{xx}_currency_{yyy}' do
      it 'returns fx_rate for given country code and currency code' do
        expect(SevenBankFxRate.country_cn_currency_usd).to eq '0.0093211'
      end

      it 'raises NoMethodError error if country code or currency code pattern not match' do
        expect { SevenBankFxRate.country_cn1_currency_usd }.to raise_error NoMethodError
        expect { SevenBankFxRate.country_cn_currency_usd1 }.to raise_error NoMethodError
      end
    end

    describe '.all' do
      it 'returns fx_rate for all countries and currencies' do
        expect(SevenBankFxRate.all.length).to eq 2
        country1 = SevenBankFxRate.all.first
        expect(country1.country_code).to eq 'CN'
        expect(country1.country_name).to eq 'China'
        currencies1 = country1.currencies
        expect(currencies1.length).to eq 2
        expect(currencies1.first.currency_code).to eq 'CNY'
        expect(currencies1.first.currency_name).to eq 'Chinese Yuan Renminbi'
        expect(currencies1.first.fx_rate).to eq '0.0636548'
        expect(currencies1.last.currency_code).to eq 'USD'
        expect(currencies1.last.currency_name).to eq 'US Dollar'
        expect(currencies1.last.fx_rate).to eq '0.0093211'
        country2 = SevenBankFxRate.all.last
        expect(country2.country_code).to eq 'US'
        expect(country2.country_name).to eq 'United States'
        currencies2 = country2.currencies
        expect(currencies2.length).to eq 1
        expect(currencies2.first.currency_code).to eq 'USD'
        expect(currencies2.first.currency_name).to eq 'US Dollar'
        expect(currencies2.first.fx_rate).to eq '0.0090763'
      end
    end

    describe '.update!' do
      it 'makes new http request to fetch latest data' do
        WebMock.reset_executed_requests!
        SevenBankFxRate.update!
        expect(WebMock).to have_requested(:get, SevenBankFxRate::SOURCE_URL).once
      end
    end

    describe 'with cached data' do
      it 'makes http request only once' do
        SevenBankFxRate.create_date
        WebMock.reset_executed_requests!
        SevenBankFxRate.apply_date
        SevenBankFxRate.for :cn, :cny
        expect(WebMock).not_to have_requested(:get, SevenBankFxRate::SOURCE_URL)
      end
    end
  end

  context 'with failed http response' do
    context 'when response code is 200 but content is invalid xml' do
      before :each do
        stub_request(
          :get,
          SevenBankFxRate::SOURCE_URL
        ).to_return(status: 200, body: 'invalid xml')
        SevenBankFxRate.update!
      end

      it 'returns nil for all meta attributes' do
        expect(SevenBankFxRate.create_date).to be_nil
        expect(SevenBankFxRate.apply_date).to be_nil
        expect(SevenBankFxRate.apply_time).to be_nil
        expect(SevenBankFxRate.create_date).to be_nil
      end

      it 'returns empty array for .all' do
        expect(SevenBankFxRate.all.length).to eq 0
      end

      it 'returns nil for .for, .find, and country_xx_currency_yyy' do
        expect(SevenBankFxRate.for(:cn, :cny)).to be_nil
        expect(SevenBankFxRate.find(:cn, :cny)).to be_nil
        expect(SevenBankFxRate.country_cn_currency_cny).to be_nil
      end
    end

    context 'when response code is 400' do
      before :each do
        stub_request(
          :get,
          SevenBankFxRate::SOURCE_URL
        ).to_return(status: 400)
      end

      it 'raises StandardError' do
        expect { SevenBankFxRate.update! }.to raise_error StandardError
      end
    end
  end
end
