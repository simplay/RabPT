class IntervalBoundary
  include Comparable

  attr_accessor :t,
                :hit_record,
                :belongs_to,
                :type

  def initialize(args = {})
    args.each do |key, value|
      send("#{key}=", value)
    end
  end

  def <=>(other)
    t <=> other.t
  end
end
