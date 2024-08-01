require 'httparty'

class WompiService
  include HTTParty
  base_uri 'https://api.co.uat.wompi.dev/v1'

  def initialize
    @headers = {
      'Content-Type' => 'application/json'
    }
  end

  def get_merchant_details
    response = self.class.get('/merchants/pub_stagint_fjIqRyHmHvmqYgPFCO5nibfrtraL6ixq', headers: @headers)
    parse_response(response)
  end

  private

  def parse_response(response)
    if response.success?
      response.parsed_response
    else
      { error: response.message }
    end
  end
end
