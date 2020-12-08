require_relative '../lib/ui'
require 'open-uri'
require 'nokogiri'
require 'colorize'
require 'tty-font'
require 'tty-prompt'
require 'tty-link'
require 'pastel'
require 'tty-table'
require 'tty-spinner'

init = UI.new
init.start
