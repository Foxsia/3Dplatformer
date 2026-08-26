extends StaticBody3D

@onready var interaction_area: Area3D = $InteractionArea
@onready var interact_label: Label3D = $Label3D

var activated := false
var player_nearby := false

@export var puzzle_manager: Node

func _ready() -> void:
	interact_label.visible = false
	
	interaction_area.body_entered.connect(_on_body_entered)
	interaction_area.body_exited.connect(_on_body_exited)


func _process(_delta: float) -> void:
	if player_nearby and not activated:
		if Input.is_action_just_pressed("interact"):
			activate()


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and not activated:
		player_nearby = true
		interact_label.visible = true


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_nearby = false
		interact_label.visible = false

func activate():
	if activated:
		return
	
	activated = true
	
	puzzle_manager.button_activated()
	
	interact_label.visible = false
	visible = false
	$CollisionShape3D.set_deferred("disabled", true)
