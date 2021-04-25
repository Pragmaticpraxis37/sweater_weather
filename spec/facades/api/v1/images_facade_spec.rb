require 'rails_helper'

describe 'Forecasts Facade' do
  describe 'class methods' do
    it '::current_weather_data' do
      VCR.use_cassette('Denver,CO_Image') do
        image =  ImagesService.image_data("Denver,CO")
        result = ImagesFacade.credit_data(image)

        expect(result).to be_a(Hash)
        expect(result.length).to eq(3)
        expect(result.keys).to match_array [:source, :author, :attribution_link]
        expect(result[:source]).to be_a(String)
        expect(result[:source]).to eq('unsplash.com')
        expect(result[:author]).to be_a(String)
        expect(result[:attribution_link]).to be_a(String)
      end
    end

    it '::image_data' do
      VCR.use_cassette('Denver,CO_Image') do
        image =  ImagesService.image_data("Denver,CO")
        credit = ImagesFacade.credit_data(image)
        result = ImagesFacade.image_data(image, credit)

        expect(result).to be_a(Hash)
        expect(result.length).to eq(3)
        expect(result.keys).to match_array [:location, :image_url, :credit]
        expect(result[:location]).to be_a(String)
        expect(result[:image_url]).to be_a(String)
        expect(result[:credit]).to be_a(Hash)
        expect(result[:credit].length).to eq(3)
        expect(result[:credit].keys).to match_array [:source, :author, :attribution_link]
        expect(result[:credit][:source]).to be_a(String)
        expect(result[:credit][:source]).to eq('unsplash.com')
        expect(result[:credit][:author]).to be_a(String)
        expect(result[:credit][:attribution_link]).to be_a(String)
      end
    end

    it '::background' do
      VCR.use_cassette('Denver,CO_Image') do
        image =  ImagesService.image_data("Denver,CO")
        credit = ImagesFacade.credit_data(image)
        image_and_credit = ImagesFacade.image_data(image, credit)
        result = ImagesFacade.background(image_and_credit)

        expect(result).to be_an(OpenStruct)
        expect(result.respond_to?('id')).to eq(true)
        expect(result.respond_to?('image')).to eq(true)
      end 
    end
  end
end
