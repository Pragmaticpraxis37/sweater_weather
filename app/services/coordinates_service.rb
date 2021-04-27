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

    begin
      JSON.parse(response.body)
    rescue JSON::ParserError => e
      return "Error search terms"
    end

    geo_data = JSON.parse(response.body, symbolize_names: true)

    if geo_data[:info][:statuscode] == 400
      "Error search terms"
    else
      lat = geo_data[:results][0][:locations][0][:latLng][:lat]
      lon = geo_data[:results][0][:locations][0][:latLng][:lng]
      lat_and_lon = [lat, lon]
    end
  end

  def self.directions(from, to)
    response = conn.get('directions/v2/route') do |req|
      req.params['from'] = "#{from}"
      req.params['to'] = "#{to}"
    end

    JSON.parse(response.body, symbolize_names: true)
  end
end
