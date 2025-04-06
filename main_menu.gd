extends CanvasLayer

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://text_displayer.tscn")


func _on_save_keys_pressed() -> void:
	var gemini = $GeminiAPI.text.strip_edges()
	var judge0 = $Judge0API.text.strip_edges()
	GameState.gemini_key = gemini
	GameState.judge0_key = judge0
