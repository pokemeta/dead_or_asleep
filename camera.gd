extends Camera3D

@onready var player: Player = $"../PlayerController"
@onready var end_level_marker = $"../EndLevel/Marker"

func _process(delta: float) -> void:
	
	if not player.crossed_end:
		global_position = lerp(global_position, player.global_position, 1 * delta)
		global_position.z = 10
	else:
		global_position = lerp(global_position, end_level_marker.global_position, 2 * delta)
		global_position.z = lerp(global_position.z, 25.0, 2.0 * delta)

	 
