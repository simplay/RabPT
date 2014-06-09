class Diffuse
  # A basic diffuse material.
  require_relative 'material.rb'
  require 'pry'
  
  include Material
  attr_accessor :k_d 
  
  # Note that the parameter value {@param kd} is the diffuse reflectance,
  # which should be in the range [0,1], a value of 1 meaning all light
  # is reflected (diffusely), and none is absorbed. The diffuse BRDF
  # corresponding to {@param kd} is actually {@param kd}/pi.
  # 
  # @param kd the diffuse reflectance 
  # Default diffuse material with reflectance (1,1,1).
  def initialize(k_d)
    @k_d = 1.0 if k_d.nil?
    @k_d = Spectrum.new(k_d)
    # normalization
    f = 1.0 / Math::PI
    @k_d.scale(f);
  end
end