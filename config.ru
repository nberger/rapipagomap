# config.ru
require File.dirname(__FILE__) + '/config/boot.rb'

map '/api/v1' do
  run RapiPagoMapApi
end

map '/' do
  run RapiPagoMap
end
