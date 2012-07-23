require 'mechanize'
require 'pry'

class RapiPagoFinder
  def self.all(options = {})
    agent = Mechanize.new
    page = agent.get("http://www.rapipago.com.ar/rapipagoWeb/index.htm")
    search_form = find_form(page)
    province = options[:province]
    search_form.field_with(:name => "provinciaSuc").options.detect {|opt| opt.text.downcase == province.gsub(/_/, " ").downcase}.select
    page = agent.submit(search_form)
    search_form = find_form(page)
    city = options[:city]
    search_form.field_with(:name => "ciudadSuc").options.detect {|opt| opt.value.downcase == city.downcase}.select
    page = agent.submit(search_form)

    addresses = grab_addresses(page)

    page.links_with(:href => /doPage/).each do |l|
      page_num = l.text.to_i
      next if page_num <= 1
      search_form = find_form(page)
      search_form.action += "?pageNum=#{page_num}"

      page = agent.submit(search_form)
      addresses.concat(grab_addresses(page))
    end

    addresses
  end

protected
  def self.grab_addresses(page)
    page.search(".resultadosText").map(&:text).reject {|a| a =~ /Ver mas/}.map {|a| {:address => a}}
  end

  def self.find_form(page)
    f = page.form_with(:id => "form")
    f.action = "suc-buscar.htm"
    f
  end

end
