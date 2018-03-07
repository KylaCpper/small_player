extends Button

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var id=0
var icon
var node_ready={}
var repart=0
var width=20
var height=30
func _ready():
	icon=get_node("/root/overall").GetTexture().icon
	# Called every time the node is added to the scene.
	# Initialization here

	#_load(get_node("/root/overall").loadid)
	pass
func _on_ready(name):
	if(!repart):
		var node_loads=get_tree().get_nodes_in_group("load")
		for obj in node_loads:
			node_ready[obj.get_name()]=0
		repart=1
		pass
	node_ready[name]=1
	for key in node_ready:
		if(node_ready[key]!=1):
			return
	if(get_node("/root/overall").Load):
		_load(get_node("/root/overall").LoadId)

	pass
func _load(id):
	var savegame = File.new()
	savegame.open_encrypted_with_pass ("user://savegame"+str(id)+".save", File.READ,"kyla")
	if(!savegame):
		return #Error!  We don't have a save to load
	    # Load the file line by line and process that dictionary to restore the object it represents
	 # dict.parse_json() requires a declared dict.
	var node_loads=get_tree().get_nodes_in_group("load")
	savegame.get_line()#time
	for obj in node_loads:
		var currentline = {}
		
		currentline.parse_json(savegame.get_line())
		obj._on_load(currentline)
	
	savegame.close()
	
	
	pass
func _on_save():
	init_save_list()
	get_node("list").show()
	pass
func init_save_list():
	var lines=4
	get_node("list/list").set_max_text_lines(lines)
	get_node("list/list").set_fixed_icon_size(Vector2(width,height))
	var file = File.new()
	for i in range(lines):
		if(!file.file_exists("user://savegame"+str(i)+".save")):
			get_node("list/list").add_item("null",icon)
		else:
			file.open_encrypted_with_pass ("user://savegame"+str(i)+".save", File.READ,"kyla")
			if(!file):return
			var currentline={}
			currentline.parse_json(file.get_line())
			var str_be=tr("time")+currentline.time+","+tr("name")+currentline.name
			get_node("list/list").add_item(str_be,icon)
	get_node("list/list").select(id)
	pass
func _on_save_select(index):
	id=index
func _on_save_sure():
	#get_node("list").hide()
	_save()
	pass # replace with function body


func _on_save_close():
	get_node("list/list").clear()
	get_node("list").hide()
	pass # replace with function body
func _save():
	get_node("/root/overall").MsgSend(self,tr("do not leave the game while saving"))
	var savegame = File.new()
	savegame.open_encrypted_with_pass ("user://savegame"+str(id)+".save", File.WRITE,"kyla")
	var date = OS.get_datetime()
	var day=tr("noon")
	if(date.hour>12):
		day=tr("afternoon")
	elif(date.hour<12):
		day=tr("morning")
	var time="%s/%s/%s %s%s:%s" %[str(date.year),str(date.month),str(date.day),day,str(date.hour),str(date.minute)]
	var name = get_node("/root/overall").GetPlayer().name
	savegame.store_line({"time":time,"name":name}.to_json())
	
	var savenodes = get_tree().get_nodes_in_group("save")
	for obj in savenodes:
		var data = obj._on_save()
		savegame.store_line(data.to_json())
	savegame.close()
	get_node("/root/overall").MsgSend(self,tr("saved"))
	var str_be=tr("time")+time+","+tr("name")+name
	get_node("list/list").set_item_text (id,str_be)