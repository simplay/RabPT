class WhittedIntegratorFactory
  require_relative '../integrator_factory.rb'
  require_relative 'whitted_integrator.rb'
  include IntegratorFactory
  
  def initialize
  end
  
  def make scene
    WhittedIntegrator.new(scene)
  end
  
end