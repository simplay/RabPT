class Sphere
  attr_accessor :origin, :radius
  attr_accessor :T, :Tinv
  
  # origin: positon of sphere center in world coordinates
  # radius: sphere radius
  def initialize(args={})
    @origin = args[:origin]
    args.each do |key, value|
      send("#{key}=", value)
    end
    
  end
  
end