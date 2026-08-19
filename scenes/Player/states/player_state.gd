class_name PlayerState
extends RefCounted

var player : CharacterBody3D

func _init(player_ref: CharacterBody3D):
	player = player_ref

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass
