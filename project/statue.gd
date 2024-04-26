extends AnimatedSprite2D


var gotMemory = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func takeMemory():
	get_parent().get_node("player").takeMemory()
	gotMemory = true
	animation = "lit"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
