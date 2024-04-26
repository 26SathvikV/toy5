extends Sprite2D

var player : CharacterBody2D;
var entered = false;

func _ready():
	player = get_parent().get_node("player")


func _process(delta):
	if ($nButtonArea/nButtonCollison.disabled == false and position.distance_to(player.position) <= 100):
		player.nButtonEntered();
		entered = true;
	elif (entered):
		player.nButtonExited()
		entered = false;
