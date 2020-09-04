# frozen_string_literal: true

require 'net/http'

module SevenBankFxRate
  SOURCE_URL = 'https://www.sevenbank.co.jp/t/html/file/CurrentFXList.xml'

  # Sends http request to fetch the latest exchange rate data
  class Agent
    # Fetches the latest data as Net::HTTPResponse object
    # @return the body of Net::HTTPResponse
    #
    # @raise errors if response code is not '200', or any network failure
    def self.response
      puts "Sending http request to: #{SOURCE_URL}" if $DEBUG
      response = Net::HTTP.get_response URI.parse(SOURCE_URL)
      unless response.code == '200'
        puts response.body if $DEBUG
        raise StandardError,
              "Unexpected response from fetching latest data: #{response.code}"
      end
      response.body
    end
  end
end
