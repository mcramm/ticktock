require 'spec_helper'

describe "tick" do
  before do
    @tt = TickTock.new
    @db = connect_to_db
  end

  it "respond to tick" do
    @tt.should.respond_to('tick')
  end

  it "should create a time when calling tick" do
    initial_size = @db[:times].all.size

    @tt.tick

    times = @db[:times].all
    times.size.should == initial_size + 1
  end

  it "start time should be now" do
    now = Time.now.to_i

    @tt.tick

    start_time = @db[:times].order(:id).last[:start_at]

    start_time.should >= now
    start_time.should < now + 10
  end
  it "end time should be null" do
    end_time = @db[:times].order(:id).last[:end_at]
    end_time.should === nil
  end

  it "should create a start time under misc when not passing a category" do
    @tt.tick

    times = @db[:times].left_outer_join(:categories, :id => :category_id).all
    times.last[:name].should == 'misc'
  end

  it "should create a start time under a specified category if one is passed" do
    category = "test_category"
    @tt.tick category

    times = @db[:times].left_outer_join(:categories, :id => :category_id).all
    times.last[:name].should == category
  end
end
