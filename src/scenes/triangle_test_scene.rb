class TriangleTestScene
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

    @camera = Camera.new(camera_args)
    @film = BoxFilterFilm.new(width, height)
    @integrator_factory = DebugIntegratorFactory.new
    @sampler_factory = OneSamplerFactory.new

    mesh_data = {
      vertices: [
        Vector3f.new(0.0, 0.0, 0.0),
        Vector3f.new(1.0, 0.0, 0.0),
        Vector3f.new(0.0, 1.0, 0.0)
      ],
      normals: [
        Vector3f.new(0.0, 0.0, 1.0),
        Vector3f.new(0.0, 0.0, 1.0),
        Vector3f.new(0.0, 0.0, 1.0)
      ],
      faces: [
        Vector3f.new(0, 1, 2)
      ]
    }

    mesh = Mesh.new(mesh_data, nil)
    intersectable_list = IntersectableList.new
    intersectable_list.put(Instance.new(mesh, Matrix4f.identity))

    @root = intersectable_list
  end

  def base_name
    'triangle_test_scene'
  end
end
