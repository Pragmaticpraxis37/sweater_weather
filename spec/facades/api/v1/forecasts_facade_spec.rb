require 'rails_helper'

describe 'Forecasts Facade' do
  describe 'class methods' do
    it '::current_weather_data' do
      VCR.use_cassette('Denver_CO') do
        weather = ForecastsService.forecast([39.738453, -104.984853])
        result = ForecastsFacade.current_weather_data(weather)

        expect(result).to be_a(Hash)
        expect(result.keys).to match_array [:datetime, :sunrise, :sunset, :temperature, :feels_like, :humidity, :uvi, :visibility, :conditions, :icon]
        expect(result[:datetime].class).to be(Time)
        expect(result[:sunrise].class).to be(Time)
        expect(result[:sunset].class).to be(Time)
        expect(result[:temperature]).to be_a(Float)
        expect(result[:feels_like]).to be_a(Float)
        expect(result[:humidity]).to be_an(Integer)
        expect(result[:uvi]).to be_a(Float)
        expect(result[:visibility]).to be_an(Integer)
        expect(result[:conditions]).to be_a(String)
        expect(result[:icon]).to be_a(String)
      end
    end

    it '::daily_weather_data' do
      VCR.use_cassette('Denver_CO') do
        weather = ForecastsService.forecast([39.738453, -104.984853])
        result = ForecastsFacade.daily_weather_data(weather)

        expect(result).to be_an(Array)
        expect(result.length).to eq(5)

        result.each do |day|
          expect(day).to be_a(Hash)
          expect(day.keys).to match_array [:date, :sunrise, :sunset, :max_temp, :min_temp, :conditions, :icon]
          expect(day).to have_key(:date)
          expect(day[:date]).to be_a(String)
          expect(Date.strptime(day[:date], '%m-%d-%Y')).to be_a(Date)
          expect(day).to have_key(:sunrise)
          expect(day[:sunrise].class).to be(Time)
          expect(day).to have_key(:sunset)
          expect(day[:sunset].class).to be(Time)
          expect(day).to have_key(:max_temp)
          expect(day[:max_temp]).to be_kind_of(Numeric)
          expect(day).to have_key(:min_temp)
          expect(day[:min_temp]).to be_kind_of(Numeric)
          expect(day).to have_key(:conditions)
          expect(day[:conditions]).to be_a(String)
          expect(day).to have_key(:icon)
          expect(day[:icon]).to be_a(String)
        end
      end
    end

    it '::hourly_weather_data' do
      VCR.use_cassette('Denver_CO') do
        weather = ForecastsService.forecast([39.738453, -104.984853])
        result = ForecastsFacade.hourly_weather_data(weather)

        expect(result).to be_an(Array)
        expect(result.length).to eq(8)

        result.each do |hour|
          expect(hour).to be_a(Hash)
          expect(hour.keys).to match_array [:time, :temp, :description, :icon]
          expect(hour[:time]).to be_a(String)
          expect(Time.parse(hour[:time]).class).to be(Time)
          expect(hour).to have_key(:temp)
          expect(hour[:temp]).to be_kind_of(Numeric)
          expect(hour).to have_key(:description)
          expect(hour[:description]).to be_a(String)
          expect(hour).to have_key(:icon)
          expect(hour[:icon]).to be_a(String)
        end
      end
    end

    it '::forecast_data' do
      VCR.use_cassette('Denver_CO') do
        weather = ForecastsService.forecast([39.738453, -104.984853])
        result = ForecastsFacade.forecast_data(weather)

        expect(result).to be_an(OpenStruct)
        expect(result.id).to eq(nil)
        expect(result.respond_to?('id')).to eq(true)
        expect(result.respond_to?('current_weather')).to eq(true)
        expect(result.respond_to?('daily_weather')).to eq(true)
        expect(result.respond_to?('hourly_weather')).to eq(true)
      end
    end
  end
end
