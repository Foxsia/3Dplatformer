extends EnemyBase
class_name MeleeEnemy

@export_group("Combat")
@export var attack_range: float = 1.0
@export var attack_cooldown := 1.2

@export_group("Abilities")
@export var ability_system: AbilitySystem
@export var melee_ability: Ability

var attack_timer: float = 0.0

func _ready() -> void:
	super._ready()
	
	if melee_ability:
		ability_system.register_ability(melee_ability)

func update_enemy_ai(delta: float) -> void:
	attack_timer = maxf(0.0, attack_timer - delta)
	target = find_player()
	
	if target == null:
		stop_movement()
		return
	
	var distance = global_position.distance_to(target.global_position)
	
	face_target(target)
	
	if distance > attack_range:
		move_towards_position(target.global_position)
		return
	
	stop_movement()
	
	if attack_timer <= 0.0 and ability_system and melee_ability:
		if ability_system.request_activation(melee_ability):
			attack_timer = attack_cooldown
