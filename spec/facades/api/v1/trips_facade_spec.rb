require 'rails_helper'

describe 'Trips Facade' do
  describe 'class methods - happy path' do
    it '::start_city' do
      trip_data = CoordinatesService.directions("Denver,CO", "Pueblo,CO")
      result = TripsFacade.start_city(trip_data[:route][:locations][0])

      expect(result).to eq("Denver, CO, US")
    end

    it '::end_city' do
      trip_data = CoordinatesService.directions("Denver,CO", "Pueblo,CO")
      result = TripsFacade.end_city(trip_data[:route][:locations][1])

      expect(result).to eq("Pueblo, CO, US")
    end

    it '::trip_time will convert less than 3600 seconds into minutes' do
      result = TripsFacade.time(1700)

      expect(result).to eq('0 hours and 28 minutes')
    end

    it '::trip_time will convert a narrow range of seconds into 1 hours and 0 minutes' do
      result = TripsFacade.time(3601)

      expect(result).to eq('1 hour(s) and 0 minutes')
    end

    it '::trip_time will convert more than 3600 seconds into minutes and hours' do
      result = TripsFacade.time(4000)

      expect(result).to eq('1 hour(s) and 6 minutes')
    end

    it '::road_trip_collection' do
      result = TripsFacade.road_trip_collection("Denver, CO, US", "Pueblo, CO, US", "2 hours, 13 minutes", {"temperature": 59.4,
                                    "conditions": "partly cloudy with a chance of meatballs"})

      expect(result).to be_an(OpenStruct)
      expect(result.respond_to?('id')).to eq(true)
      expect(result.id).to eq(nil)
      expect(result.respond_to?('start_city')).to eq(true)
      expect(result.start_city).to be_a(String)
      expect(result.start_city).to eq("Denver, CO, US")
      expect(result.respond_to?('end_city')).to eq(true)
      expect(result.end_city).to eq("Pueblo, CO, US")
      expect(result.end_city).to be_a(String)
      expect(result.respond_to?('travel_time')).to eq(true)
      expect(result.travel_time).to eq("2 hours, 13 minutes")
      expect(result.travel_time).to be_a(String)
      expect(result.respond_to?('weather_at_eta')).to eq(true)
      expect(result.weather_at_eta).to be_a(Hash)
      expect(result.weather_at_eta.keys).to match_array [:temperature, :conditions]
      expect(result.weather_at_eta[:temperature]).to eq(59.4)
      expect(result.weather_at_eta[:temperature]).to be_a(Float)
      expect(result.weather_at_eta[:conditions]).to eq("partly cloudy with a chance of meatballs")
      expect(result.weather_at_eta[:conditions]).to be_a(String)
    end
  end

  describe 'class methods - sad path' do
    it '::collection will trigger ::trip_impossible if only the destination is provided' do
      result = TripsFacade.collection("", "Pueblo,CO")

      expect(result).to be_an(OpenStruct)
      expect(result.respond_to?('id')).to eq(true)
      expect(result.id).to eq(nil)
      expect(result.respond_to?('start_city')).to eq(true)
      expect(result.start_city).to eq("")
      expect(result.respond_to?('end_city')).to eq(true)
      expect(result.end_city).to eq("Pueblo,CO")
      expect(result.respond_to?('travel_time')).to eq(true)
      expect(result.travel_time).to eq("impossible")
      expect(result.respond_to?('weather_at_eta')).to eq(true)
      expect(result.weather_at_eta).to eq("")
    end

    it '::collection will trigger ::trip_impossible if only the origin is provided' do
      result = TripsFacade.collection("Denver,CO", "")

      expect(result).to be_an(OpenStruct)
      expect(result.respond_to?('id')).to eq(true)
      expect(result.id).to eq(nil)
      expect(result.respond_to?('start_city')).to eq(true)
      expect(result.start_city).to eq("Denver,CO")
      expect(result.respond_to?('end_city')).to eq(true)
      expect(result.end_city).to eq("")
      expect(result.respond_to?('travel_time')).to eq(true)
      expect(result.travel_time).to eq("impossible")
      expect(result.respond_to?('weather_at_eta')).to eq(true)
      expect(result.weather_at_eta).to eq("")
    end
  end
end
