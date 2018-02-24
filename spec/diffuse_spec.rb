require_relative 'spec_helper'

describe Diffuse do
  before(:each) do
    @diffuse_material = Diffuse.new(nil)
    hit_record_args = {
      position: Vector3f.new(1.0, 2.0, 1.0),
      normal: Vector3f.new(1.0, 0.0, 0.0),
      u: Vector2f.new(0.5, 0.5),
      v: Vector2f.new(0.5, 0.5),
      w: Vector3f.new(0.5, 2.0, 1.0).normalize,
      intersectable: nil,
      material: @diffuse_material,
      p: 1.0
    }

    @hit_record = HitRecord.new hit_record_args
  end

  it "should allow to evaluate a brdf" do
    (@diffuse_material.respond_to? :evaluate_brdf).should be_true
    lambda { @diffuse_material.evaluate_brdf(nil,nil,nil) }.should_not raise_error
  end

  it "should allow to evaluate an emission" do
    (@diffuse_material.respond_to? :evaluate_emission).should be_true
    lambda { @diffuse_material.evaluate_emission(nil,nil) }.should_not raise_error
  end

  it "should allow check if has specular reflection" do
    (@diffuse_material.respond_to? :has_specular_reflection?).should be_true
    lambda { @diffuse_material.has_specular_reflection? }.should_not raise_error
  end

  it "should allow to evaluate specular reflection" do
    (@diffuse_material.respond_to? :evaluate_specular_reflection).should be_true
    lambda { @diffuse_material.evaluate_specular_reflection(nil) }.should_not raise_error
  end

  it "should allow check if has specular refraction" do
    (@diffuse_material.respond_to? :has_specular_refraction?).should be_true
    lambda { @diffuse_material.has_specular_refraction? }.should_not raise_error
  end

  it "should allow to evaluate specular refraction" do
    (@diffuse_material.respond_to? :evaluate_specular_refraction).should be_true
    lambda { @diffuse_material.evaluate_specular_refraction(nil) }.should_not raise_error
  end

  it "should allow to get shading sample" do
    (@diffuse_material.respond_to? :shading_sample).should be_true
    lambda { @diffuse_material.shading_sample(@hit_record, [0.5, 3.2]) }.should_not raise_error
  end

  it "should allow to get emission sample" do
    (@diffuse_material.respond_to? :emission_sample).should be_true
    lambda { @diffuse_material.emission_sample(nil,nil) }.should_not raise_error
  end

  it "should allow to check if casts shadows" do
    (@diffuse_material.respond_to? :casts_shadows?).should be_true
    lambda { @diffuse_material.casts_shadows? }.should_not raise_error
  end

  it "should allow to evaluate a bum map" do
    (@diffuse_material.respond_to? :evaluate_bump_map).should be_true
    lambda { @diffuse_material.evaluate_bump_map(nil) }.should_not raise_error
  end

  it "should have a string representation" do
    (@diffuse_material.respond_to? :to_s).should be_true
    lambda { @diffuse_material.to_s }.should_not raise_error
  end
end
