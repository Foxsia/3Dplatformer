class_name EnemyDeathState
extends EnemyState

var death_duration: float = 1.5
var timer: float = 0.0
var finished: bool = false

func enter() -> void:
	timer = 0.0
	finished = false
	
	enemy.velocity = Vector3.ZERO
	
	if enemy.animation_playback:
		enemy.animation_playback.travel("death")

func physics_update(_delta: float) -> void:
	enemy.velocity = Vector3.ZERO
	
	if finished:
		return
	
	timer += _delta
	
	if timer >= death_duration:
		finished = true
		enemy.queue_free()
