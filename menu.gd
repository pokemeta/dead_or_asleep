extends CanvasLayer


@onready var map_scene = load("res://map_overworld_early.tscn")

func _on_button_pressed() -> void:
	FancyFade.tile_reveal(map_scene.instantiate())
