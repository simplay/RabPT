class WhittedIntegratorFactory
  include IntegratorFactory

  def make(scene)
    WhittedIntegrator.new(scene)
  end
end
