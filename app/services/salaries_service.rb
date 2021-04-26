class SalariesService

  def self.urban_area(destination)
    response = Faraday.get('https://api.teleport.org/api/urban_areas/')

    urban_areas_data = JSON.parse(response.body, symbolize_names: true)
  end

  def self.slug(url)
    response_slug = Faraday.get(url)

    slug_data = JSON.parse(response_slug.body, symbolize_names: true)
  end

  def self.salaries(id)
    response_salaries = Faraday.get("https://api.teleport.org/api/urban_areas/teleport:#{id}/salaries/")

    salaries_data = JSON.parse(response_salaries.body, symbolize_names: true)
  end

end
