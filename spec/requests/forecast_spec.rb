require 'rails_helper'

describe 'Geocoding Requests' do
  describe 'obtains forecasts' do
    it 'can obtain forecast information' do
      VCR.use_cassette('Denver,CO') do
        get api_v1_forecasts_path, params: {location: "Denver,CO"}

        forecast = JSON.parse(response.body, symbolize_names: true)

        require "pry"; binding.pry
        expect(response).to be_successful

        expect(forecast).to be_a(Hash)
        expect(forecast.length).to eq(1)
        expect(forecast).to have_key(:data)
        expect(forecast[:data]).to be_a(Hash)
        expect(forecast[:data].length).to eq(3)
        expect(forecast[:data]).to have_key(:id)
        expect(forecast[:data][:id]).to eq(nil)
        expect(forecast[:data]).to have_key(:type)
        expect(forecast[:data][:type]).to eq("forecast")
        expect(forecast[:data]).to have_key(:attributes)
        expect(forecast[:data][:attributes]).to be_a(Hash)
        expect(forecast[:data][:attributes].length).to eq(3)
        expect(forecast[:data][:attributes]).to have_key(:current_weather)
        expect(forecast[:data][:attributes]).to have_key(:daily_weather)
        expect(forecast[:data][:attributes]).to have_key(:hourly_weather)
        expect(forecast[:data][:attributes][:current_weather].length).to eq(10)
        expect(forecast[:data][:attributes][:current_weather]).to have_key(:datetime)
        expect(forecast[:data][:attributes][:current_weather][:datetime]).to be_a(String)
        expect(Time.parse(forecast[:data][:attributes][:current_weather][:datetime]).class).to be(Time)
        expect(forecast[:data][:attributes][:current_weather]).to have_key(:sunrise)
        expect(forecast[:data][:attributes][:current_weather][:sunrise]).to be_a(String)
        expect(Time.parse(forecast[:data][:attributes][:current_weather][:sunrise]).class).to be(Time)
        expect(forecast[:data][:attributes][:current_weather]).to have_key(:sunset)
        expect(forecast[:data][:attributes][:current_weather][:sunset]).to be_a(String)
        expect(Time.parse(forecast[:data][:attributes][:current_weather][:sunset]).class).to be(Time)
        expect(forecast[:data][:attributes][:current_weather]).to have_key(:temperature)
        expect(forecast[:data][:attributes][:current_weather][:temperature]).to be_a(Float)
        expect(forecast[:data][:attributes][:current_weather]).to have_key(:feels_like)
        expect(forecast[:data][:attributes][:current_weather][:feels_like]).to be_a(Float)
        expect(forecast[:data][:attributes][:current_weather]).to have_key(:humidity)
        expect(forecast[:data][:attributes][:current_weather][:humidity]).to be_kind_of(Numeric)
        expect(forecast[:data][:attributes][:current_weather]).to have_key(:uvi)
        expect(forecast[:data][:attributes][:current_weather][:uvi]).to be_kind_of(Numeric)
        expect(forecast[:data][:attributes][:current_weather]).to have_key(:visibility)
        expect(forecast[:data][:attributes][:current_weather][:visibility]).to be_kind_of(Numeric)
        expect(forecast[:data][:attributes][:current_weather]).to have_key(:conditions)
        expect(forecast[:data][:attributes][:current_weather][:conditions]).to be_a(String)
        expect(forecast[:data][:attributes][:current_weather]).to have_key(:icon)
        expect(forecast[:data][:attributes][:current_weather][:icon]).to be_a(String)

        

      end
    end
  end
end






# VCR.turn_off!
# WebMock.allow_net_connect!
# VCR.turn_on!
