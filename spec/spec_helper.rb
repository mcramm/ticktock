require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'bacon'
require 'sequel'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

DB_DIR = "#{ENV['HOME']}/.test_ticktock"
DB_NAME = "test_ticktock"

require 'ticktock'

Bacon.summary_on_exit

def connect_to_db
  Sequel.sqlite "#{DB_DIR}/#{DB_NAME}.db"
end

