extends CanvasLayer

var string_counter = 0 # limit 9

var console_active = false

@onready var player: Player = get_tree().current_scene.find_child("PlayerController")

func _process(delta: float) -> void:
	if string_counter > 9:
		$Control/RichTextLabel.clear()
		string_counter = 0
	
	self.visible = console_active

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("console"):
		console_active = !console_active
		player.enable_disable_input()
	
	if event.is_action_pressed("ui_accept") and console_active:
		var expression = Expression.new()
		var user_input: LineEdit = $Control/LineEdit
		
		expression.parse(user_input.text)
		
		expression.execute([], self)
		
		if expression.has_execute_failed():
			$Control/RichTextLabel.add_text("Error: unknown command" + "\n")
			string_counter += 1

func test_print(text_input: String):
	$Control/RichTextLabel.add_text(text_input + "\n")
	string_counter += 1

func powerup(name: String):
	match name:
		"nor":
			player.current_power_state = player.PowerState.NORMAL
			$Control/RichTextLabel.add_text("Removed powerups" + "\n")
			string_counter += 1
		"enh":
			player.current_power_state = player.PowerState.ENHANCED
			$Control/RichTextLabel.add_text("Powerup enhanced set" + "\n")
			string_counter += 1
		"ice":
			player.current_power_state = player.PowerState.ICE
			$Control/RichTextLabel.add_text("Powerup ice set" + "\n")
			string_counter += 1
		_:
			$Control/RichTextLabel.add_text("Error: no powerup found" + "\n")
			string_counter += 1
