require 'spec_helper'

describe "reporting" do
  before do
    @tt = TickTock.new
    @db = connect_to_db
    create_test_data
  end

  after do
    FileUtils.rm_rf DB_DIR
  end

  it "should respond to 'report'" do
    @tt.should.respond_to "report"
  end

  it "should return a paragraph explaining your times" do
    report = @tt.report

    expected_report = "Here is a quick summary for all of your logged times:\n\n"

    expected_report << "\tmisc: 1.3 hrs. (4700 sec)\n"
    expected_report << "\tcoding: 0.8 hrs. (2900 sec)\n"
    expected_report << "\teating: 0.5 hrs. (1800 sec)\n"
    expected_report << "\tsleeping: 2.9 hrs. (10600 sec)\n"

    report.should == expected_report
  end

end

