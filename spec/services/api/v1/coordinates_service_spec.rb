require 'rails_helper'

describe 'Coordinates Service' do
  describe 'class methods - happy path' do
    it '::conn' do
      connection = CoordinatesService.conn

      expect(connection).to be_a(Faraday::Connection)
    end

    it '::coordinates', :VCR do
      result = CoordinatesService.coordinates("Denver,CO")

      expect(result).to be_an(Array)
      expect(result.length).to eq(2)
      expect(result[0]).to be_a(Float)
      expect(result[1]).to be_a(Float)
    end

    it '::directions', :VCR do
      result = CoordinatesService.directions("Denver,CO", "Pueblo,CO")

      expect(result).to be_an(Hash)
      expect(result.length).to eq(2)
      expect(result.keys).to match_array [:route, :info]
    end
  end

  describe 'class methods - sad path' do
    it '::coordinates returns a error message if coordinates are not provided' do
      result = CoordinatesService.coordinates("")

      expect(result).to eq("Error search terms")
    end

    it '::directions returns an error message if origin and destination are not provided' do
      result = CoordinatesService.directions("", "")

      expect(result).to be_an(Hash)
      expect(result.length).to eq(2)
      expect(result.keys).to match_array [:route, :info]
      expect(result[:info][:messages][0]).to eq("At least two locations must be provided.")
    end

    it '::directions returns an error message if only origin is provided' do
      result = CoordinatesService.directions("Denver, CO", "")

      expect(result).to be_an(Hash)
      expect(result.length).to eq(2)
      expect(result.keys).to match_array [:route, :info]
      expect(result[:info][:messages][0]).to eq("At least two locations must be provided.")
    end

    it '::directions returns an error message if only destination is provided' do
      result = CoordinatesService.directions("", "Pueblo, CO")

      expect(result).to be_an(Hash)
      expect(result.length).to eq(2)
      expect(result.keys).to match_array [:route, :info]
      expect(result[:info][:messages][0]).to eq("At least two locations must be provided.")
    end
  end
end
