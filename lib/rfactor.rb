$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Rfactor
  VERSION = '0.0.2'
end

require 'rubygems'
require 'ruby_parser'
require 'sexp_processor'

require 'rfactor/string_ext'
require 'rfactor/line_finder'
require 'rfactor/code'
