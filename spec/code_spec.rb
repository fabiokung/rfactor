require File.dirname(__FILE__) + '/spec_helper.rb'

describe Rfactor::Code do
  it "should require new method name on refactor" do
    rfactor = Rfactor::Code.new("def a; end")
    lambda { rfactor.extract_method({}) }.should raise_error(":name is required")
  end
end