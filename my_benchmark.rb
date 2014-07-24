require 'benchmark'
require_relative 'util/vector3f.rb'

ITERATIONS =1_000_000
vec3f_array_a = []
vec3f_array_b = []
ITERATIONS.times do
  vec3f_array_b << Vector3f.new(rand, rand, rand)
  vec3f_array_a << Vector3f.new(rand, rand, rand)
end

Benchmark.bm do |x|
  x.report("vec3fsub"){ ITERATIONS.times do |idx|
    vec3f_array_b[idx].sub(vec3f_array_a[idx])
  end}

  x.report("vec3fadd"){ ITERATIONS.times do |idx|
    vec3f_array_b[idx].add(vec3f_array_a[idx])
  end}
end