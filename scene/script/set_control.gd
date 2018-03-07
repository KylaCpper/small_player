extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("esc").connect("pressed",self,"_on_esc")
	set_process_input(true)
	pass
func _input(event):
	if(event.is_action_pressed("esc")):
		var shop=get_parent().get_node("shop list")
		if(shop.get_node("build_monster_shop").is_visible()):
			shop.get_node("build_monster_shop")._on_close()
		elif(shop.get_node("property_shop").is_visible()):
			shop.get_node("property_shop")._on_close()
		elif(shop.get_node("groceries_shop").is_visible()):
			shop.get_node("groceries_shop")._on_close()
		else:
			get_tree().call_group(0,"set","_display")
	pass
func _on_esc():
	var ev = InputEvent()
	ev.set_as_action("esc", true)
	Input.parse_input_event(ev)