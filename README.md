## RabPT - A Ruby Ray- and bidirectional Path-Tracer
+ A collection of various physical phenomenon rendering approaches, following basic ray-tracing approaches, implemented as a ruby application.

### run this application:
1. bundle
2. ruby rabpt.rb **img_width** **img_height** **spp** **name_ext** **sel_scene**

where
* img_width: number of pixels in height of the rendered image
* img_height: number of pixels in height of the rendered image
* spp: samples per pixel used for rendering during tracing step
* name_ext: Is the filename extension. Each rendered image has a basic filename plus this user specified extension.
* sel_scene: The selected test scene to render ranging from 1 to N (integer values). The value will change - See list of implemented test-scenes below 

Example: ````ruby rabpt.rb 300 400 7 abc 3````

Will render a **300** by **400** pixel image using **7** samples per pixel of the  **3**-th test-scene. The output file wil be stored in ````../output```` and will be called **instancing_test_scene_1spp_300w_300h_abcd.bmp**

Note, that only the first arguments are required to successfully render an image. If there are less provided then an exception will be raised 'too few arguments'. 

### Available scene list:
1. CameraTestScene: showing that the camera setup works
2. BlinnTestScene: showing that the blinn material works
3. InstancingTestScene: showing that instancing works
Else CameraTestScene: default fall-back

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
6. jruby -S rabpt.rb **img_width** **img_height** **spp** **name_ext** **sel_scene**

