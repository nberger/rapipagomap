require 'mechanize'

class RapiPagoFinder
  def self.all(options = {})
    province = options[:province]
    city = options[:city]
    limit = options[:limit].to_i if options[:limit]

    page = agent.get("http://www.rapipago.com.ar/rapipagoWeb/index.htm")
    search_form = find_form(page)
    search_form.field_with(:name => "provinciaSuc").options.detect {|opt| opt.text.downcase == province.gsub(/_/, " ").downcase}.select
    page = agent.submit(search_form)
    search_form = find_form(page)
    search_form.field_with(:name => "ciudadSuc").options.detect {|opt| opt.value.downcase == city.downcase}.select
    page = agent.submit(search_form)

    addresses = []

    each_page_from(page) do |page, page_num|
      new_addresses = grab_addresses(page)
      new_addresses = new_addresses[0, limit - addresses.size] if limit && limit < addresses.size + new_addresses.size
      addresses.concat(new_addresses)
      break if limit && addresses.size >= limit
    end

    # add city and province
    addresses.map {|a| a.merge(:province => province, :city => city)}
  end

protected
  def self.agent
    @agent ||= Mechanize.new
  end

  def self.each_page_from(page)
    # current page
    yield page, 1

    # following pages
    page.links_with(:href => /doPage/).each do |l|
      page_num = l.text.to_i
      # skip first page
      next if page_num <= 1

      search_form = find_form(page)
      search_form.action += "?pageNum=#{page_num}"

      page = agent.submit(search_form)

      yield page, page_num
    end
  end

  def self.grab_addresses(page)
    streets_and_numbers = page.search(".resultadosText").map(&:text).reject {|a| a =~ /Ver mas/}
    names = page.search(".resultadosTextWhite").map(&:text)
    ids = page.search(".resultadosNumeroSuc").map(&:text)
    streets_and_numbers.zip(names, ids).map do |street_and_number, name, id|
      {
        :street_and_number => street_and_number,
        :name => name,
        :agency_id => id
      }
    end
  end

  def self.find_form(page)
    f = page.form_with(:id => "form")
    f.action = "suc-buscar.htm"
    f
  end

end
