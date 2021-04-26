class SalariesFacade

  def self.salaries_collection(destination)
    weather_collection = weather_collection(destination)

    destination_collection = destination_collection(destination)

    urban_areas_collection = urban_areas_collection(destination)
    id = slug_collection(urban_areas_collection)
    salaries = salaries(id)
    collection(destination_collection, weather_collection, salaries)
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

  def self.urban_areas_collection(destination)
    response = Faraday.get('https://api.teleport.org/api/urban_areas/')

    urban_areas_data = JSON.parse(response.body, symbolize_names: true)

    urban_areas = urban_areas_data[:_links][:"ua:item"]

    slug = nil

    urban_areas.each do |urban_area|
      if urban_area[:name].downcase == destination.downcase
        slug = urban_area[:href]
      end
    end

    slug
  end

  def self.slug_collection(slug)
    response_slug = Faraday.get(slug)

    slug_data = JSON.parse(response_slug.body, symbolize_names: true)

    slug_data[:ua_id]
  end

  def self.salaries(id)
    # require "pry"; binding.pry
    response_salaries = Faraday.get("https://api.teleport.org/api/urban_areas/teleport:#{id}/salaries/")

    salaries_data = JSON.parse(response_salaries.body, symbolize_names: true)


    jobs = ["Data Analyst", "Data Scientist", "Mobile Developer", "QA Engineer", "Software Engineer", "Systems Administrator", "Web Developer"]

    salaries_collection = []

    salaries_data[:salaries].each do |salary|
      if jobs.include?(salary[:job][:title])
        salaries_collection << {title: salary[:job][:title], min: salary[:salary_percentiles][:percentile_25].truncate(2).to_s, max: salary[:salary_percentiles][:percentile_75].truncate(2).to_s}
      end
    end

    salaries_collection
  end

  def self.collection(destination, forecast, salaries_collection)
    serializer_collection = OpenStruct.new({
      id: nil,
      destination: destination,
      forecast: forecast,
      salaries: salaries_collection
      })
  end

end
