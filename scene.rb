class Scene
  attr_accessor :SPP
  
  def initialize(options = {})
    options.each do |key, val|
      send("#{key}=",val)
    end
    
  end
end