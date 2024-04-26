extends Sprite2D

var xPos = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(_delta):
	move_local_x(xPos)
	xPos = xPos + 1
