class PointLightMaterial
  include Material

  attr_accessor :emission

  def initialize(emission)
    @emission = Spectrum.new(emission)
  end

  def evaluate_brdf(hit_record, w_out, w_in)
    Spectrum.new(0.0)
  end

  def evaluate_emission(hit_record, w_out)
    Spectrum.new(emission);
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
    psi_1 = sample[0] * 2.0 * Math::PI
    psi   = sample[1] * 2.0 - 1.0
    psi_2 = Math::sqrt(1.0 - psi**2.0)

    x = psi_2 * Math::cos(psi_1)
    y = psi_2 * Math::sin(psi_1)

    p = 1.0 / (4.0 * Math::Pi).to_f

    dir = Vector3f.new(x, y, psi)
    ShadingSample.new(
      Spectrum.new(0.0),
      Spectrum.new(emission),
      dir,
      false,
      p
    )
  end

  def casts_shadows?
    false
  end

  def evaluate_bump_map(hit_record)
    nil
  end

  def to_s
    "point light material with emission: #{emission}"
  end
end
