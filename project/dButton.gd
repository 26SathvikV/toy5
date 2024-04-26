extends Sprite2D

var player : CharacterBody2D;
var entered = false;

func _ready():
	player = get_parent().get_node("player")


func _process(delta):
	if ($dButtonArea/dButtonCollision.disabled == false and position.distance_to(player.position) <= 100):
		player.dButtonEntered();
		entered = true;
	elif (entered):
		player.dButtonExited()
		entered = false;
