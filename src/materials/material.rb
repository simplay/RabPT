module Material
  # Materials implement functionality for shading surfaces using their BRDFs. Light sources 
  # are implemented using materials that return an emission term.
  
  require_relative '../../util/vector3f.rb'
  require_relative '../../util/matrix3f.rb'
  require_relative '../hit_record.rb'
  require_relative '../shading_sample.rb'
  require_relative '../spectrum.rb'
  
  # Evaluate BRDF for pair of incoming and outgoing directions. This method
  # is typically called by an integrator when the integrator obtained the incident 
  # direction by sampling a point on a light source
  # @param hitRecord Information about hit point
  # @param wOut Outgoing direction, normalized and pointing away from the surface
  # @param wIn Incoming direction, normalized and pointing away from the surface
  # @return BRDF spectrum
  def evaluate_brdf(hit_record, w_out, w_in)
    raise "not implemented yet"
  end
  
  # Evaluate emission for outgoing direction. This method is typically called 
  # by an integrator when the integrator obtained the outgoing direction of
  # the emission by sampling a point on a light source. 
  # @param hitRecord Information about hit point on light source
  # @param wOut Outgoing direction, normalized and pointing away from the surface
  # @return emission spectrum 
  def evaluate_emission(hit_record, w_out)
    raise "not implemented yet"
  end
  
  # Return whether material has perfect specular reflection. 
  def has_specular_reflection?
    raise "not implemented yet"
  end
  
  # Evaluate specular reflection. This method is typically called by a recursive
  # ray tracer to follow the path of specular reflection. 
  # @return a ShadingSample
  def evaluate_specular_reflection(hit_record)
    raise "not implemented yet"
  end
  
  # Return whether the material has perfect specular refraction.
  def has_specular_refraction?
    raise "not implemented yet"
  end
  
  # Evaluate specular refraction. This method is typically called by a recursive
  # ray tracer to follow the path of specular refraction. 
  # @return a ShadingSample
  def evaluate_specular_refraction(hit_record)
    raise "not implemented yet"
  end
  
  # Calculate a shading sample, given a uniform random sample as input. This 
  # method is typically called in a path tracer to sample and evaluate the
  # next path segment. The methods decides which component of the material to 
  # sample (diffuse, specular reflection or refraction, etc.), computes an 
  # incident direction, and returns the BRDF value, the direction, and the 
  # probability density stored in a ShadingSample.  
  # @param hit_record HitRecord
  # @param sample Float[]
  # @return a ShadingSample
  def shading_sample(hit_record, sample)
    raise "not implemented yet"
  end
  
  # Calculate an emission sample, given a hit record and a uniform random 
  # sample as input. This method is typically called in a bidirectional
  # path tracer to sample and evaluate the first light path segment. The 
  # methods computes an outgoing direction, and returns the emission value, 
  # the direction, and the probability density (all stored in a 
  # ShadingSample).
  # @param hit_record HitRecord
  # @param sample Float[]
  # @return a ShadingSample  
  def emission_sample(hit_record, sample)
    raise "not implemented yet"
  end
  
  # Indicate whether the material casts shadows or not.
  def casts_shadows?
    raise "not implemented yet"
  end
  
  def evaluate_bump_map(hit_record)
    raise "not implemented yet"
  end
  
  def to_s
    raise "not implemented yet"
  end
  
end