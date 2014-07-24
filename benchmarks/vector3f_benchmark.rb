require_relative 'benchmark_skeleton.rb'
class Vector3fBenchmark
  include BenchmarkSkeleton

  def initialize
    @matrix3f_a = []
    @vec3f_array_a = []
    @vec3f_array_b = []
    @vec3f_array_c = []

    print "Initializing Benchmark Data Sets"
    ITERATIONS.times do
      @vec3f_array_b << Vector3f.new(rand, rand, rand)
      @vec3f_array_a << Vector3f.new(rand, rand, rand)
      @vec3f_array_c << Vector3f.new(rand, rand, rand)
      @matrix3f_a << Matrix3f.new(Vector3f.new(rand, rand, rand), Vector3f.new(rand, rand, rand), Vector3f.new(rand, rand, rand))
    end
  end

  def benchmarking
    Benchmark.bm(30) do |x|
      x.report("Vector3f#new"){ ITERATIONS.times do |idx|
        Vector3f.new(rand, rand, rand)
      end}

      x.report("Vector3f#sub"){ ITERATIONS.times do |idx|
        @vec3f_array_b[idx].sub(@vec3f_array_a[idx])
      end}

      x.report("Vector3f#add"){ ITERATIONS.times do |idx|
        @vec3f_array_b[idx].add(@vec3f_array_a[idx])
      end}

      x.report("Vector3f#dot"){ ITERATIONS.times do |idx|
        @vec3f_array_b[idx].dot(@vec3f_array_a[idx])
      end}

      x.report("Vector3f#cross"){ ITERATIONS.times do |idx|
        @vec3f_array_b[idx].cross(@vec3f_array_a[idx])
      end}

      x.report("Vector3f#scale"){ ITERATIONS.times do |idx|
        @vec3f_array_b[idx].scale(rand)
      end}

      x.report("Vector3f#same_values_as?"){ ITERATIONS.times do |idx|
        @vec3f_array_b[idx].same_values_as?(@vec3f_array_a[idx])
      end}

      x.report("Vector3f#approx_same_values_as?"){ ITERATIONS.times do |idx|
        @vec3f_array_b[idx].approx_same_values_as?(@vec3f_array_a[idx])
      end}

      x.report("Vector3f#dotted"){ ITERATIONS.times do |idx|
        @vec3f_array_b[idx].dotted
      end}

      x.report("Vector3f#length"){ ITERATIONS.times do |idx|
        @vec3f_array_b[idx].length
      end}

      x.report("Vector3f#normalize"){ ITERATIONS.times do |idx|
        @vec3f_array_b[idx].normalize
      end}

      x.report("Vector3f#negate"){ ITERATIONS.times do |idx|
        @vec3f_array_b[idx].negate
      end}

      x.report("Vector3f#norm_2"){ ITERATIONS.times do |idx|
        @vec3f_array_c[idx].norm_2(@vec3f_array_c[idx])
      end}

      x.report("Vector3f#transform"){ ITERATIONS.times do |idx|
        @vec3f_array_b[idx].transform(@matrix3f_a[idx])
      end}
    end
   end

end