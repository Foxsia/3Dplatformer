extends EnemyBase
class_name MeleeEnemy

@export var melee_ability_path: NodePath = ^"MeleeAttackAbility"
@export var attack_cooldown := 1.2

@onready var melee_ability = get_node_or_null(melee_ability_path)

var attack_timer: float = 0.0

func _ready() -> void:
	super._ready()
	
	if melee_ability:
		$AbilitySystem.register_ability(melee_ability)

func update_enemy_ai(delta: float) -> void:
	attack_timer = maxf(0.0, attack_timer - delta)
	target = find_player()
