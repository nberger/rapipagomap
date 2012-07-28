require 'spec_helper.rb'
require 'multi_json'

describe "rapi_pago_list" do
  let(:limit) {100}

  context "when searching almagro" do
    let(:province) {"capital_federal"}
    let(:city) {"almagro"}
  
    context "with cassette" do
      before do
        VCR.use_cassette('sucursales_almagro') do
          get "/list.json", provincia: "capital_federal", ciudad: "almagro", limit: limit
        end

        @rapipagos = MultiJson.load(last_response.body)
      end

      it "gives address for some rapi pago stores" do
        @rapipagos.map {|rp| rp["street_and_number"]}.should include("AV LA PLATA 537")
        @rapipagos.map {|rp| rp["street_and_number"]}.should include("M BRAVO 7")
      end
      it "gives address for some rapi pago stores in page 2" do
        @rapipagos.map {|rp| rp["street_and_number"]}.should include("AV B RIVADAVIA 4225")
      end
      it "includes province with the address" do
        @rapipagos[0]["province"].should == "capital_federal"
      end
      it "includes city with the address" do
        @rapipagos[0]["city"].should == "almagro"
      end
    end

    context "with cassette limited by 5" do
      let(:limit) {5}
      before do
        VCR.use_cassette('sucursales_almagro') do
          get "/list.json", provincia: "capital_federal", ciudad: "almagro", limit: limit
        end

        @rapipagos = MultiJson.load(last_response.body)
      end

      it "gets 5 addresses" do
        @rapipagos.should have(5).items
      end
      it "gives address for some rapi pago stores" do
        @rapipagos.map {|rp| rp["street_and_number"]}.should include("AV LA PLATA 537")
        @rapipagos.map {|rp| rp["street_and_number"]}.should include("M BRAVO 7")
      end
      it "does not give address for rapi pago stores in page 2" do
        @rapipagos.map {|rp| rp["street_and_number"]}.should_not include("AV B RIVADAVIA 4225")
      end
      it "includes province for each address" do
        @rapipagos[0]["province"].should == "capital_federal"
      end
      it "includes city for each address" do
        @rapipagos[0]["city"].should == "almagro"
      end
    end

    context "with real web limited by 5" do
      let(:limit) {5}
      before do
        get "/list.json", provincia: "capital_federal", ciudad: "almagro", limit: limit

        @rapipagos = MultiJson.load(last_response.body)
      end

      it "gets 5 addresses" do
        @rapipagos.should have(5).items
      end
      it "gives address for some rapi pago stores" do
        @rapipagos.map {|rp| rp["street_and_number"]}.should include("AV LA PLATA 537")
        @rapipagos.map {|rp| rp["street_and_number"]}.should include("M BRAVO 7")
      end
      it "includes city for each address" do
        @rapipagos[0]["city"].should == "almagro"
      end
    end
  end
end
