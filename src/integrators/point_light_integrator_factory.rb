class DebugIntegratorFactory
  require_relative '../integrator_factory.rb'
  require_relative 'point_light_integrator.rb'
  include IntegratorFactory
  
  def initialize
  end
  
  def make scene
    PointLightIntegrator.new(scene)
  end
  
end