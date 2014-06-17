class MeshTriangle
  require_relative '../intersectable.rb'
  require_relative '../ray.rb'
  require_relative '../hit_record.rb'
  
  include Intersectable
  
  # Defines a triangle by referring back to a Mesh and its vertex and
  # index arrays.
  
  attr_accessor :p_x, :p_y, :p_z
  
  # compute triangle spanning vertices
  # TODO explain beta_gama
  def initialize(mesh, index)
    verts = mesh.indices.values_at(3*index+1, 3*index+2, 3*index+3)
    
    # spanning triangle points
    @p_x = verts[0]
    @p_y = verts[1]
    @p_z = verts[2]
  end
  
  def intersect ray
    binding.pry
    hit_record = nil
    
    a_to_b = @p_x.s_copy.sub(@p_y)
    a_to_c = @p_x.s_copy.sub(@p_z)
    
    triangle = Matrix3f.new(nil, nil, nil)
		triangle.set_column_at(1, a_to_b);
		triangle.set_column_at(2, a_to_c);
    triangle.set_column_at(3, ray.direction);    
    b = @p_x.s_copy.sub(ray.origin)
    
    # solve system
    # beta_gamma_triangle = System.solve3x3System(triangle, b)
    # TODO please extand functionalitz in oder to work with a 
    # LUP or Cholesky solver
    # highly unstable under certain circumstances
    t_inv = triangle.invert
    raise "this matrix is singular" if t_inv.is_singular?
    beta_gamma_triangle = t_inv.mult(b)
    if beta_gamma_triangle.nil?
      return nil
    elsif inside_triangle?(beta_gamma_triangle)
      # compute hit_record data
    end
    hit_record
  end
  
  
  
  private 
  
  # use BC coordinates
  # was triangle intersected
  def inside_triangle? (beta, gamma)
    unit_range = [0.0, 1.0]
    no_triangle_hit = [beta,gamma].all? do |expression| 
      is_between(expression, unit_range, "<=")
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
    value.send(operation, range.last) && range.first.send(operation, value)
  end
  
  
end