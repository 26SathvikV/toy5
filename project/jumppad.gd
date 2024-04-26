extends Sprite2D

var player : CharacterBody2D;
var entered = false;

func _ready():
	player = get_parent().get_node("player")


func _process(delta):
	if ($jumpadArea/jumppadCollision.disabled == false and !entered and position.distance_to(player.position) <= 100):
		player.jumppadEntered();
		entered = true;
	elif (entered):
		player.jumppadExited()
		entered = false;
