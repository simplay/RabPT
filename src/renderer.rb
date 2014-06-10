class Renderer
  require File.join(File.dirname(__FILE__), 'scenes/debug_scene.rb')
  require_relative 'scenes/camera_test_scene.rb'
  require 'pry'
  include ImageRuby

  attr_accessor :image, :dimN, :dimM, :scene
  
  def initialize(args={})
    
    @dimN = args[:N]
    @dimM = args[:M]
    
    # @scene = DebugScene.new({:SPP => args[:SPP] || 1,
                        # :width => @dimM,
                        # :height => @dimN
                        # })
                        #  
    @scene = CameraTestScene.new(@dimM, @dimN, args[:SPP].to_i || 1)
    
    puts "dimensions (#{@dimN}, #{@dimM}),"
    
    @image = Image.new(@dimN, @dimM)
    val1 = 25
    val2 = 100
    val3 = 240

    
    colors = []
    color = Color.from_rgb(val1,val2,val3)
    (@dimN*@dimM).times do
      colors << color
    end

    puts "start rendering pixels"
    render_cluster([0, @dimM-1], [0, @dimN-1], colors)
    
    begin
      @image.save("output/raytraced.bmp", :bmp)
    rescue
      print "Could no generate the image"
    end
    
  end
  
  private 
  
  def init_rendering_process
    
  end
  
  def run
    # foreach pixel
    (1..@width).each do |j|
      (1..@height).each do |i|
        # for N sampels per pixel
        (1..samples.length) do |k|
          # make ray
          ray = task.scene.camera.make_world_space_ray(i, j, samples[k-1])
          
          # evaluate ray
          ray_spectrum = task.integrator.integrate(ray)
          
          # write to film
          task.scene.film.add_sample(i.to_f+samples[k][0].to_f, j.to_f+samples[k][1].to_f, ray_spectrum)
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
  
  def self.toInt256 f_value
    (f_value*256).to_i
  end
  
end