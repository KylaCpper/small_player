extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var display=0
var sound={
	"bg":20,
	"effect":20
}
var sound_proportion=100/5
var language_id=0
func _ready():
	_load()
	#sound bg
	get_node("set/sound bg/scroll bar").connect("value_changed",self,"_on_change_sound_bg_scroll")
	get_node("set/sound bg/edit").connect("text_entered",self,"_on_change_sound_bg_text")
	get_node("set/sound bg/scroll bar").set_value(sound.bg)
	#sound effect
	get_node("set/sound effect/scroll bar").connect("value_changed",self,"_on_change_sound_effect_scroll")
	get_node("set/sound effect/edit").connect("text_entered",self,"_on_change_sound_effect_text")
	get_node("set/sound effect/scroll bar").set_value(sound.effect)
	
	get_node("set/save").connect("pressed",self,"_on_set")
	get_node("set/close").connect("pressed",self,"_on_close")
	_on_set()

	pass

func _on_change_sound_bg_scroll(val):
	get_node("set/sound bg/edit").set_text("%d" %val)
	get_tree().call_group(0,"sound","set_sound_bg",val/sound_proportion)
	pass
func _on_change_sound_bg_text(str_):
	get_node("set/sound bg/scroll bar").set_value(str_.to_int())
	get_tree().call_group(0,"sound","set_sound_bg",str_.to_int()/sound_proportion)
	pass
func _on_change_sound_effect_scroll(val):
	get_node("set/sound effect/edit").set_text("%d" %val)
	get_tree().call_group(0,"sound","set_sound_effect",val/sound_proportion)
	pass
func _on_change_sound_effect_text(str_):
	get_node("set/sound effect/scroll bar").set_value(str_.to_int())
	if(get_node("/root/overall").GetReady()):	
		get_tree().call_group(0,"sound","set_sound_effect",str_.to_int()/sound_proportion)
	pass

func _on_set():
	sound.bg=get_node("set/sound bg/scroll bar").get_value()
	sound.effect=get_node("set/sound effect/scroll bar").get_value()
	_save()
	_close()
	pass
func _save():
	var file = File.new()
	file.open("user://set.save", File.WRITE)
	if(!file):return
	file.store_line(sound.to_json())
	var language={"id":language_id}
	file.store_line(language.to_json())
	file.close()
	pass
func _load():
	var file = File.new()
	if(!file.file_exists("user://set.save")):return
	file.open("user://set.save", File.READ)
	if(!file):return
	var data={}
	data.parse_json(file.get_line())
	sound=data
	data={}
	data.parse_json(file.get_line())
	if(data.id):
		language_id=data.id
	file.close()
	pass
func set_language(id):
	language_id=id
	_save()
	get_node("/root/global").GoTo_Scene("res://scene/start.tscn")

func _on_close():
	
	_close()

	pass
func _open():
	get_node("set").show()
	display=1
	get_tree().set_pause(true)
	pass
func _close():
	set()
	get_tree().call_group(0,"sound","set_sound_bg",sound.bg/sound_proportion)
	get_tree().call_group(0,"sound","set_sound_effect",sound.effect/sound_proportion)
	get_node("set").hide()
	display=0
	get_tree().set_pause(false)
	pass
func set():
	get_node("set/sound bg/scroll bar").set_value(sound.bg)
	get_node("set/sound effect/scroll bar").set_value(sound.effect)
	pass
func _display():
	if(display):
		_close()
	else:
		_open()


func _on_goto_start():
	get_tree().set_pause(false)
	get_node("/root/overall").InitData()
	get_node("/root/overall").SetLoad(0)
	get_node("/root/global").GoTo_Scene("res://scene/start.tscn")
	pass # replace with function body
