require_relative 'spec_helper'
require 'open3'

describe 'Rabpt' do
  def execute(mode:)
    cmd = "SKIP_WRITE=1 ruby rabpt.rb -s 1 -w 2 -h 2 -f foo -i #{mode}"
    _, _, status = Open3.capture3(cmd)
    status
  end

  it "can run CameraTestScene" do
    expect(execute(mode: 1).success?).to be(true)
  end

  it "can run BlinnTestScene" do
    expect(execute(mode: 2).success?).to be(true)
  end

  it "can run InstancingTestScene" do
    expect(execute(mode: 3).success?).to be(true)
  end

  it "can run MeshLoadingTestScene" do
    expect(execute(mode: 4).success?).to be(true)
  end

  it "can run RefractionTestScene" do
    expect(execute(mode: 5).success?).to be(true)
  end
end
