require_relative '../intersectable.rb'
require_relative '../ray.rb'
require_relative '../hit_record.rb'
require_relative 'mesh_triangle.rb'

# A triangle mesh. The mesh internally stores the triangles using vertex and
# index arrays. The mesh also instantiates a {@link MeshTriangle} for each
# triangle, and the mesh provides an iterator to iterate through the triangles.
class Mesh < IntersectableList
  # :attr_reader:
  #   vertices: Vector3f Hash
  #     Hash of triangle vertices. Stores x,y,z coordinates for each vertex
	#     consecutively.
  #
  #   normals: Vector3f Hash
  #     Hash of triangle normals (one normal per vertex). Stores x,y,z
  #     coordinates for each normal consecutively.
  #
  #   indices, Vector3f Hash
  #     Index Hash. Each triangle is defined by three consecutive indices in
  #     this Hash. The indices refer to the Mesh#vertices and
  #     Mesh#normals Hash that store vertex and normal coordinates.
  #
  #   triangles: MeshTriangle Array
  #     Array of triangles stored in the mesh.
  #
  #   material: Material
  #     material of this mesh

  attr_reader :vertices,
              :normals,
              :indices,
              :triangles,
              :material

  # Make a mesh from a loaded obj file data, stroring vertices, normals and
  # indices.
  #
  # @param mesh_data mesh data provided by ObjReader.
  def initialize(mesh_data, material)
    flush
    @vertices = mesh_data[:vertices]
    @normals  = mesh_data[:normals]
    @indices  = mesh_data[:faces]
    @material = material

    @indices.length.times do |idx|
      put(MeshTriangle.new(self, idx))
    end
  end

  def triangles
    @container
  end
end
