require 'pry'

class ObjReader
  # obj file format storing basic triangular mesh data
  # for further information please have a look at: 
  # http://en.wikipedia.org/wiki/Wavefront_.obj_file
  
  ObjReader::BASEPATH = "meshes/"
  attr_reader :mesh
  
  # @param file_name String indicating
  #        the file name of the target 
  #        obj file + its extension
  # E.g. file_name = "teapot.obj"
  def initialize file_name
    binding.pry
    counter = 1
    path = ObjReader::BASEPATH + file_name
    file = File.new(path, "r")
    while (line = file.gets)
      arguments = line.split
      case arguments[0]
      when "v"
        # vertex data
      when "f"
        # face data
      when "vn"
        # vertex normal data
      when "#"
        # meta mesh information
      else
        raise "unsupported argument type: #{arguments} at line #{counter} in file #{file_name}"
      end       
      counter = counter + 1
    end
    file.close
    
  end
  
end