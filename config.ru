# config.ru
require File.dirname(__FILE__) + '/config/boot.rb'

map '/' do
  run RapiPagoMap
end
