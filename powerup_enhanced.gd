extends StaticBody3D

func _on_hit_box_power_body_entered(body: Player) -> void:
	body.is_flying = false
	body.is_ice_active = false
	body.current_power_state = body.PowerState.ENHANCED
	queue_free()
