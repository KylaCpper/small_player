extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var boss
var act=0
var repeat=0
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	boss = preload("res://scene/main/boss.tscn")
	get_tree().call_group(0,"save_control","_on_ready",self.get_name())
	pass

func clear_monster(kill=0):
	if(!repeat):
		if(kill):
			repeat=1
			kill_boss()
	act=0
	get_node("boss").queue_free()
	var night=get_node("/root/overall").GetData("night")
	get_tree().call_group(0,"option button","set_start_night",night)
	get_tree().call_group(0,"sound","boss_bg",false)
	get_tree().call_group(0,"door","open")
	get_tree().call_group(0,"light","close")
	pass
func clear_monster_delay():
	get_node("Timer").start()
	pass
func set_monster_hp(hp):
	get_node("boss/hp bar").set_value(hp)
	pass
func set_monster_hp_cap(hp_cap):
	get_node("boss/hp bar").set_max(hp_cap)
	set_monster_hp(hp_cap)
	pass

func kill_boss():
	get_parent().get_node("kill boss/window").show()
	pass

func init_boss():
	if(act):return
	act=1
	_on_close()
	var tscn=boss.instance()
	add_child(tscn)
	var monster=get_node("/root/config").GetConfig("Monsters")
	set_monster_hp_cap(monster.boss.hp)
	get_tree().call_group(0,"sound","boss_bg",true)
	get_tree().call_group(0,"door","close")
	get_tree().call_group(0,"light","open")
	pass # replace with function body


func _on_close():
	get_parent().get_node("pop windows/boss").hide()
	pass # replace with function body


func _on_timeout_1():
	clear_monster()
	pass # replace with function body
func _on_save():
	return {
		"repeat":repeat
	}
func _on_load(data):
	repeat=data.repeat