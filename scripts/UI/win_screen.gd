extends Control

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_next_level_pressed():
	print("Next level")

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("")
	print("menu")
