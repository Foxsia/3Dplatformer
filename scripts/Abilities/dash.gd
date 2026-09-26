extends Ability

@export var speed := 20.0
@export var duration := 0.25

var remaining := 0.0
var direction := Vector3.ZERO
@onready var player: CharacterBody3D = get_parent()

func set_direction(new_direction: Vector3):
	direction = new_direction.normalized()

func _on_activate():
	remaining = duration


func _on_update(delta):
	remaining -= delta
	player.velocity.x = direction.x * speed
	player.velocity.z = direction.z * speed

	if remaining <= 0.0:
		finish()
