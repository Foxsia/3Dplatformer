extends CanvasLayer

@onready var ring_label = $RingLabel
@onready var lives_label = $LivesLabel
@onready var player = $"../Player"

func _ready():
	GameManager.rings_changed.connect(_on_rings_changed)
	_on_rings_changed(GameManager.rings)
	player.lives_changed.connect(_on_lives_changed)
	_on_lives_changed(player.lives)

func _on_rings_changed(amount):
	ring_label.text = "RINGS: " + str(amount)

func _on_lives_changed(amount):
	lives_label.text = "LIVES: " + str(amount)
