require File.dirname(__FILE__) + '/spec_helper.rb'

NO_PARAMETER_CODE="""
class Example
  def long_method
    puts \"This is a long method\"
    puts \"used to print a message\"
    puts \"saying this is a long method\"
    puts \"but does nothing useful\"
  end
end"""

SIMPLE_PARAMETER_CODE="""
class Example
  def long_method
    first_message = \"This is a long method\"
    puts first_message
    second_message = \"used to print a message\"
    third_message = \"saying this is a long method\"
    puts second_message
    puts third_message
    puts \"but does nothing useful\"
  end
end"""

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
    
    it "should accept start and ends beyond boundaries" do
      lambda { @rfactor.extract_method({:name => "b", :start => 0, :end => 3}) }.should_not raise_error
    end
  end
  
  it "should extract method and add it even if the method is the last thing of the code" do
    rfactor = Rfactor::Code.new("""
      def the_method(firstArg, secondArg)
        puts \"some\"
        puts :code
        puts /to be/
        puts 'refactored'
      end""")
    new_code = rfactor.extract_method(:name => "print", :start => 3, :end => 5)
    new_code.should == """
      def the_method(firstArg, secondArg)
        print
        puts 'refactored'
      end

      def print
        puts \"some\"
        puts :code
        puts /to be/
      end"""
  end
  
  it "should extract method and adjust identation even if it is highly idented" do
    rfactor = Rfactor::Code.new("""
      def the_method
        stop = false
        while not stop
          if not stop
            stop = true
          end
        end
      end""")
    new_code = rfactor.extract_method(:name => "stop?", :start => 6, :end => 6)
    new_code.should == """
      def the_method
        stop = false
        while not stop
          if not stop
            stop = stop?
          end
        end
      end

      def stop?
        stop = true
      end"""
  end
  
  context "no parameters method extraction" do
    before(:each) do
      @rfactor = Rfactor::Code.new(NO_PARAMETER_CODE)
    end
    
    it "should extract the first line of the long method" do
      new_code = @rfactor.extract_method({:name => "print_description", :start => 4, :end => 4})
      new_code.should == """
class Example
  def long_method
    print_description
    puts \"used to print a message\"
    puts \"saying this is a long method\"
    puts \"but does nothing useful\"
  end

  def print_description
    puts \"This is a long method\"
  end
end"""
    end

    it "should extract the middle line of the long method" do
      new_code = @rfactor.extract_method({:name => "print_motive", :start => 5, :end => 5})
      new_code.should == """
class Example
  def long_method
    puts \"This is a long method\"
    print_motive
    puts \"saying this is a long method\"
    puts \"but does nothing useful\"
  end

  def print_motive
    puts \"used to print a message\"
  end
end"""
    end

    it "should extract the whole method lines of the long method" do
      new_code = @rfactor.extract_method({:name => "print_message", :start => 4, :end => 7})
      new_code.should == """
class Example
  def long_method
    print_message
  end

  def print_message
    puts \"This is a long method\"
    puts \"used to print a message\"
    puts \"saying this is a long method\"
    puts \"but does nothing useful\"
  end
end"""
    end
    
    it "should extract the whole method without parameters for literal strings, regexs and symbols" do
      rfactor = Rfactor::Code.new("""
class Example
  def long_method
    puts \"This is a long method\"
    puts 'used to print a message'
    puts /saying this is a long method/
    puts :but_does_nothing_useful
  end
end""")
      new_code = rfactor.extract_method({:name => "print_message", :start => 4, :end => 7})
      new_code.should == """
class Example
  def long_method
    print_message
  end

  def print_message
    puts \"This is a long method\"
    puts 'used to print a message'
    puts /saying this is a long method/
    puts :but_does_nothing_useful
  end
end"""
    end
    
    it "should ignore constants such as literal strings, strings, regexs, symbols and boolean values" do
      rfactor = Rfactor::Code.new("""
class Example
  def long_method
    puts \"This is a long method\"
    puts /saying this is a long method/
    puts :but_does_nothing_useful
    puts 'used to = print a message'
    puts true
    puts false
  end
end""")
      new_code = rfactor.extract_method({:name => "print_message", :start => 4, :end => 9})
      new_code.should == """
class Example
  def long_method
    print_message
  end

  def print_message
    puts \"This is a long method\"
    puts /saying this is a long method/
    puts :but_does_nothing_useful
    puts 'used to = print a message'
    puts true
    puts false
  end
end"""
    end
  end
  
  context "with parameters" do
    context "without collateral effects between uses of variables" do
      before(:each) do
        @rfactor = Rfactor::Code.new(SIMPLE_PARAMETER_CODE)
      end
      
      it "should extract the method and discover simple parameter" do
        new_code = @rfactor.extract_method({:name => "print_description", :start => 5, :end => 5})
        new_code.should == """
class Example
  def long_method
    first_message = \"This is a long method\"
    print_description(first_message)
    second_message = \"used to print a message\"
    third_message = \"saying this is a long method\"
    puts second_message
    puts third_message
    puts \"but does nothing useful\"
  end

  def print_description(first_message)
    puts first_message
  end
end"""
      end
      
      it "should extract the method and not include parameters defined within the extracted code" do
        new_code = @rfactor.extract_method({:name => "print_description", :start => 4, :end => 5})
        new_code.should == """
class Example
  def long_method
    print_description
    second_message = \"used to print a message\"
    third_message = \"saying this is a long method\"
    puts second_message
    puts third_message
    puts \"but does nothing useful\"
  end

  def print_description
    first_message = \"This is a long method\"
    puts first_message
  end
end"""
      end

      it "should extract the method and assign the method if the last instruction is an assignment" do
        new_code = @rfactor.extract_method({:name => "print_description", :start => 4, :end => 6})
        new_code.should == """
class Example
  def long_method
    second_message = print_description
    third_message = \"saying this is a long method\"
    puts second_message
    puts third_message
    puts \"but does nothing useful\"
  end

  def print_description
    first_message = \"This is a long method\"
    puts first_message
    second_message = \"used to print a message\"
  end
end"""
      end
      
      it "should extract parameter from complex code" do
        rfactor = Rfactor::Code.new("""
        def extract_method
          last_instruction = method_contents.split(\"\\n\")[-1]
          is_assignment = remove_constants(last_instruction).match(/\\s*([a-zA-Z][\\w\\?\\!]*)\\s*=/)
          new_code << \"#{$1} = \" if is_assignment
        end
""")
        new_code = rfactor.extract_method(:name => "last_instruction_is_assignment", :start => 3, :end => 4)
        new_code.should == """
        def extract_method
          is_assignment = last_instruction_is_assignment(method_contents)
          new_code << \"#{$1} = \" if is_assignment
        end

        def last_instruction_is_assignment(method_contents)
          last_instruction = method_contents.split(\"\\n\")[-1]
          is_assignment = remove_constants(last_instruction).match(/\\s*([a-zA-Z][\\w\\?\\!]*)\\s*=/)
        end
"""
      end

      it "should extract the method with more than one parameter" do
        new_code = @rfactor.extract_method({:name => "print_description", :start => 8, :end => 9})
        new_code.should == """
class Example
  def long_method
    first_message = \"This is a long method\"
    puts first_message
    second_message = \"used to print a message\"
    third_message = \"saying this is a long method\"
    print_description(second_message, third_message)
    puts \"but does nothing useful\"
  end

  def print_description(second_message, third_message)
    puts second_message
    puts third_message
  end
end"""
      end   
    end
  end
end