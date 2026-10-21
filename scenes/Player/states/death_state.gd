class_name PlayerDeathState
extends PlayerState

@export var death_duration: float = 1.5

var timer: float = 0.0
var finished: bool = false

func enter() -> void:
	timer = 0.0
	finished = false
	player.velocity = Vector3.ZERO
	player.play_animation("death")

func physics_update(_delta: float) -> void:
	player.velocity = Vector3.ZERO
	
	if finished:
		return
	
	timer += _delta
	
	if timer >= death_duration:
		finished = true
		player.finish_death()
