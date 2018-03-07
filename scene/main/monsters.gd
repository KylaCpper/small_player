extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var monster_night=["monster0_1","monster1_1","monster2_1","boss"]
var monster_reward=[{"money":100,"expe":100},{"money":500,"expe":500},{"money":1000,"expe":1000}]
var monster
var night=0
var monster_num=3
var boss_index=3
var act=0
var enter=0
func _ready():
	monster=preload("res://scene/main/monster.tscn")
	get_node("time").connect("timeout",self,"_on_timeout")
	get_node("area").connect("body_enter",self,"_on_in",[true])
	get_node("area").connect("body_exit",self,"_on_in",[false])
	get_tree().call_group(0,"save_control","_on_ready",self.get_name())
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("/root/overall").SetData("night",night)
	get_tree().call_group(0,"option button","set_start_night",night)
	pass
func _on_in(obj,be):
	if(str(obj.get_name())=="player"):
		enter=be
func _on_start_night():
	if(!enter):
		get_node("/root/overall").MsgSend(self,tr("enter the night outside"))
		return
	if(night==boss_index):
		get_tree().call_group(0,"boss","init_boss")
		return
	if(act):return
	get_tree().call_group(0,"sound","boss_bg",true)
	get_tree().call_group(0,"door","close")
	get_tree().call_group(0,"light","open")
	for i in range(monster_num):
		act=1
		var monster_tscn=monster.instance()
		add_child(monster_tscn)
		var pos=monster_tscn.get_pos()
		pos.x+=30*i
		pos.y-=30*i
		monster_tscn.set_pos(pos)
	pass
var num=0
func monster_die():
	num+=1
	if(num==monster_num):
		num=0
		#获得过夜奖励
		night+=1
		act=0
		get_tree().call_group(0,"sound","boss_bg",false)
		get_tree().call_group(0,"door","open")
		get_tree().call_group(0,"light","close")
		get_tree().call_group(0,"option button","set_start_night",night)
		get_node("/root/overall").SetData("night",night)
		var night_be=night-1
		get_tree().call_group(0,"player","pass_night",monster_reward[night_be].money,monster_reward[night_be].expe,night)
		get_tree().call_group(0,"pop windows","pass_night",night,monster_reward[night_be])
		
	pass
func _on_timeout():
	#get_tree().call_group(0,"sound","boss_bg",false)
	act=0
	get_tree().call_group(0,"sound","boss_bg",false)
	get_tree().call_group(0,"door","open")
	get_tree().call_group(0,"light","close")
	get_tree().call_group(0,"monster","clear_monster")
	pass
func clear_monster_delay():
	get_node("time").start()
	pass
func _on_save():
	return {
		"night":night
	}
func _on_load(data):
	night=data.night
	get_tree().call_group(0,"option button","set_start_night",night)
	get_node("/root/overall").SetData("night",night)