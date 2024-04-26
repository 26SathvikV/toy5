extends Area2D

var savePath = "user://cycleData.save"
var time = "night"
var timeRep = 0
var activated = false
var cloudTex
var nightSky
var daySky
var moon
var sun

func _ready():
	cloudTex = load("res://lvl1_clouds.png")
	nightSky = load("res://night_sky.png")
	daySky = load("res://day_sky.png")
	moon = load("res://moon.png")
	sun = load("res://sun.png")
	reset()
	loadSave()

func turn(time, finRot):
	$cycleArrow.rotation = lerp_angle($cycleArrow.rotation,finRot,time)
	
	if time < 1:
		time += 0.1
		await get_tree().create_timer(0.05).timeout
		turn(time, finRot)
	elif time > 1:
		turn(1.0,finRot)

func changeNight():
	time = "night"
	timeRep = 0
	
	for sky in get_parent().get_node("bg/sky").get_children():
		sky.texture = nightSky
	
	for moon in get_parent().get_node("bg/moon").get_children():
		moon.texture = moon
	
	for nObj in get_tree().get_nodes_in_group("night"):
		nObj.visible = true
		if (nObj.get_class() == "CollisionShape2D"):
			nObj.disabled = false
	
	for dObj in get_tree().get_nodes_in_group("day"):
		dObj.visible = false
		if (dObj.get_class() == "CollisionShape2D"):
			dObj.disabled = true
	
	save()

func changeDay():
	time = "day"
	timeRep = 1
	
	for sky in get_parent().get_node("bg/sky").get_children():
		sky.texture = daySky
	
	for moon in get_parent().get_node("bg/moon").get_children():
		moon.texture = sun
	
	for dObj in get_tree().get_nodes_in_group("day"):
		dObj.visible = true
		if (dObj.get_class() == "CollisionShape2D"):
			dObj.disabled = false
	
	for nObj in get_tree().get_nodes_in_group("night"):
		nObj.visible = false
		if (nObj.get_class() == "CollisionShape2D"):
			nObj.disabled = true
	
	save()

func changeClouds():
	for cloud in get_parent().get_node("bg/clouds").get_children():
		cloud.texture = cloudTex

func activate():
	activated = true
	
	var finRot = $cycleArrow.rotation + PI/2
	turn(0.1, finRot)
	
	changeClouds()
	changeNight()

func change():
	if (!activated):
		activate()
	else:
		var finRot = $cycleArrow.rotation + PI + 5 * TAU
		for cycle in get_parent().get_tree().get_nodes_in_group("cycleCh1"):
			cycle.turn(0.1, finRot)
		
		if (time == "night"):
			changeDay()
		else:
			changeNight()

func reset():
	var file = FileAccess.open(savePath, FileAccess.WRITE)
	file.store_var(-1)
	file.store_var(false)
	file.close()

func save():
	var file = FileAccess.open(savePath, FileAccess.WRITE)
	file.store_var(timeRep)
	file.store_var(activated)
	file.close()

func loadSave():
	if FileAccess.file_exists(savePath):
		var file = FileAccess.open(savePath, FileAccess.READ)
		timeRep = file.get_var(timeRep)
		activated = file.get_var(activated)
		
		if (timeRep == 0):
			$cycleArrow.rotation = PI
			changeClouds()
			changeNight()
		elif (timeRep == 1):
			$cycleArrow.rotation = 0
			changeClouds()
			changeDay()
		
		file.close()

func _process(_delta):
	pass
