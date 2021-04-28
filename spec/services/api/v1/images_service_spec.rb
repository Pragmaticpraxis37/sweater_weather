require 'rails_helper'

describe 'Images Service' do
  describe 'class methods' do
    it '::conn' do
      connection = ImagesService.conn

      expect(connection).to be_a(Faraday::Connection)
    end

    it '::image_data' do
      VCR.use_cassette('Denver,CO_Image') do
        result = ImagesService.image_data("Denver,CO")

        expect(result).to be_a(Hash)
        expect(result.keys).to match_array [:total, :total_pages, :results]
      end
    end
  end

  describe 'class methods - sad path' do
    it '::image_data returns an error messge if no location is provided' do
      result = ImagesService.image_data("")

      expect(result).to eq("Error search terms")
    end
  end
end
