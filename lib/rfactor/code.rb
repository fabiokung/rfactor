module Rfactor
  
  class Code
    
    ### code: String with code to be refactored
    def initialize(code)
      @code = code
    end
    
    ### == Required arguments
    #
    # You must pass them inside a Hash:
    #
    # * :name => 'the new method name'
    # * :start => line number where the code to be extracted starts
    # * :end => line number where the code to be extracted ends
    #
    # == Example
    #
    #   code.extract_method :name => 'common_code', :start => 3, :end => 7
    def extract_method(args)
      raise_error_if_absent(args, ["name", "start", "end"])
      
      method_lines = extract_method_lines(args[:start])
      selected_lines = Range.new(args[:start], args[:end])
      method_contents = extract_method_contents(selected_lines)
      parameters = extract_parameters(method_contents)
      method_call = "#{args[:name]}(#{parameters.join(', ')})"
      unindented_new_method_code = "def #{method_call}\n#{method_contents}\nend\n"
      
      new_method_code = ""
      new_code = ""
      extracted_method = ""
      added = false
      identation = 0
      
      @code.each_with_index do |line, n|
        line_number = n + 1 ### not 0-based
        if line_number == method_lines.first
          identation = extract_identation_level_from line
          new_method_code = indent(unindented_new_method_code)
        end
        if selected_lines.include? line_number
          new_code << "#{identation}  #{method_call}\n" if line_number == selected_lines.first
        elsif line_number > method_lines.last && !added
          added = true
          new_code << new_method_code
          new_code << line
        else
          new_code << line
        end
      end
      new_code << new_method_code unless added
      new_code
    end
    
    private
    def raise_error_if_absent(arguments, keys)
      keys.each do |key|
        raise ":#{key} is required" unless arguments.has_key?(key.to_sym)
      end
    end
    
    def extract_method_lines(starting_line)
      ast = RubyParser.new.parse(@code)
      line_finder = LineFinder.new(ast)
      line_finder.method_lines(starting_line)
    end
    
    def extract_method_contents(selected_lines)
      method_contents = ""
      @code.each_with_index do |line, n|
        line_number = n + 1 # not 0-based
        method_contents << line if selected_lines.include? line_number
      end
      method_contents
    end
    
    def extract_identation_level_from(line)
      spaces = line.match /^(\s*)def/
      spaces.captures[0]
    end
    
    def extract_parameters(method_contents)
      []
    end
  end
end

