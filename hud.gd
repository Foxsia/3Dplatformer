extends CanvasLayer

@onready var ring_label = $RingLabel

func _ready():
	GameManager.rings_changed.connect(_on_rings_changed)
	_on_rings_changed(GameManager.rings)

func _on_rings_changed(amount):
	ring_label.text = "RINGS: " + str(amount)
