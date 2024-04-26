extends Node

var player : CharacterBody2D;

func _ready():
	player = get_parent().get_node("player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for child : AudioStreamPlayer2D in get_children():
		child.position = player.position;
