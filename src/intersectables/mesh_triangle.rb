class MeshTriangle
  require_relative '../intersectable.rb'
  require_relative '../ray.rb'
  require_relative '../hit_record.rb'
  
  include Intersectable
  
  # Defines a triangle by referring back to a Mesh and its vertex and
  # index arrays.
  
  attr_accessor :p_x, :p_y, :p_z,
                :n_x, :n_y, :n_z,
                :mesh
  
  # compute triangle spanning vertices
  # TODO explain beta_gama
  def initialize(mesh, index)
    facs = mesh.indices[index+1]
    @mesh = mesh

    verts = mesh.vertices.values_at(facs.x, facs.y, facs.z)
    norms = mesh.normals.values_at(facs.x, facs.y, facs.z)
    
    puts facs.to_s + " " + verts.to_s + " " + index.to_s
    
    # spanning triangle points
    @p_x = verts[0]
    @p_y = verts[1]
    @p_z = verts[2]
    
    @n_x = norms[0]
    @n_y = norms[1]
    @n_z = norms[2]
  
  end
  
  def intersect ray

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
    
    return nil if t_inv.nil?
    
    
    bgt = t_inv.vectormult(b)
    
    
    if bgt.nil?
      return nil
    elsif inside_triangle?(bgt.x, bgt.y)
              # binding.pry
              
              t = bgt.z
              ray_dir = ray.direction.s_copy
              intersection_position = ray_dir.scale(t).add(ray.origin)
        			hit_normal = make_normal(bgt)
              w_in = ray.direction.s_copy.normalize.negate
              
              tangent = @p_x.s_copy.sub(@p_y).scale(0.5)
              tan_b = @p_x.s_copy.sub(@p_z).scale(0.5)
              tangent.add(tan_b).normalize
      
              hash = {:t => t,
                      :position => intersection_position,
                      :normal => hit_normal,
                      :tangent => tangent,
                      :w => w_in,
                      :intersectable => self,
                      :material => @mesh.material,
                      :u => 0.0,
                      :v => 0.0}

              hit_record = HitRecord.new hash            

    end
    hit_record
  end
  
  
  
  private 
  
  def make_normal bgt
    # note that: alpha + beta + gamma = 1
    a = @n_x.s_copy.scale(1.0 - bgt.x - bgt.y)
    b = @n_y.s_copy.scale(bgt.x)
    c = @n_z.s_copy.scale(bgt.y)
    a.add(b).add(c).normalize 
  end
  
  
  # use BC coordinates
  # was triangle intersected
  def inside_triangle? (beta, gamma)
    unit_range = [0.0, 1.0]
    no_triangle_hit = [beta,gamma].all? do |expression| 
      is_between?(expression, unit_range, "<=")
    end
    
    # inside or outhsie triangle but not ON triangle (i.e. hit)
    no_triangle_hit ? false : is_between?((gamma+beta), unit_range, "<")
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