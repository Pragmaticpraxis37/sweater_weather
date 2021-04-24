require 'rails_helper'

describe 'Geocoding Requests' do
  describe 'obtains forecasts' do
    it 'can obtain forecast information' do
      VCR.use_cassette('Denver,CO') do
      get api_v1_forecasts_path, params: {location: "Denver,CO"}

      require "pry"; binding.pry

      forecast = JSON.parse(response.body, symbolize_names: true)


      expect(data).to be_a(OpenStruct)
      end
    end
  end
end






# VCR.turn_off!
# WebMock.allow_net_connect!
# VCR.turn_on!
