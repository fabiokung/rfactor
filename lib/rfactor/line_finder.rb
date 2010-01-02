module Rfactor
  class LineFinder
    def initialize(ast)
      @ast = ast
    end
    
    def method_lines(line_in_code)
      processor = MethodLineFinderProcessor.new(line_in_code)
      processor.process(@ast)
      Range.new(processor.method_line, processor.last_method_line)
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
    
    def process_defn(exp)
      current = exp.line
      if current > @method_line && current < @line
        @method_line = current
        @last_method_line = exp.endline
      end
      exp
    end
    
    def process_defs(exp)
      current = exp.line
      if current > @method_line && current < @line
        @method_line = current
        @last_method_line = exp.last.line
      end
      exp
    end
  end
end
