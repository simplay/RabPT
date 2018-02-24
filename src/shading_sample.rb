# Stores information about a shading sample.
# brdf: Spectrum
#   The BRDF value
#
# emission: Spectrum
#   The emission value.
#
# w: Vector3f
#   The sampled direction.
#
# is_specular: Boolean
#   Tells the integrator whether this is a specular sample. In this case,
#   a cosine factor in the specular BRDF should be omitted in the returned
#   BRDF value, and the integrator should act accordingly.
#
# p: Float
#   The (directional) probability density of the sample
class ShadingSample

  attr_accessor :brdf,
                :emission,
                :w,
                :is_specular,
                :p

  def initialize(args = {})
    return if args.empty?

    @brdf        = args[:brdf].s_copy
    @emission    = args[:emission].s_copy
    @w           = args[:w].s_copy
    @is_specular = args[:is_specular]
    @p           = args[:p]
  end
end
