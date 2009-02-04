module Rfactor

  class LineFinder
    
    def initialize(ast, last_line)
      @ast = ast
      @last_line = last_line
    end
    
    def method_lines(line_in_code)
      processor = MethodLineFinderProcessor.new(line_in_code)
      processor.process(@ast)
      Range.new(processor.method_line, processor.last_method_line || @last_line, true)
    end
  end
  
  class MethodLineFinderProcessor < ::SexpProcessor
    attr_reader :method_line
    attr_reader :last_method_line
    
    def initialize(line)
      super()
      self.strict = false
      self.require_empty = false
      @line = line
      @method_line = 0
      @last_method_line = 0
    end
    
    def process_defn(exp, next_exp)
      current = exp.line
      if current > @method_line && current < @line
        @method_line = current
        @last_method_line = next_exp.line if next_exp
      end
      exp
    end
    
    def last_method_line
      @last_method_line if @last_method_line > @method_line
    end
  end

end
