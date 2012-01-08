VALID_NAME=/[a-zA-Z][\w\?\!]*/
VARIABLE_DEFINITION=/(#{VALID_NAME})[^(?:\()(?: \w)]/

module Rfactor
  class Code
    ##### code: String with code to be refactored
    def initialize(code)
      @code = code
    end
    
    ##### == Required arguments
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
      method_call = "#{args[:name]}"
      method_call += "(#{parameters.join(', ')})" unless parameters.empty?
      
      new_code = ""
      
      line_number = 0
      @code.each do |line|
        line_number =+ 1
        if line_number == selected_lines.first
          call_identation = extract_identation_level_from line
          new_code << call_identation
          
          return_value = assignment_value(method_contents)
          unless return_value.nil?
            new_code << "#{return_value} = "
            method_contents.gsub!(/^(.*)#{return_value}\s*=\s*(.*)$/m, '\1\2')
          end
          
          new_code << "#{method_call}\n"
          method_contents.gsub!(/^#{call_identation}/, "")
        elsif line_number == method_lines.last
          method_identation = extract_identation_level_from line
          # In this order to keep the line break preference
          new_code << "#{method_identation}end\n"
          new_code << "\n#{method_identation}def #{method_call}\n"
          new_code << ident(method_contents, method_identation+"  ")
        end
          
        new_code << line unless selected_lines.include? line_number
      end
      new_code
    end

    # == Required arguments
    #
    # You must pass them inside a Hash:
    #
    # * :name => 'the new variable name'
    # * :text => what to be extracted to the variable
    # * :line => line number where the variable to be extracted is
    #
    # == Example
    #
    #   code.extract_variable :name => 'common_code', :text => "'string'", :line => 3
    def extract_variable(args)
      raise ":name is required" unless args.has_key?(:name)
      
      ast = RubyParser.new.parse(@code)
      line_finder = LineFinder.new(ast)
      
      method_lines = line_finder.method_lines(args[:line])
      
      new_code = ""
      added = false
      identation = 0
      
      @code.each_with_index do |line, n|
        line_number = n + 1 # not 0-based
        if line_number == method_lines.first
          identation = extract_identation_level_from line
        end
        if line_number == method_lines.first + 1
          new_code << "#{identation}  #{args[:name]} = #{args[:text]}\n"
        end
        if method_lines.include? line_number
          new_line = line.gsub(args[:text], args[:name])
          new_code << new_line
        else
          new_code << line
        end
      end
      new_code
    end
    
    private
    
    def assignment_value(method_contents)
      last_instruction = method_contents.split("\n")[-1]
      is_assignment = remove_constants(last_instruction).match(/\s*(#{VALID_NAME})\s*=/)
      $1
    end
        
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
        line_number = n + 1 ### not 0-based
        method_contents << line if selected_lines.include? line_number
      end
      method_contents
    end
    
    def extract_identation_level_from(line)
      spaces = line.match /^(\s*)\w/
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
      parsed_stringless_code = literal_stringless_code.gsub(/"([^"\\]|\\.)*"/, "")
      parsed_stringless_code.gsub(/(true)|(false)/, "")
    end
    
    def ident(code, identation)
      idented_code = code.split("\n").map{|line| identation+line}.join("\n")
      idented_code += "\n" if code[-1] == "\n"[0]
      idented_code
    end
  end
end



