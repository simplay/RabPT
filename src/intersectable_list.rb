class IntersectableList
  EPSILON = 0.00001
  require_relative 'intersectable.rb'
  include Intersectable
  
  attr_accessor :container
  
  def initialize
    @container = []
  end
  
  def put intersectable
    @container << intersectable
  end
  
  def length
    @container.length
  end
  
  def intersect ray
    t = Float::MAX
    hit_record = nil
    @container.each do |intersectable|
      current_hit_record = intersectable.intersect(ray)
      unless current_hit_record.nil?
         if(current_hit_record.t < t && current_hit_record.t > EPSILON)
           t = current_hit_record.t
           hit_record = current_hit_record
         end
      end
    end
    hit_record
  end
  
  
end