require 'rails_helper'

describe 'Coordinates Service' do
  describe 'class methods' do
    it '::conn' do
      connection = CoordinatesService.conn

      expect(connection).to be_a(Faraday::Connection)
    end

    it '::coordinates' do
      VCR.use_cassette('Denver,CO_Forecast') do
        result = CoordinatesService.coordinates("Denver,CO")

        expect(result).to be_an(Array)
        expect(result.length).to eq(2)
        expect(result[0]).to be_a(Float)
        expect(result[1]).to be_a(Float)
      end
    end
  end
end
