# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SevenBankFxRate::Agent do
  before :all do
    WebMock.disable_net_connect!
  end

  after :all do
    WebMock.enable_net_connect!
  end

  after :each do
    WebMock.reset!
  end

  describe '.response' do
    context 'when http request responds with 200 code' do
      before :each do
        stub_request(
          :get,
          SevenBankFxRate::SOURCE_URL
        ).to_return(
          status: 200,
          body: '<fxrateinfo></fxrateinfo>'
        )
      end

      it 'returns xml body' do
        expect(SevenBankFxRate::Agent.response).to eq '<fxrateinfo></fxrateinfo>'
      end
    end

    context 'when http request responds with non-200 code' do
      before :each do
        stub_request(
          :get,
          SevenBankFxRate::SOURCE_URL
        ).to_return(status: 400)
      end

      it 'raises StandardError' do
        expect { SevenBankFxRate::Agent.response }.to raise_error StandardError
      end
    end

    context 'when http request timeouts' do
      before :each do
        stub_request(
          :get,
          SevenBankFxRate::SOURCE_URL
        ).to_timeout
      end

      it 'raises Net::OpenTimeout error' do
        expect { SevenBankFxRate::Agent.response }.to raise_error Net::OpenTimeout
      end
    end

    context 'when http request fails' do
      before :each do
        stub_request(
          :get,
          SevenBankFxRate::SOURCE_URL
        ).to_raise StandardError
      end

      it 'raises StandardError' do
        expect { SevenBankFxRate::Agent.response }.to raise_error StandardError
      end
    end
  end
end
