extends CanvasLayer

@onready var resume_button = $Panel/Container/Resume
@onready var restart_button = $Panel/Container/Restart
@onready var main_menu_button = $Panel/Container/MainMenu

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	
	resume_button.pressed.connect(resume_game)
	restart_button.pressed.connect(restart_level)
	main_menu_button.pressed.connect(main_menu)

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		if is_level_scene():
			toggle_pause()

func is_level_scene() -> bool:
	var current_scene = get_tree().current_scene
	
	if current_scene == null:
		return false
	
	return current_scene.is_in_group("level")

func toggle_pause():
	if get_tree().paused:
		resume_game()
	else:
		pause_game()

func pause_game():
	get_tree().paused = true
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func resume_game():
	get_tree().paused = false
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func restart_level():
	get_tree().paused = false
	visible = false
	get_tree().reload_current_scene()

func main_menu():
	get_tree().paused = false
	visible = false
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")
