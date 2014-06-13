class Blinn
  # A basic diffuse material.
  require_relative 'material.rb'
  require 'pry'
  
  include Material
  attr_accessor :diffuse_contribution,
                :specular_contribution,
                :shinyness_power
  
  
  def initialize(diffuse, specular, shinyness)
    @diffuse_contribution = diffuse
    @specular_contribution = specular
    @shinyness_power = shinyness
  end
  
  def evaluate_brdf(hit_record, w_out, w_in)
    contribution = Spectrum.new(0.0)
    
    diffuse = Spectrum.new(@diffuse_contribution)
    specular = Spectrum.new(@specular_contribution)
    ambient = Spectrum.new(@diffuse_contribution);
    
    halfway_vector = w_in.s_copy.add(w_out).normalize
    
    diffuse.scale(w_in.dot(hit_record.normal))
    specular.scale(halfway_vector.dot(hit_record.normal)**@shinyness_power)
    
    contribution.add(diffuse)
    contribution.add(specular)
    contribution.add(ambient)
    contribution
  end
  
  def evaluate_emission(hit_record, w_out)
    nil
  end
  
  def has_specular_reflection?
    false
  end
  
  def evaluate_specular_reflection(hit_record)
    nil
  end
  
  def has_specular_refraction?
    false
  end
  
  def evaluate_specular_refraction(hit_record)
    nil
  end
  
  def shading_sample(hit_record, sample)
    nil
  end
  
  def emission_sample(hit_record, sample)
    ShadingSample.new({})
  end
  
  def casts_shadows?
    true
  end
  
  def evaluate_bump_map(hit_record)
    nil
  end
  
  def to_s
    "blinn material with k_d: #{@k_d.to_s}"
  end
  
end