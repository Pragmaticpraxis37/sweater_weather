require 'rails_helper'

describe 'Forecasts Service' do
  describe 'class methods' do
    it '::conn' do
      connection = ForecastsService.conn

      expect(connection).to be_a(Faraday::Connection)
    end

    it '::forecast' do
      VCR.use_cassette('Denver_CO') do
        result = ForecastsService.forecast([39.738453, -104.984853])

        expect(result).to be_a(Hash)
        expect(result.keys).to match_array [:lat, :lon, :timezone, :timezone_offset, :current, :minutely, :hourly, :daily]
      end
    end
  end
end
