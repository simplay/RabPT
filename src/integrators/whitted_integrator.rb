require_relative '../integrator.rb'
require_relative '../ray.rb'
require_relative '../spectrum.rb'

class WhittedIntegrator
  include Integrator

  attr_accessor :root, :light_list,
                :reflected_part,
                :refracted_part,
                :total_refracted_reflection

	MAX_BOUNCES = 5;

  def initialize(scene)
    @root                       = scene.root
    @light_list                 = scene.light_list.container
    @reflected_part             = Spectrum.new(0.0)
    @refracted_part             = Spectrum.new(0.0)
    @total_refracted_reflection = Spectrum.new(0.0)
  end

  def integrate(ray)
    hit_record = root.intersect(ray)
    total_contribution = Spectrum.new(0.0)

    unless hit_record.nil?

      emission = hit_record.material.evaluateEmission(hit_record, hit_record.w)
      return emission unless emission.nil?

      return @total_refracted_reflection if has_reflrefr_contribution(hit_record, ray)


  			# // Iterate over all light sources
  			# Iterator<LightGeometry> lightSources = lightList.iterator();
  			# while (lightSources.hasNext()) {
  			# 	LightGeometry lightSource = lightSources.next();
  			# 	Spectrum currentContribution = getContributionOf(lightSource,
  			# 			intersectionsEyeScene, CameraRay.t);
  			# 	totalContribution.add(currentContribution);
  			# }
    end
    total_contribution
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
  #
  # @param lightSource current point light source.
  # @param hitRecord closest intersection primary ray with scene.
  # @param t parameter of ray equation p_uvw(t) = 0 + t(s_uvw-0).
  # @return returns current spectrum of light source at intersaction point.
  def contribution_of(light_source, hit_record, t)
  end

  # Check whether hitPosition receives light
  #
  # @param hitPosition viewer ray hit (closest)
  # @param L light direction vector
  # @param t parameter of ray equation p_uvw(t) = 0 + t(s_uvw-0)
  # @return is light source occluded by object at hitPostion?
  def occluded?(hit_position, light_dir, t, eps)
    ray_args = {
      origin: hit_position,
      direction: light_dir,
      t: t,
      should_perturbate: true
    }

    shadow_ray = Ray.new ray_args
    shadow_hit = @root.intersect(shadow_ray)

    return false if shadow_hit.nil?
    dist_shad_hit_view_hit2 = shadow_hit.position.dist_to_sqr(hit_position)

    shadow_hit.material.casts_shadows? && dist_shad_hit_view_hit2 < eps
  end
end
