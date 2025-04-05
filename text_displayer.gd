extends CanvasLayer

func continue_text() -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed('Enter_key'):
		continue_text()
