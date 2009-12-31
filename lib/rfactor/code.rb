VALID_NAME=/[a-zA-Z][\w\?\!]*/
VARIABLE_DEFINITION=/(#{VALID_NAME})[^(?:\()(?: \w)]/

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
      
      new_code = ""
      identation = ""
      
      @code.each_with_index do |line, n|
        line_number = n + 1 ### not 0-based
        if line_number == method_lines.first
          identation = extract_identation_level_from line
        end
        if line_number == selected_lines.first
          new_code << "#{identation}  "
          
          last_instruction = method_contents.split("\n")[-1]
          is_assignment = remove_constants(last_instruction).match(/\s*(#{VALID_NAME})\s*=/)
          new_code << "#{$1} = " if is_assignment
          
          new_code << "#{method_call}\n"
        elsif line_number == method_lines.last + 1
          new_code << "\n#{identation}def #{method_call}\n#{method_contents}#{identation}end\n"
        end
          
        new_code << line unless selected_lines.include? line_number
      end
      new_code << new_method_code unless method_lines.last < @code.size
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
      all_variables = remove_constants(method_contents).scan(VARIABLE_DEFINITION).flatten
      all_variables.reject do |variable|
        method_contents.match(/^\s*#{variable}\s*=/)
      end
    end
    
    def remove_constants(code)
      symbolless_code = code.gsub(/:#{VALID_NAME}/, "")
      regexless_code = symbolless_code.gsub(/\/([^\/\\]|\\.)*\//, "")
      literal_stringless_code = regexless_code.gsub(/'([^'\\]|\\.)*'/, "")
      literal_stringless_code.gsub(/"([^"\\]|\\.)*"/, "")
    end
    
    def add_identation(identation, code)
      code.gsub(/\n/, "\n#{identation}")
    end
  end
end

