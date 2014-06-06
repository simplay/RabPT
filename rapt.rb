require "rubygems"
require "imageruby"
require "pry"
require File.join(File.dirname(__FILE__), 'renderer.rb')

#require 'path/to/mycode.jar'

hash = {:N => ARGV[0].to_i, :M => ARGV[1].to_i}

Renderer.new hash

