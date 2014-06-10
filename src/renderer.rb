class Renderer
  require File.join(File.dirname(__FILE__), 'scenes/debug_scene.rb')
  require_relative 'scenes/camera_test_scene.rb'
  require 'pry'
  include ImageRuby

  attr_accessor :image, :dimN, :dimM, :scene,
                :integrator, :sampler
  
  def initialize(args={})
    @dimN = args[:N]
    @dimM = args[:M]

    @scene = CameraTestScene.new(@dimM, @dimN, args[:SPP].to_i || 1)
    @integrator = @scene.integrator_factory.make(@scene)
    @sampler = @scene.sampler_factory.make
    
    puts "dimensions (#{@dimN}, #{@dimM}),"
    @image = Image.new(@dimN, @dimM)

    puts "start rendering pixels"
    init_rendering_process
    
    begin
      @image.save("output/raytraced_t2.bmp", :bmp)
    rescue
      print "Could no generate the image"
    end
  end
  
  private 
  
  def init_rendering_process
    compute_contribution
    write_image
  end
  
  def write_image
    film_img = @scene.film.image
    idn = 0
    idm = 0
    # write pixelwise into image
    film_img.each do |row|
      idm = 0
      row.each do |pixel|
        x = Renderer.toInt256(pixel.r)
        y = Renderer.toInt256(pixel.g)
        z = Renderer.toInt256(pixel.b)
        @image[idm, idn] =  Color.from_rgb(x,y,z)
        idm += 1
      end
      idn += 1
    end
  end
  
  def compute_contribution
    # foreach pixel
    (1..@scene.width).each do |j|
      (1..@scene.height).each do |i|
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
      end
    end
  end
  
  
  
  # renders an n x m pixel region
  # which is spanned bz 
  # Render all pixel in the rectangle:
  # (x_min, y_max) * * * (x_max, y_may)
  #       *                     * 
  #       *                     *
  #       *                     *
  # (x_min, y_min) * * * (x_max, y_min)
  # spanned by x_interval, y_interval
  # x_interval = [x_min, x_max]
  # y_interval = [y_min, y_max]
  # using the passed color values 
  def render_cluster(x_interval, y_interval, colors)
    idx = 0
    x_intervalE = (x_interval[0]..x_interval[1])
    y_intervalE = (y_interval[0]..y_interval[1])
    
    x_intervalE.each do |n| 
      y_intervalE.each do |m|  
        pixel = Image.new(1, 1, colors[idx])
        @image[m..m, n..n] = pixel 
        idx = idx + 1
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
  
end