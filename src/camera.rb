# Pinwhole camera model - later introduce additional models. C transformation
# matrix from world to camera space. Cinv is transformation matrix from world
# coordinates to camera space.

# Given the specification of a ray in image space, a camera constructs
# a corresponding ray in world space.
class Camera
  attr_accessor :eye,
                :look_at,
                :up,
                :fov,
                :aspect_ratio,
                :width,
                :height,
                :C,
                :Cinv,
                :angularFov,
                :t,
                :b,
                :r,
                :l,
                :camera_matrix

  # @param eye from position of camera
  # @param lookAt to position of camera
  # @param up height
  # @param fov field of view angle [degree]
  # @param aspect aspect ratio w/h
  # @param width image width
  # @param height image height
  def initialize(args = {})
    args.each do |key, value|
      send("#{key}=", value)
    end

    compute_camera_matrix
    compute_image_corners
  end

  # Given a ray in image space, make a ray in world space according to the
  # camera specifications. The method receives a sample that the camera can use
  # to generate the ray. Typically the first two sample dimensions are used to
  # sample a location in the current pixel. The samples are assumed to be in
  # the range [0,1].
  #
  # @param i pixel column index: Integer, start counting at 1
  # @param j pixel row index: Integer, start counting at 1
  # @param sample random sample that the camera can use to generate a ray float
  #   array.
  # @return the ray in world coordinates
  def make_world_space_ray(i, j, sample)
    u_ij = @l + (@r - @l) * ((i-1) + sample[0]) / @width
    v_ij = @b + (@t - @b) * ((j-1) + sample[1]) / @height
    w_ij = -1.0

    p_uvw = Vector4f.new(u_ij, v_ij, w_ij, 0.0).transform(@camera_matrix)

    ray_args = {
      origin: @eye.s_copy,
      direction: Vector3f.new(p_uvw.x, p_uvw.y, p_uvw.z),
      t: Random.rand(1.0)
    }
    Ray.new(ray_args)
  end

  private

  def compute_camera_matrix
    from = Vector3f.new(@eye.x, @eye.y, @eye.z)
    to = Vector3f.new(@look_at.x, @look_at.y, @look_at.z)
    up = Vector3f.new(@up.x, @up.y, @up.z)

    # z-axis
    w = Vector3f.new(from.x, from.y, from.z)
    w.sub(to)
    w.normalize
    zc = Vector4f.new(w.x, w.y, w.z, 0.0)

    # x-axis
    u = up.cross(w)
    u.normalize
    xc = Vector4f.new(u.x, u.y, u.z, 0.0)

    # y-axis
    v = w.cross(u)
    yc = Vector4f.new(v.x, v.y, v.z, 0.0)
    e = Vector4f.new(from.x, from.y, from.z, 1.0)

    @camera_matrix = Matrix4f.new(nil, nil, nil, nil)
    @camera_matrix.set_column_at(1, xc)
    @camera_matrix.set_column_at(2, yc)
    @camera_matrix.set_column_at(3, zc)
    @camera_matrix.set_column_at(4, e)
  end

  def compute_image_corners
    @angularFov = Math::PI * (fov / 180.0);
    @t = Math::tan(angularFov / 2.0.to_f);
    @b = -t;
    @r = aspect_ratio * t;
    @l = -r;
  end
end
