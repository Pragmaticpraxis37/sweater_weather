class Api::V1::SalariesController < ActionController::API

  def salary

    coordinates = CoordinatesService.coordinates(params[:destination])
    weather = ForecastsService.forecast(coordinates)

    destination = { destination: params[:destination]}

    forecast =  {
                  forecast: { summary: weather[:current][:weather][0][:description],
                            temperature: "#{weather[:current][:temp]} F" }
                }


    response = Faraday.get('https://api.teleport.org/api/urban_areas/')

    urban_areas_data = JSON.parse(response.body, symbolize_names: true)

    urban_areas = body[:_links][:"ua:item"]

    require "pry"; binding.pry
  end

end
