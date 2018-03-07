extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var cmd
var num=0
var sound={
	"bg":20,
	"effect":20
}
var language_key=["zh","et","en","ja","fr","ru","sv","es"]
var sound_proportion=100/5
func _ready():
	cmd=get_node("cmd ani")
	cmd.connect("finished",self,"_on_init_game")
	#get_node("start game").set_volume(sound.bg/sound_proportion)
	get_node("key board").set_volume(sound.effect/sound_proportion)
	get_node("sound").set_default_volume(sound.effect/sound_proportion) 
	var file = File.new()
	if(!file.file_exists("user://set.save")):return
	file.open("user://set.save", File.READ)
	if(!file):return
	var language={}
	language.parse_json(file.get_line())
	language={}
	language.parse_json(file.get_line())
	if(!language.id):language.id=0
	TranslationServer.set_locale(language_key[language.id])
	file.close()
	
	pass
func _on_init_game():
	cmd.play("init game")
	cmd.disconnect("finished",self,"_on_init_game")
	cmd.connect("finished",self,"_on_start_game")
	pass
func _on_start_game():
	get_node("/root/global").GoTo_Scene("res://scene/start.tscn")
	pass

