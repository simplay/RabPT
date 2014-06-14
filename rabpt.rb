require "rubygems"
require "imageruby"
require "pry"
require File.join(File.dirname(__FILE__), 'src/renderer.rb')

KEYS = [:N, :M, :SPP, :file_name, :selected_scene]

arg_count = ARGV.length
key_count = KEYS.length
raise "too few arguments provided" if arg_count < 2
raise "too many arguments provided" if arg_count > key_count

user_args = {}
arg_count.times do |idx|
  user_args[KEYS[idx]] = ARGV[idx]
end  

Renderer.new user_args