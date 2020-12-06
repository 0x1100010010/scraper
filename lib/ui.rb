class UI
  def ui
    font = TTY::Font.new(:standard)
    prompt = TTY::Prompt.new
    puts font.write('Yo Scrapper!').red

    uname = prompt.ask('What is your name?', default: ENV['USER'])
    init = controller('init')
    category = prompt.select('Select catogory#', init)
    scrap(category, nil)
  end

  private

  def validate_input(str)
    puts "validates user input #{str}"
  end

  def controller(str)
    case str
    when 'init'
      @addr = 'www.tradingview.com/markets/'
      puts "Fetching catogories from '#{@addr}'"
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
      stocks
    when 'Cryptocurrencies'
      cryptocurrencies
    when 'exit'
    end
  end

  def init(addr)
    arr = []
    @doc = Nokogiri::HTML(URI.open("http://#{addr[0]}"))
    arr << @doc.css(addr[1]).text.split
    arr
  end

  def futures
    puts 'futures'.bold.blue
  end

  def stocks
    @ref = 'www.tradingview.com/markets/stocks-usa/market-movers-large-cap/'
    @doc = Nokogiri::HTML(URI.parse("http://#{@ref}").open)
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
    @ref = 'www.tradingview.com/markets/cryptocurrencies/prices-all/'
    @doc = Nokogiri::HTML(URI.parse("http://#{@ref}").open)
    @filter = 'tr.tv-data-table__row'
    @doc.css(@filter).each do |i|
      @name = i.css('a[class="tv-screener__symbol"]').text.bold
      @cap = i.css('td.tv-screener-table__cell--big')[1].text.bold
      @price = i.css('td.tv-screener-table__cell--big')[3].text.bold
      @available = i.css('td.tv-screener-table__cell--big')[4].text.bold
      @total = i.css('td.tv-screener-table__cell--big')[5].text.bold
      @trade_volume = i.css('td.tv-screener-table__cell--big')[6].text.bold
      @change = i.css('td.tv-screener-table__cell--big')[7].text.bold
      puts " #{@name} #{@cap} #{@price} #{@available} #{@total} #{@trade_volume} #{@change}"
    end
  end
end
