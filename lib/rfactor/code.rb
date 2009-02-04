module Rfactor
  
  class Code
    
    def initialize(code)
      @code = code
      @ast = RubyParser.new.parse(code)
      @line_finder = LineFinder.new(@ast, code.last_line)
    end
    
    def extract_method(args)
      raise ":name is required" unless args.has_key?(:name)
      method_lines = @line_finder.method_lines(args[:start])
      selected_lines = Range.new(args[:start], args[:end])
      new_code = ""
      @code.each_with_index do |line, number|
        if selected_lines.include?(number+1)
          new_code << "#{args[:name]}()\n" if number == method_lines.first
        else
          new_code << line
        end
      end
      new_code
    end
        
  end
end