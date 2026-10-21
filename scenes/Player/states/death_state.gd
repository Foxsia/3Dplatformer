class_name PlayerDeathState
extends PlayerState

func enter() -> void:
	player.velocity = Vector3.ZERO
	player.play_animation("death")

func physics_update(_delta: float) -> void:
	player.velocity = Vector3.ZERO
