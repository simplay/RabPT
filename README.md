# RabPT - A Ruby Ray- and bidirectional Path-Tracer
**RabPT** is a collection of various physical phenomenon rendering approaches, following basic ray-tracing approaches, implemented as a ruby application.

**RabPT** is licensed under the [MIT License](https://github.com/simplay/RabPT/blob/master/LICENSE).

### run this application:
1. Install Gems: run ````bundle````
2. Run the application: ````ruby rabpt.rb img_width img_height spp name_ext sel_scene````

where the passed arugments are:

* **img_width**: number of pixels in height of the rendered image
* **img_height**: number of pixels in height of the rendered image
* **spp**: samples per pixel used for rendering during tracing step
* **name_ext**: Is the filename extension. Each rendered image has a basic filename plus this user specified extension.
* **sel_scene**: The selected test scene to render ranging from 1 to N (integer values). The value will change - See list of implemented test-scenes below 

Example: ````ruby rabpt.rb 300 400 7 abc 3````

Will render a **300** by **400** pixel image using **7** samples per pixel of the  **3**-th test-scene. The output file wil be stored in ````../output```` and will be called **instancing_test_scene_7spp_300w_400h_abc.bmp**.

Note that only the first 3 arguments are required in order to successfully render an image. If there are less provided an exception will be raised _too few arguments_.

### Available scene list:
The following list contains all currently available _scenes_ encoded as the **sel_scene** argument used when starting this application:

1. **CameraTestScene**: showing that the camera setup works. Filname-Prefix: **camera_test_scene**
2. **BlinnTestScene**: showing that the blinn material works. Filname-Prefix: **blinn_test_scene**
3. **InstancingTestScene**: showing that instancing works. Filname-Prefix: **instancing_test_scene**
4. **MeshLoadingTestScene**: showing that instancing works. Filname-Prefix: **mesh_loading_test_scene**
Else **CameraTestScene**: default fall-back. Filname: **instancing_test_scene**

### Debugging within the code
Place a ```` binding.pry ```` statement in w/e code region

### Run a specific test
```` rspec tests/my_model_spec.rb ````

### Milestone1
Implement a debug-ray tracer which can render a simple scene consisting of a pinhole camera, simple csg_solid objects, point-lights - relying on an appriximative sampling strategy (one-samples). 


### JRUBY support 
For multithreading purposes there is jruby support provided (runtime check whether you are using ruby or jrby). In the following a list of required steps to perform in order to let the application run using JRuby:

1. Install jruby
2. rvm use jrby #VERSION
3. ````jruby -S gem install imageruby````
4. ````jruby -S gem install imageruby-bmp````
5. ````jruby -S gem install pry````
6. Start App:````jruby -S rabpt.rb img_width img_height spp name_ext sel_scene````

