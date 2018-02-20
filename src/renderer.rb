require_relative '../util/obj_reader.rb'
require_relative 'scenes/camera_test_scene.rb'
require_relative 'scenes/blinn_test_scene.rb'
require_relative 'scenes/instancing_test_scene.rb'
require_relative 'scenes/mesh_loading_test_scene.rb'
require_relative 'scenes/refraction_test_scene.rb'

class Renderer
  include ImageRuby

  CORE_POOL_THREADS     = 8
  MAX_POOL_THREADS      = 16
  ROW_NUMBER_PER_THREAD = 10
  PROGRESS_STAR_COUNT   = 20
  OUTPUT_PATH           = 'output/'.freeze

  if RUBY_PLATFORM == 'java'
    require 'java'
    require_relative 'rendering_task.rb'

    java_import 'java.util.concurrent.Callable'
    java_import 'java.util.concurrent.FutureTask'
    java_import 'java.util.concurrent.LinkedBlockingQueue'
    java_import 'java.util.concurrent.ThreadPoolExecutor'
    java_import 'java.util.concurrent.TimeUnit'
    java_import 'java.lang.Runtime'
    CORE_POOL_THREADS = Runtime.getRuntime.availableProcessors
  end

  attr_accessor :image, :dimN, :dimM, :scene,
                :integrator, :sampler

  def initialize(args={})
    @dimN       = args[:N].to_i
    @dimM       = args[:M].to_i
    @scene      = scene_instance_from(args[:selected_scene] || 1, args[:SPP].to_i || 1)
    @integrator = @scene.integrator_factory.make(@scene)
    @sampler    = @scene.sampler_factory.make
    @image      = Image.new(@dimN, @dimM)

    puts "Start rendering \'#{@scene.base_name}\' at #{@dimN} by #{@dimM} pixels."
    tic         = Time.now
    init_rendering_process
    toc         = Time.now

    begin
      user_input = (args[:file_name].nil? || args[:file_name].empty?) ? '' : "_#{args[:file_name].to_s}"
      file_name = @scene.file_name + user_input
      @image.save("#{OUTPUT_PATH}#{file_name}.bmp", :bmp)
    rescue
      print 'Could no generate the image'
    end
    puts "\nIt took #{(toc-tic)*1000.0} ms to render this scene."
  end

  private

  def scene_instance_from(selection, spp)
    case selection
    when 1
      CameraTestScene.new(@dimM, @dimN, spp)
    when 2
      BlinnTestScene.new(@dimM, @dimN, spp)
    when 3
      InstancingTestScene.new(@dimM, @dimN, spp)
    when 4
      MeshLoadingTestScene.new(@dimM, @dimN, spp)
    when 5
      RefractionTestScene.new(@dimN, @dimN, spp)
    else
      CameraTestScene.new(@dimM, @dimN, spp)
    end
  end

  def init_rendering_process
    if RUBY_PLATFORM == 'java'
      render_parallel
    else
      compute_contribution
    end

    @scene.film.post_process(:clamp)
    write_image
  end

  def render_parallel
    puts "rendering in java mode using #{CORE_POOL_THREADS} threads"
    executor = ThreadPoolExecutor.new(
      CORE_POOL_THREADS, # core_pool_treads
      MAX_POOL_THREADS,  # max_pool_threads
      60,                # keep_alive_time
      TimeUnit::SECONDS,
      LinkedBlockingQueue.new
    )

    block = {}
    tasks = []
    block[:xmin] = 1
    block[:xmax] = @scene.width
    delta_height = ROW_NUMBER_PER_THREAD
    num_tasks = (@scene.height / delta_height).to_i
    reminder_rows = @scene.height - num_tasks * delta_height

    num_tasks.times do |k|
      block[:ymin] = k * delta_height + 1
      block[:ymax] = (k + 1) * delta_height
      tasks << FutureTask.new(RenderingTask.new(block, @scene, @integrator, @sampler))
    end

    # handle reminder rows
    if reminder_rows > 0
      block[:ymin] = @scene.height - reminder_rows + 1
      block[:ymax] = @scene.height + 1
      tasks << FutureTask.new(RenderingTask.new(block, @scene, @integrator, @sampler))
    end

    print 'Progress: '
    tasks.each do |task|
      executor.execute(task)
    end

    # Wait for all threads to complete
    # before writing the output image
    @count = java.util.concurrent.atomic.AtomicInteger.new
    tasks.each do |t|
      progress2
      t.get
    end

    executor.shutdown
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
        @image[idm, idn] =  Color.from_rgb(x, y, z)
        idm += 1
      end
      idn += 1
    end
  end

  # foreach pixel
  def compute_contribution
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
          @scene.film.add_sample(
            i.to_f + samples[k-1][0].to_f,
            j.to_f + samples[k-1][1].to_f,
            ray_spectrum
          )
        end
        counter += 1
        print progress(counter)
      end
    end
  end

  def interval2
    stars = PROGRESS_STAR_COUNT

    num_tasks = (@scene.height / ROW_NUMBER_PER_THREAD).to_i
    reminder_rows = @scene.height - num_tasks*ROW_NUMBER_PER_THREAD
    num_tasks += 1 if reminder_rows > 0
    pixels_per_star = (num_tasks / stars).to_i
    (pixels_per_star < 1) ? 1 : pixels_per_star
  end

  def interval
    stars = PROGRESS_STAR_COUNT
    pixel_count = @scene.width * @scene.height
    pixels_per_star = (pixel_count / stars).to_i
    (pixels_per_star < 1) ? 1 : pixels_per_star
  end

  def progress2
    (@count.incrementAndGet % interval2 == 0) ? "* " : ""
    print "* " if (@count.to_s.to_i % interval2 == 0)
  end

  def progress(pixels)
    (pixels % interval == 0) ? "* " : ""
  end

  # TODO write a toneMAPPER instead of using this mapping from float unit range
  # to int 0-255 range
  # f: [0.0,1.0] -> [0,255]
  def self.toInt256 f_value
    (f_value*255).to_i
  end
end
