class PointLightIntegrator
  require_relative '../integrator.rb'
  require_relative '../ray.rb'
  require_relative '../spectrum.rb'
  
  include Integrator
  
  attr_accessor :root, :light_list
  
  def initialize scene
    @root = scene.root
    @light_list = scene.light_list.container
  end
  
  # Basic Point Light integrator 
  # iterates over the light sources and accumulates
  # their BRDF contributions. 
  # Performs shading.
  # No reflection, refraction effects modeled
  # No area light sources
  # @param CameraRay primary camera ray
  # @return total contribution of this primary ray 
  def integrate ray
    hit_record = @root.intersect(ray)
    contribution = Spectrum.new(0.0)
    
    unless hit_record.nil?
      @light_list.each do |light_source|
        current_contribution = contribution_of(light_source, hit_record, ray.t)
				contribution.add(current_contribution)
      end
    end
    contribution
  end
  
  # Make sample budget for a pixel. Since this integrator only samples the 2D 
  # pixel area itself, the samples are 2D.
  # 
  # @param sampler the sampler to be usef for generating the samples
  # @param n the desired number of samples
  def make_pixel_samples(sampler, n)
    sampler.make_samples(n, 2);
  end
  
  private 
  
  # Compute BRDF contribution for a given source at closest intersection point.
  # @param lightSource current point light source.
  # @param hitRecord closest intersection primary ray with scene.
  # @param t parameter of ray equation p_uvw(t) = 0 + t(s_uvw-0).
  # @return returns current spectrum of light source at intersaction point.
  def contribution_of(light_source, hit_record, t)
		light_hit = light_source.sample;
    light_dir = light_hit.position.s_copy
    light_dir.sub(hit_record.position)
    
    d2 = light_dir.dotted
    light_dir.normalize
    
    return Spectrum.new(0.0) if occluded?(hit_record.position, light_dir, t, d2)
    
    brdf_contribution = hit_record.material.evaluate_brdf(hit_record, hit_record.w, light_dir)
    
    # shading: brdf * emission * dot(normal,light_dir) * geom_term
    contribution = Spectrum.new(brdf_contribution)
    
    l = light_dir.s_copy
    l.negate
    light_emission = light_hit.material.evaluate_emission(light_hit, l)
    
    contribution.mult(light_emission)
    
    cos_theta = [hit_record.normal.dot(light_dir), 0.0].max
    contribution.scale(cos_theta)
    contribution.scale(1.0/d2.to_f)
    contribution
  end
  
  # Check whether hitPosition receives light
  # @param hitPosition viewer ray hit (closest)
  # @param L light direction vector
  # @param t parameter of ray equation p_uvw(t) = 0 + t(s_uvw-0)
  # @return is light source occluded by object at hitPostion? 
  def occluded?(hit_position, light_dir, t, eps)
     is_shaddowed = false
     
     ray_args = {
       :origin => hit_position,
       :direction => light_dir,
       :t => t,
       :should_pertubate => true
     }
  
     shadow_ray = Ray.new ray_args
     shadow_hit = @root.intersect(shadow_ray)
     
     if(shadow_hit != nil)
       dist_shad_hit_view_hit2 = shadow_hit.position.dist_to_sqr(hit_position)
       if(shadow_hit.material.casts_shadows? && dist_shad_hit_view_hit2 < eps)
         is_shaddowed = true
       end
     end
     is_shaddowed
  end
  
end