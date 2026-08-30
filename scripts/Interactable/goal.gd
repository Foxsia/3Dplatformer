extends Area3D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		level_complete()

func level_complete():
	get_tree().change_scene_to_file.call_deferred("res://scenes/UI/win_screen.tscn")
