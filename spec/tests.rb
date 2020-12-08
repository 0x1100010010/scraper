require_relative '../lib/ui'
require_relative '../lib/controller'
require 'open-uri'
require 'nokogiri'
require 'tty-font'
require 'tty-prompt'
require 'tty-link'
require 'pastel'
require 'tty-table'
require 'tty-spinner'
require 'webmock/rspec'
require 'colorize'
require 'rspec'
require 'rails_helper'
require 'spec_helper'

describe UI do
  let(:init) { UI.new }
  describe '[UI Class Initializations] >>'.bold.blue, type: :request do
    it 'Initialization for name as array' do
      expect(init._name.class).to eql(Array)
    end
    it 'Initial value  for name' do
      expect(init._name).to eql([])
    end
    it 'Initialization for address as array' do
      expect(init._address.class).to eql(Array)
    end
    it 'Initial value  for address' do
      expect(init._address).to eql([])
    end

    it 'Initialization for root_addr as String' do
      expect(init._root_addr.class).to eql(String)
    end
    it 'Initial value  for address' do
      expect(init._root_addr).to eql('https://www.tradingview.com/markets')
    end

    it 'Initialization for spinner' do
      expect(init.spinner.class).to eql(TTY::Spinner)
    end

    it 'Initialization for font' do
      expect(init.font.class).to eql(TTY::Font)
    end

    it 'Initialization for prompt' do
      expect(init.prompt.class).to eql(TTY::Prompt)
    end
  end
end

describe Controller do
  let(:init) { UI.new }
  let(:controller_object) { Controller.new(init._name, init._address, init._root_addr, init.spinner, init.prompt) }
  describe '[Controller Class Test Cases] >>'.bold.blue, type: :request do
    it 'Object Declaraion' do
      expect(controller_object.class).to eql(Controller)
    end

    it 'Controller class variables encapsolation' do
      expect { controller_object.name }.to raise_error(NoMethodError)
    end

    it 'Controller class methods encapsolation' do
      expect { controller_object.name }.to raise_error(NoMethodError)
    end
  end
end
