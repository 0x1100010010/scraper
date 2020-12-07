# FLOW: UI -> controller -> scrap
class UI
  def initialize
    @_name = []
    @_address = []
    @_root_addr = 'https://www.tradingview.com/markets'
    @spinner = TTY::Spinner.new
    @font = TTY::Font.new(:standard)
    @prompt = TTY::Prompt.new(help_color: :cyan)
  end

  def ui
    puts @font.write('Yo Scrapper!').red
    category = @prompt.select('Select catogory#', controller('init'), filter: true)
    scrap(category)
  end

  private

  def controller(str)
    case str
    when 'init'
      puts TTY::Link.link_to("Fetching catogories from#{' TradingView'.blue.bold}", @_root_addr.blue)
      @spinner.auto_spin
      @target = 'a.tv-feed-widget__title-link'
      @out = scrap(str, [@_root_addr, @target])
    when 'Indices'
      puts 'Indices'
    end
    @spinner.success
    @out
  end

  def scrap(category, args = nil)
    case category
    when 'init'
      init(args)
      # s = @_root_addr + @_address[1][8..-1]
      # puts s
      # puts @_name.inspect, @_address.inspect
    when 'Indices'
      indices(args)
    when 'Futures'
      futures(args)
    when 'Currencies'
      currencies(args)
    when 'Bonds'
      bonds(args)
    when 'Stocks'
      stocks(args)
    when 'Cryptocurrencies'
      cryptocurrencies
    when 'exit'
      abort('yeah')
    end
  end

  def init(args)
    @doc = Nokogiri::HTML(URI.open(args[0]))
    @_name = @doc.css(args[1]).text.split
    @_address = @doc.css(args[1]).map { |link| link['href'] }
    @_name
  end

  def indices(_args = nil)
    puts 'Indices'.bold.blue
  end

  def futures(_args = nil)
    puts 'futures'.bold.blue
  end

  def currencies(_args = nil)
    puts 'currencies'.bold.blue
  end

  def bonds(_args = nil)
    puts 'bonds'.bold.blue
  end

  def stocks
    @ref = 'https://www.tradingview.com/markets/stocks-usa/market-movers-large-cap/'
    @doc = Nokogiri::HTML(URI.parse(@ref).open)
    @filter = 'tr.tv-data-table__row'
    @doc.css(@filter).each do |i|
      @name = i.css('a[class="tv-screener__symbol"]').text.bold
      @cap = i.css('td.tv-screener-table__cell--big')[6].text.bold
      @price = i.css('td.tv-screener-table__cell--big')[1].text.bold
      @vol = i.css('td.tv-screener-table__cell--big')[5].text.bold
      @recommendation = i.css('td.tv-screener-table__cell--big')[4].text.bold
      @sector = i.css('td.tv-screener-table__cell--big')[10].text.bold
      puts " #{@name} #{@cap} #{@price} #{@vol} #{@recommendation} #{@sector}"
    end
  end

  def cryptocurrencies
    @spinner.auto_spin
    @out = []
    @ref = 'https://www.tradingview.com/markets/cryptocurrencies/prices-all/'
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
