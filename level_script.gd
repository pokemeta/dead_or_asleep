extends Node3D

@onready var music = $BGMusic

func _ready() -> void:
	music.play()
