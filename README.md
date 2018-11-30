# RabPT

RabPT (A Ruby Ray- and bidirectional Path-Tracer) is a ray-tracer written in ruby.

[MIT License](https://github.com/simplay/RabPT/blob/master/LICENSE).

### Usage

`ruby rabpt.rb img_width img_height spp name_ext sel_scene`

| **Argument** | **Description**        |
|--------------|------------------------|
| img_width    | width of output image  |
| img_height   | height of output image |
| spp          | samples per pixel      |
| name_ext     | filename extension     |
| sel_scene    | scene to render        |

Example: `ruby rabpt.rb 300 400 7 abc 3`

This will render a **300** by **400** pixel image of the 3rd scene using **7** samples per pixel. The generated image is stored in `./output`.

### Available Scenes

| **sel_scene** | **Scene**               | Description         |
|---------------|-------------------------|---------------------|
| 1             | CameraTestScene         | camera demo         |
| 2             | BlinnTestScene          | blinn material demo |
| 3             | InstancingTestScene     | instancing demo     |
| 4             | MeshLoadingTestScene    | mesh loading demo   |

## Run Tests

`rspec tests/`


## Use JRuby

To execute the renderer in parallel.

In the following a list of required steps to perform in order to let the application run using JRuby:

### Installation

1. Install jruby
2. `jruby -S gem install imageruby`
3. `jruby -S gem install imageruby-bmp`
4. Start App: `jruby -S rabpt.rb img_width img_height spp name_ext sel_scene`
