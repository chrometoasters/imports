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

# load sanitize configurations

Dir['./lib/sanitize_configs/*.rb'].each {|file| require file }


# load code

require './lib/inports/string'
require './lib/inports/exceptions'
require './lib/inports/redis'
require './lib/inports/logger'
require './lib/inports/convert'
require './lib/inports/crawler'
require './lib/inports/ez_objects'
require './lib/inports/formatters'
