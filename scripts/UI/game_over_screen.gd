extends Control

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_try_again_pressed():
	var level_path = "res://scenes/Levels/level_" + str(GameManager.current_level) + ".tscn"
	get_tree().change_scene_to_file(level_path)

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")
