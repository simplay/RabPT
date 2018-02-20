# A film stores a 2D grid of Spectrum representing an image. Rendered samples
# can be added one by one to a film. Samples are filtered using some filter
# (depending on the implementation of this interface) when added.
require_relative 'tone_mapper.rb'

module Film


  # Add a sample to the film at a specified floating point position. The
  # position coordinates are assumed to be in image space.
  #
  # @param x x-coordinate in image space
  # @param y y-coordinate in image space
  # @param spectrum sample to be added
  def add_sample(x, y, spectrum)
    raise "not implemented yet"
  end

  def post_process(method)
    case method
    when :clamp
      ToneMapper.new(self)
    else
      puts "Error: No post-processing #{method} available"
    end
  end
end
