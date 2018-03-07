extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var night=0
var texture={
	"gold":null
}
var scene={

}
class Player:
	var name
	var atk=1
	var def=0
	var hp =10
	var hp_cap=10
	var direction="down"
	var lv=1
	var expe=100
	var expe_current=0
	var money=100
	var num_monster=0
	var num_monster_json={}
	var act=1
	func _init(name_):
		name=name_

	func kill_monster(monster_expe):
		expe_current+=monster_expe
	func lv_up():
		lv+=1
		hp_cap+=3
		hp+=3
		atk+=0.5
		if(expe_current>=expe):
			var expe_overflow=expe_current-expe
			expe_current=expe_overflow
		expe=lv*100
		#def+=0.5

		
		
var player
class Monster:
	var name
	var atk
	var def
	var hp 
	var lv
	var expe
	var money

	func _init(name_,atk_=1,def_=0,hp_=10,expe_=10,money_=100):
		name=name_
		atk=atk_
		def=def_
		hp=hp_
		expe=expe_
		money=money_

var monster
var Load=0
var LoadId=0

var sound={
	"bg":20,
	"effect":20
}


func _ready():
	player=Player.new("kylaCpp")
	texture.gold=preload("res://assets/item/gold.png")
	texture.icon=preload("res://icon.png")
	texture.blue_slime = preload("res://assets/monster/blue_slime.png")
	texture.red_slime = preload("res://assets/monster/red_slime.png")
	texture.green_slime = preload("res://assets/monster/green_slime.png")
	
	scene.monster0 = preload("res://scene/monster0.tscn")
	scene.monster1 = preload("res://scene/monster1.tscn")
	scene.monster2 = preload("res://scene/monster2.tscn")
	# Called every time the node is added to the scene.
	# Initialization here
	pass
func InitData():
	player=Player.new("kylaCpp")
func SetName(name):
	player.name=name

func GetPlayer():
	return  player
#monster0
func GetSetMonster(obj):
	return Monster.new(obj.name,obj.atk,obj.def,obj.hp,obj.expe,obj.money)
func GetTexture():
	return texture
func GetSound():
	return sound
func MsgSend(that,data,color="default"):
	that.get_tree().call_group(0,"information","msg_send",data,color)
func Load(id):
	Load=1
	LoadId=id
func SetLoad(Load_=1):
	Load=Load_
func GetScene():
	return scene
func GetData(key):
	return self[key]
func SetData(key,num):
	self[key]=num