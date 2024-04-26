extends CharacterBody2D

var jump_speed = -1000.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var walkspeed = 400
var isJumping = false
var doubleJump = false
var memoryCount = 0
var inMemory = false
var inStatue = false
var inDoor = false
var inSaveStatue = false
var doorOpen = false
var currAnim = "rightIdle"
var currStatue = null
var currProgression = 0
var medallionCount = 0
var currLevel = "res://tutorial.tscn"
var currLvlRep = 0
var savePath = "user://saveData.save"
var tree = null
var inCycle = false
var inMedallion = false
var inNButton = false
var inDButton = false
var finishedDay = false
var finishedNight = false
var inJumppad = false

func _ready():
	queue_redraw()
	tree = get_tree()
	reset()
	loadSave()

func get_input(delta):
	velocity.y += gravity * delta * 2

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
		doubleJump = true
		isJumping = true
		get_parent().get_node("audio/jump").play()
	elif Input.is_action_just_pressed("jump") and doubleJump:
		velocity.y = jump_speed
		doubleJump = false
		get_parent().get_node("audio/jump").play()
	elif isJumping and is_on_floor():
		isJumping = false
		get_parent().get_node("audio/land").play()

	# Get the input direction.
	var direction = Input.get_axis("left", "right")
	velocity.x = direction * walkspeed

func changeAnim():
	if velocity.x < 0 and isJumping:
		currAnim = "leftJump"
	elif velocity.x > 0 and isJumping:
		currAnim = "rightJump"
	elif velocity.x < 0:
		currAnim = "leftMov"
	elif velocity.x > 0:
		currAnim = "rightMov"
	elif currAnim == "leftMov":
		currAnim = "leftIdle"
	elif currAnim == "rightMov":
		currAnim = "rightIdle"

func kill():
	queue_redraw()
	tree.change_scene_to_file("res://death.tscn")

func checkDeath():
	var deathArea = get_parent().get_node("deathStatic")
	for index in get_slide_collision_count():
		var collision := get_slide_collision(index)
		var body := collision.get_collider()
		if (body == deathArea):
			kill()

func giveMemory():
	memoryCount = memoryCount + 1
	get_parent().get_node("audio/get").play()
	get_parent().get_node("memory").queue_free()

func takeMemory():
	if (memoryCount > 0):
		memoryCount = memoryCount - 1
		get_parent().get_node("audio/insert").play()
		get_parent().get_node("endStatue/statueSprite").animation = "lit"
		get_parent().get_node("door/doorSprite").play("opening")
		get_parent().get_node("audio/doorOpen").play()
		doorOpen = true
		return true
	else:
		return false

func giveMedallion():
	medallionCount = medallionCount + 1;
	get_parent().get_node("medallion").kill()
	
	var file = FileAccess.open(savePath, FileAccess.WRITE)
	file.store_var(position.x)
	file.store_var(position.y)
	file.store_var(currProgression)
	file.store_var(currLvlRep)
	file.store_var(memoryCount)
	file.store_var(medallionCount)
	file.close()

func changeTooltip(string):
	get_parent().get_node("camera/tooltip").text = string

func loadSave():
	if FileAccess.file_exists(savePath):
		var file = FileAccess.open(savePath, FileAccess.READ)
		position.x = file.get_var(position.x)
		position.y = file.get_var(position.y)
		currProgression = file.get_var(currProgression)
		currLvlRep = file.get_var(currLvlRep)
		memoryCount = file.get_var(memoryCount)
		medallionCount = file.get_var(medallionCount)
		file.close()
		interpLvl()

func reset():
	var file = FileAccess.open(savePath, FileAccess.WRITE)
	position.x = 0
	position.y = 325
	currProgression = 0
	currLvlRep = 0
	memoryCount = 0
	medallionCount = 0
	file.store_var(position.x)
	file.store_var(position.y)
	file.store_var(currProgression)
	file.store_var(currLvlRep)
	file.store_var(memoryCount)
	file.store_var(medallionCount)
	file.close()

func save():
	get_parent().get_node(currStatue).animation = "lit"
	get_parent().get_node("audio/save").play()
	
	var file = FileAccess.open(savePath, FileAccess.WRITE)
	file.store_var(position.x)
	file.store_var(position.y)
	file.store_var(currProgression)
	file.store_var(currLvlRep)
	file.store_var(memoryCount)
	file.store_var(medallionCount)
	file.close()

func saveHub():
	currProgression += 1
	currLvlRep = -1
	currStatue = null
	position.x = -300
	position.y = 325
	
	var file = FileAccess.open(savePath, FileAccess.WRITE)
	file.store_var(position.x)
	file.store_var(position.y)
	file.store_var(currProgression)
	file.store_var(currLvlRep)
	file.store_var(memoryCount)
	file.store_var(medallionCount)
	file.close()

func interpLvl():
	if currLvlRep == -1:
		currLevel = "res://hub.tscn"
	elif currLvlRep == 0:
		currLevel = "res://tutorial.tscn"
	elif currLvlRep == 1:
		currLevel = "res://ch1.tscn"


