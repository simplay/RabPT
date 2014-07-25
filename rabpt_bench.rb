require 'optparse'

require_relative 'benchmarks/vector3f_benchmark'
require_relative 'benchmarks/vector4f_benchmark'

user_args = {}
opt_parser = OptionParser.new do |opt|
  opt.banner = "Usage: ruby rabpt_bench.rb -b vec3
  \nFor additional information please visit RabPT's github repository:\nhttps://github.com/simplay/RabPT"

  opt.separator  ""

  opt.on("-b", "--bench FILENAME", String, "benchmark task. List available task via --taks") do |file_name|
    user_args[:bench_task] = file_name
  end

  opt.on_tail("-h", "--help", "Show this message") do
    puts opt
    exit
  end

  opt.on_tail("-t", "--tasks", "List available benchmark tasks") do
    puts "The following benchmark tasks are available:"
    puts "vec3      Vector3f Benchmark"
    puts "vec4      Vector4f Benchmark"
    exit
  end

end
begin
  opt_parser.parse!
  required_args = [:bench_task]
  required_args.each do |arg|
    raise OptionParser::MissingArgument if user_args[arg].nil?
  end
rescue OptionParser::MissingArgument
  puts "Incorrect input argument(s) passed\n"
  puts opt_parser.help
  exit
end

if user_args[:bench_task].eql?("vec3")
  Vector3fBenchmark.new.run_benchmark
elsif(user_args[:bench_task].eql?("vec4"))
  Vector4fBenchmark.new.run_benchmark
else
  puts "Incorrect input argument(s) passed\n"
  puts opt_parser.help
  exit
end


