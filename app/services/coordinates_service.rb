class CoordinatesService

  def self.conn
    Faraday.new(
      url: "#{ENV['MAP_QUEST_BASE_URL']}",
      params: {key: "#{ENV['key']}"}
    )
  end

  def self.coordinates(location)
    response = conn.get('geocoding/v1/address') do |req|
      req.params['location'] = "#{location}"
    end

    require "pry"; binding.pry

    begin
      JSON.parse(response.body)
    rescue JSON::ParserError => e
      require "pry"; binding.pry
    end
      # return {"lat": 39.738453,"lng": -104.984853} if response.env.request_body.nil?
    geo_data = JSON.parse(response.body, symbolize_names: true)


    lat = geo_data[:results][0][:locations][0][:latLng][:lat]
    lon = geo_data[:results][0][:locations][0][:latLng][:lng]
    lat_and_lon = [lat, lon]
  end
end
