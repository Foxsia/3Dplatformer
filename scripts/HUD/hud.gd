extends CanvasLayer

signal dialogue_finished

@onready var ring_label = $RingLabel
@onready var lives_label = $LivesLabel
@onready var player = $"../Player"

@onready var dialogue_box: Panel = $DialogueBox
@onready var name_label: Label = $DialogueBox/NameLabel
@onready var dialogue_label: Label = $DialogueBox/DialogueLabel

@onready var health_component: HealthComponent = player.get_node("HealthComponent")

@onready var health_bar: ProgressBar = $HealthPanel/VBoxContainer/HealthBar
@onready var health_label: Label = $HealthPanel/VBoxContainer/HealthLabel

@onready var dash_label: Label = $AbilitiesContainer/DashPanel/VBoxContainer/DashLabel
@onready var dash_cooldown: Label = $AbilitiesContainer/DashPanel/VBoxContainer/DashCooldown

@onready var ground_slam_label: Label = $AbilitiesContainer/GroundSlamPanel/VBoxContainer/GroundSlamLabel
@onready var ground_slam_cooldown: Label = $AbilitiesContainer/GroundSlamPanel/VBoxContainer/GroundSlamCooldown

var dialogue_lines: Array = []
var current_line := 0
var dialogue_open := false

var ability_refresh_timer := 0.0

func _ready():
	GameManager.rings_changed.connect(_on_rings_changed)
	_on_rings_changed(GameManager.rings)
	
	health_component.lives_changed.connect(_on_lives_changed)
	health_component.health_changed.connect(_on_health_changed)
	
	_on_lives_changed(health_component.get_lives())
	_on_health_changed(health_component.get_health(), health_component.get_max_health())
	
	health_bar.min_value = 0.0
	health_bar.max_value = health_component.get_max_health()
	
	dialogue_box.visible = false
	
	update_abilities()

func _on_rings_changed(amount: int):
	ring_label.text = "RINGS: " + str(amount)

func _on_lives_changed(amount: int):
	lives_label.text = "LIVES: " + str(amount)

func _on_health_changed(current_health: float, max_health: float):
	health_bar.max_value = max_health
	health_bar.value = current_health
	
	health_label.text = "HP  %d / %d" % [roundi(current_health), roundi(max_health)]

func update_ability(ability: Ability, label: Label, cooldown_label: Label) -> void:
	if ability == null:
		label.text = "Unavailable"
		cooldown_label.text = ""
		return
	
	if ability.is_active():
		label.text = "ACTIVE"
		cooldown_label.text = ""
	elif ability.is_on_cooldown():
		label.text = "COOLDOWN"
		cooldown_label.text = "%.1f s" % ability.get_cooldown_remaining()
	else:
		label.text = "READY"
		cooldown_label.text = ""

func update_abilities() -> void:
	update_ability(player.dash_ability, dash_label, dash_cooldown)
	
	update_ability(player.ground_slam_ability, ground_slam_label, ground_slam_cooldown)

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
	
	ability_refresh_timer += _delta
	if ability_refresh_timer >= 0.1:
		ability_refresh_timer = 0.0
		update_abilities()

func close_dialogue() -> void:
	dialogue_open = false
	dialogue_box.visible = false
	dialogue_finished.emit()
