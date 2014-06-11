## RabPT - A Ruby Ray- and bidirectional Path-Tracer
+ A collection of various physical phenomenon rendering approaches, following basic ray-tracing approaches, implemented as a ruby application.

### run this application:
1. bundle
2. ruby rabpt.rb img_width img_height samples


### Debugging within the code
Place a ```` binding.pry ```` statement in w/e code region

### Run a specific test
```` rspec tests/my_model_spec.rb ````

### Milestone1
Implement a debug-ray tracer which can render a simple scene consisting of a pinhole camera, simple csg_solid objects, point-lights - relying on an appriximative sampling strategy (one-samples). 


### JRUBY support 
For multithreading purposes there is jruby support provided (runtime check whether you are using ruby or jrby). Steps to let the application running:

1. Install jruby
2. rvm use jrby #VERSION
3. jruby -S gem install imageruby
4. jruby -S gem install imageruby-bmp
5. jruby -S gem install pry
6. jruby -S rabpt.rb  img_width img_height samples
