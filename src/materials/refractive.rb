class Refractive
  # A basic diffuse material.
  require_relative 'material.rb'
  require 'pry'
  
  include Material
  attr_accessor :refractive_idx 
  
  # @param refractive_idx:Float refractive index
  def initialize(refractive_idx)
    @refractive_idx = refractive_idx
  end
  
  def evaluate_brdf(hit_record, w_out, w_in)
    Spectrum.new(@k_d)
  end
  
  def evaluate_emission(hit_record, w_out)
    nil
  end
  
  def has_specular_reflection?
    true
  end
  
  def evaluate_specular_reflection(hit_record)
		reflection_direction = reflect(hit_record.normal, hit_record.w);
		brdf_contribution = Spectrum.new(@ks);  
    args = {:brdf => brdf_contribution,
            :emission => Spectrum.new(0.0),
            :w => reflection_direction,
            :is_specular => false,
            :p => 1.0}
		ShadingSample.new args
  end
  
  def has_specular_refraction?
    false
  end
  
  def evaluate_specular_refraction(hit_record)
    nil
  end
  
  def shading_sample(hit_record, sample)
    evaluate_specular_reflection(hit_record);
  end
  
  def emission_sample(hit_record, sample)
    ShadingSample.new({})
  end
  
  def casts_shadows?
    false
  end
  
  def evaluate_bump_map(hit_record)
    nil
  end
  
  def to_s
    "reflective material with k_d: #{@k_d.to_s}"
  end
  
  
end