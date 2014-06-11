# used to call java code
require 'java'

# 'java_import' is used to import java classes
java_import 'java.util.concurrent.Callable'
java_import 'java.util.concurrent.FutureTask'
java_import 'java.util.concurrent.LinkedBlockingQueue'
java_import 'java.util.concurrent.ThreadPoolExecutor'
java_import 'java.util.concurrent.TimeUnit'


class RenderingTask
  attr_accessor :shared_image,
                :shared_data,
                :xmin, :xmax,
                :ymin, :max
  
  def initialize(block_range, image)
    # @xmin = block_range[:xmin]
    # @xmax = block_range[:xmax]
    # @ymin = block_range[:ymin]
    # @ymax = block_range[:ymax]
    @shared_image = image
  end
  
  include Callable
  def call
    puts "#Thread #{@shared_image} is running"
  end
  
  private
  
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
        @shared_image[m, n] = pixel 
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