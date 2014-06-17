require 'pry'
require_relative 'vector3f.rb'

class ObjReader
  # obj file format storing basic triangular mesh data
  # for further information please have a look at: 
  # http://en.wikipedia.org/wiki/Wavefront_.obj_file
  
  ObjReader::BASEPATH = "meshes/"
  attr_reader :mesh_data,
              :x_min, :x_max,
              :y_min, :y_max,
              :z_min, :z_max
  
  
  # @param file_name String indicating
  #        the file name of the target 
  #        obj file + its extension
  # E.g. file_name = "teapot.obj"
  def initialize file_name
    @x_min = Float::MAX
    @y_min = Float::MAX 
    @z_min = Float::MAX
    @x_max = -Float::MAX
    @y_max = -Float::MAX 
    @z_max = -Float::MAX
    
    vertices = {}
    faces = {}
    normals = {}
    
    counter = 1
    vertex_counter = 1
    normal_counter = 1
    face_counter = 1
    path = ObjReader::BASEPATH + file_name
    file = File.new(path, "r")
    while (line = file.gets)
      arguments = line.split
      case arguments[0]
      when "v"
        # vertex data
        vertex = Vector3f.make_from_floats(arguments[1..3].map &:to_f)
        vertices[vertex_counter] = vertex
        update_vertex_extrema_of(vertex) 
        vertex_counter += 1
        
      when "f"
        # face data
        indices = []
        triangle_indices = (arguments[1..3].map{|e| e.split("/")}.map &:first).map &:to_i
        indices = Vector3f.make_from_floats triangle_indices
        faces[face_counter] = indices
        face_counter += 1
        
      when "vn"
        # vertex normal data
				normal = Vector3f.make_from_floats(arguments[1..3].map &:to_f)
        normals[normal_counter] = normal.normalize
        normal_counter += 1
        
      when "#"
        # meta mesh information
      else
        raise "unsupported argument type: #{arguments} at line #{counter} in file #{file_name}"
      end       
      counter = counter + 1
    end
    file.close
    
    # number vertex noramls corresponds to number of mesh vertices
    normals = normals.reject do |key| 
      key  > vertices.max.first
    end
    
    @mesh_data = {
      :vertices => vertices,
      :normals => normals,
      :faces => faces
    }
    
    normalize_vertices
    raise "Ambiguous obj file: Number of vertices does not match the number of vertex normals." unless (vertices.count == normals.count)
  end
  
  private 
  
  # update extrema of vertices
  def update_vertex_extrema_of vertex
    @x_min = vertex.x if vertex.x <= @x_min
    @x_max = vertex.x if vertex.x >= @x_max
    
    @y_min = vertex.y if vertex.y <= @y_min
    @y_max = vertex.y if vertex.y >= @y_max  
    
    @z_min = vertex.z if vertex.z <= @z_min
    @z_max = vertex.z if vertex.z >= @z_max  
  end
  
  # map vertices into range [0.0 , 1.0]
  # found extrema define the scale of this mesh
  # extrema value corresponds to 1m
  def normalize_vertices

    
  end
  
end