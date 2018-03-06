# Defines a triangle by referring back to a Mesh and its vertex and index
# arrays.
class MeshTriangle
  include Intersectable

  attr_accessor :p_x, :p_y, :p_z,
                :n_x, :n_y, :n_z,
                :mesh

  # compute triangle spanning vertices
  # TODO explain beta_gama
  def initialize(mesh, index)
    @mesh = mesh
    faces = mesh.indices[index]
    verts = mesh.vertices.values_at(faces.x, faces.y, faces.z)
    norms = mesh.normals.values_at(faces.x, faces.y, faces.z)

    # spanning triangle points
    @p_x = verts[0]
    @p_y = verts[1]
    @p_z = verts[2]

    @n_x = norms[0]
    @n_y = norms[1]
    @n_z = norms[2]
  end

  def intersect(ray)
    hit_record = nil

    a_to_b = p_x.s_copy.sub(p_y)
    a_to_c = p_x.s_copy.sub(p_z)

    triangle = Matrix3f.new(nil, nil, nil)
		triangle.set_column_at(1, a_to_b)
		triangle.set_column_at(2, a_to_c)
    triangle.set_column_at(3, ray.direction)

    b = p_x.s_copy.sub(ray.origin)

    # solve system
    # beta_gamma_triangle = System.solve3x3System(triangle, b)
    # TODO please extand functionalitz in oder to work with a
    # LUP or Cholesky solver
    # highly unstable under certain circumstances
    t_inv = triangle.s_copy.invert

    return nil if t_inv.nil?

    bgt = t_inv.vectormult(b)

    return nil if bgt.nil?

    if inside_triangle?(bgt.x, bgt.y)
      t = bgt.z

      ray_dir = ray.direction.s_copy
      intersection_position = ray_dir.scale(t).add(ray.origin)
      hit_normal = make_normal(bgt)
      w_in = ray.direction.s_copy.normalize.negate

      tangent = p_x.s_copy.sub(p_y).scale(0.5)
      tan_b = p_x.s_copy.sub(p_z).scale(0.5)
      tangent.add(tan_b).normalize

      hash = {
        t: t,
        position: intersection_position,
        normal: hit_normal,
        tangent: tangent,
        w: w_in,
        intersectable: self,
        material: mesh.material,
        u: 0.0,
        v: 0.0
      }

      hit_record = HitRecord.new(hash)
    end
    hit_record
  end

  private

  def make_normal(bgt)
    # note that: alpha + beta + gamma = 1
    a = n_x.s_copy.scale(1.0 - bgt.x - bgt.y)
    b = n_y.s_copy.scale(bgt.x)
    c = n_z.s_copy.scale(bgt.y)
    a.add(b).add(c).normalize
  end

  # if 0 < a*t + b < 1 then we are below line.
  # if we are below two intersecting lines, then we are inside a triangle.
  #
  # @param t1 [Float] parameter of affine line
  # @param t2 [Float] parameter of affine line
  # @return [Boolean] true if we are inside a triangle spanned by 3 lines
  def inside_triangle?(t1, t2)
    outside_line1 = t1 <= 0.0 || t1 >= 1.0
    outside_line2 = t2 <= 0.0 || t2 >= 1.0

    # conservative inside check
    return false if outside_line1 || outside_line2

    # parameterization within
    t = t1 + t2
    t > 0.0 && t < 1.0
  end
end
