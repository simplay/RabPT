class IntervalBoundary
  attr_accessor :t,
                :hit_record,
                :belongs_to,
                :type

  def initialize(args = {})
    args.each do |key, value|
      send("#{key}=",value)
    end
  end

  def compare_to(other)
    if @t < other.t
      return -1
    elsif @t == other.t
      return 0
    else
      return 1
    end
  end
end
