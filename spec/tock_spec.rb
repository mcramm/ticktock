require 'spec_helper'

describe "tock" do
  before do
    @tt = TickTock.new
    @db = connect_to_db
  end

  after do
    FileUtils.rm_rf DB_DIR
  end

  it "should respond to tock" do
    @tt.should.respond_to('tock')
  end

  it "should create a new time (tick) if no un-ended time is found" do
    initial_size = @db[:times].all.size

    @tt.tock

    times = @db[:times].all
    times.size.should == initial_size + 1
  end
  it "should not create a new time (tick) if an un-ended time is found" do
    @tt.tick
    initial_size = @db[:times].all.size

    @tt.tock

    times = @db[:times].all
    times.size.should == initial_size
  end

  it "end time should be now" do
    @tt.tick

    now = Time.now.to_i
    @tt.tock

    end_time = @db[:times].order(:id).last[:end_at]

    end_time.should >= now
    end_time.should < now + 10
  end

  it "should only end the most recently created time" do
    2.times { @tt.tick }

    @tt.tock

    times = @db[:times].order(:id).all

    times.first[:end_at].should == nil
    times.last[:end_at].should.not == nil
  end

  it "should only end the most recently created time in a category if specified" do
    category = "test_category"

    @tt.tick
    @tt.tick category
    @tt.tick

    @tt.tock category

    times = @db[:times].order(:id).all

    times.first[:end_at].should == nil
    times.last[:end_at].should == nil

    times[1][:end_at].should.not == nil
  end

end
