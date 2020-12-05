require 'open-uri'
require 'nokogiri'
require 'kimurai'
require 'colorize'
require 'tco'
require 'rmagick'
require 'whirly'
require 'paint'
require 'rutui'

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

puts 'Yo Scrapper!'.bold.red, 'Gimmi some thing to scrap', 'like www.someting.com'
input = gets.chomp
if input == ''
  input = 'www.tradingview.com/markets/'
  puts "None given hommie, setting up '#{input}'"
end

if input == ''
  input = 'www.tradingview.com/markets/cryptocurrencies/prices-all/'
  puts "None given hommie, setting up '#{input}'"
end

doc = Nokogiri::HTML(URI.open("http://#{input}"))
puts 'Now gimmi the target homie!'
# target = gets.chomp
target = 'a.tv-feed-widget__title-link' if target == '' || target.nil?
puts '', doc.css(target).text

puts 'Now chose form above'
# target = gets.chomp
target = 'cryptocurrencies'
case target
when 'indices'
when 'futures'
when 'currencies'
when 'bonds'
when 'stocks'
when 'cryptocurrencies'
  input = 'www.tradingview.com/markets/cryptocurrencies/prices-all/'
  doc = Nokogiri::HTML(URI.parse("http://#{input}").open)
  target = 'tr.tv-data-table__row'
  # puts doc
  doc.css(target).each do |i|
    name = i.css('a[class="tv-screener__symbol"]').text.bold
    cap = i.css('td.tv-screener-table__cell--big')[1].text.bold
    price = i.css('td.tv-screener-table__cell--big')[3].text.bold
    available = i.css('td.tv-screener-table__cell--big')[4].text.bold
    total = i.css('td.tv-screener-table__cell--big')[5].text.bold
    trade_volume = i.css('td.tv-screener-table__cell--big')[6].text.bold
    change = i.css('td.tv-screener-table__cell--big')[7].text.bold

    puts " #{name} #{cap} #{price} #{available} #{total} #{trade_volume} #{change}"
  end
when 'exit'
end
