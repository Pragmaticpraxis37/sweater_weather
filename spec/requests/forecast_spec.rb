require 'rails_helper'
require 'date'

describe 'Forecast Requests' do
  describe 'obtains forecast' do
    it 'can obtain forecast information' do
      VCR.use_cassette('Denver,CO') do
        get api_v1_forecasts_path, params: {location: "Denver,CO"}

        forecast = JSON.parse(response.body, symbolize_names: true)

        require "pry"; binding.pry
        expect(response).to be_successful

        expect(forecast).not_to have_key(forecast[:minutely])
        expect(forecast).not_to have_key(forecast[:lat])
        expect(forecast).not_to have_key(forecast[:lon])
        expect(forecast).not_to have_key(forecast[:timezone])
        expect(forecast).not_to have_key(forecast[:timezone_offset])
        expect(forecast).not_to have_key(forecast[:current_weather][:pressure])
        expect(forecast).not_to have_key(forecast[:current_weather][:dew_point])
        expect(forecast).not_to have_key(forecast[:current_weather][:clouds])
        expect(forecast).not_to have_key(forecast[:current_weather][:wind_speed])
        expect(forecast).not_to have_key(forecast[:current_weather][:wind_deg])
        expect(forecast).not_to have_key(forecast[:current_weather][:wind_gust])


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

        expect(forecast[:data][:attributes][:current_weather]).to be_a(Hash)
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

        expect(forecast[:data][:attributes][:daily_weather]).to be_an(Array)
        expect(forecast[:data][:attributes][:daily_weather].length).to eq(5)

        forecast[:data][:attributes][:daily_weather].each do |day|
          expect(day).to have_key(:date)
          expect(day[:date]).to be_a(String)
          expect(Date.strptime(day[:date], '%m-%d-%Y')).to be_a(Date)
          expect(day).to have_key(:sunrise)
          expect(day[:sunrise]).to be_a(String)
          expect(Time.parse(day[:sunrise]).class).to be(Time)
          expect(day).to have_key(:sunset)
          expect(day[:sunset]).to be_a(String)
          expect(Time.parse(day[:sunset]).class).to be(Time)
          expect(day).to have_key(:max_temp)
          expect(day[:max_temp]).to be_a(Float)
          expect(day).to have_key(:min_temp)
          expect(day[:min_temp]).to be_a(Float)
          expect(day).to have_key(:conditions)
          expect(day[:conditions]).to be_a(String)
          expect(day).to have_key(:icon)
          expect(day[:icon]).to be_a(String)
        end

        forecast[:data][:attributes][:hourly_weather].each do |hour|
          expect(hour).to have_key(:time)
          expect(hour[:time]).to be_a(String)
          expect(Time.parse(hour[:time]).class).to be(Time)
          expect(hour).to have_key(:temp)
          expect(hour[:temp]).to be_a(Float)
          expect(hour).to have_key(:description)
          expect(hour[:description]).to be_a(String)
          expect(hour).to have_key(:icon)
          expect(hour[:icon]).to be_a(String)
        end


      end
    end
  end
end






# VCR.turn_off!
# WebMock.allow_net_connect!
# VCR.turn_on!
