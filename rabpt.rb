#!/usr/bin/env jruby

require 'rubygems'
require 'imageruby'
require 'optparse'
require_relative 'src/renderer.rb'

Version = "0.0.1"

user_args = {}
opt_parser = OptionParser.new do |opt|
  opt.banner = "Usage example: ruby rabpt.rb -s 4 -w 128 -h 128 -f my_scene_file -i 5
  \nFor additional information please visit RabPT's github repository:\nhttps://github.com/simplay/RabPT"

  opt.separator  ""
  # some defaults
  user_args[:SPP] = 8

  opt.on("-s", "--spp N", Integer, "the number of samples per pixel") do |spp|
    user_args[:SPP] = spp
  end
  opt.on("-w", "--width WIDTH", Integer, "width of the resulting image") do |width|
    user_args[:M] = width
  end
  opt.on("-h", "--height HEIGHT", Integer, "height of the resulting image") do |height|
    user_args[:N] = height
  end
  opt.on("-f", "--filename FILENAME", String, "name of the file that the resulting image will be saved in (without file extension)") do |file_name|
    user_args[:file_name] = file_name
  end
  opt.on("-i", "--inputscene N", Integer, "Number of the scene that is going to be rendered") do |selected_scene|
    user_args[:selected_scene] = selected_scene
  end

  opt.on_tail("-h", "--help", "Show this message") do
    puts opt
    exit
  end
  opt.on_tail("--version", "Show version") do
    puts "rabpt #{Version}"
    exit
  end
end

begin
  opt_parser.parse!
  required_args = [:SPP, :M, :N, :file_name, :selected_scene]
  required_args.each do |arg|
    raise OptionParser::MissingArgument if user_args[arg].nil?
  end
rescue OptionParser::MissingArgument
  puts "Incorrect input argument(s) passed\n"
  puts opt_parser.help
  exit
end

Renderer.new user_args
