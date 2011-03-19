require 'spec_helper'

describe "tick" do
  before do
    @tt = TickTock.new
  end


  it "respond to tick" do
    @tt.should.respond_to('tick')
  end
end
