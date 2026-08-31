extends Control

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	var completed_level = GameManager.current_level
	
	GameManager.complete_level(completed_level)

func _on_next_level_pressed():
	var next_level = GameManager.current_level
	
	get_tree().change_scene_to_file(
		"res://scenes/Levels/level_" + str(next_level) + ".tscn"
	)

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")
