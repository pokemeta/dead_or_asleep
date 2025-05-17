extends CharacterBody3D

# The custom class we give to the player
class_name Player

var active_input = true

# Variables for the speed and jump force
const SPEED = 5.0
const JUMP_VELOCITY = 10.0

# Variable needed for when the player gets pushed
const KNOCKBACK_TIME = 0.03
const KNOCKBACK_STRENGTH = 25.0

# Variable related to HUD and how many lives has
@export var lives: int = 3
@onready var hud = $"../HUD"

# Custom signal to decrease lives
signal kill_player

signal finished_level

var crossed_end = false

###############
var end_timer = 0
################

# Variables for coyote jump
const COYOTE_TIME := 0.1
var coyote_timer := 0.0

# Initialized variables for the pushback
var knockback_velocity = Vector3.ZERO
var knockback_timer = 0.0

# Powerup
enum PowerState { NORMAL, ENHANCED, ICE }
@export var current_power_state: PowerState = PowerState.NORMAL
var normal_texture = preload("res://textures/regular.tres")
var enhanced_texture = preload("res://textures/enhanced.tres")
var ice_texture = preload("res://textures/ice.tres")

# All these variables are needed to handle the enhanced powerup
@export var is_flying = false
var double_press_flying_timer = 2.0
var activate_double_press_timer = false
const FLYING_SPEED = 5.0
var delay_double_press = 0.1
var delay_deactivate = 2.0

# Variables for the ice powerup
var ice_ball_obj = preload("res://ice_ball.tscn")
var player_current_direction = 1
var is_ice_active = false
var fly_stamina = 200

func enable_disable_input():
	active_input = !active_input

func _ready() -> void:
	$FlyMeter.max_value = fly_stamina

func _physics_process(delta: float) -> void:
	handle_powerup_change()
	
	powerup_enhanced()
	
	powerup_ice()
	
	# Gravity
	if (not is_on_floor() and not is_flying) or fly_stamina <= 0:
		velocity += get_gravity() * delta
	elif  not is_on_floor() and is_flying and fly_stamina > 0:
		var input_dir := Vector2.ZERO
		if Input.is_action_pressed("ui_up"):
			input_dir.y = 1.0
		elif Input.is_action_pressed("ui_down"):
			input_dir.y = -1.0
		velocity.y = input_dir.y * FLYING_SPEED
	
	# These lines of code trigger and handle the coyote jump timer
	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer -= delta

	# First comes the check for the push timer code
	if knockback_timer > 0.0:
		velocity.x = knockback_velocity.x
		velocity.z = knockback_velocity.z
		knockback_timer -= delta
	else:
		
		# Now comes the code to move player, also includes a bit of the coyote handler code
		if (Input.is_action_just_pressed("ui_accept") and active_input) and (is_on_floor() or coyote_timer > 0) and not crossed_end:
			velocity.y = JUMP_VELOCITY
			coyote_timer = 0.0

		if not crossed_end:
			var input_dir := Vector2.ZERO
			if Input.is_action_pressed("ui_left"):
				input_dir.x = -1.0
				if player_current_direction == 1:
					player_current_direction *= -1
					$Marker3D.position.x *= -1
			elif Input.is_action_pressed("ui_right"):
				input_dir.x = 1.0
				if player_current_direction == -1:
					player_current_direction *= -1
					$Marker3D.position.x *= -1

			var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
			if direction and active_input:
				if current_power_state == PowerState.ENHANCED:
					velocity.x = direction.x * SPEED * 1.5
					velocity.z = direction.z * SPEED * 1.5
				else:
					velocity.x = direction.x * SPEED
					velocity.z = direction.z * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				velocity.z = move_toward(velocity.z, 0, SPEED)
		else:
			velocity.x = 1.0 * 5.0
			end_timer += 1

	move_and_slide()
	
	#####################
	if end_timer >= 240:
		get_tree().quit()
	#####################

# Function that does the magic for getting the player pushed
func push_back(direction: Vector3, strength: float = KNOCKBACK_STRENGTH):
	knockback_velocity = direction * strength
	knockback_timer = KNOCKBACK_TIME

func handle_powerup_change():
	match current_power_state:
		PowerState.NORMAL:
			$FlyMeter.visible = false
			$wings_placeholder.visible = false
			$hand_placeholder.visible = false
			$MeshInstance3D.set_surface_override_material(0, normal_texture)
		PowerState.ENHANCED:
			$MeshInstance3D.set_surface_override_material(0, enhanced_texture)
			$FlyMeter.visible = true
			$wings_placeholder.visible = true
			$hand_placeholder.visible = false
		PowerState.ICE:
			$FlyMeter.visible = false
			$MeshInstance3D.set_surface_override_material(0, ice_texture)
			$wings_placeholder.visible = false
			$hand_placeholder.visible = true
		# Equivalent to switch default according to godot's docs
		_:
			print("No powestate set")

func powerup_enhanced():
	if current_power_state == PowerState.ENHANCED and Input.is_action_just_pressed("ui_accept") and is_on_floor():
		activate_double_press_timer = true
	
	if activate_double_press_timer and not is_flying:
		if delay_double_press > 0.0:
			delay_double_press -= 0.1
		else:
			if Input.is_action_just_pressed("ui_accept"):
				is_flying = true
				double_press_flying_timer = 2.0
				delay_double_press = 0.1
				activate_double_press_timer = false
	
	if is_flying and not activate_double_press_timer and delay_deactivate > 0.0:
		delay_deactivate -= 0.1
	else:
		if Input.is_action_just_pressed("ui_accept"):
			is_flying = false
			delay_deactivate = 0.2
	
	powerup_enhanced_ui()
	
	if not is_on_floor() and is_flying:
		$WingsPlayer.play("flap")

func powerup_enhanced_ui():
	if is_flying and not is_on_floor() and fly_stamina > 0:
		fly_stamina -= 1
	
	if is_on_floor() and fly_stamina <= 0:
		is_flying = false
		fly_stamina = 200
	
	if is_on_floor():
		fly_stamina = 200
	
	var player_screen_pos = get_viewport().get_camera_3d().unproject_position($FlyUI.global_position)
	$FlyMeter.global_position = player_screen_pos
	$FlyMeter.value = fly_stamina

func powerup_ice():
	if current_power_state == PowerState.ICE:
		is_ice_active = true
	
	if Input.is_action_just_pressed("shoot_ball") and is_ice_active:
		var new_ice = ice_ball_obj.instantiate()
		new_ice.global_position = $Marker3D.global_position
		
		if player_current_direction == 1:
			new_ice.force_direction = 3
		else:
			new_ice.force_direction = -3
		
		get_node("../BallParent").add_child(new_ice)
		
	#destroy_frozen_objects()
	if Input.is_action_just_pressed("snap"):
		$HandPlayer.play("snap")

func destroy_frozen_objects():
	for i in get_node("../FrozenObjects").get_children():
		i.queue_free()
		await get_tree().create_timer(0.3).timeout

# The function for the kill signal
func _on_kill_player() -> void:
	if lives > 1:
		match current_power_state:
			PowerState.ENHANCED:
				current_power_state = PowerState.NORMAL
				is_flying = false
				is_ice_active = false
			PowerState.ICE:
				current_power_state = PowerState.NORMAL
				is_flying = false
				is_ice_active = false
			PowerState.NORMAL:
				lives -= 1
	else:
		# The hud gets called to display the dead message
		hud.emit_signal("display_dead_message")

func _on_finished_level() -> void:
	crossed_end = true
	hud.emit_signal("display_end_message")
