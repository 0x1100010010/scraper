require_relative 'controller'

# FLOW: UI -> controller -> scrap
class UI
  def initialize
    @_name = []
    @_address = []
    @_root_addr = 'https://www.tradingview.com/markets'
    @spinner = TTY::Spinner.new
    @font = TTY::Font.new(:standard)
    @prompt = TTY::Prompt.new(help_color: :cyan)
    @obj = Controller.new(@_name, @_address, @_root_addr, @spinner, @font, @prompt)
  end

  def start
    puts @font.write('Yo Scrapper!').red
    category = @prompt.select('Select catogory#', @obj.controller('init'), filter: true)
    @obj.controller(category)
  end
end
