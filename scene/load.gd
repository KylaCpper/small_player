extends ItemList

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var icon
var id=0
var width=90
var height =110
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	icon = get_node("/root/overall").GetTexture().icon
	init_list()
	set_process_input(true)
	pass
func _input(event):
	if(event.is_action_pressed("esc")):
		_on_close()
	pass
func init_list():
	var lines=4
	set_max_text_lines(lines)
	set_fixed_icon_size(Vector2(width,height))
	var file = File.new()
	for i in range(lines):
		if(!file.file_exists("user://savegame"+str(i)+".save")):
			add_item("null",icon)
		else:
			file.open_encrypted_with_pass ("user://savegame"+str(i)+".save", File.READ,"kyla")
			if(!file):return
			var currentline={}
			currentline.parse_json(file.get_as_text())
			var str_be=tr("time")+currentline.time+","+tr("name")+currentline.name
			add_item(str_be,icon)
	file.close()
	select(id)
	#print(OS.get_data_dir())



func _on_load():
	if(get_item_text(id)!="null"):
		get_node("/root/global").GoTo_Scene("res://scene/main.tscn",id)
	pass # replace with function body


func _on_close():
	get_node("/root/global").GoTo_Scene("res://scene/start.tscn")
	pass # replace with function body


func _on_list_select( index ):
	id=index
	pass # replace with function body


func _on_list_item_act( index ):
	if(get_item_text(index)!="null"):
		get_node("/root/global").GoTo_Scene("res://scene/main.tscn",index)
	pass # replace with function body
