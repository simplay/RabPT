require_relative '../integrator_factory.rb'
require_relative 'point_light_integrator.rb'

class PointLightIntegratorFactory
  include IntegratorFactory

  def make scene
    PointLightIntegrator.new(scene)
  end
end
