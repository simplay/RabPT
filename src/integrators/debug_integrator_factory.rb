class DebugIntegratorFactory
  include IntegratorFactory

  def make(scene)
    DebugIntegrator.new(scene)
  end
end
