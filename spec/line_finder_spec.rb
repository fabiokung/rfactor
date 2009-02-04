require File.dirname(__FILE__) + '/spec_helper.rb'

CODE = <<-END
class Bla
  def my_method
    puts "something"
    puts "more"
    3+2
  end
  
  def my_other_method
    puts "anything"
  end
end
END

describe Rfactor::LineFinder do
  
  before(:each) do
    @ast = RubyParser.new.parse(CODE)
    @finder = Rfactor::LineFinder.new(@ast)
  end
  
  it "should find method start line" do
    @finder.method_lines(3).first.should == 2
  end
  
  it "should find method end line" do
    @finder.method_lines(3).last.should == 6
  end
  
  it "it should find method end line even if the method is the last" do
    @finder.method_lines(9).last.should == 10
  end
  
end