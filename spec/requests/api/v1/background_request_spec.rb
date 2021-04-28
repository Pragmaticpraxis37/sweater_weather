require 'rails_helper'

describe 'Background Request' do
  describe 'obtains background - happy path' do
    it 'can obtain background information', :VCR do
      get api_v1_backgrounds_path, params: {location: "Denver,CO"}

      background = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful

      expect(background).to be_a(Hash)
      expect(background.length).to eq(1)
      expect(background[:data].keys).to match_array [:id, :type, :attributes]
      expect(background).to have_key(:data)
      expect(background[:data]).to be_a(Hash)
      expect(background[:data].length).to eq(3)
      expect(background[:data]).to have_key(:id)
      expect(background[:data][:id]).to eq(nil)
      expect(background[:data]).to have_key(:type)
      expect(background[:data][:type]).to eq("image")
      expect(background[:data]).to have_key(:attributes)
      expect(background[:data][:attributes]).to be_a(Hash)
      expect(background[:data][:attributes].length).to eq(1)
      expect(background[:data][:attributes]).to have_key(:image)
      expect(background[:data][:attributes].keys).to match_array [:image]

      expect(background[:data][:attributes][:image]).to be_a(Hash)
      expect(background[:data][:attributes][:image].length).to eq(3)
      expect(background[:data][:attributes][:image].keys).to match_array [:location, :image_url, :credit]
      expect(background[:data][:attributes][:image]).to have_key(:location)
      expect(background[:data][:attributes][:image][:location]).to be_a(String)
      expect(background[:data][:attributes][:image]).to have_key(:image_url)
      expect(background[:data][:attributes][:image][:image_url]).to be_a(String)
      expect(background[:data][:attributes][:image]).to have_key(:credit)
      expect(background[:data][:attributes][:image][:credit]).to be_a(Hash)
      expect(background[:data][:attributes][:image][:credit].length).to eq(3)
      expect(background[:data][:attributes][:image][:credit][:source]).to be_a(String)
      expect(background[:data][:attributes][:image][:credit][:author]).to be_a(String)
      expect(background[:data][:attributes][:image][:credit][:attribution_link]).to be_a(String)
    end
  end

  describe 'obtains background - sad path' do
    it 'returns an error message if only a string is passed to the query param', :VCR do
      get api_v1_backgrounds_path, params: {location: ""}

      error = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expect(error).to be_a(Hash)
      expect(error[:error]).to eq("Please provide search terms.")
    end

    it 'returns an error message if no query param is passed' do
      get api_v1_backgrounds_path

      error = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expect(error).to be_a(Hash)
      expect(error[:error]).to eq("Please provide a query parameter and search terms.")
    end
  end
end
