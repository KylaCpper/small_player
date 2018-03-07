extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	get_node("bg").play()
	#get_node("/root/overall").SetReady()
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func pause_bg(bool_):
	get_node("bg").set_paused(bool_)
func shop_bg(bool_):
	pause_bg(bool_)
	if(bool_):
		get_node("shop").play()
	else:
		get_node("shop").stop()
	pass
func boss_bg(bool_):
	pause_bg(bool_)
	if(bool_):
		get_node("boss").play()
	else:
		get_node("boss").stop()
	pass
func misc(name,poly=false):
	get_node("misc").play(name,poly)
func move(name):
	if(!get_node("misc").is_active()):
		misc(name)
func set_sound_bg(num):
	get_node("bg").set_volume(num)
	get_node("shop").set_volume(num)
	get_node("boss").set_volume(num)
	pass
func set_sound_effect(num):
	get_node("misc").set_default_volume(num) 
	pass