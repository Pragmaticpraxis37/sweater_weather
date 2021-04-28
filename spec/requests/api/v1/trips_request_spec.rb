require 'rails_helper'
require 'date'

describe 'Trips Requests' do
  describe 'obtains road trips - happy path' do
    it 'can obtain road trip information for medium trips', :VCR do
      user = User.create(email: 'jango@fett.com', password: 'hatesolo', api_key: SecureRandom.hex)
      user_api_key = user.api_key

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

    it 'can obtain road trip information for long trips', :VCR do
      user = User.create(email: 'jango@fett.com', password: 'hatesolo', api_key: SecureRandom.hex)
      user_api_key = user.api_key

      user_api_key = User.first.api_key

      body = ({
                "origin": "San Francisco, CA",
                "destination": "Portland, OR",
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
      expect(trip[:data][:attributes][:start_city]).to eq("San Francisco, CA, US")
      expect(trip[:data][:attributes][:end_city]).to be_a(String)
      expect(trip[:data][:attributes][:end_city]).to eq("Portland, OR, US")
      expect(trip[:data][:attributes][:travel_time]).to be_a(String)
      expect(trip[:data][:attributes][:weather_at_eta].keys).to  match_array [:temperature, :conditions]
      expect(trip[:data][:attributes][:weather_at_eta][:temperature]).to be_a(Float)
      expect(trip[:data][:attributes][:weather_at_eta][:conditions]).to be_a(String)
    end
  end

  describe 'obtains road trips - sad path' do
    it 'will not display travel time if the route is impossible', :VCR do
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

    it 'will return an error if the origin route is missing' do
      user = User.create(email: 'obi@kenobi.com', password: 'loveluke', api_key: SecureRandom.hex)
      user_api_key = user.api_key

      body = ({
                "origin": "",
                "destination": "London, UK",
                "api_key": "#{user_api_key}"
              })

      headers = {"CONTENT_TYPE" => "application/json"}

      post api_v1_road_trip_path, headers: headers, params: body, as: :json

      expect(response).not_to be_successful
      expect(response.status).to eq(400)

      trip = JSON.parse(response.body, symbolize_names: true)

      expect(trip).to be_a(Hash)
      expect(trip.length).to eq(1)
      expect(trip.keys).to match_array [:error]
      expect(trip[:error]).to eq("Please provide an origin.")
    end

    it 'will return an error if the destination route is missing' do
      user = User.create(email: 'obi@kenobi.com', password: 'loveluke', api_key: SecureRandom.hex)
      user_api_key = user.api_key

      body = ({
                "origin": "Denver, CO",
                "destination": "",
                "api_key": "#{user_api_key}"
              })

      headers = {"CONTENT_TYPE" => "application/json"}

      post api_v1_road_trip_path, headers: headers, params: body, as: :json

      expect(response).not_to be_successful
      expect(response.status).to eq(400)

      trip = JSON.parse(response.body, symbolize_names: true)

      expect(trip).to be_a(Hash)
      expect(trip.length).to eq(1)
      expect(trip.keys).to match_array [:error]
      expect(trip[:error]).to eq("Please provide a destination.")
    end

    it 'will return an error if API key is missing' do

      user = User.create(email: 'obi@kenobi.com', password: 'loveluke', api_key: SecureRandom.hex)
      user_api_key = user.api_key

      body = ({
                "origin": "Denver, CO",
                "destination": "Pueblo, CO",
                "api_key": ""
              })

      headers = {"CONTENT_TYPE" => "application/json"}

      post api_v1_road_trip_path, headers: headers, params: body, as: :json

      expect(response).not_to be_successful
      expect(response.status).to eq(401)

      trip = JSON.parse(response.body, symbolize_names: true)

      expect(trip).to be_a(Hash)
      expect(trip.length).to eq(1)
      expect(trip.keys).to match_array [:error]
      expect(trip[:error]).to eq("Please provide an API key.")
    end

    it 'will return unathorized if the api key does not exist' do

      user = User.create(email: 'obi@kenobi.com', password: 'loveluke', api_key: SecureRandom.hex)
      user_api_key = user.api_key

      body = ({
                "origin": "Denver, CO",
                "destination": "Pueblo, CO",
                "api_key": "general_grievous"
              })

      headers = {"CONTENT_TYPE" => "application/json"}

      post api_v1_road_trip_path, headers: headers, params: body, as: :json

      expect(response).not_to be_successful
      expect(response.status).to eq(401)

      trip = JSON.parse(response.body, symbolize_names: true)

      expect(trip).to be_a(Hash)
      expect(trip.length).to eq(1)
      expect(trip.keys).to match_array [:error]
      expect(trip[:error]).to eq("Unathorized")
    end
  end
end
