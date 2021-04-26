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

    urban_areas = urban_areas_data[:_links][:"ua:item"]

    collector = []

    urban_areas.each do |urban_area|
      if urban_area[:name].downcase == params[:destination].downcase
        collector << urban_area
      end
    end


    require "pry"; binding.pry
  end

end
