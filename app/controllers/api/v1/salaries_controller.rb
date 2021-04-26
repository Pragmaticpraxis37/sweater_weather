class Api::V1::SalariesController < ActionController::API

  def salary

    coordinates = CoordinatesService.coordinates(params[:destination])
    weather = ForecastsService.forecast(coordinates)

    city = 

    forecast =

    require "pry"; binding.pry
  end

end
