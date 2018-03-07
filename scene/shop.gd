extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var build_monster=0
var property_shop=0
var groceries_shop=0
var shop_pointer={
	"build_monster_shop":0,
	"property_shop":0,
	"groceries_shop":0
}
func _ready():
	#get_node("build_monster").set_exclusive(false)
	set_fixed_process(true)
	pass
func _fixed_process(delta): 
	for key in shop_pointer:
		if(shop_pointer[key]):
			if(Input.is_action_pressed("mouse_left")):
				shop_bg()
				get_node(key)._on_open_shop_list()
				get_tree().call_group(0,"sound","misc","open shop")
	pass
func _on_init_shop(obj):
	for key in shop_pointer:
		if(obj.get_name()==key):
			shop_bg()
			get_node(key)._on_open_shop_list()
			get_tree().call_group(0,"sound","misc","open shop")
	pass
	#if(obj.name()=="")

func shop_bg():
	get_tree().call_group(0,"sound","shop_bg",true)
func _on_out_shop(obj):
	pass

func _on_build_monster_shop_input_event(viewport,event,id):
	pass

func _on_build_monster_shop(viewport,event,id):
	pass


func _on_build_monster_shop_mouse_enter():
	shop_pointer.build_monster_shop=1

func _on_property_shop_mouse_enter():
	shop_pointer.property_shop=1

func _on_groceries_shop_mouse_enter():
	shop_pointer.groceries_shop=1
	
func _on_build_monster_shop_mouse_exit():
	shop_pointer.build_monster_shop=0

func _on_property_shop_mouse_exit():
	shop_pointer.property_shop=0

func _on_groceries_shop_mouse_exit():
	shop_pointer.groceries_shop=0
