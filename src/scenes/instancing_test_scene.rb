# Test scene for pinhole camera specifications.
class InstancingTestScene
  include Scene

  def initialize(width, height, spp)
    @width  = width
    @height = height
    @spp    = spp

    eye     = Vector3f.new(0.0, 0.0, 3.0)
    look_at = Vector3f.new(0.0, 0.0, 0.0)
    up      = Vector3f.new(0.0, 1.0, 0.0)
    fov     = 60.0
    aspect  = @width.to_f / @height.to_f

    camera_args = {
      eye: eye,
      look_at: look_at,
      up: up,
      fov: fov,
      aspect_ratio: aspect,
      width: @width,
      height: @height
    }

    @camera = Camera.new camera_args
    @film = BoxFilterFilm.new(width, height)
    @integrator_factory = DebugIntegratorFactory.new
    @sampler_factory = OneSamplerFactory.new

    blinn = Blinn.new(
      Spectrum.new(Vector3f.new(1.0, 0.0, 0.0)),
      Spectrum.new(0.6),
      50.0
    )

    intersectable_list = IntersectableList.new
    sphere = Sphere.new(blinn, Vector3f.new(0.0, 0.0, 0.0), 1.0)

    translation_right = Matrix4f.identity
                                .translate(Vector3f.new(0.0, 2.0, 0.0))
    translation_left = Matrix4f.identity
                               .translate(Vector3f.new(0.0, -2.0, 0.0))

    center_instance = Instance.new(sphere, Matrix4f.identity)
    right_instance = Instance.new(sphere, translation_right)
    left_instance = Instance.new(sphere, translation_left)

    intersectable_list.put(center_instance)
    intersectable_list.put(right_instance)
    intersectable_list.put(left_instance)
    @root = intersectable_list
  end

  def base_name
    'instancing_test_scene'
  end
end
