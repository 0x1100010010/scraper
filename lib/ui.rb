class UI
  # constants = if spinner_pack = ARGV[0]
  #               [spinner_pack.upcase]
  #             else
  #               Whirly::Spinners.constants
  #             end

  # constants.each do |spinner_pack|
  #   puts
  #   puts Paint[spinner_pack,]
  #   puts
  #   Whirly::Spinners.const_get(spinner_pack).keys.sort.each do |spinner_name|
  #     Whirly.start(spinner: spinner_name, status: spinner_name) do
  #       sleep 1
  #     end
  #   end
  # end

  def ui
    puts 'Yo Scrapper!'.bold.red, 'Gimmi some thing to scrap', 'like www.someting.com'
    input = input_controller('init')
    doc = Nokogiri::HTML(URI.open("http://#{input}"))
    categories = input_controller('categories')
    puts '', doc.css(categories).text.bold.blue, 'Now chose form above', ''
    category = input_controller('category')
    scrap(category)
  end

  private

  def validate_input(str)
    puts "validates user input #{str}"
  end

  def input_controller(str)
    case str
    when 'init'
      @out = gets.chomp
      if @out == ''
        @out = 'www.tradingview.com/markets/'
        puts "None given hommie, setting up '#{@out}'"
      end
    when 'categories'
      @out = 'a.tv-feed-widget__title-link'
    when 'category'
      @out = 'stocks'
    end
    @out
  end

  def scrap(category)
    case category
    when 'indices'
    when 'futures'
    when 'currencies'
    when 'bonds'
    when 'stocks'
      stocks
    when 'cryptocurrencies'
      cryptocurrencies
    when 'exit'
    end
  end

  def stocks
    @ref = 'www.tradingview.com/markets/stocks-usa/market-movers-large-cap/'
    @doc = Nokogiri::HTML(URI.parse("http://#{@ref}").open)
    @filter = 'tr.tv-data-table__row'
    @doc.css(@filter).each do |i|
      @name = i.css('a[class="tv-screener__symbol"]').text.bold
      @cap = i.css('td.tv-screener-table__cell--big')[6].text.bold
      @price = i.css('td.tv-screener-table__cell--big')[1].text.bold
      @available = i.css('td.tv-screener-table__cell--big')[4].text.bold
      @total = i.css('td.tv-screener-table__cell--big')[5].text.bold
      @trade_volume = i.css('td.tv-screener-table__cell--big')[6].text.bold
      @change = i.css('td.tv-screener-table__cell--big')[2].text.bold
      puts " #{@name} #{@cap} #{@price} #{@available} #{@total} #{@trade_volume} #{@change}"
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
