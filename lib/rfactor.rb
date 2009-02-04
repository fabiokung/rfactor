$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Rfactor
  VERSION = '0.0.1'
end

class String
  def last_line
    number = 0
    self.each_with_index do |line, i|
      number = i
    end
    number + 1
  end
end

require 'rubygems'
require 'ruby_parser'
require 'sexp_processor'

require 'rfactor/line_finder'
require 'rfactor/code'
