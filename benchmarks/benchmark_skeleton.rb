require 'benchmark'

require_relative '../util/vector3f.rb'
require_relative '../util/vector4f.rb'

require_relative '../util/matrix3f.rb'
require_relative '../util/matrix4f.rb'

module BenchmarkSkeleton
  ITERATIONS =1_000_000

  def run_benchmark
    print " DONE\n"
    benchmarking
    puts "Running Benchmark with #{ITERATIONS} Iterations\n"
  end

  def benchmarking
    raise "not implemented yet"
  end

end