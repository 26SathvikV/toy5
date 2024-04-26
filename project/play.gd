extends Button


var savePath = "user://saveData.save"
var currLvlRep = 0
var currLevel = "res://tutorial.tscn"
var currProgression = 0
var memoryCount = 0
var positionx = 0
var positiony

func _ready():
	loadSave()

func _process(_delta):
	pass

func loadSave():
	if FileAccess.file_exists(savePath):
		var file = FileAccess.open(savePath, FileAccess.READ)
		positionx = file.get_var(position.x)
		positiony = file.get_var(position.y)
		currProgression = file.get_var(currProgression)
		currLvlRep = file.get_var(currLvlRep)
		memoryCount = int(file.get_var(memoryCount))
		file.close()
		interpLvl()

func interpLvl():
	if currLvlRep == -1:
		currLevel = "res://hub.tscn"
	elif currLvlRep == 0:
		currLevel = "res://tutorial.tscn"
	elif currLvlRep == 1:
		currLevel = "res://ch1.tscn"

func _on_button_down():
	get_tree().change_scene_to_file(currLevel)
