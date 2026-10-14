extends CanvasLayer

@onready var debug_panel: Control = $AbilityDebugPanel
@onready var debug_label: Label = $AbilityDebugPanel/MarginContainer/Label

var debug_visible := false
func _ready() -> void:
	debug_panel.visible = debug_visible

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_ability_debug"):
		debug_visible = !debug_visible
		debug_panel.visible = debug_visible
		get_viewport().set_input_as_handled()

func _process(delta: float) -> void:
	if not debug_visible:
		return
	
	var player = get_tree().get_first_node_in_group("player")
	
	if player == null:
		debug_label.text = "ABILITY DEBUG\nPlayer not found"
		return
	
	var ability_system = player.get_node_or_null("AbilitySystem")
	
	if ability_system == null:
		debug_label.text = "ABILITY DEBUG\nAbilitySystem not found"
		return
	
	var abilities = ability_system.get_abilities()
	var lines: Array[String] = []
	
	lines.append("=== ABILITY DEBUG ===")
	var active_abilities: Array[String] = []
	
	for ability in abilities:
		if not is_instance_valid(ability):
			continue
		
		var ability_name = ability.name
		var state = ability.get_state_name()
		var cooldown = ability.get_cooldown_remaining()

		if ability.is_active():
			active_abilities.append(ability_name)
		
		if cooldown > 0.0:
			lines.append(
				"%s | %s | %.1f s" %
				[ability_name, state, cooldown]
			)
		else:
			lines.append(
				"%s | %s" % [ability_name, state]
			)
	
	if active_abilities.is_empty():
		lines.append("")
		lines.append("Active: none")
	else:
		lines.append("")
		lines.append(
			"Active: " + ", ".join(active_abilities)
		)

	debug_label.text = "\n".join(lines)
