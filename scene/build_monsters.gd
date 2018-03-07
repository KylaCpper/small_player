extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var Monster_tscn={
	"monster0":null,
	"monster1":null,
	"monster2":null
}
var Monster_texture={
	"blue_slime":null,
	"red_slime":null,
	"green_slime":null
}
var tscn_name="monster0"
var tscn_arr={
	"monster0":{"name":0,"money":0},
	"monster1":{"name":0,"money":0},
	"monster2":{"name":0,"money":0}
}
var tscn_arr_auto={
	"monster0":{"name":0,"money":0},
	"monster1":{"name":0,"money":0},
	"monster2":{"name":0,"money":0},
	"nexts":[]
}
var auto_monster=0
func _ready():
	var scene=get_node("/root/overall").GetScene()
	var texture=get_node("/root/overall").GetTexture()
	Monster_texture.blue_slime = texture.blue_slime
	Monster_texture.red_slime = texture.red_slime
	Monster_texture.green_slime = texture.green_slime
	Monster_tscn.monster0 = scene.monster0
	Monster_tscn.monster1 = scene.monster1
	Monster_tscn.monster2 = scene.monster2
	# Called every time the node is added to the scene.
	# Initialization here
	#set_fixed_process(true)
	get_tree().call_group(0,"save_control","_on_ready",self.get_name())
	pass
func set_monster(monster_name,tscn_name):
	var config=get_node("/root/config").GetConfig("Monsters")

	get_node(tscn_name+"/Sprite").set_texture(Monster_texture[config[monster_name].texture])
func _on_init_monster(monster_name,money,auto=0):
	if(!tscn_name):
		return
	if(auto_monster):
		if(!auto):
			return
	tscn_monster_init(monster_name,money)
	_tscn_arrangement()
	pass
func tscn_monster_init(monster_name,money):
	var tscn=Monster_tscn[tscn_name].instance()
	add_child(tscn)
	set_monster(monster_name,tscn_name)
	get_tree().call_group(0,"player","_on_monster_init",monster_name,tscn_name,money)
	set_monster_hp_cap(monster_name,tscn_name)
	tscn_arr[tscn_name].name=monster_name
	tscn_arr[tscn_name].money=money
	pass
func _on_clear_monster(tscn_name):
	get_node(tscn_name).queue_free()
	tscn_arr_auto[tscn_name].name=tscn_arr[tscn_name].name
	tscn_arr_auto[tscn_name].money=tscn_arr[tscn_name].money
	tscn_arr[tscn_name].name=0
	_tscn_arrangement()
	if(auto_monster):
		tscn_arr_auto.nexts.append(tscn_name)
		get_node("Timer").start()
	pass
func set_monster_hp(tscn_name,hp):
	get_node(tscn_name+"/hp bar").set_value(hp)
	pass
func set_monster_hp_cap(monster_name,tscn_name):
	var monsters=get_node("/root/config").GetConfig("Monsters")
	get_node(tscn_name+"/hp bar").set_max(monsters[monster_name].hp)
	pass
func _tscn_arrangement():
	for key in tscn_arr:
		if(!tscn_arr[key].name):
			tscn_name=key
			return
	tscn_name=0

func _on_timeout_1():
	if(tscn_arr_auto.nexts.size()):
		_on_init_monster(tscn_arr_auto[tscn_arr_auto.nexts[0]].name,tscn_arr_auto[tscn_arr_auto.nexts[0]].money,1)
		(tscn_arr_auto.nexts).pop_front()
	
	pass
func _on_auto_monster():
	if(auto_monster):
		auto_monster_stop()
	else:
		auto_monster_start()
	pass
func auto_monster_stop():
	get_parent().get_node("option button/auto monster").set_text("auto monster")
	get_node("Timer").stop()
	auto_monster=0
	pass
func auto_monster_start():
	get_parent().get_node("option button/auto monster").set_text(tr("cancel")+tr("auto monster"))
	auto_monster=1
	pass
func _on_save():
	var data={}
	for key in tscn_arr:
		data[key]=tscn_arr[key]
	data["tscn_name"]=tscn_name
	return data
func _on_load(data):
	for key in data:
		if(key!="tscn_name"&&data[key].name):
			tscn_arr[key]=data[key]
			tscn_name=key
			tscn_monster_init(data[key].name,0)
	_tscn_arrangement()
	pass
