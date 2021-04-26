class Api::V1::SalariesController < ActionController::API

  def salary
    serializer_collection = SalariesFacade.salaries_collection(params[:destination])
    render json: SalariesSerializer.new(serializer_collection)
  end
end
