extends Ability

@export var slam_speed := 30.0

var player: CharacterBody3D

func _ready() -> void:
	player = get_parent()

func _can_activate() -> bool:
	return not player.is_on_floor()

func _on_activate():
	player.velocity.y = -slam_speed

func _on_update(delta):
	player.velocity.y = -slam_speed

	if player.is_on_floor():
		finish()
