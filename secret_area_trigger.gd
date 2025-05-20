extends Node3D

@export var remove_object_tareget: Node3D
@onready var player = get_node("../PlayerController")

func _on_area_3d_body_entered(body: Node3D) -> void:
	player.found_secret = true
	remove_object_tareget.queue_free()
	self.queue_free()
