class_name EnemyDeathState
extends EnemyState

@export var death_duration: float = 1.5

var timer: float = 0.0
var finished: bool = false

func enter() -> void:
	enemy.velocity = Vector3.ZERO
	enemy.play_animation("death")

func physics_update(_delta: float) -> void:
	enemy.velocity = Vector3.ZERO
