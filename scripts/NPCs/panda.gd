extends StaticBody3D

@onready var interaction_area: Area3D = $InteractionArea
@onready var interact_label: Label3D = $Label3D

@export var dialogue_ui: CanvasLayer

var player_nearby := false
var dialogue_finished := false
var puzzle_completed := false

func _ready() -> void:
	interact_label.visible = false
	interaction_area.body_entered.connect(_on_body_entered)
	interaction_area.body_exited.connect(_on_body_exited)
	dialogue_ui.dialogue_finished.connect(_on_dialogue_finished)

func _process(delta: float) -> void:
	if player_nearby and not dialogue_finished:
		if Input.is_action_just_pressed("interact"):
			if not dialogue_ui.dialogue_open:
				talk()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_nearby = true
		interact_label.visible = true

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_nearby = false
		interact_label.visible = false
		dialogue_finished = false
		
		if dialogue_ui.dialogue_open:
			dialogue_ui.close_dialogue()

func talk() -> void:
	if puzzle_completed:
		dialogue_ui.start_dialogue(
			"Panda",
			[
				"You did it!",
				"The gate is open now.",
				"Good luck on your journey!"
			]
		)
	else:
		dialogue_ui.start_dialogue(
			"Panda",
			[
				"Hey there, little fox!",
				"There are two switches hidden nearby.",
				"Activate both switches to open the gate.",
				"Good luck!"
			]
		)

func _on_dialogue_finished() -> void:
	dialogue_finished = true
