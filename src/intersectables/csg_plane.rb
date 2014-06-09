class CsgPlane
  require File.join(File.dirname(__FILE__), 'csg_solid.rb')
  include CsgSolid
  
  # Construct a plane given its normal @param n and distance to the origin @param
  # d. Note that the distance is along the direction that the normal points.
  # The sign matters!
  # 
  # @param normal
  #   normal of the plane
  #
  #  @param d
  #   distance to origin measured along normal direction 
  attr_accessor :material,
                :normal,
                :distance
                
  def initialize(args = {})
    args.each do |key, value|
      send("#{key}=", value)
    end
  end
  
end