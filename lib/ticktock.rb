require 'ticktock/commands'
require 'rubygems'
require 'sequel'
require 'sqlite3'

DB_DIR ||= "#{ENV['HOME']}/.ticktock"
DB_NAME ||= "ticktock"

class TickTock
  include Commands

  def initialize
    @db = Sequel.sqlite "#{DB_DIR}/#{DB_NAME}.db"

    install unless File.exists?(DB_DIR) && !@db.nil?
  end

  def perform(command)
    command = ARGV.shift
    self.send command ARGV
  end

  def method_missing(method, *args, &block)
    if self.respond_to?(method)
      self.send method, args, block
    else
      raise "#{methond} was not found. Use --help for more information."
    end
  end
end
