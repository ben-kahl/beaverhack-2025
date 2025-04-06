extends CanvasLayer

const GameDataLoader = preload("res://game_data_loader.gd")
var script_data = null
var cur_script = null

func _ready() -> void:
	script_data = GameDataLoader.new("res://data/data.json")
	update_text()

func update_text() -> void:
	cur_script = GameState.get_script_at_current_index()
	$RichTextLabel.text = script_data.text_data[cur_script]
	pass

func continue_text() -> void:
	pass

func continue_to_problem() -> void:
	GameState.current_script_idx += 1
	if GameState.current_script_idx == 11:
		get_tree().change_scene_to_file("res://game_over.tscn")
	elif GameState.current_script_idx % 2 == 0:
		get_tree().change_scene_to_file("res://problem_edit.tscn")
	else:
		update_text()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('Enter_key'):
		continue_to_problem()
