$LOAD_PATH.unshift(File.expand_path('src'))
$LOAD_PATH.unshift(File.expand_path('lib'))

require 'benchmark'
require 'util/vector4f'
require 'util/vector3f'
require 'util/matrix4f'
require 'util/matrix3f'

Dir['lib/ejml-v0.33-libs/*.jar'].each do |file|
  require(file.split("/")[1..-1].join("/"))
end

def ran
  rand(0..1.0)
end

n = 500_000

Benchmark.bm do |x|
  x.report('RabPT#invert4f') do
    m = Matrix4f.new(
      ran, ran, ran, ran,
      ran, ran, ran, ran,
      ran, ran, ran, ran,
      ran, ran, ran, ran
    )
    m.invert
  end
  x.report('ejml#invert4f') do
    a = [
      ran, ran, ran, ran,
      ran, ran, ran, ran,
      ran, ran, ran, ran,
      ran, ran, ran, ran
    ]
    org.ejml.simple.SimpleMatrix.new(4, 4, true, a.to_java(:float)).invert
  end
end


Benchmark.bm do |x|
  x.report('RabPT#mult4f') do
    m1 = Matrix4f.new(
      ran, ran, ran, ran,
      ran, ran, ran, ran,
      ran, ran, ran, ran,
      ran, ran, ran, ran
    )

    m2 = Matrix4f.new(
      ran, ran, ran, ran,
      ran, ran, ran, ran,
      ran, ran, ran, ran,
      ran, ran, ran, ran
    )
  end
  x.report('ejml#mult4f') do
    a = [
      ran, ran, ran, ran,
      ran, ran, ran, ran,
      ran, ran, ran, ran,
      ran, ran, ran, ran
    ]
    b = [
      ran, ran, ran, ran,
      ran, ran, ran, ran,
      ran, ran, ran, ran,
      ran, ran, ran, ran
    ]

    m1 = org.ejml.simple.SimpleMatrix.new(4, 4, true, a.to_java(:float))
    m2 = org.ejml.simple.SimpleMatrix.new(4, 4, true, b.to_java(:float))
    m1.mult(m2)
  end
end
