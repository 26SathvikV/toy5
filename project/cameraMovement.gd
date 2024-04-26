extends Camera2D


var player
var playerExists = true

func _ready():
	player = get_parent().get_node("player")

func disableCamera():
	playerExists = false;

func enableCamera():
	playerExists = true;

func _process(_delta):
	if (playerExists):
		position.x = player.position.x
		position.y = player.position.y
