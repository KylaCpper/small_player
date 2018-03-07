extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var show=1
func _ready():
	information_update()
	get_node("msg/text").set_scroll_follow(1)
	# Called every time the node is added to the scene.
	# Initialization here
	pass
func information_update():
	var Player=get_node("/root/overall").GetPlayer()
	
	get_node("hp/hp bar").set_max(Player.hp_cap)
	get_node("hp/hp bar").set_value(Player.hp)
	get_node("hp/hp").set_text(str(Player.hp)+"/"+str(Player.hp_cap))
	
	get_node("exp/exp bar").set_max(Player.expe)
	get_node("exp/exp bar").set_value(Player.expe_current)
	get_node("exp/exp").set_text(str(Player.expe_current)+"/"+str(Player.expe))
	
	get_node("player information/name/text").set_text(Player.name)
	get_node("player information/lv/text").set_text("%d" % Player.lv)
	get_node("player information/atk/text").set_text(str(Player.atk))
	get_node("player information/def/text").set_text(str(Player.def))
	get_node("player information/expe/text").set_text("%d" % Player.expe)
	get_node("player information/expe_current/text").set_text("%d" % Player.expe_current)
	get_node("player information/money/text").set_text("%d" % Player.money)
	get_node("player information/num monster/text").set_text("%d" % Player.num_monster)

func msg_send(data,color="default"):
	get_node("msg/text").add_text(data+"\n")

func display():
	if(show):
		get_node("player information").hide()
		get_parent().get_node("group_map2/property_shop").set_z(7)
	else:
		get_node("player information").show()
		get_parent().get_node("group_map2/property_shop").set_z(0)
	show=!show
	

func _on_msg_clear():
	get_node("msg/text").clear()
