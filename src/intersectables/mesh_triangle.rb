class MeshTriangle
  require_relative '../intersectable.rb'
  require_relative '../ray.rb'
  require_relative '../hit_record.rb'
  
  include Intersectable
  
  # Defines a triangle by referring back to a Mesh and its vertex and
  # index arrays.
  
  attr_accessor :mesh,
                :index,
                :spanning_vertices,
                :spanning_normal
  
  def initialize(mesh, index)
    @mesh = mesh
    @index = index
    
    # build triangle
    vertices = mesh.vertices
    indices = mesh.indices
    
    spanning_vertices_idx = indices.values_at(index, index+1, index+2)
    spanning_vertices = vertices.values_at(index, index+1, index+2)
    @spanning_vertices = []
    @spanning_vertices << Vector3f.make_from_float(spanning_vertices[0])
    @spanning_vertices << Vector3f.make_from_float(spanning_vertices[1])
    @spanning_vertices << Vector3f.make_from_float(spanning_vertices[2])
    
    # do further stuff here, prepare for intersection testing
    # prepare for later boundung box init
    # store as much as possible
  end
  
  private 
  
  # use BC coordinates
  def inside_triangle? (beta, gamma)
    unit_range = [0.0, 1.0]
    no_triangle_hit = ([beta,gamma].all? do |expression| 
      is_between(expression, unit_range, "<=")})
    end
    
    # inside or outhsie triangle but not ON triangle (i.e. hit)
    no_triangle_hit ? false : is_between((gamma+beta), unit_range, "<")
  end
  
  # is given  value fulfilling condition
  # condition: range.first <= value <= range.last
  # @param value to check whether it is in range.
  # @param range Array contining upper and lower bound of range.
  # @param operation, i.e. comparission operator, as string 
  # @return condition:Boolean state 
  def is_between?(value, range, operation)
    (value <= range.last) && (value >= )
    value.send(operation, range.last) && range.first.send(operation, value)
  end
  
  
  
end