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
      extracted_method = ""
      added = false
      identation = 0
      
      @code.each_with_index do |line, number|
        if number + 1 == method_lines.first
          spaces = line.match /^(\s*)def/
          identation = spaces.captures[0]
          extracted_method << "\n\n#{identation}"
          extracted_method << "def #{args[:name]}()\n"
        end
        if selected_lines.include?(number+1)
          new_code << "#{args[:name]}()\n" if number == method_lines.first
          extracted_method << line
        elsif number+1 > method_lines.last && !added
          added = true
          new_code << extracted_method << "end\n"
        else
          new_code << line
        end
      end
      new_code << extracted_method << "#{identation}end\n" unless added
      new_code
    end
        
  end
end