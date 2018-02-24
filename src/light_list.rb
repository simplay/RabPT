# A list of light sources.
class LightList
  attr_accessor :container

  def initialize
    @container = []
  end

  def put light
    @container << light
  end

  def random_light_source
    idx = Random.rand(@container.count)
    @container[idx]
  end
end
