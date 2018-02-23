# Test scene for pinhole camera specifications.
class MeshLoadingTestScene
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
    @integrator_factory = PointLightIntegratorFactory.new

    @sampler_factory = OneSamplerFactory.new

    blinn = Blinn.new(
      Spectrum.new(Vector3f.new(1.0, 0.0, 0.0)),
      Spectrum.new(0.6),
      50.0
    )

    # assuming you do have a teapot.obj file in your meshes folder
    reader = ObjReader.new('teapot.obj')
    mesh = Mesh.new(reader.mesh_data, blinn)
    intersectable_list = IntersectableList.new
    intersectable_list.put(Instance.new(mesh, Matrix4f.identity))

    @root = intersectable_list

    @light_list = LightList.new
    @light_list.put(
      PointLight.new(Vector3f.new(0.5, 0.5, 2.0), Spectrum.new(1.0))
    )
    @light_list.put(
      PointLight.new(Vector3f.new(-0.75, 0.75, 2.0), Spectrum.new(1.0))
    )
  end

  def base_name
    'mesh_loading_test_scene'
  end
end
