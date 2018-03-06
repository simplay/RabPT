java_import 'java.util.concurrent.Callable'
java_import 'java.util.concurrent.FutureTask'
java_import 'java.util.concurrent.LinkedBlockingQueue'
java_import 'java.util.concurrent.ThreadPoolExecutor'
java_import 'java.util.concurrent.TimeUnit'

class RenderingTask
  attr_accessor :x_range, :y_range,
                :scene,
                :integrator,
                :sampler

  include Callable

  def initialize(block, scene, integtrator, sampler)
    unless block.nil?
      @x_range = (block[:xmin]..block[:xmax])
      @y_range = (block[:ymin]..block[:ymax])
    end

    @scene      = scene
    @integrator = integtrator
    @sampler    = sampler
  end

  # execute task
  def call
    compute_contribution
  end

  private

  def compute_contribution
    x_range.each do |j|
      y_range.each do |i|
        samples = integrator.make_pixel_samples(sampler, scene.spp);
        # for N sampels per pixel
        (1..samples.length).each do |k|

          # make ray
          ray = scene.camera.make_world_space_ray(i, j, samples[k-1])

          # evaluate ray
          ray_spectrum = integrator.integrate(ray)

          # write to film
          scene.film.add_sample(
            i.to_f + samples[k-1][0].to_f,
            j.to_f + samples[k-1][1].to_f,
            ray_spectrum
          )
        end
      end
    end
  end
end
