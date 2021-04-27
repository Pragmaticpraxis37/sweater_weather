require 'rails_helper'
require 'date'

describe 'Forecast Requests' do
  describe 'obtains forecast - happy path' do
    it 'can obtain forecast information' do

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

      trip = JSON.parse(response.body, symbolize_names: true)
    end
  end
end
