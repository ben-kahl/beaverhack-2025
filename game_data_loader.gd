class_name GameDataLoader

var text_data

func _init(_filename = "res://data/data.json") -> void:
	text_data = loadJSONData(_filename)
	
func loadJSONData(filename):
	var data_file = FileAccess.open(filename, FileAccess.READ)
	var data_string = data_file.get_as_text()
	var json_data = JSON.new()
	var error = json_data.parse(data_string)
	if error == OK:
		var data_received = json_data.data
		if typeof(data_received) == TYPE_DICTIONARY:
			return data_received
		else:
			assert(false, "Unexpected data in JSON")
	else:
		print("JSON parser error: ", json_data.get_error_message(), "in", data_string, "at line", json_data.get_error_line())
		assert(false, "JSON Parse Error")
