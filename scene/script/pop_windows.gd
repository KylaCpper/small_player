extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("start night/close").connect("pressed",self,"_on_window_close",["start night"])
	get_node("start night/sure").connect("pressed",self,"_on_start_night",["start night"])
	get_node("pass night/close").connect("pressed",self,"_on_window_close",["pass night"])
	
	pass
	
func _on_start_night(name):
	get_tree().call_group(0,"monsters","_on_start_night")
	window_close(name)
	
func pass_night(night,reward):
	var str_be=tr("the")+str(night)+tr("night")+tr("passed")+"\n"+tr("获得钱")+str(reward.money)+","+tr("经验")+str(reward.expe)
	get_node("pass night/text").set_text(str_be)
	window_open("pass night")
func start_night(night):
	var str_be=tr("whether to start the")+str(night)+tr("night")
	get_node("start night/text").set_text(str_be)
	window_open("start night")


func _on_window_close(name):
	window_close(name)
	
	

func window_open(name):
	get_node(name).show()
func window_close(name):
	get_node(name).hide()