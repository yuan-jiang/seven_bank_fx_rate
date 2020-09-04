# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SevenBankFxRate::Parser do
  describe '#meta' do
    context 'with valid header info in xml' do
      it 'returns meta object with corresponding attributes' do
        xml = File.open(File.expand_path('../fixtures/fx_rate_header.xml', __dir__))
        parser = SevenBankFxRate::Parser.new xml
        meta = parser.meta
        expect(meta.create_date).to eq '20200901'
        expect(meta.apply_date).to eq '20200902'
        expect(meta.apply_time).to eq '0800'
        expect(meta.data_count).to eq '0288'
      end
    end

    context 'with invalid info' do
      it 'returns nil for meta attributes if xml contains no header info' do
        parser = SevenBankFxRate::Parser.new '<fxrateinfo></fxrateinfo>'
        meta = parser.meta
        expect(meta.create_date).to be_nil
        expect(meta.apply_date).to be_nil
        expect(meta.apply_time).to be_nil
        expect(meta.data_count).to be_nil
      end

      [nil, '', 'not xml', '123', '<p></p>'].each do |unexpected_xml|
        it "returns nil for meta attributes if xml is #{unexpected_xml.inspect}" do
          parser = SevenBankFxRate::Parser.new unexpected_xml
          meta = parser.meta
          expect(meta.create_date).to be_nil
          expect(meta.apply_date).to be_nil
          expect(meta.apply_time).to be_nil
          expect(meta.data_count).to be_nil
        end
      end
    end
  end

  describe '#countries' do
    context 'with valid countries info in xml' do
      it 'returns array of country objects with exchange rate data' do
        xml = File.open(File.expand_path('../fixtures/fx_rate_countries.xml', __dir__))
        parser = SevenBankFxRate::Parser.new xml
        countries = parser.countries
        expect(countries.length).to eq 1
        country = countries.first
        expect(country.country_code).to eq 'CN'
        expect(country.country_name).to eq 'China'
        currencies = country.currencies
        expect(currencies.length).to eq 2
        expect(currencies.first.currency_code).to eq 'CNY'
        expect(currencies.first.currency_name).to eq 'Chinese Yuan Renminbi'
        expect(currencies.first.fx_rate).to eq '0.0636548'
        expect(currencies.last.currency_code).to eq 'USD'
        expect(currencies.last.currency_name).to eq 'US Dollar'
        expect(currencies.last.fx_rate).to eq '0.0093211'
      end
    end

    context 'with invalid info' do
      it 'returns empty array if xml contains no countries info' do
        parser = SevenBankFxRate::Parser.new '<fxrateinfo></fxrateinfo>'
        countries = parser.countries
        expect(countries.length).to eq 0
      end

      [nil, '', 'not xml', '123', '<p></p>'].each do |unexpected_xml|
        it "returns empty array if xml is #{unexpected_xml.inspect}" do
          parser = SevenBankFxRate::Parser.new unexpected_xml
          countries = parser.countries
          expect(countries.length).to eq 0
        end
      end
    end
  end
end
