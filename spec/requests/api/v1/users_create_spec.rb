require 'rails_helper'

describe 'Users Requests - Create' do
  describe 'creates a user - happy path' do
    it 'can create a user' do

      body = ({
                email: 'jabba@hutt.com',
                password: 'hatesolo',
                password_confirmation: 'hatesolo'
              })

      headers = {"CONTENT_TYPE" => "application/json"}

      post api_v1_users_path, headers: headers, params: body, as: :json

      expect(response).to be_successful
      expect(response.status).to eq(201)

      user = JSON.parse(response.body, symbolize_names: true)

      # require "pry"; binding.pry

      expect(user).to be_a(Hash)
      expect(user.length).to eq(1)
      expect(user.keys).to match_array [:data]
      expect(user[:data]).to be_a(Hash)
      expect(user[:data].length).to eq(3)
      expect(user[:data].keys).to match_array [:id, :type, :attributes]
      expect(user[:data][:id]).to be_a(String)
      expect(user[:data][:type]).to be_a(String)
      expect(user[:data][:attributes]).to be_a(Hash)
      expect(user[:data][:attributes].length).to eq(2)
      expect(user[:data][:attributes].keys).to match_array [:email, :api_key]
      expect(user[:data][:attributes][:email]).to be_a(String)
      expect(user[:data][:attributes][:api_key]).to be_a(String)
    end
  end

  describe 'creates a user - sad path' do
    it 'will not create a user without a password' do
      body = ({
                email: 'luke@skywalker.com',
                password: "",
                password_confirmation: ""
              })

      headers = {"CONTENT_TYPE" => "application/json"}

      post api_v1_users_path, headers: headers, params: body, as: :json

      expect(response).not_to be_successful
      expect(response.status).to eq(400)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error).to be_a(Hash)
      expect(error.length).to eq(1)
      expect(error[:error]).to be_a(Array)
      expect(error[:error][0]).to be_a(String)
      expect(error[:error][0]).to eq("Password confirmation doesn't match Password")
      expect(error[:error][1]).to be_a(String)
      expect(error[:error][1]).to eq("Password can't be blank")
    end

    it 'will not create a user without an email' do
      body = ({
                email: "",
                password: "Bobba",
                password_confirmation: "Bobba"
              })

      headers = {"CONTENT_TYPE" => "application/json"}

      post api_v1_users_path, headers: headers, params: body, as: :json

      expect(response).not_to be_successful
      expect(response.status).to eq(400)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error).to be_a(Hash)
      expect(error.length).to eq(1)
      expect(error[:error]).to be_a(Array)
      expect(error[:error][0]).to be_a(String)
      expect(error[:error][0]).to eq("Email can't be blank")
    end

    it 'will not create a user without a password confirmation' do
      body = ({
                email: "luke@skywalker.com",
                password: "Bobba",
                password_confirmation: ""
              })

      headers = {"CONTENT_TYPE" => "application/json"}

      post api_v1_users_path, headers: headers, params: body, as: :json

      expect(response).not_to be_successful
      expect(response.status).to eq(400)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error).to be_a(Hash)
      expect(error.length).to eq(1)
      expect(error[:error]).to be_a(Array)
      expect(error[:error][0]).to be_a(String)
      expect(error[:error][0]).to eq("Password confirmation doesn't match Password")
    end

    it 'will not create a user without mismatched passwords' do
      body = ({
                email: "luke@skywalker.com",
                password: "Bobba",
                password_confirmation: "Vader"
              })

      headers = {"CONTENT_TYPE" => "application/json"}

      post api_v1_users_path, headers: headers, params: body, as: :json

      expect(response).not_to be_successful
      expect(response.status).to eq(400)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error).to be_a(Hash)
      expect(error.length).to eq(1)
      expect(error[:error]).to be_a(Array)
      expect(error[:error][0]).to be_a(String)
      expect(error[:error][0]).to eq("Password confirmation doesn't match Password")
    end

    it 'does not create a user that has already been created' do

      body = ({
                email: "chewy@skywalker.com",
                password: "Lovesolo",
                password_confirmation: "Lovesolo"
              })

      headers = {"CONTENT_TYPE" => "application/json"}

      post api_v1_users_path, headers: headers, params: body, as: :json

      expect(response).to be_successful
      expect(response.status).to eq(201)

      body = ({
                email: "chewy@skywalker.com",
                password: "Lovesolo",
                password_confirmation: "Lovesolo"
              })

      headers = {"CONTENT_TYPE" => "application/json"}

      post api_v1_users_path, headers: headers, params: body, as: :json

      expect(response).not_to be_successful
      expect(response.status).to eq(400)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error).to be_a(Hash)
      expect(error.length).to eq(1)
      expect(error[:error]).to be_a(Array)
      expect(error[:error][0]).to be_a(String)
      expect(error[:error][0]).to eq("Email has already been taken")
    end
  end
end
