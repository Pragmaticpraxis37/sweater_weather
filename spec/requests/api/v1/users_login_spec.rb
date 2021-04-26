require 'rails_helper'

describe 'Users Requests - Login' do
  describe 'logs a user in - happy path' do
    it 'can login a user' do

      body = ({
                email: 'jabba@hutt.com',
                password: 'hatesolo',
                password_confirmation: 'hatesolo'
              })

      headers = {"CONTENT_TYPE" => "application/json"}

      post api_v1_users_path, headers: headers, params: body, as: :json

      user_api_key = User.first.api_key

      body = ({
                email: 'jabba@hutt.com',
                password: 'hatesolo',
              })

      headers = {"CONTENT_TYPE" => "application/json"}

      post api_v1_sessions_path, headers: headers, params: body, as: :json

      expect(response).to be_successful
      expect(response.status).to eq(200)

      login = JSON.parse(response.body, symbolize_names: true)

      expect(login).to be_a(Hash)
      expect(login.length).to eq(1)
      expect(login.keys).to match_array [:data]
      expect(login[:data]).to be_a(Hash)
      expect(login[:data].length).to eq(3)
      expect(login[:data].keys).to match_array [:id, :type, :attributes]
      expect(login[:data][:id]).to be_a(String)
      expect(login[:data][:type]).to be_a(String)
      expect(login[:data][:attributes]).to be_a(Hash)
      expect(login[:data][:attributes].length).to eq(2)
      expect(login[:data][:attributes].keys).to match_array [:email, :api_key]
      expect(login[:data][:attributes][:email]).to be_a(String)
      expect(login[:data][:attributes][:api_key]).to be_a(String)
      expect(User.first.api_key).to eq(user_api_key)
    end
  end

  describe 'logs a user in - sad path' do
    it 'will not log a user in when the password is missing' do
      body = ({
                email: 'jabba@hutt.com',
                password: 'hatesolo',
                password_confirmation: 'hatesolo'
              })

      headers = {"CONTENT_TYPE" => "application/json"}

      post api_v1_users_path, headers: headers, params: body, as: :json

      body = ({
                email: 'jabba@hutt.com',
                password: ""
              })

      headers = {"CONTENT_TYPE" => "application/json"}

      post api_v1_sessions_path, headers: headers, params: body, as: :json

      expect(response).not_to be_successful
      expect(response.status).to eq(400)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error).to be_a(Hash)
      expect(error.length).to eq(1)
      expect(error.keys).to match_array [:error]
      expect(error[:error]).to be_a(String)
      expect(error[:error]).to eq("Please both an email and a password.")
    end

    it 'will not log a user in when the email is missing' do
      body = ({
                email: 'jabba@hutt.com',
                password: 'hatesolo',
                password_confirmation: 'hatesolo'
              })

      headers = {"CONTENT_TYPE" => "application/json"}

      post api_v1_users_path, headers: headers, params: body, as: :json

      body = ({
                email: '',
                password: 'hatesolo'
              })

      headers = {"CONTENT_TYPE" => "application/json"}

      post api_v1_sessions_path, headers: headers, params: body, as: :json

      expect(response).not_to be_successful
      expect(response.status).to eq(400)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error).to be_a(Hash)
      expect(error.length).to eq(1)
      expect(error.keys).to match_array [:error]
      expect(error[:error]).to be_a(String)
      expect(error[:error]).to eq("Please both an email and a password.")
    end

    it 'will not log a user in when the password is wrong' do
      body = ({
                email: 'jabba@hutt.com',
                password: 'hatesolo',
                password_confirmation: 'hatesolo'
              })

      headers = {"CONTENT_TYPE" => "application/json"}

      post api_v1_users_path, headers: headers, params: body, as: :json

      body = ({
                email: 'jabba@hutt.com',
                password: 'lovesolo'
              })

      headers = {"CONTENT_TYPE" => "application/json"}

      post api_v1_sessions_path, headers: headers, params: body, as: :json

      expect(response).not_to be_successful
      expect(response.status).to eq(400)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error).to be_a(Hash)
      expect(error.length).to eq(1)
      expect(error.keys).to match_array [:error]
      expect(error[:error]).to be_a(String)
      expect(error[:error]).to eq('The email or password was incorrect')
    end
  end
end
