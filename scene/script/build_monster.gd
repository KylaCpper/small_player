extends ColorFrame

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var id=0
var Node_List
var Node_Money
var List=[
	{"info":"build blue slime","texture":null,"name":"monster0","money":10},
	{"info":"build red slime","texture":null,"name":"monster1","money":50},
	{"info":"build green slime","texture":null,"name":"monster2","money":100}
]
func _ready():
	Node_List=get_node("list")
	Node_Money=get_node("money")
	List[0].texture= preload("res://assets/monster/blue_slime_.png")
	List[1].texture= preload("res://assets/monster/red_slime_.png")
	List[2].texture= preload("res://assets/monster/green_slime_.png")
	Node_List.set_fixed_icon_size(Vector2(20,20))
	Node_Money.set_fixed_icon_size(Vector2(20,20))
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_open_shop_list():
	for i in range(3):
		Node_List.add_item(tr(List[i].info),List[i].texture)
		var gold=get_node("/root/overall").GetTexture().gold
		Node_Money.add_item(str(List[i].money)+"g",gold,0)
	show()
	#Node_List.set_allow_rmb_select(true)
	get_tree().set_pause(true)
func _on_close():
	Node_List.clear()
	Node_Money.clear()
	hide()
	get_tree().call_group(0,"sound","shop_bg",false)
	get_tree().set_pause(false)

func _on_select(id):
	self.id=id
func _on_buy(id_be=id):
	get_tree().call_group(0,"build_monster","_on_init_monster",List[id_be].name,List[id_be].money)
	get_tree().call_group(0,"sound","misc","buy")
	_on_close()
	


