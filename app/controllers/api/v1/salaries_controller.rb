class Api::V1::SalariesController < ActionController::API

  def salary

    coordinates = CoordinatesService.coordinates(params[:destination])
    weather = ForecastsService.forecast(coordinates)

    destination = params[:destination]

    forecast =  {
                  summary: weather[:current][:weather][0][:description],
                  temperature: "#{weather[:current][:temp]} F"
                }


    response = Faraday.get('https://api.teleport.org/api/urban_areas/')

    urban_areas_data = JSON.parse(response.body, symbolize_names: true)

    urban_areas = urban_areas_data[:_links][:"ua:item"]

    slug = nil

    urban_areas.each do |urban_area|
      if urban_area[:name].downcase == params[:destination].downcase
        slug = urban_area[:href]
      end
    end

    response_slug = Faraday.get(slug)

    slug_data = JSON.parse(response_slug.body, symbolize_names: true)

    slug_id = slug_data[:ua_id]

    response_salaries = Faraday.get("https://api.teleport.org/api/urban_areas/teleport:#{slug_id}/salaries/")



    salaries_data = JSON.parse(response_salaries.body, symbolize_names: true)


    jobs = ["Data Analyst", "Data Scientist", "Mobile Developer", "QA Engineer", "Software Engineer", "Systems Administrator", "Web Developer"]

    salaries_collection = []

    salaries_data[:salaries].each do |salary|
      if jobs.include?(salary[:job][:title])
        # require "pry"; binding.pry
        salaries_collection << {title: salary[:job][:title], min: salary[:salary_percentiles][:percentile_25].truncate(2).to_s, max: salary[:salary_percentiles][:percentile_75].truncate(2).to_s}
      end
    end

    serializer_collection = OpenStruct.new({
      id: nil,
      destination: destination,
      forecast: forecast,
      salaries: salaries_collection
      })

    render json: SalariesSerializer.new(serializer_collection)
    # require "pry"; binding.pry
  end

end
