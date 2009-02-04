require File.dirname(__FILE__) + '/spec_helper.rb'

describe Rfactor do
  it "should have VERSION" do
    Rfactor::VERSION.should_not be_empty
  end
end
