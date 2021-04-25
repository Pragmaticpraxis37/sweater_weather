class ForecastsService

  def self.conn
    Faraday.new(
      url: "#{ENV['OPEN_WEATHER_BASE_URL']}",
      params: {appid: "#{ENV['appid']}"}
    )
  end

  def self.forecast(coordinates)
    response = conn.get('/data/2.5/onecall') do |req|
      req.params['lat'] = "#{coordinates[0]}"
      req.params['lon'] = "#{coordinates[1]}"
      req.params['units'] = 'imperial'
    end

    weather = JSON.parse(response.body, symbolize_names: true)
  end

end
