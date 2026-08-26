extends AnimatableBody3D

@export var open_height := 3.5
@export var open_speed := 3.0

var is_open := false
var start_position: Vector3

func _ready() -> void:
	start_position = position

func open() -> void:
	if is_open:
		return
	
	is_open = true

func _physics_process(delta: float) -> void:
	if is_open:
		position.y = move_toward(position.y, start_position.y + open_height, open_speed * delta)
