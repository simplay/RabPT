class DebugIntegratorFactory
  require_relative '../integrator_factory.rb'
  require_relative 'debug_integrator.rb'
  include IntegratorFactory
  
  def initialize
  end
  
  def make scene
    DebugIntegrator.new(scenes)
  end
  
end