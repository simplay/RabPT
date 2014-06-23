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
    true
  end
  
  def evaluate_specular_refraction(hit_record)
    normal = hit_record.normal.s_copy
    w_in = hit_record.normal.s_copy
    
    n_1 = 1.0
    n_2 = @refractive_idx
    
    # is hit not inside refractive material
    unless inside_material?(normal, w_in)
      n_1 = @refractive_idx
      n_2 = 1.0
      normal.negate
    end
    
    refraction_ratio = n_1/n_2
    cos_theta_i = w_in.dot(normal)
		w_in.negate();
    
    sin2_thata_t = (refraction_ratio**2.0)*(1.0-(cos_theta_i**2.0))
    cos_theta_t = Math::sqrt(1.0 - sin2_thata_t)
    
    total_internal_refraction = (sin2_thata_t > 1)
    
    # schlick approximation for refraction coefficient R 
    r_schlick = 1.0
    unless (total_internal_refraction)
      r_0 = ((n_1 - n_2) / (n_1 + n_2))**2
      x = (n_1 <= n_2) ? (1.0 - cos_theta_i) : (1.0 - cos_theta_t)
  		r_schlick = r_0 + (1.0 - r_0)*(x**5.0)
    else
      return nil
    end
    
    # t from the paper
    t_vec = w_in.s_copy
    t_vec.scale(refraction_ratio)
    scale_factor = refraction_ratio*cos_theta_i - cos_theta_t
    tranformed_normal = normal.s_copy.scale(scale_factor)
    t_vec.add(tranformed_normal)
      
    brdf_contribution = Spectrum.new(1.0)
    brdf_contribution.mult(1.0 - r_schlick)  
    args = {:brdf => brdf_contribution,
            :emission => Spectrum.new(0.0),
            :w => t_vec,
            :is_specular => true,
            :p => 1.0-r_schlick}
		ShadingSample.new args
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
  
  private 
  
  # are we tracing a hit inside a specific material?
  # examines angles between surface normal 
  # and incident light direction
  # @param normal at surface hit
  # @param w_in incident light direction.
  def inside_material?(normal, w_in)
    normal.dot(w_in) > 0.0
  end
  
  
end