extends Node3D

@onready var player = get_node("../PlayerController")
@onready var bg_music = get_node("../BGMusic")

var reduce_music = true

func _process(delta: float) -> void:
	var distance = player.global_position.x - global_position.x
	
	if (distance >= -30 or distance <= 30) and player.found_secret:
		# 0
		var determining = roundi(fmod(distance, 3.0))
		if determining == 0 and reduce_music:
			bg_music.set_volume_db(bg_music.get_volume_db() - 1.0)
			reduce_music = false
		
		if determining < 0 or determining > 0:
			reduce_music = true


func _on_hit_box_body_entered(body: Node3D) -> void:
	body.can_cross_secret = true
	bg_music.stop()

func _on_hit_box_body_exited(body: Node3D) -> void:
	body.can_cross_secret = false
