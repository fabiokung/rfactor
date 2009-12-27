require File.dirname(__FILE__) + '/spec_helper.rb'

describe Rfactor::Code do
  context "minimalist code" do
    before(:each) do
      @rfactor = Rfactor::Code.new("def a; end")
    end
    it "should require new method name on extract method" do
      lambda { @rfactor.extract_method({}) }.should raise_error(":name is required")
    end

    it "should require starting line number on extract method" do
      lambda { @rfactor.extract_method({:name => "b"}) }.should raise_error(":start is required")
    end
    
    it "should require ending line number on extract method" do
      lambda { @rfactor.extract_method({:name => "b", :start => 3}) }.should raise_error(":end is required")
    end
    
    it "should extract all document if start and end are greater than limits" do
      lambda { @rfactor.extract_method({:name => "b", :start => 0, :end => 3}) }.should_not raise_error
    end
  end
end