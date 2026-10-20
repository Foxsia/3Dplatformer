extends EnemyBase
class_name MeleeEnemy

@export_group("Combat")
@export var attack_range: float = 0.85
@export var attack_cooldown := 1.2

@export_group("Abilities")
@export var ability_system: AbilitySystem
@export var melee_ability: Ability

var attack_timer: float = 0.0

func _ready() -> void:
	super._ready()
	
	if melee_ability and ability_system:
		ability_system.register_ability(melee_ability)

func get_attack_range() -> float:
	return attack_range

func start_attack() -> void:
	if attack_timer > 0.0:
		return

	if not ability_system or not melee_ability:
		return

	if ability_system.request_activation(melee_ability):
		attack_timer = attack_cooldown

func _physics_process(delta: float) -> void:
	attack_timer = maxf(0.0, attack_timer - delta)
	super._physics_process(delta)
