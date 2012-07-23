# config.ru
#require File.dirname(__FILE__) + '/config/boot.rb'

require File.dirname(__FILE__) + '/lib/rapi_pago_map.rb'

map '/' do
  run RapiPagoMap
end
