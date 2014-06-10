class CameraTestScene
  # Test scene for pinhole camera specifications.
  
  require_relative '../scene.rb'
  require_relative '../films/box_filter_film.rb'
  require_relative '../integrators/debug_integrator_factory.rb'
  require_relative '../samplers/one_sampler_factory.rb'
  require_relative '../intersectables/plane.rb'
  require_relative '../intersectable_list.rb'
  require_relative '../light_list.rb'
  require_relative '../spectrum.rb'
  require_relative '../lightsources/point_light.rb'
  require_relative '../materials/diffuse.rb'
  
  include Scene
  
  def initialize(width, height, spp)
    @width = width
    @height = height
    @spp = spp
    @output_filename = "camera_test_scene_#{spp}samples"
    
    eye = Vector3f.new(0.0, 0.0, 3.0)
    look_at = Vector3f.new(0.0, 0.3, 3.0)
    up = Vector3f.new(0.0, 1.0, 0.0)
    fov = 60.0
    aspect = @width.to_f / @height.to_f
    
    camera_args = {:eye => eye,
            :look_at => look_at,
            :up => up,
            :fov => fov,
            :aspect_ratio => aspect,
            :width => @width,
            :height => @height}
            
    @camera = Camera.new camera_args
    @film = BoxFilterFilm.new(width, height)
    
    @integratorFactory = DebugIntegratorFactory.new
    @sampler_factory = OneSamplerFactory.new
    
    material = Diffuse.new(Spectrum.new(1.0));
    
    intersectable_list = IntersectableList.new
    intersectable_list.put(Plane.new(material, Vector3f.new(1.0, 0.0, 0.0), 1.0))
    intersectable_list.put(Plane.new(material, Vector3f.new(-1.0, 0.0, 0.0), 1.0))
    intersectable_list.put(Plane.new(material, Vector3f.new(0.0, 1.0, 0.0), 1.0))
    intersectable_list.put(Plane.new(material, Vector3f.new(1.0, -1.0, 0.0), 1.0))
    intersectable_list.put(Plane.new(material, Vector3f.new(1.0, 0.0, 1.0), 1.0))
    
    @root = intersectable_list
    
    @light_list = LightList.new
    
    @light_list.put(PointLight.new(Vector3f.new(0.5, 0.5, 2.0), Spectrum.new(1.0)))
    
    
    
    
  end
end