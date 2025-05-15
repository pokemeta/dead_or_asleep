extends StaticBody3D

func _on_hit_jump_body_entered(body: Node3D) -> void:
	if body is Player:
		var ply: Player = body
		ply.velocity.y = ply.JUMP_VELOCITY
		if ply.current_power_state == ply.PowerState.ENHANCED:
			ply.activate_double_press_timer = true
