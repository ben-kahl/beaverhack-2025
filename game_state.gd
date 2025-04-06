extends Node

var current_challenge_index := 0
var current_script_idx := 0
var completed_challenges := []

func get_script_at_current_index():
	match current_script_idx:
		0:
			return 'intro'
		1:
			return 'pre_problem_1'
		2:
			return 'post_problem_1'
		3:
			return 'pre_problem_2'
		4:
			return 'post_problem_2'
		5:
			return 'pre_problem_3'
		6:
			return 'post_problem_3'
		7:
			return 'pre_problem_4'
		8:
			return 'post_problem_4'
		9:
			return 'pre_problem_5'
		10:
			return 'post_problem_5'
		11:
			return 'conclusion'

func get_challenge_at_current_index():
	match current_challenge_index:
		1:
			return 'problem_1_'
		2:
			return 'problem_2_'
		3:
			return 'problem_3_'
		4:
			return 'problem_4_'
		5:
			return 'problem_5_'

#updates based on script position
func update_challenge_index():
	if current_script_idx < 3:
		current_challenge_index = 1
	elif current_script_idx > 2 and current_script_idx < 5:
		current_challenge_index = 2
	elif current_script_idx > 4 and current_script_idx < 7:
		current_challenge_index = 3
	elif current_script_idx > 6 and current_script_idx < 9:
		current_challenge_index = 4
	else:
		current_challenge_index = 5
