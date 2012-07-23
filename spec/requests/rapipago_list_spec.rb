require 'spec_helper.rb'
require 'multi_json'

describe "rapi_pago_list" do
  before do
    VCR.use_cassette('sucursales_almagro') do
      get "/list.json?provincia=capital_federal&ciudad=almagro"
    end

    @rapipagos = MultiJson.load(last_response.body)
  end

  it "gives address for some rapi pago stores" do
    @rapipagos.map {|rp| rp["address"]}.should include("AV LA PLATA 537")
    @rapipagos.map {|rp| rp["address"]}.should include("M BRAVO 7")
  end
  it "gives address for some rapi pago stores in page 2" do
    @rapipagos.map {|rp| rp["address"]}.should include("AV B RIVADAVIA 4225")
  end
end
