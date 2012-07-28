require 'sinatra/base'
require 'sinatra/json'
require_relative 'rapi_pago_finder'

class RapiPagoMap < Sinatra::Base
  helpers Sinatra::JSON

  get '/list.json' do
    rapipagos = RapiPagoFinder.all(:province => params[:provincia], :city => params[:ciudad], :limit => params[:limit])
    json rapipagos
  end
end
