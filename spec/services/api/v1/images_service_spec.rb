require 'rails_helper'

describe 'Images Service' do
  describe 'class methods' do
    it '::conn' do
      connection = ImagesService.conn

      expect(connection).to be_a(Faraday::Connection)
    end

    it '::image_data' do
      VCR.turn_off!
      WebMock.allow_net_connect!
        result = ImagesService.image_data("Denver,CO")

        expect(result).to be_a(Hash)
        expect(result.keys).to match_array [:total, :total_pages, :results]
      VCR.turn_on!
    end
  end
end
