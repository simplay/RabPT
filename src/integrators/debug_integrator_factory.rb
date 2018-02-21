require_relative '../integrator_factory.rb'
require_relative 'debug_integrator.rb'

class DebugIntegratorFactory
  include IntegratorFactory

  def make(scene)
    DebugIntegrator.new(scene)
  end
end
