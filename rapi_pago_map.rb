require 'sinatra/base'

class RapiPagoMap < Sinatra::Base
  set :haml, :format => :html5

  get '/' do
    haml :index
  end
end
