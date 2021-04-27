require 'rails_helper'
require 'date'

describe 'Trips Requests' do
  describe 'obtains road trips - happy path' do
    it 'can obtain road trip information' do

      body = ({
                email: 'jango@fett.com',
                password: 'hatesolo',
                password_confirmation: 'hatesolo'
              })

      headers = {"CONTENT_TYPE" => "application/json"}

      post api_v1_users_path, headers: headers, params: body, as: :json

      user_api_key = User.first.api_key

      body = ({
                "origin": "Denver,CO",
                "destination": "Pueblo,CO",
                "api_key": "#{user_api_key}"
              })

      headers = {"CONTENT_TYPE" => "application/json"}

      post api_v1_road_trip_path, headers: headers, params: body, as: :json

      expect(response).to be_successful
      expect(response.status).to eq(200)
      trip = JSON.parse(response.body, symbolize_names: true)
      require "pry"; binding.pry

      expect(trip).to be_a(Hash)
      expect(trip.length).to eq(1)
      expect(trip[:data]).to be_a(Hash)
      expect(trip[:data].length).to eq(3)
      expect(trip[:data].keys).to match_array [:id, :type, :attributes]
      expect(trip[:data][:id]).to eq(nil)
      expect(trip[:data]).to have_key(:type)
      expect(trip[:data][:type]).to eq("roadtrip")
      expect(trip[:data][:attributes]).to be_a(Hash)
      expect(trip[:data][:attributes].length).to eq(4)
      expect(trip[:data][:attributes].keys).to match_array [:start_city, :end_city, :travel_time, :weather_at_eta]
      expect(trip[:data][:attributes][:start_city]).to be_a(String)
      expect(trip[:data][:attributes][:start_city]).to eq("Denver, CO, US")
      expect(trip[:data][:attributes][:end_city]).to be_a(String)
      expect(trip[:data][:attributes][:end_city]).to eq("Pueblo, CO, US")
      expect(trip[:data][:attributes][:travel_time]).to be_a(String)
      expect(trip[:data][:attributes][:weather_at_eta].keys).to  match_array [:temperature, :conditions]
      expect(trip[:data][:attributes][:weather_at_eta][:temperature]).to be_a(Float)
      expect(trip[:data][:attributes][:weather_at_eta][:conditions]).to be_a(String)
    end
  end

  describe 'obtains road trips - sad path' do
    it 'will not display travel time if the route is impossible' do

      user = User.create(email: 'obi@kenobi.com', password: 'loveluke', api_key: SecureRandom.hex)
      user_api_key = user.api_key

      body = ({
                "origin": "Denver, CO",
                "destination": "London, UK",
                "api_key": "#{user_api_key}"
              })

      headers = {"CONTENT_TYPE" => "application/json"}

      post api_v1_road_trip_path, headers: headers, params: body, as: :json

      expect(response).to be_successful
      expect(response.status).to eq(200)

      trip = JSON.parse(response.body, symbolize_names: true)

      expect(trip).to be_a(Hash)
      expect(trip.length).to eq(1)
      expect(trip[:data]).to be_a(Hash)
      expect(trip[:data].length).to eq(3)
      expect(trip[:data].keys).to match_array [:id, :type, :attributes]
      expect(trip[:data][:id]).to eq(nil)
      expect(trip[:data]).to have_key(:type)
      expect(trip[:data][:type]).to eq("roadtrip")
      expect(trip[:data][:attributes]).to be_a(Hash)
      expect(trip[:data][:attributes].length).to eq(4)
      expect(trip[:data][:attributes].keys).to match_array [:start_city, :end_city, :travel_time, :weather_at_eta]
      expect(trip[:data][:attributes][:start_city]).to be_a(String)
      expect(trip[:data][:attributes][:start_city]).to eq("Denver, CO")
      expect(trip[:data][:attributes][:end_city]).to be_a(String)
      expect(trip[:data][:attributes][:end_city]).to eq("London, UK")
      expect(trip[:data][:attributes][:travel_time]).to be_a(String)
      expect(trip[:data][:attributes][:travel_time]).to eq("impossible")
      expect(trip[:data][:attributes][:weather_at_eta]).to eq("")
    end
  end
end
