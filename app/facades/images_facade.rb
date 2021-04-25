class ImagesFacade

  def self.image(location)
    image_data = ImagesService.image_data(location)

    if image_data == "Error search terms"
      return "Error search terms"
    else
      credit = credit_data(image_data)
      image_and_credit = image_data(image_data, credit)
      background(image_and_credit)
    end 
  end

  def self.credit_data(image_data)
    credit_data =   {
                      source: "unsplash.com",
                      author: image_data[:results][0][:user][:name],
                      attribution_link: image_data[:results][0][:user][:links][:self]
                    }
  end

  def self.image_data(image_data, credit_data)
    image_and_credit_data = {
                              location: image_data[:results][0][:user][:location],
                              image_url: image_data[:results][0][:urls][:regular],
                              credit: credit_data
                            }
  end

  def self.background(image_and_credit_data)
    OpenStruct.new({
                    id: nil,
                    image: image_and_credit_data
                  })
  end
end
