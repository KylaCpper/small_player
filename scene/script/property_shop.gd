extends ColorFrame

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var id=0
var Node_List
var Node_Money
var List=[
	{"property":"atk","info":"atk+1","money":100},
	{"property":"def","info":"def+1","money":150},
	{"property":"hp_cap","info":"hp limit+1","money":20},
	{"property":"lv","info":"lv up","money":100}
]
func _ready():
	Node_List=get_node("list")
	Node_Money=get_node("money")
	List[0].texture= preload("res://assets/item/act.png")
	List[1].texture= preload("res://assets/item/def.png")
	List[2].texture= preload("res://assets/item/blood_up.png")
	List[3].texture= preload("res://assets/item/lv_up.png")
	Node_List.set_fixed_icon_size(Vector2(20,20))
	Node_Money.set_fixed_icon_size(Vector2(20,20))

	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_open_shop_list():
	for i in range(4):
		Node_List.add_item(tr(List[i].info),List[i].texture)
		var gold=get_node("/root/overall").GetTexture().gold
		Node_Money.add_item(str(List[i].money),gold,0)
	
	show()
	
	"""
	Node_List.set_max_columns(2)
	var size=Node_List.get_size()
	Node_List.set_fixed_column_width(size.x/2-15)
	Node_List.set_same_column_width(true)
	"""
	get_tree().set_pause(true)
func _on_close():
	Node_List.clear()
	Node_Money.clear()
	hide()
	get_tree().set_pause(false)
	get_tree().call_group(0,"sound","shop_bg",false)
	
func _on_select(id):
	self.id=id
func _on_buy():
	get_tree().call_group(0,"player","property_business",List[id].property,1,List[id].money)
	var name ="buy"
	if(id==0):
		name="atk"
	elif(id==1):
		name="def"
	elif(id==3):
		name="lv_up"
	get_tree().call_group(0,"sound","misc",name)
	pass
	#_on_close()
	

func _on_property_shop_mouse_enter():
	pass # replace with function body
