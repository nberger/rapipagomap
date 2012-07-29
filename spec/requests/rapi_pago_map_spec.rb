require 'spec_helper.rb'

describe "rapi_pago_list" do
  before do
    Capybara.app = app
  end
  def app
    RapiPagoMap.new
  end

  it "says hello" do
    visit "/"
    page.should have_content "RapiPago Map"
  end
end
