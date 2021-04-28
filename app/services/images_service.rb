class ImagesService

  def self.conn
    Faraday.new(
      url: "#{ENV['UNSPLASH_BASE_URL']}",
      params: {client_id: "#{ENV['client_id']}"}
    )
  end

  def self.image_data(location)
    response = conn.get('search/photos') do |req|
          req.params['page'] = 1
          req.params['per_page'] = 1
          req.params['query'] = "#{location}"
        end

    image_data = JSON.parse(response.body, symbolize_names: true)

    if image_data[:results].empty?
      "Error search terms"
    else
      image_data
    end
  end
end
