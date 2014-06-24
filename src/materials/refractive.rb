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
    local_space = LocalSpace.new(hit_record)
    
    # schlick approximation for refraction coefficient R     
    return nil if local_space.has_specular_refraction?
    reflected_part = local_space.compute_schlick_r
  
		return nil if (reflected_part < 1e-5)
    
    r_dir = local_space.w_in.s_copy
    scaled_normal = local_space.normal.s_copy.scale(2.0*local_space.cos_theta_i)
    r_dir.add(scaled_normal)
    
    brdf_contribution = Spectrum.new(1.0)
		brdf_contribution.mult(reflected_part) 

    brdf_contribution = Spectrum.new(1.0)
    brdf_contribution.mult(1.0 - r_schlick)  
    args = {:brdf => brdf_contribution,
            :emission => Spectrum.new(0.0),
            :w => r_dir,
            :is_specular => true,
            :p => reflected_part}
		ShadingSample.new args
  end
  
  def has_specular_refraction?
    true
  end
  
  def evaluate_specular_refraction(hit_record)
    local_space = LocalSpace.new(hit_record)
    
    # schlick approximation for refraction coefficient R     
    return nil if local_space.has_specular_refraction?
    refractive_part = 1.0 - local_space.compute_schlick_r
    
    # t from the paper
    scale_factor = local_space.refraction_ratio*local_space.cos_theta_i - local_space.cos_theta_t
    scaled_normal = local_space.normal.s_copy.scale(scale_factor)
    
    t_dir = local_space.w_in.s_copy.scale(local_space.refraction_ratio)
    t_dir.add(scaled_normal)
      
    brdf_contribution = Spectrum.new(1.0)
    brdf_contribution.mult(refractive_part)  
    args = {:brdf => brdf_contribution,
            :emission => Spectrum.new(0.0),
            :w => t_dir,
            :is_specular => true,
            :p => refractive_part}
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
    "refractive material using a refractive index equal to: #{@refractive_idx}"
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
  

  

  
  class LocalSpace
    attr_reader :normal,
                :w_in,
                :cos_theta_i,
                :cos_theta_t,
                :sin2_thata_t,
                :total_internal_refraction,
                :n_1, :n_2
                
    def initialize(hit_record)
      
      @normal = hit_record.normal.s_copy
      @w_in = hit_record.normal.s_copy
      @refraction_ratio = refractive_ratio(@normal, @w_in)
    
      @cos_theta_i = @w_in.dot(@normal)
  		@w_in.negate
    
      @sin2_thata_t = (@refraction_ratio**2.0)*(1.0-(@cos_theta_i**2.0))
      @cos_theta_t = Math::sqrt(1.0 - @sin2_thata_t)
    
      @total_internal_refraction = (@sin2_thata_t > 1)
       
    end
    
    def has_total_internal_refraction?
      @total_internal_refraction
    end
    
    # compute an approximation of the fresnel coefficient
    # used as the weight for refraction
    def compute_schlick_r
      r_0 = ((@n_1 - @n_2) / (@n_1 + @n_2))**2.0
      x = (@n_1 <= @n_2) ? (1.0 - @cos_theta_i) : (1.0 - @cos_theta_t)
  		r_0 + (1.0 - r_0)*(x**5.0)
    end
    
    def refractive_ratio(normal, w_in)
      @n_1 = 1.0
      @n_2 = @refractive_idx
    
      # is hit not inside refractive material
      unless inside_material?(normal, w_in)
        @n_1 = @refractive_idx
        @n_2 = 1.0
        normal.negate
      end
      @n_1/@n_2
    end
    
  end
  
end