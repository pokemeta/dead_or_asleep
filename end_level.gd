extends Node3D

func _on_player_entered(body: Player) -> void:
	body.emit_signal("finished_level")
	get_node("../BGMusic").stop()
	get_node("../WinSound").play()
