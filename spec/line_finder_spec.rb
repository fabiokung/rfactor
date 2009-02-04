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
    @finder = Rfactor::LineFinder.new(@ast, CODE.last_line)
  end
  
  it "should find method start line" do
    @finder.method_lines(3).first.should == 2
  end
  
  it "should use next method line as last line" do
    @finder.method_lines(3).last.should == 8
  end
  
  it "should use file last line if position is last method method" do
    @finder.method_lines(9).last.should == 11
  end
  
end