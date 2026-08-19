extends AnimatableBody3D

@export var move_distance := 3.0
@export var move_speed := 2.0

var start_position : Vector3
var time := 0.0

func _ready():
	start_position = position

func _physics_process(delta):
	time += delta
	
	position.x = start_position.x + sin(time * move_speed) * move_distance
