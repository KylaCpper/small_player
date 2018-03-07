extends ColorFrame

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var id=0
var Node_List
var Node_Money
var List=[
	{"money":10,"info":"potion1 restore 10hp","hp":10},
	{"money":20,"info":"potion2 restore 22hp","hp":22},
	{"money":30,"info":"potion3 restore 35hp","hp":35}
]
func _ready():
	Node_List=get_node("list")
	Node_Money=get_node("money")
	List[0].texture= preload("res://assets/item/blood.png")
	List[1].texture= preload("res://assets/item/blood.png")
	List[2].texture= preload("res://assets/item/blood.png")
	Node_List.set_fixed_icon_size(Vector2(20,20))
	Node_Money.set_fixed_icon_size(Vector2(20,20))
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_open_shop_list():
	for i in range(3):
		Node_List.add_item(tr(List[i].info),List[i].texture)
		var gold=get_node("/root/overall").GetTexture().gold
		Node_Money.add_item(str(List[i].money),gold,0)
	show()
	get_tree().set_pause(true)
func _on_close():
	Node_List.clear()
	Node_Money.clear()
	hide()
	get_tree().set_pause(false)
	get_tree().call_group(0,"sound","shop_bg",false)

func _on_select(id):
	if(!self.id==id):
		get_tree().call_group(0,"sound","misc","water")
	self.id=id
func _on_buy():
	get_tree().call_group(0,"player","property_business","hp",List[id].hp,List[id].money)
	get_tree().call_group(0,"sound","misc","drink water")
	
	pass
	#_on_close()
	