class UI
  def ui
    font = TTY::Font.new(:standard)
    prompt = TTY::Prompt.new
    puts font.write('Yo Scrapper!').red

    # uname = prompt.ask('What is your name?', default: ENV['USER'])
    category = prompt.select('Select catogory#', controller('init'))
    scrap(category, nil)
  end

  private

  def validate_input(str)
    puts "validates user input #{str}"
  end

  def controller(str)
    case str
    when 'init'
      @addr = 'https://www.tradingview.com/markets/'
      puts TTY::Link.link_to("Fetching catogories from#{' TradingView'.blue.bold}", @addr.blue)
      @target = 'a.tv-feed-widget__title-link'
      @out = scrap(str, [@addr, @target])
    when 'category'
      @out = 'stocks'
    end
    @out
  end

  def scrap(category, args)
    case category
    when 'init'
      init(args)
    when 'Indices'
      puts 'indices'.bold.blue
    when 'Futures'
      puts 'futures'.bold.blue
    when 'Currencies'
      puts 'currencies'.bold.blue
    when 'Bonds'
      puts 'bonds'.bold.blue
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
    @name = @doc.css(args[1]).text.split
    @address = @doc.css(args[1]).map { |link| link['href'] }
    puts @name.index('Stocks')
    [@name, @address]
  end

  def futures()
    puts 'futures'.bold.blue
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
    options_controller([@header, @out])
  end

  def options_controller(tbl)
    prompt = TTY::Prompt.new
    @options = ['List All', 'Search', 'List Select']
    @opt = prompt.select('Choose your destiny?', @options)
    options(@opt, tbl)
  end

  def options(str, tbl)
    prompt = TTY::Prompt.new
    case str
    when 'List All'
      table = TTY::Table.new(tbl[0], tbl[1])
      puts table.render(:ascii).bold
    when 'Search'
      @names = []
      @tbl_new = []
      tbl[1].each_with_index { |_val, i| @names << tbl[1][i][0] }
      @choice = prompt.select('Choose your destiny?', @names, filter: true)
      tbl[1].select { |val| @tbl_new << val if val[0] == @choice }
      table = TTY::Table.new(tbl[0], @tbl_new)
      puts table.render(:ascii).bold
    when 'Select'
    end
  end
end
