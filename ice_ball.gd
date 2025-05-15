extends RigidBody3D

class_name Ice_Ball

var timer_life = 240
var force_direction = 3

func _ready() -> void:
	apply_central_impulse(Vector3(force_direction, 0, 0))

func _physics_process(delta: float) -> void:
	#apply_central_force(Vector3(2, 1, 0))
	constant_force = Vector3(force_direction, 0, 0)
	timer_life -= 1
	if timer_life <= 0:
		self.queue_free()

func _on_enemy_body_entered(body: Node3D) -> void:
	queue_free()
