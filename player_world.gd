extends CharacterBody3D

class_name Player_Overworld

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var can_open_level = false

@onready var map_scene = preload("res://world_test_cube.tscn")
const CUSTOM_IMAGE = preload("res://addons/transitions/images/Radial_01.png")

func _ready() -> void:
	$"../BGMusic".play()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and can_open_level:
		FancyFade.custom_fade(map_scene.instantiate(), 1.0, CUSTOM_IMAGE)
		
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player_Overworld:
		$"../HUDOverworld/Label".visible = true
		can_open_level = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is Player_Overworld:
		$"../HUDOverworld/Label".visible = false
		can_open_level = false
