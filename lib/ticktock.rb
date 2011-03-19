require 'ticktock/commands'
require 'rubygems'
require 'sequel'
require 'sqlite3'
require 'fileutils'

DB_DIR ||= "#{ENV['HOME']}/.ticktock"
DB_NAME ||= "ticktock"

class TickTock
  include Commands

  def initialize
    @db ||= connect_to_db

    install unless File.exists?(DB_DIR) && !@db.nil?
  end

  def perform(command, *args)

    if self.respond_to? command
      args.size == 0 ? self.send(command) : self.send(command, args)
    end
  end

end
