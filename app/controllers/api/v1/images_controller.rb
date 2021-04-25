require 'ostruct'

class Api::V1::ImagesController < ActionController::API
  def image
    conn = Faraday.new(
        url: "#{ENV['UNSPLASH_BASE_URL']}",
        params: {client_id: "#{ENV['client_id']}"}
      )

    response = conn.get('search/photos') do |req|
          req.params['page'] = 1
          req.params['per_page'] = 1
          req.params['query'] = 'Denver,CO'
        end

    background_data = JSON.parse(response.body, symbolize_names: true)

    credit =  {
                source: "unsplash.com",
                author: background_data[:results][0][:user][:name],
                attribution_link: background_data[:results][0][:user][:links][:self]
              }


    photo = {
              location: background_data[:results][0][:user][:location],
              image_url: background_data[:results][0][:urls][:regular],
              credit: credit
            }

    background = OpenStruct.new({
            id: nil,
            image: photo
      })

    render json: ImageSerializer.new(background)

  end
end
