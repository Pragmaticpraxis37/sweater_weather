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
end
