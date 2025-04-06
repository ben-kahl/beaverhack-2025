extends Control

@onready var initHttp = $InitRequest
@onready var chatHttp = $ChatRequest
@onready var gemini_api_key : String = ""

func _init() -> void:
	var url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$"+gemini_api_key
	var headers = ["Content-Type: application/json"]
	var json = {
			"system_instruction": {
		  "parts": [
			{
			  "text": "You are assisting a recently hired employee who does not know
	how to program at all. Help them write python code (no other languages) to help complete their 
	assignments, but only give explanations on topics or guidance on their code. Do not give them
	the answer to the whole problem."
			}
		  ]
		},
		"contents": [
		  {
			"parts": [
			  {
				"text": "Help! I lied on my resume and got hired as a software engineer but I have no idea
				how to code. Help me learn python!"
			  }
			]
		  }
		]
	}
	var json_string = JSON.stringify(json)
	#var error = initHttp.request(url, headers, HTTPClient.METHOD_POST, json_string)
	
	#if error != OK:
	#	print("HTTP Request error: ", error)

func _on_chat_pressed() -> void:
	$ChatInput.text = ""
	$ChatOutput.text = "Placeholder response"
	pass # Replace with function body.

func _on_init_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	pass # Replace with function body.


func _on_chat_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	pass # Replace with function body.
