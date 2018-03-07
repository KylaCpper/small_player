extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
func _ready():
	get_node("start night").connect("pressed",self,"_on_start_night_window")
	#get_node("start night/close").connect("pressed",self,"_on_close",["start night"])
	#get_node("start boss/close").connect("pressed",self,"_on_close",["start boss"])
				# Called every time the node is added to the scene.
	# Initialization here
	pass
func set_start_night(night):
	var str_be=tr("the")+str(night+1)+tr("night")
	get_node("start night").set_text(str_be)
func _on_start_night_window():
	var night=get_node("/root/overall").GetData("night")
	get_tree().call_group(0,"pop windows","start_night",(night+1))