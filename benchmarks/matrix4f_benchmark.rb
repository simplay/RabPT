require_relative 'benchmark_skeleton.rb'
class Matrix4fBenchmark
  include BenchmarkSkeleton

  def initialize
    @matrix4f_a = []
    @matrix4f_b = []
    @vec4f_array_b = []

    print "Initializing Benchmark Data Sets"
    ITERATIONS_LOW.times do
      @vec4f_array_b << Vector4f.new(rand, rand, rand, rand)
      @matrix4f_a << Matrix4f.new(Vector4f.new(rand, rand, rand, rand),
                                  Vector4f.new(rand, rand, rand, rand),
                                  Vector4f.new(rand, rand, rand, rand),
                                  Vector4f.new(rand, rand, rand, rand))
      @matrix4f_b << Matrix4f.new(Vector4f.new(rand, rand, rand, rand),
                                  Vector4f.new(rand, rand, rand, rand),
                                  Vector4f.new(rand, rand, rand, rand),
                                  Vector4f.new(rand, rand, rand, rand))
    end
  end

  def benchmarking
    Benchmark.bm(30) do |x|
      x.report("Vector4f#new"){ ITERATIONS_LOW.times do |idx|
        Matrix4f.new(Vector4f.new(rand, rand, rand, rand),
                     Vector4f.new(rand, rand, rand, rand),
                     Vector4f.new(rand, rand, rand, rand),
                     Vector4f.new(rand, rand, rand, rand))
      end}
      x.report("Vector4f#invert"){ ITERATIONS_LOW.times do |idx|
        @matrix4f_a[idx].invert
      end}
    end
  end
end