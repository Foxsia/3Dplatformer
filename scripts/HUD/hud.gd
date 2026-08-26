extends CanvasLayer

signal dialogue_finished

@onready var ring_label = $RingLabel
@onready var lives_label = $LivesLabel
@onready var player = $"../Player"

@onready var dialogue_box: Panel = $DialogueBox
@onready var name_label: Label = $DialogueBox/NameLabel
@onready var dialogue_label: Label = $DialogueBox/DialogueLabel

var dialogue_lines: Array = []
var current_line := 0
var dialogue_open := false

func _ready():
	GameManager.rings_changed.connect(_on_rings_changed)
	_on_rings_changed(GameManager.rings)
	player.lives_changed.connect(_on_lives_changed)
	_on_lives_changed(player.lives)
	
	dialogue_box.visible = false

func _on_rings_changed(amount):
	ring_label.text = "RINGS: " + str(amount)

func _on_lives_changed(amount):
	lives_label.text = "LIVES: " + str(amount)

func start_dialogue(speaker: String, lines: Array) -> void:
	name_label.text = speaker
	dialogue_lines = lines
	current_line = 0
	dialogue_open = true
	
	dialogue_box.visible = true
	dialogue_label.text = dialogue_lines[current_line]

func _process(_delta: float) -> void:
	if dialogue_open and Input.is_action_just_pressed("interact"):
		current_line += 1
		
		if current_line >= dialogue_lines.size():
			close_dialogue()
		else:
			dialogue_label.text = dialogue_lines[current_line]

func close_dialogue() -> void:
	dialogue_open = false
	dialogue_box.visible = false
	dialogue_finished.emit()
