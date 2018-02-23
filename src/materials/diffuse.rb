# A basic diffuse material.
class Diffuse
  include Material

  attr_accessor :k_d

  # Note that the parameter value {@param kd} is the diffuse reflectance, which
  # should be in the range [0,1], a value of 1 meaning all light is reflected
  # (diffusely), and none is absorbed. The diffuse BRDF corresponding to
  # {@param kd} is actually {@param kd}/pi.
  #
  # @param kd the diffuse reflectance
  # Default diffuse material with reflectance (1,1,1).
  def initialize(k_d)
    @k_d = Spectrum.new(k_d)

    # normalization
    f = 1.0 / Math::PI
    @k_d.scale(f);
  end

  def evaluate_brdf(hit_record, w_out, w_in)
    Spectrum.new(k_d)
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
    # transformed random sampled numbers
    psi_1_t = Math::sqrt(sample[0])
    psi_2_t = sample[1] * 2.0 * Math::PI

    x = Math::cos(psi_2_t) * psi_1_t
    y = Math::sin(psi_2_t) * psi_1_t
    z = Math::sqrt(1.0 - sample[0]);

    dir = Vector3f.new(x, y, z)

    tangentspace = hit_record.tbs
    dir.transform(tangentspace);
		dir.normalize

		# map to directional vector
    p = dir.dot(hit_record.normal) / Math::PI;

    args = {
      brdf: evaluate_brdf(hit_record, hit_record.w, dir),
      emission: Spectrum.new(0.0),
      w: dir,
      is_specular: false,
      p: p
    }
		ShadingSample.new(args)
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
    "diffuse material with k_d: #{k_d}"
  end
end
