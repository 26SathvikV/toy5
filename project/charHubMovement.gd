extends CharacterBody2D

var jump_speed = -1000.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var walkspeed = 400
var isJumping = false
var doubleJump = false
var currDoor = 0
var currProgression = 1
var inDoor = false
var currLvlRep = 0
var memoryCount = 0
var currAnim = "rightIdle"
var savePath = "user://saveData.save"
var tree

func _ready():
	queue_redraw()
	tree = get_tree()
	
	loadSave()
	
	if (currProgression >= 0):
		get_parent().get_node("tutDoor/doorSprite").animation = "open"
	elif (currProgression >= 1):
		get_parent().get_node("door1/doorSprite").animation = "open"
	elif (currProgression >= 2):
		get_parent().get_node("door2/doorSprite").animation = "open"
	elif (currProgression >= 3):
		get_parent().get_node("door3/doorSprite").animation = "open"
	elif (currProgression >= 4):
		get_parent().get_node("door4/doorSprite").animation = "open"
	elif (currProgression >= 5):
		get_parent().get_node("door5/doorSprite").animation = "open"
	elif (currProgression >= 6):
		get_parent().get_node("door6/doorSprite").animation = "open"

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

func changeTooltip(string):
	get_parent().get_node("camera/tooltip").text = string

func enterChapter():
	currLvlRep = currDoor
	save()
	print(currLvlRep)
	
	if (currDoor == 0):
		currLvlRep = 0
		save()
		tree.change_scene_to_file("res://tutorial.tscn")
	elif (currDoor == 1):
		currLvlRep = 1
		save()
		tree.change_scene_to_file("res://ch1.tscn")

func loadSave():
	if FileAccess.file_exists(savePath):
		var file = FileAccess.open(savePath, FileAccess.READ)
		position.x = file.get_var(position.x)
		position.y = file.get_var(position.y)
		currProgression = file.get_var(currProgression)
		currLvlRep = file.get_var(currLvlRep)
		memoryCount = int(file.get_var(memoryCount))
		file.close()

func reset():
	var file = FileAccess.open(savePath, FileAccess.WRITE)
	file.store_var(0)
	file.store_var(325)
	file.store_var(0)
	file.store_var(0)
	file.store_var(0)
	file.close()

func save():
	var file = FileAccess.open(savePath, FileAccess.WRITE)
	file.store_var(position.x)
	file.store_var(position.y)
	file.store_var(currProgression)
	file.store_var(currLvlRep)
	file.store_var(memoryCount)
	file.close()

func saveHub():
	currProgression += 1
	currLvlRep = -1
	position.x = -300
	position.y = 325
	
	var file = FileAccess.open(savePath, FileAccess.WRITE)
	file.store_var(position.x)
	file.store_var(position.y)
	file.store_var(currProgression)
	file.store_var(currLvlRep)
	file.store_var(memoryCount)
	file.close()

func _physics_process(delta):
	get_input(delta)
	changeAnim()
	$playerSprite.animation = currAnim
	
	if velocity.x != 0 and is_on_floor() and !get_parent().get_node("audio/footstep").playing:
		get_parent().get_node("audio/footstep").play()
	
	if is_on_floor():
		checkDeath()
	
	if (inDoor and Input.is_action_just_pressed("interact")):
		enterChapter()
	
	move_and_slide()


func exitedDoor():
	currDoor = -1
	inDoor = false
	changeTooltip("")

func _on_tut_door_body_entered(_body):
	currDoor = 0
	if (currProgression >= 0):
		inDoor = true
		changeTooltip("Press E to Enter Tutorial")

func _on_tut_door_body_exited(_body):
	exitedDoor()

func _on_door_1_body_entered(_body):
	currDoor = 1
	if (currProgression >= 1):
		inDoor = true
		changeTooltip("Press E to Enter Chapter 1")

func _on_door_1_body_exited(_body):
	exitedDoor()

func _on_door_2_body_entered(_body):
	currDoor = 2
	if (currProgression >= 2):
		inDoor = true
		changeTooltip("Press E to Enter Chapter 2")

func _on_door_2_body_exited(_body):
	exitedDoor()

func _on_door_3_body_entered(_body):
	currDoor = 3
	if (currProgression >= 3):
		inDoor = true
		changeTooltip("Press E to Enter Chapter 3")

func _on_door_3_body_exited(_body):
	exitedDoor()

func _on_door_4_body_entered(_body):
	currDoor = 4
	if (currProgression >= 4):
		inDoor = true
		changeTooltip("Press E to Enter Chapter 4")

func _on_door_4_body_exited(_body):
	exitedDoor()

func _on_door_5_body_entered(_body):
	currDoor = 5
	if (currProgression >= 5):
		inDoor = true
		changeTooltip("Press E to Enter Chapter 5")

func _on_door_5_body_exited(_body):
	exitedDoor()

func _on_door_6_body_entered(_body):
	currDoor = 6
	if (currProgression >= 6):
		inDoor = true
		changeTooltip("Press E to Enter Chapter 6")

func _on_door_6_body_exited(_body):
	exitedDoor()
