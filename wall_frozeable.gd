extends StaticBody3D

var ice_texture = preload("res://textures/ice.tres")

func _on_hit_box_ball_entered(body: Node3D) -> void:
	$MeshInstance3D.set_surface_override_material(0, ice_texture)
	self.reparent(get_node("../FrozenObjects"), true)
