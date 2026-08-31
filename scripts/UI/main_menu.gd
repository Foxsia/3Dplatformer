extends Control

@export var first_level_path := "res://scenes/Levels/level_1.tscn"

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_play_button_pressed():
	GameManager.current_level = 1
	get_tree().change_scene_to_file(first_level_path)

func _on_quit_button_pressed():
	get_tree().quit()
