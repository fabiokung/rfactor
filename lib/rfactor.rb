$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

# == Usage
#
# The main class to be used is Rfactor::Code
# 
# Example:
#   code = Rfactor::Code.new(document)
#   new_code = code.extract_method :name => 'new_method',
#                :start => 3,
#                :end => 5
module Rfactor
  VERSION = '0.0.3'
end

require 'rubygems'
require 'ruby_parser'
require 'sexp_processor'

require 'rfactor/string_ext'
require 'rfactor/line_finder'
require 'rfactor/code'
