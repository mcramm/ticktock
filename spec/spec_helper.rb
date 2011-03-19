require 'stringio'
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

def create_test_data
  %w(coding eating sleeping).each do |category|
    @db[:categories].insert(:name => category)
  end

  [
    {:start_at => 0, :end_at => 600, :category_id => 1},
    {:start_at => 600, :end_at => 1000, :category_id => 2},
    {:start_at => 1000, :end_at => 2000, :category_id => 3},
    {:start_at => 2000, :end_at => 4000, :category_id => 2},
    {:start_at => 4000, :end_at => 4500, :category_id => 2},
    {:start_at => 4500, :end_at => 7000, :category_id => 1},
    {:start_at => 7000, :end_at => 7600, :category_id => 4},
    {:start_at => 7600, :end_at => 8400, :category_id => 4},
    {:start_at => 8400, :end_at => 9200, :category_id => 3},
    {:start_at => 9200, :end_at => 10800, :category_id => 1},
    {:start_at => 10800, :end_at => 20000, :category_id => 4},
    {:start_at => 20000, :end_at => nil, :category_id => 4}
  ].each do |time|
    @db[:times].insert(
      :category_id => time[:category_id],
      :start_at => time[:start_at],
      :end_at => time[:end_at]
    )
  end
end

module Kernel
  def capture_stdout
    out = StringIO.new
    $stdout = out
    yield
    return out
  ensure
    $stdout = STDOUT
  end
end
