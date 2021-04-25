require 'ostruct'

class Api::V1::ImagesController < ActionController::API
  before_action :check_params

  def image
    image_data = ImagesFacade.image(params[:location])

    if image_data == "Error search terms"
      render json: {error: "Please provide search terms."}, status: 400
    else
      render json: ImageSerializer.new(image_data)
    end 
  end

  private

  def check_params
    if params[:location].nil?
      render json: {error: "Please provide a query parameter and search terms."}, status: 400
    end
  end
end
