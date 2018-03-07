extends Panel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var list_arr=[
	"no data\n"
]
var list=""

func _ready():
	get_node("close").connect("pressed",self,"_on_close")
	get_parent().get_node("donate list").connect("pressed",self,"_on_open")
	for i in range(list_arr.size()):
		list+=list_arr[i]
	get_node("list").set_text(list)
	pass
func _on_close():
	hide()
	
func _on_open():
	show()
	