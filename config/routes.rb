Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      get '/forecast', to: 'forecasts#forecast'
      get '/backgrounds', to: 'images#image'
    end
  end
end

# get '/items/:id/merchant', to: 'item_merchant#show', as: 'items_merchant'
