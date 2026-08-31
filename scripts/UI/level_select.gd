extends Control

@onready var level_list = $LevelList

const LEVELS_PATH := "res://scenes/Levels/"

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	create_level_buttons()

func create_level_buttons():
	var dir = DirAccess.open(LEVELS_PATH)
	
	if dir == null:
		print("Failed to open: ", LEVELS_PATH)
		return
	
	var files = dir.get_files()
	
	for file in files:
		if not file.ends_with(".tscn"):
			continue
		
		if not file.begins_with("level_"):
			continue
		
		var level_number = int(
			file.trim_prefix("level_").trim_suffix(".tscn")
		)
		
		var button = Button.new()
		button.custom_minimum_size = Vector2(300, 60)
		
		if GameManager.is_level_unlocked(level_number):
			var style = StyleBoxFlat.new()
			style.bg_color = Color("19703dff")
			button.add_theme_stylebox_override("normal", style)
			button.disabled = false
		else:
			button.disabled = true
			var style = StyleBoxFlat.new()
			style.bg_color = Color("#555555")
			button.add_theme_stylebox_override("normal", style)
		
		button.text = "Level " + str(level_number)
		var level_path = LEVELS_PATH + file

		button.pressed.connect(
			_on_level_pressed.bind(level_path, level_number)
		)
		
		level_list.add_child(button)

func _on_level_pressed(level_path: String, level_number: int):
	GameManager.current_level = level_number
	get_tree().change_scene_to_file(level_path)

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")
