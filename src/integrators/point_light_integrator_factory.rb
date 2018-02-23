class PointLightIntegratorFactory
  include IntegratorFactory

  def make(scene)
    PointLightIntegrator.new(scene)
  end
end
