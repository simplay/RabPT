class ToneMapper
  attr_accessor :film

  def initialize film
    @film = film
    process
  end

  private

  def process
    raw_image = @film.image
    raw_image.each do |pixel_row|
      pixel_row.map do |pixel_spectrum|
        pixel_spectrum.clamp(0.0, 1.0)
      end
    end
  end
end
