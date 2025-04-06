extends CanvasLayer

@onready var http = $HTTPRequest
@onready var source_code = ""
@onready var isAccepted = null
@onready var isCorrect = false
const GameDataLoader = preload("res://game_data_loader.gd")
var secret_key = ""
var answer_data = null
var instruction_data = null
var last_token: String = ""

func _ready() -> void:
	answer_data = GameDataLoader.new("res://data/answers.json")
	instruction_data = GameDataLoader.new("res://data/instructions.json")
	GameState.update_challenge_index()
	var ins = GameState.get_challenge_at_current_index()+'ins'
	$InstructionBG/Instructions.text = instruction_data.text_data[ins]
	loadKey()

func loadKey():
	var path = "res://keys/judge0"
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		secret_key = file.get_as_text().strip_edges()
		print("API key loaded")
	else:
		print("Error loading API key")

func _on_save_pressed() -> void:
	source_code = $CodeEdit.text
	var file = FileAccess.open("user://user_code.py", FileAccess.WRITE)
	file.store_string(source_code)
	print("File Successfully Saved")

func _on_load_pressed() -> void:
	var file = FileAccess.open("user://user_code.py", FileAccess.READ)
	$CodeEdit.text = file.get_as_text()

func _on_judge_pressed() -> void:
	$JudgeStatus.text = "Judging..."
	var json = {
		"source_code": source_code,
		"language_id": 71,
	}
	var json_string = JSON.stringify(json)
	var url = "https://judge0-ce.p.rapidapi.com/submissions?base64_encoded=false&wait=false&fields=*"
	var headers = [
		"Content-Type: application/json",
		"x-rapidapi-host: judge0-ce.p.rapidapi.com",
		"x-rapidapi-key: %s" % secret_key
		]
	
	var error = http.request(url, headers, HTTPClient.METHOD_POST, json_string)
	
	if error != OK:
		print("HTTP Request error: ", error)
		

func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response = JSON.parse_string(body.get_string_from_utf8())

	# This is a submission polling response
	if response.has("status"):
		var status = response["status"]
		var id = status["id"]
		var description = status["description"]
		print("Submission status: ", description)

		if id == 3:
			# Accepted
			var stdout = response.get("stdout", "")
			var stderr = response.get("stderr", "")
			var compile_output = response.get("compile_output", "")
			print("Output:\n", stdout)
			print("Errors:\n", stderr)
			print("Compile Output:\n", compile_output)
			$JudgeStatus.text = "Submission Accepted!"
			checkAnswer(stdout)
			
		elif id == 1 or id == 2:
			# In queue or Processing
			await get_tree().create_timer(1.0).timeout
			poll_submission_result(last_token)
		else:
			# Some error happened
			$JudgeStatus.text = "Error: " + description
	else:
		# Initial submission response
		last_token = response["token"]
		poll_submission_result(last_token)

		
func poll_submission_result(token):
	var url = "https://judge0-ce.p.rapidapi.com/submissions/%s?base64_encoded=false" % token
	var headers = [
		"x-rapidapi-host: judge0-ce.p.rapidapi.com",
		"x-rapidapi-key: %s" % secret_key
	]
	var err = http.request(url, headers, HTTPClient.METHOD_GET)
	if err != OK:
		print("Error requesting result: ", err)

func _on_continue_pressed() -> void:
	if isCorrect == true or GameState.completed_challenges.has(GameState.current_challenge_index):
		isAccepted = null
		isCorrect = false
		get_tree().change_scene_to_file("res://text_displayer.tscn")
	else:
		$JudgeStatus.text = "Challenge must be completed to continue!"

func checkAnswer(submission) -> void:
	var ans = GameState.get_challenge_at_current_index()+'ans'
	var problem_ans = answer_data.text_data[ans]
	print(submission)
	print(problem_ans)
	if submission == problem_ans:
		$JudgeStatus.text = "Correct Answer! Please Continue Your Adventure!"
		isCorrect = true
	else:
		$JudgeStatus.text = "Incorrect Answer! Please Try Again."
	
