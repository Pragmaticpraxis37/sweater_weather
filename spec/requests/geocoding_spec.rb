require 'rails_helper'

describe 'Geocoding Requests' do
  describe 'obtains forecasts' do
    it 'can obtain forecast information' do
      VCR.turn_off!
      WebMock.allow_net_connect!
      get api_v1_forecasts_path

      # require "pry"; binding.pry

      # expect(data).to be_a(OpenStruct)
      VCR.turn_on!
    end
  end
end
