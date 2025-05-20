extends Node3D

enum LEVEL_CONTEXT { NORMAL, SECRET }
@export var current_context: LEVEL_CONTEXT = LEVEL_CONTEXT.NORMAL

@onready var music = $BGMusic

@onready var player = $PlayerController
@onready var checkpoint_spawnpoint = $Checkpoint_spawn

func _ready() -> void:
	music.play()
	if Checkpoint.checkpoint_passed:
		player.global_position = checkpoint_spawnpoint.global_position
