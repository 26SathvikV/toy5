extends Button


func _ready():
	pass # Replace with function body.

func _process(_delta):
	pass


func _on_button_down():
	get_tree().change_scene_to_file("res://playui.tscn")
