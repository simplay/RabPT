# Uses a box filter when accumulating samples on a film. A box filter means
# that samples contribute only to the pixel that they lie in. Sample values
# are simply averaged.
class BoxFilterFilm
  include Film

  attr_accessor :image,
                :width,
                :height,
                :unnormalized,
                :n_samples

  def initialize(width, height)
    @width        = width
    @height       = height
    @image        = []
    @unnormalized = []
    @n_samples    = []

    initialize_containers
  end

  # @param x [Float] projected horizontal hit position
  # @param y [Float] projected vertical hit position
  # @param spectrum [Spectrum] contribution added to hit position.
  def add_sample(x, y, spectrum)
    x_idx = x.to_i
    y_idx = y.to_i

    return unless coordinates_inside_box?(x_idx, y_idx)

    @unnormalized[x_idx][y_idx].add(spectrum)
    @n_samples[x_idx][y_idx] += 1.0
    @image[x_idx][y_idx].r = @unnormalized[x_idx][y_idx].r / @n_samples[x_idx][y_idx].to_f
    @image[x_idx][y_idx].g = @unnormalized[x_idx][y_idx].g / @n_samples[x_idx][y_idx].to_f
    @image[x_idx][y_idx].b = @unnormalized[x_idx][y_idx].b / @n_samples[x_idx][y_idx].to_f
  end

  # Checks whether a given index pair is inside the film's image.
  #
  # @param x_idx [Integer] width index
  # @param y_idx [Integer] height index
  def coordinates_inside_box?(x_idx, y_idx)
    (x_idx >= 0 && x_idx < width) && (y_idx >= 0 && y_idx < height)
  end

  private

  def initialize_containers
    width.times do
      image_row = []
      unnorm_row = []
      sample_row = []

      height.times do
        image_row << Spectrum.new(0.0)
        unnorm_row << Spectrum.new(0.0)
        sample_row << 0.0
      end

      @image << image_row
      @unnormalized << unnorm_row
      @n_samples << sample_row
    end
  end
end
