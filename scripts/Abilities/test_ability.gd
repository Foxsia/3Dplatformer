extends Ability

var remaining := 1.0


func _on_activate():
	remaining = 1.0
	print("TEST ABILITY: ACTIVATED")


func _on_update(delta):
	remaining -= delta

	if remaining <= 0.0:
		print("TEST ABILITY: FINISHED")
		finish()
