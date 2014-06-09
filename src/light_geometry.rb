module LightGeometry
  require_relative 'intersectable.rb'
  include Intersectable
  
  # An interface to implement light sources. Light sources derive from 
  # this interface, and they store a reference to a {@link Material}
  # with an emission term. As an examples, see {@link rt.lightsources.PointLight}.
  
  # Sample a point on a light geometry.
  def sample s
    raise "not implemented yet"
  end
end