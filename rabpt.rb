#!/usr/bin/env jruby

$LOAD_PATH.unshift(File.expand_path('src'))

require 'rubygems'
require 'imageruby'
require 'optparse'
require 'dependencies'

VERSION = '0.0.1'.freeze

user_args = {}
opt_parser = OptionParser.new do |opts|
  opts.banner = <<~BANNER
    Usage example: ruby rabpt.rb -s 4 -w 128 -h 128 -f my_scene_file -i 5
    For additional information please visit RabPT's github repository:
    https://github.com/simplay/RabPT"
  BANNER

  opts.on('-s', '--spp [SPP]', Integer,
          'Number of samples per pixel') do |spp|
    user_args[:spp] = spp
  end

  opts.on('-w', '--width [WIDTH]', Integer,
          'Width of the resulting image') do |width|
    user_args[:width] = width
  end

  opts.on('-h', '--height [HEIGHT]', Integer,
          'Height of the resulting image') do |height|
    user_args[:height] = height
  end

  opts.on('-f', "--filename [FILENAME]", String,
          'output filename') do |file_name|
    user_args[:file_name] = file_name
  end

  opts.on('-i', "--inputscene [INPUTSCENE]", Integer,
          'Scence to render') do |selected_scene|
    user_args[:selected_scene] = selected_scene
  end

  opts.on_tail('-h', '--help', 'Show this message') do
    puts opts
    exit
  end

  opts.on_tail('--version', 'Show version') do
    puts "RabPT v#{VERSION}"
    exit
  end
end

begin
  opt_parser.parse!
  required_args = %i(spp width height file_name selected_scene)
  required_args.each do |arg|
    raise OptionParser::MissingArgument if user_args[arg].nil?
  end
rescue OptionParser::MissingArgument
  puts 'Incorrect input argument(s) passed'
  puts
  puts opt_parser.help
  exit
end

Renderer.new(user_args)
