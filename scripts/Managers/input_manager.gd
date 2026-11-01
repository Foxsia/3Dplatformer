extends Node

func get_movement_input() -> Vector2:
	return Input.get_vector("left", "right", "up", "down")

func is_jump_pressed() -> bool:
	return Input.is_action_just_pressed("jump")

func is_sprint_pressed() -> bool:
	return Input.is_action_just_pressed("sprint")

func is_dash_pressed() -> bool:
	return Input.is_action_just_pressed("dash")

func is_ground_slam_pressed() -> bool:
	return Input.is_action_just_pressed("ground_slam")

func is_attack_pressed() -> bool:
	return Input.is_action_just_pressed("attack")

func is_interact_pressed() -> bool:
	return Input.is_action_just_pressed("interact")

func is_quit_pressed() -> bool:
	return Input.is_action_just_pressed("quit")
