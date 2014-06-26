#!/usr/bin/env jruby

require "rubygems"
require "imageruby"
require "pry"
require 'optparse'
require File.join(File.dirname(__FILE__), 'src/renderer.rb')

user_args = {}
opt_parser = OptionParser.new do |opt|
  opt.banner = "TODO usage hints"
  opt.separator  ""
  opt.on("-s", "--spp N", Integer, "the number of samples per pixel") do |spp|
    user_args[:SPP] = spp
  end
  opt.on("-w", "--width WIDTH", Integer, "width of the resulting image") do |width|
    user_args[:M] = width
  end
  opt.on("-h", "--height HEIGHT", Integer, "height of the resulting image") do |height|
    user_args[:N] = height
  end
  opt.on("-f", "--filename [FILENAME]", String, "name of the file that the resulting image will be saved in (without file extension)") do |file_name|
    user_args[:file_name] = file_name
  end
  opt.on("-i", "--inputscene N", Integer, "Number of the scene that is going to be rendered") do |selected_scene|
    user_args[:selected_scene] = selected_scene
  end
end

opt_parser.parse!
puts user_args
Renderer.new user_args
