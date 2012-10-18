require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)


# Create config object
raw_config = File.read('./config.yml')
CONFIG = YAML.load(raw_config)


# Create terminal
$term = HighLine.new


# load helpers
Dir['./lib/helpers/*.rb'].each {|file| require file }


# load sanitize transformers
Dir['./lib/inports/sanitize_transformers/*.rb'].each {|file| require file }


# load sanitize configurations
Dir['./lib/inports/sanitize_configs/*.rb'].each {|file| require file }


# load code
require './lib/inports/techlink_database.rb'
require './lib/inports/string'
require './lib/inports/exceptions'
require './lib/inports/redis'
require './lib/inports/logger'
require './lib/inports/post_processor'
require './lib/inports/processor'
require './lib/inports/ezpub'
require './lib/inports/formatters'
require './lib/inports/include_blacklist'

