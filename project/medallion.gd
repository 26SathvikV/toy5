extends Sprite2D

var savePath = "user://medallionSave.save"
var alive = true

# Called when the node enters the scene tree for the first time.
func _ready():
	var chNum = get_parent().get_node("player").currLvlRep
	savePath = "user://medallionSave" + String.num(chNum,0) + ".save"
	loadSave()

func loadSave():
	if FileAccess.file_exists(savePath):
		var file = FileAccess.open(savePath, FileAccess.READ)
		alive = file.get_var(alive)
		if (!alive):
			kill()

func kill():
	alive = false
	var file = FileAccess.open(savePath, FileAccess.WRITE)
	file.store_var(alive)
	file.close()
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
