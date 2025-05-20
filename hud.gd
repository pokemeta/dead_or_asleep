extends CanvasLayer

signal display_dead_message
signal update_life_counter
signal display_end_message

@onready var label = $Label
@onready var life_counter = $LifeCounter
@onready var timer = $Timer
@onready var finished_level = $FinishedLevel
@onready var finished_level_secret = $FinishedLevelSecret

@onready var player: Player = $"../PlayerController"

@onready var instructions_door = $InstructionsDoor

func _ready() -> void:
	#life_counter.text = "Lives: " + str(global.player_lives)
	pass

func _process(delta: float) -> void:
	life_counter.text = "Lives: " + str(player.lives)

func toggle_door_instructions(val: bool):
	instructions_door.visible = val

func _on_display_dead_message() -> void:
	get_tree().paused = true
	label.visible = true
	timer.start()

func _on_timer_timeout() -> void:
	get_tree().paused = false
	label.visible = false
	get_tree().reload_current_scene()

func _on_update_life_counter() -> void:
	#life_counter.text = "Lives: " + str(global.player_lives)
	pass

func _on_display_end_message() -> void:
	var level_context = get_parent().current_context
	if level_context == get_parent().LEVEL_CONTEXT.NORMAL:
		finished_level.visible = true
	elif level_context == get_parent().LEVEL_CONTEXT.SECRET:
		finished_level_secret.visible = true
