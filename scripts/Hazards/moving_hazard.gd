extends Area3D

@export var move_distance := 2.0
@export var move_speed := 2.0

var start_position : Vector3
var time := 0.0

func _ready():
	start_position = position
	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	time += delta
	
	position.z = start_position.z + sin(time * move_speed) * move_distance

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.die()
