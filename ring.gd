extends Area3D

@export var rotation_speed := 2.0
@onready var ring = $MeshInstance3D

func _ready():
	body_entered.connect(_on_body_entered)

func _process(delta):
	ring.rotate_x(rotation_speed * delta)

func _on_body_entered(body):
	if body is CharacterBody3D:
		GameManager.add_ring()
		queue_free()
