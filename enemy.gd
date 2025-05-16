extends CharacterBody3D

# The direction variable, to the left by default
var direction = -1

# The turning variable helps in making the enemy turn get delayed
var turning = false

var frozen_body = preload("res://frozen_enemy.tscn")

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Moves depending the direction
	velocity.x = direction * 2.0
	
	# These line handle turning the enemy by calling the function.
	# Side note: both are different because one is for detecting a wall
	# and the other to detect corner.
	if is_on_wall() and not turning:
		turn_around_enemy()
	
	if not $RayCast3D.is_colliding() and is_on_floor() and not turning:
		turn_around_enemy()
	
	move_and_slide()

# Function to turn the enemy around
func turn_around_enemy():
	turning = true
	$MeshInstance3D.scale.x *= -1
	$RayCast3D.position.x *= -1
	direction *= -1
	
	# This is needed to add a time delay for the turning to become false
	await get_tree().create_timer(0.6).timeout
	
	turning = false

# The code for collisioning with the player. Right now there's a bug
# where the opposite direction doesn't work when moving.
func _on_hit_body_entered(body: Node3D) -> void:
	if body is Player:
		var collision_direction = body.global_position - global_position
		
		if collision_direction.y > 1.3:
			body.velocity.y = body.JUMP_VELOCITY
			queue_free()
		else:
			body.push_back(collision_direction.normalized(), 25.0)
			body.emit_signal("kill_player")
	
	if body is Ice_Ball:
		var frozen_obj = frozen_body.instantiate()
		frozen_obj.global_position = self.global_position
		frozen_obj.position.y += 0.1
		get_node("../FrozenObjects").add_child(frozen_obj)
		queue_free()
