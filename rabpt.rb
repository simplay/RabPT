#!/usr/bin/env jruby

$LOAD_PATH.unshift File.expand_path('src')

require 'rubygems'
require 'imageruby'
require 'optparse'

require 'util/obj_reader'
require 'util/vector2f'
require 'util/vector3f'
require 'util/vector4f'
require 'util/matrix2f'
require 'util/matrix3f'
require 'util/matrix4f'
require 'util/optics'

require 'camera'
require 'film'
require 'hit_record'
require 'integrator'
require 'integrator_factory'
require 'intersectable'
require 'intersectable_list'
require 'light_geometry'
require 'light_list'
require 'ray'
require 'renderer'
require 'rendering_task'
require 'sampler'
require 'sampler_factory'
require 'scene'
require 'shading_sample'
require 'spectrum'
require 'tone_mapper'
require 'films/box_filter_film'
require 'integrators/debug_integrator'
require 'integrators/debug_integrator_factory'
require 'integrators/point_light_integrator'
require 'integrators/point_light_integrator_factory'
require 'integrators/whitted_integrator'
require 'integrators/whitted_integrator_factory'
require 'intersectables/csg_solid'
require 'intersectables/csg_plane'
require 'intersectables/instance'
require 'intersectables/interval_boundary'
require 'intersectables/mesh'
require 'intersectables/mesh_triangle'
require 'intersectables/plane'
require 'intersectables/sphere'
require 'lightsources/point_light'
require 'materials/material'
require 'materials/blinn'
require 'materials/diffuse'
require 'materials/point_light_material'
require 'materials/reflective'
require 'materials/refractive'
require 'samplers/one_sampler'
require 'samplers/one_sampler_factory'
require 'scenes/blinn_test_scene'
require 'scenes/camera_test_scene'
require 'scenes/instancing_test_scene'
require 'scenes/mesh_loading_test_scene'
require 'scenes/refraction_test_scene'

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
