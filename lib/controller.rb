class Controller
  
  def initialize(_name, _address, _root_addr, _spinner, _font, _prompt)
    @_name = _name
    @_address = _address
    @_root_addr = _root_addr
    @spinner = _spinner
    @font = _font
    @prompt = _prompt
  end

  def controller(str)
    @spinner.auto_spin
    case str
    when 'init'
      puts TTY::Link.link_to("Fetching catogories from#{' TradingView'.blue.bold}", @_root_addr.blue)
      @target = 'a.tv-feed-widget__title-link'
      @out = init([@_root_addr, @target])
    when 'Indices'
      @ref = @_root_addr + @_address[@_name.index(str)][8..-1]
      indices(@ref)
    when 'Futures'
      @ref = @_root_addr + @_address[@_name.index(str)][8..-1]
      futures(@ref)
    when 'Currencies'
      @ref = @_root_addr + @_address[@_name.index(str)][8..-1]
      currencies(@ref)
    when 'Bonds'
      @ref = @_root_addr + @_address[@_name.index(str)][8..-1]
      bonds(@ref)
    when 'Stocks'
      @ref = "#{@_root_addr}/stocks-usa/market-movers-large-cap/"
      stocks(@ref)
    when 'Cryptocurrencies'
      @ref = @_root_addr + @_address[@_name.index(str)][8..-1]
      cryptocurrencies
    when 'exit'
      abort('yeah')
    end
    @spinner.success
    @out
  end

  def init(args)
    @doc = Nokogiri::HTML(URI.parse(args[0]).open)
    @_name = @doc.css(args[1]).text.split
    @_address = @doc.css(args[1]).map { |link| link['href'] }
    @_name
  end

  def indices(_args = nil)
    @out = []
    puts TTY::Link.link_to("Fetching latest data from#{' TradingView'.blue.bold}", @ref.blue)
    @spinner.auto_spin
    @doc = Nokogiri::HTML(URI.parse(@ref).open)
    @filter = 'tr.tv-data-table__row'
    @header = %w[NAME PRICE CHANGE-% HIGH LOW RECOMMENDATION]
    @doc.css(@filter).each do |i|
      @name = i.css('a[class="tv-screener__symbol"]').text
      @price = i.css('td.tv-screener-table__cell--big')[1].text
      @change = i.css('td.tv-screener-table__cell--big')[2].text
      @high = i.css('td.tv-screener-table__cell--big')[4].text
      @low = i.css('td.tv-screener-table__cell--big')[5].text
      @recommendation = i.css('td.tv-screener-table__cell--big')[6].text
      @out << [@name, @price, @change, @high, @low, @recommendation]
    end
    @spinner.success
    options_controller([@header, @out])
  end

  def futures(_args = nil)
    @out = []
    puts TTY::Link.link_to("Fetching latest data from#{' TradingView'.blue.bold}", @ref.blue)
    @spinner.auto_spin
    @doc = Nokogiri::HTML(URI.parse(@ref).open)
    @filter = 'tr.tv-data-table__row'
    @header = %w[NAME PRICE CHANGE-% HIGH LOW RECOMMENDATION]
    @doc.css(@filter).each do |i|
      @name = i.css('a[class="tv-screener__symbol"]').text
      @price = i.css('td.tv-screener-table__cell--big')[1].text
      @change = i.css('td.tv-screener-table__cell--big')[2].text
      @high = i.css('td.tv-screener-table__cell--big')[4].text
      @low = i.css('td.tv-screener-table__cell--big')[5].text
      @recommendation = i.css('td.tv-screener-table__cell--big')[6].text
      @out << [@name, @price, @change, @high, @low, @recommendation]
    end
    @spinner.success
    options_controller([@header, @out])
  end

  def currencies(_args = nil)
    @out = []
    puts TTY::Link.link_to("Fetching latest data from#{' TradingView'.blue.bold}", @ref.blue)
    @spinner.auto_spin
    @doc = Nokogiri::HTML(URI.parse(@ref).open)
    @filter = 'tr.tv-data-table__row'
    @header = %w[NAME PRICE CHANGE-% BID ASK HIGH LOW RECOMMENDATION]
    @doc.css(@filter).each do |i|
      @name = i.css('a[class="tv-screener__symbol"]').text
      @price = i.css('td.tv-screener-table__cell--big')[1].text
      @change = i.css('td.tv-screener-table__cell--big')[2].text
      @bid = i.css('td.tv-screener-table__cell--big')[4].text
      @ask = i.css('td.tv-screener-table__cell--big')[5].text
      @high = i.css('td.tv-screener-table__cell--big')[6].text
      @low = i.css('td.tv-screener-table__cell--big')[7].text
      @recommendation = i.css('td.tv-screener-table__cell--big')[8].text
      @out << [@name, @price, @change, @bid, @ask, @high, @low, @recommendation]
    end
    @spinner.success
    options_controller([@header, @out])
  end

  def bonds(_args = nil)
    @out = []
    puts TTY::Link.link_to("Fetching latest data from#{' TradingView'.blue.bold}", @ref.blue)
    @spinner.auto_spin
    @doc = Nokogiri::HTML(URI.parse(@ref).open)
    @filter = 'tr.tv-data-table__row'
    @header = %w[NAME COUPON MATURITY-DATE YIELD CHANGE-% HIGH LOW RECOMMENDATION]
    @doc.css(@filter).each do |i|
      @name = i.css('a[class="tv-screener__symbol"]').text
      @coupon = i.css('td.tv-screener-table__cell--big')[1].text
      @maturity = i.css('td.tv-screener-table__cell--big')[2].text
      @yield = i.css('td.tv-screener-table__cell--big')[3].text
      @change = i.css('td.tv-screener-table__cell--big')[4].text
      @high = i.css('td.tv-screener-table__cell--big')[6].text
      @low = i.css('td.tv-screener-table__cell--big')[7].text
      @recommendation = i.css('td.tv-screener-table__cell--big')[8].text
      @out << [@name, @coupon, @maturity, @yield, @change, @high, @low, @recommendation]
    end
    @spinner.success
    options_controller([@header, @out])
  end

  def stocks(_args = nil)
    @out = []
    puts TTY::Link.link_to("Fetching latest data from#{' TradingView'.blue.bold}", @ref.blue)
    @spinner.auto_spin
    @doc = Nokogiri::HTML(URI.parse(@ref).open)
    @filter = 'tr.tv-data-table__row'
    @header = %w[NAME MARKET-CAPITAL VOLUME PRICE CHANGE-% SECTOR PRICE_TO_EARNING_RATIO RATING]
    @doc.css(@filter).each do |i|
      @name = i.css('a[class="tv-screener__symbol"]').text
      @cap = i.css('td.tv-screener-table__cell--big')[6].text
      @vol = i.css('td.tv-screener-table__cell--big')[5].text
      @price = i.css('td.tv-screener-table__cell--big')[1].text
      @change = i.css('td.tv-screener-table__cell--big')[2].text
      @sector = i.css('td.tv-screener-table__cell--big')[10].text
      @pte = i.css('td.tv-screener-table__cell--big')[7].text
      @rating = i.css('td.tv-screener-table__cell--big')[4].text
      @out << [@name, @cap, @vol, @price, @change, @sector, @pte, @rating]
    end
    @spinner.success
    options_controller([@header, @out])
  end

  def cryptocurrencies(_args = nil)
    @out = []
    puts TTY::Link.link_to("Fetching latest data from#{' TradingView'.blue.bold}", @ref.blue)
    @spinner.auto_spin
    @doc = Nokogiri::HTML(URI.parse(@ref).open)
    @filter = 'tr.tv-data-table__row'
    @header = %w[NAME CAP PRICE AVAILABLE TOTAL VOLUME CHANGE]
    @doc.css(@filter).each do |i|
      @name = i.css('a[class="tv-screener__symbol"]').text
      @cap = i.css('td.tv-screener-table__cell--big')[1].text
      @price = i.css('td.tv-screener-table__cell--big')[3].text
      @available = i.css('td.tv-screener-table__cell--big')[4].text
      @total = i.css('td.tv-screener-table__cell--big')[5].text
      @trade_volume = i.css('td.tv-screener-table__cell--big')[6].text
      @change = i.css('td.tv-screener-table__cell--big')[7].text
      @out << [@name, @cap, @price, @available, @total, @trade_volume, @change]
    end
    @spinner.success
    options_controller([@header, @out])
  end

  def options_controller(tbl)
    @options = ['List All', 'Search', 'Multi-Select']
    @opt = @prompt.select('What is it to be?', @options)
    options(@opt, tbl)
  end

  def options(str, tbl)
    case str
    when 'List All'
      render_table(tbl[0], tbl[1])
    when 'Search'
      @tbl_new = extract_table_index(str, tbl)
      render_table(tbl[0], @tbl_new)
    when 'Multi-Select'
      @tbl_new = extract_table_index(str, tbl)
      render_table(tbl[0], @tbl_new)
    end
  end

  def extract_table_index(str, tbl)
    @names = []
    @tbl_new = []
    tbl[1].each_with_index { |_val, i| @names << tbl[1][i][0] }
    case str
    when 'Multi-Select'
      @choice = @prompt.multi_select('Search and multi select form following list:', @names, filter: true)
      @choice.each { |i| tbl[1].select { |val| @tbl_new << val if val[0] == i } }
    when 'Search'
      @choice = @prompt.select('Choose your destiny?', @names, filter: true)
      @tbl_new = tbl[1].select { |val| val if val[0] == @choice }
    end
    @tbl_new
  end

  def render_table(header, content)
    @table = TTY::Table.new(header, content)
    puts @table.render(:ascii).bold
  end
end
