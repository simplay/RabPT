class Renderer
  require File.join(File.dirname(__FILE__), 'scenes/debug_scene.rb')
  require_relative 'scenes/camera_test_scene.rb'
  require_relative 'rendering_task.rb'
  require 'pry'
  include ImageRuby
  
  
  if (RUBY_PLATFORM == "java")
    require 'java'
    # 'java_import' is used to import java classes
    java_import 'java.util.concurrent.Callable'
    java_import 'java.util.concurrent.FutureTask'
    java_import 'java.util.concurrent.LinkedBlockingQueue'
    java_import 'java.util.concurrent.ThreadPoolExecutor'
    java_import 'java.util.concurrent.TimeUnit'
  end
  

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
    puts "\nimages created"
  end
  
  private 
  
  def init_rendering_process
    # are we using jruby
    if (RUBY_PLATFORM == "java")
      render_parallel
    else
      compute_contribution
      write_image
    end

  end
  
  # TODO: java multithreading magic goes here.
  def render_parallel
 
    puts "rendering in java mode"
    # compute_contribution
    # write_image
    # Create a thread pool
    executor = ThreadPoolExecutor.new(4, # core_pool_treads
                                      4, # max_pool_threads
                                      60, # keep_alive_time
                                      TimeUnit::SECONDS,
                                      LinkedBlockingQueue.new)
    num_tests = 20
    num_threads = 4
    block = {}
    tasks = []
    block[:xmin] = 1
    block[:xmax] = @scene.width
    delta_height = 5
    num_tasks = (@scene.height / delta_height).to_i
    reminder_rows = @scene.height - num_tasks*delta_height
    num_tasks.times do |k|
      block[:ymin] = k*delta_height
      block[:ymax] = (k+1)*delta_height
      tasks << FutureTask.new(RenderingTask.new(block, Random.rand(200) ))
    end
    
    # handle reminder rows
    if (reminder_rows > 0)
      block[:ymin] = @scene.height-reminder_rows
      block[:ymax] = @scene.height
      tasks << FutureTask.new(RenderingTask.new(block, Random.rand(200) ))
    end
    
    tasks.each do |task|
      executor.execute(task)
    end
    
    executor.shutdown()

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
    counter = 0
    print "Progress: "
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
        counter += 1
        print progress(counter)
      end     
    end
  end
  
  def interval
    stars = 20
    pixel_count = @scene.width * @scene.height
    pixels_per_star = (pixel_count / stars).to_i
    (pixels_per_star < 1)? 1 : pixels_per_star
  end
  
  def progress pixels
    (pixels % interval == 0) ? "* " : ""
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