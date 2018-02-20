require_relative '../integrator_factory.rb'
require_relative 'whitted_integrator.rb'

class WhittedIntegratorFactory
  include IntegratorFactory

  def make scene
    WhittedIntegrator.new(scene)
  end
end
