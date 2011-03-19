require 'spec_helper'

describe 'initialize' do
  before do
    @tt = TickTock.new
  end

  after do
    FileUtils.rm_rf DB_DIR
  end

  it "should create a ticktock directory whenever TickTock is intitialized " do
    File.should.exist DB_DIR
  end

  it "should create a db file in ~/.ticktock/ for times" do
    File.should.exist "#{DB_DIR}/#{DB_NAME}.db"
  end

  it "should create a misc database on initilize" do
    categories = @tt.categories.all
    categories.size.should == 1
    categories.first[:name].should == 'misc'
  end
end
