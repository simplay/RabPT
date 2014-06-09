class Spectrum
  require_relative '../util/vector3f.rb'  

  attr_accessor :r, :g, :b
  
  def initialize(args={})
    # graysclae case
    if args.is_a? Float
      @r = args; @g = args; @b = args
    elsif args.is_a? Array
      @r = args[0]; @g = args[1]; @b = args[2]
    elsif args.is_a? Vector3f  
      @r = args.x; @g = args.y; @b = args.z
    elsif args.is_a? Hash
      @r = args[:r]; @g = args[:g]; @b = args[:b]
    elsif args_is_a? Spectrum
      @r = args.r; @g = args.g; @b = args.b
    else
      @r = 0.0; @g = 0.0; @b = 0.0
    end
  end
  
  def copy_s
    Spectrum.new(to_a)
  end
  
  def to_a
    [@r, @g, @b]
  end
  
  def mult other
    @r *= other.r
    @g *= other.g
    @b *= other.b
  end
  
  def divide other
    @r /= (other.r).to_f
    @g /= (other.g).to_f
    @b /= (other.b).to_f
  end
  
  def scale by
    @r *= by
    @g *= by
    @b *= by 
  end
  
  def add other
    @r += other.r
    @g += other.g
    @b += other.b
  end
  
  def sub other
    @r -= other.r
    @g -= other.g
    @b -= other.b
  end
  
  def shift by
    @r += by
    @g += by
    @b += by 
  end
  
  # get summes squared components
  def dotted
    sum = 0.0
    to_a.each do |component|
      sum += component ** 2
    end
    sum
  end
  
  def clamp(min, max)
    @r = [max, @r].min
    @r = [min, @r].max
    
    @g = [max, @g].min
    @g = [min, @g].max
    
    @b = [max, @b].min
    @b = [min, @b].max
  end
  
  # E'Y = 0,299 E'R + 0,587  E'G + 0,114  E'B
  def luminance
    0.299*@r + 0.587*@g + 0.114*@b
  end
  
  
end