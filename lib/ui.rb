require_relative 'controller'

class UI
  attr_reader :_name, :_address, :_root_addr, :font, :spinner, :prompt, :obj

  def initialize
    @_name = []
    @_address = []
    @_root_addr = 'https://www.tradingview.com/markets'
    @spinner = TTY::Spinner.new
    @font = TTY::Font.new(:standard)
    @prompt = TTY::Prompt.new(help_color: :cyan)
    @obj = Controller.new(@_name, @_address, @_root_addr, @spinner, @prompt)
  end

  def start
    puts @font.write('Yo Scrapper!').red
    category = @prompt.select('Select catogory#', @obj.controller('init'), filter: true)
    @obj.controller(category)
  end
end
