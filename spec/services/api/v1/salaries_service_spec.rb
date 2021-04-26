describe 'Salaries Service' do
  describe 'class methods' do
    it '::urban_areas' do
      urban_areas = SalariesService.urban_area("chicago")

      expect(urban_areas).to be_a(Hash)
      expect(urban_areas.length).to eq(2)
      expect(urban_areas.keys).to match_array [:_links, :count]
    end

    it '::slug' do
      slug = SalariesService.slug("https://api.teleport.org/api/urban_areas/slug:miami/")

      expect(slug).to be_a(Hash)
      expect(slug.length).to eq(10)
      expect(slug.keys).to match_array [:_links, :bounding_box, :continent, :full_name, :is_government_partner, :mayor, :name, :slug, :teleport_city_url, :ua_id]
    end
  end
end
