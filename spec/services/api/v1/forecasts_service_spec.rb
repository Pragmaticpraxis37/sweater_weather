require 'rails_helper'

describe 'Forecasts Service' do
  describe 'class methods' do
    it '::conn' do
      connection = ForecastsService.conn

      expect(connection).to be_a(Faraday::Connection)
    end

    it '::forecast', :vcr do
      result = ForecastsService.forecast([39.738453, -104.984853])

      expect(result).to be_a(Hash)
      expect(result.keys).to match_array [:lat, :lon, :timezone, :timezone_offset, :current, :minutely, :hourly, :daily]
    end
  end

  describe 'class methods - sad path', :vcr do
    it '::forecast returns a 400 and error if no coordinates are provided' do
      result = ForecastsService.forecast("")

      expect(result).to be_a(Hash)
      expect(result.keys).to match_array [:cod, :message]
      expect(result[:cod]).to be_a(String)
      expect(result[:cod]).to eq("400")
      expect(result[:message]).to be_a(String)
      expect(result[:message]).to eq("Nothing to geocode")
    end
  end
end
