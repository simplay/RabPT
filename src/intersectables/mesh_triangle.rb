class MeshTriangle
  require_relative '../intersectable.rb'
  require_relative '../ray.rb'
  require_relative '../hit_record.rb'
  
  include Intersectable
  
  # Defines a triangle by referring back to a {@link Mesh} and its vertex and
  # index arrays.
  
  attr_accessor :mesh,
                :index
  
  def initialize(mesh, index)
    @mesh = mesh
    @index = index
    
    # build triangle
    vertices = mesh.vertices
    indices = mesh.indices
    
    spanning_vertices_idx = indices.values_at(index, index+1, index+2)
    spanning_vertices = vertices.values_at(index, index+1, index+2)
    
    Vector3f.new(spanning_vertices[0].x, spanning_vertices[0].y, spanning_vertices[0].z)
    Vector3f.new(spanning_vertices[1].x, spanning_vertices[1].y, spanning_vertices[1].z)
    Vector3f.new(spanning_vertices[2].x, spanning_vertices[2].y, spanning_vertices[2].z)
    
    # do further stuff here, prepare for intersection testing
    # prepare for later boundung box init
    # store as much as possible
  end
  
  
  
end