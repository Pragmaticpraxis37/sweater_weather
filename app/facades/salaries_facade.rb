class SalariesFacade

  def self.salaries_collection(destination)
    require "pry"; binding.pry
    weather_collection = weather_collection(destination)
    destination_collection = destination_collection(destination)
  end

  def self.destination_collection(destination)
    destination = destination
  end


  def self.weather_collection(destination)
    coordinates = CoordinatesService.coordinates(destination)
    weather = ForecastsService.forecast(coordinates)

    forecast =  {
                  summary: weather[:current][:weather][0][:description],
                  temperature: "#{weather[:current][:temp]} F"
                }
  end


end
