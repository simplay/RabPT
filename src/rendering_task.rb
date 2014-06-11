# used to call java code
require 'java'
require 'pry'
# 'java_import' is used to import java classes
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
    @scene = scene
    @integrator = integtrator
    @sampler = sampler
  end
  
  # execute task
  def call
    compute_contribution
    print '* '
  end
  
  private
  
  # renders an n x m pixel region
  # which is spanned by
  # Render all pixel in the rectangle:
  # (x_min, y_max) * * * (x_max, y_may)
  #       *                     * 
  #       *                     *
  #       *                     *
  # (x_min, y_min) * * * (x_max, y_min)
  # spanned by x_interval, y_interval
  # @x_range = [x_min, x_max]
  # @y_range = [y_min, y_max]
  # using the passed color values 
  def render_cluster(x_interval, y_interval, colors)
    @x_range.each do |m| 
      @y_range.each do |n|
        pixel_color = @shared_colors[m][n]
        x = self.toInt256(pixel_color.r)
        y = self.toInt256(pixel_color.g)
        z = self.toInt256(pixel_color.b)
        @shared_image[m, n] = Color.from_rgb(x,y,z) 
      end
    end
    
  end
  
  # TODO write a toneMAPPER istead using this shit
  # mapping from float unit range
  # to int 0-255 range
  # f: [0.0,1.0] -> [0,255]
  def self.toInt256 f_value
    f_value = 1.0 if f_value > 1.0
    (f_value*255).to_i
  end
  
  
  
  
  
  
  def compute_contribution
    # foreach pixel
    # counter = 0
    # print "Progress: "
    @x_range.each do |j|
      @y_range.each do |i|
        samples = @integrator.make_pixel_samples(@sampler, @scene.spp);
        # for N sampels per pixel
        (1..samples.length).each do |k|
          
          # make ray
          ray = @scene.camera.make_world_space_ray(i, j, samples[k-1])
          
          # evaluate ray
          ray_spectrum = @integrator.integrate(ray)
          
          # write to film
          @scene.film.add_sample(i.to_f+samples[k-1][0].to_f, j.to_f+samples[k-1][1].to_f, ray_spectrum)
          
        end
        # counter += 1
        # print progress(counter)
      end     
    end
  end

  
  
  
  
  
  
  
  
  
  
  
  
end