func finishCh():
	tree.change_scene_to_file("res://hub.tscn")
	saveHub()
	if (currProgression == 2):
		tree.change_scene_to_file("res://endTemp.tscn")

func changeCycle():
	get_parent().get_node("cycle").change()

func _physics_process(delta):
	get_input(delta)
	changeAnim()
	$playerSprite.animation = currAnim
	
	if velocity.x != 0 and is_on_floor() and !get_parent().get_node("audio/footstep").playing:
		get_parent().get_node("audio/footstep").play()
	
	if is_on_floor():
		checkDeath()
	
	if (inMemory and Input.is_action_just_pressed("interact")):
		giveMemory()
	
	if (inStatue and Input.is_action_just_pressed("interact")):
		takeMemory()
		
	if (inSaveStatue and Input.is_action_just_pressed("interact")):
		save()
		
	if (get_parent().get_node("door/doorSprite").get_frame() == 9 and doorOpen):
		get_parent().get_node("audio/doorOpen").stop()
		get_parent().get_node("door/doorSprite").stop()
		get_parent().get_node("door/doorSprite").animation = "open"
	
	if (inDoor and doorOpen and Input.is_action_just_pressed("interact")):
		finishCh()
	
	if (inCycle and Input.is_action_just_pressed("interact")):
		changeCycle()
	
	if (inMedallion and Input.is_action_just_pressed("interact")):
		giveMedallion()
	
	if (inJumppad and Input.is_action_just_pressed("jump")):
		velocity.y = -2500
	
	if (inDButton and Input.is_action_just_pressed("interact")):
		finishedDay = true;
		position.x = 7600;
		position.y = -600;
		
		if (finishedNight):
			position.x = 5550
			position.y = -2000
	
	if (inNButton and Input.is_action_just_pressed("interact")):
		finishedNight = true;
		position.x = 7600;
		position.y = -600;
		
		if (finishedDay):
			position.x = 6150
			position.y = -1750
	
	move_and_slide()


func _on_memory_body_entered(_body):
	inMemory = true
	changeTooltip("Press E to Pick Up")

func _on_memory_body_exited(_body):
	inMemory = false
	changeTooltip("")

func _on_end_statue_body_entered(_body):
	inStatue = true
	if (memoryCount > 0):
		changeTooltip("Press E to Place")

func _on_end_statue_body_exited(_body):
	inStatue = false
	changeTooltip("")

func _on_door_body_entered(_body):
	inDoor = true
	if (doorOpen):
		changeTooltip("Press E to Enter")

func _on_door_body_exited(_body):
	inDoor = false
	changeTooltip("")

func _on_cycle_body_entered(_body):
	inCycle = true
	changeTooltip("Press E to Change")

func _on_cycle_body_exited(_body):
	inCycle = false
	changeTooltip("")

func _on_save_statue_1_body_entered(_body):
	inSaveStatue = true
	currStatue = "saveStatue1/statueSprite"
	changeTooltip("Press E to Save")

func _on_save_statue_1_body_exited(_body):
	inSaveStatue = false
	currStatue = ""
	changeTooltip("")

func _on_save_statue_2_body_entered(_body):
	inSaveStatue = true
	currStatue = "saveStatue2/statueSprite"
	changeTooltip("Press E to Save")

func _on_save_statue_2_body_exited(_body):
	inSaveStatue = false
	currStatue = ""
	changeTooltip("")

func _on_save_statue_3_body_entered(body):
	inSaveStatue = true
	currStatue = "saveStatue3/statueSprite"
	changeTooltip("Press E to Save")

func _on_save_statue_3_body_exited(body):
	inSaveStatue = false
	currStatue = ""
	changeTooltip("")

func _on_m_area_body_entered(body):
	inMedallion = true
	changeTooltip("Press E to Take")

func _on_m_area_body_exited(body):
	inMedallion = false
	changeTooltip("")

func _on_n_button_area_body_entered(area_rid, area, area_shape_index, local_shape_index):
	inNButton = true
	changeTooltip("Press E to Press")

func _on_n_button_area_body_exited(area_rid, area, area_shape_index, local_shape_index):
	inNButton = false
	changeTooltip("")

func _on_d_button_area_body_entered(body):
	inDButton = true
	changeTooltip("Press E to Press")

func _on_d_button_area_body_exited(body):
	inDButton = false
	changeTooltip("")

func jumppadEntered():
	inJumppad = true
	changeTooltip("Press Space to Jump Higher")

func jumppadExited():
	print("exited")
	inJumppad = false
	changeTooltip("")

func nButtonEntered():
	inNButton = true
	changeTooltip("Press E to Press")

func nButtonExited():
	inNButton = false
	changeTooltip("")

func dButtonEntered():
	inDButton = true
	changeTooltip("Press E to Press")

func dButtonExited():
	inDButton = false
	changeTooltip("")
