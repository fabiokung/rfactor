class String
  
  def last_line
    number = 0
    self.each_with_index do |line, i|
      number = i
    end
    number + 1
  end
  
  def strip_blank_lines_at_end
    self.gsub /((\s*)\n)+$/, ''
  end
end
