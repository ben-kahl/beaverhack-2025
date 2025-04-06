extends CanvasLayer

@onready var http = $HTTPRequest
@onready var source_code = ""
@onready var isAccepted = null

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
	# for now use localhost, consider switching to cloud hosting
	var url = "http://localhost:2358/submissions?base64_encoded=false&wait=true"
	var headers = ["Content-Type: application/json"]
	
	var error = http.request(url, headers, HTTPClient.METHOD_POST, json_string)
	
	if error != OK:
		print("HTTP Request error: ", error)
		

func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response = JSON.parse_string(body.get_string_from_utf8())
	print("Response: ", response)
	if response and response.has("status"):
		var status = response["status"]
		if status.has("description"):
			var description = status["description"]
			if description == "Accepted":
				isAccepted = true
				$JudgeStatus.text = "Code Accepted!"
			else:
				isAccepted = false
				$JudgeStatus.text = "Code not Accepted. Try Again!"
	else:
		print("Error with http request")
		$JudgeStatus.text = "Error Submitting Code. Check internet connection and try again!"


func _on_continue_pressed() -> void:
	if isAccepted == true:
		get_tree().change_scene_to_file("res://text_displayer.tscn")
	else:
		$JudgeStatus.text = "Challenge must be completed to continue!"
