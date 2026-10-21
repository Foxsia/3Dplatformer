class_name EnemyHitState
extends EnemyState

var hit_duration := 0.4
var timer := 0.0

func enter() -> void:
	timer = 0.0
	enemy.is_hit = true
	enemy.stop_movement()
	enemy.is_attacking = false
	
	if enemy.animation_playback:
		enemy.animation_playback.travel("hit")

func physics_update(_delta: float) -> void:
	timer += _delta
	
	enemy.velocity.x = 0.0
	enemy.velocity.z = 0.0
	
	if timer >= hit_duration:
		enemy.is_hit = false
		var player = enemy.find_player()

		if player != null:
			enemy.state_machine.change_state(enemy.chase_state)
		else:
			enemy.state_machine.change_state(enemy.idle_state)

func exit() -> void:
	enemy.is_hit = false
