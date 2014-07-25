require_relative 'benchmark_skeleton.rb'
class Vector4fBenchmark
  include BenchmarkSkeleton

  def initialize
    @matrix4f_a = []
    @vec4f_array_a = []
    @vec4f_array_b = []
    @vec4f_array_c = []

    print "Initializing Benchmark Data Sets"
    ITERATIONS.times do
      @vec4f_array_b << Vector4f.new(rand, rand, rand, rand)
      @vec4f_array_a << Vector4f.new(rand, rand, rand, rand)
      @vec4f_array_c << Vector4f.new(rand, rand, rand, rand)
      @matrix4f_a << Matrix4f.new(Vector4f.new(rand, rand, rand, rand),
                                  Vector4f.new(rand, rand, rand, rand),
                                  Vector4f.new(rand, rand, rand, rand),
                                  Vector4f.new(rand, rand, rand, rand))
    end
  end

  def benchmarking
    Benchmark.bm(30) do |x|
      x.report("Vector4f#new"){ ITERATIONS.times do |idx|
        Vector4f.new(rand, rand, rand, rand)
      end}

      x.report("Vector4f#sub"){ ITERATIONS.times do |idx|
        @vec4f_array_b[idx].sub(@vec4f_array_a[idx])
      end}

      x.report("Vector4f#add"){ ITERATIONS.times do |idx|
        @vec4f_array_b[idx].add(@vec4f_array_a[idx])
      end}

      x.report("Vector4f#dot"){ ITERATIONS.times do |idx|
        @vec4f_array_b[idx].dot(@vec4f_array_a[idx])
      end}

      x.report("Vector4f#scale"){ ITERATIONS.times do |idx|
        @vec4f_array_b[idx].scale(rand)
      end}

      x.report("Vector4f#same_values_as?"){ ITERATIONS.times do |idx|
        @vec4f_array_b[idx].same_values_as?(@vec4f_array_a[idx])
      end}

      x.report("Vector4f#approx_same_values_as?"){ ITERATIONS.times do |idx|
        @vec4f_array_b[idx].approx_same_values_as?(@vec4f_array_a[idx])
      end}

      x.report("Vector4f#dotted"){ ITERATIONS.times do |idx|
        @vec4f_array_b[idx].dotted
      end}

      x.report("Vector4f#length"){ ITERATIONS.times do |idx|
        @vec4f_array_b[idx].length
      end}

      x.report("Vector4f#normalize"){ ITERATIONS.times do |idx|
        @vec4f_array_b[idx].normalize
      end}

      x.report("Vector4f#norm_2"){ ITERATIONS.times do |idx|
        @vec4f_array_c[idx].norm_2(@vec4f_array_c[idx])
      end}

      x.report("Vector4f#transform"){ ITERATIONS.times do |idx|
        @vec4f_array_b[idx].transform(@matrix4f_a[idx])
      end}
    end
   end

end