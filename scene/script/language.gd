extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
# 法语FR 俄语RU 瑞典语SV 西班牙es
var language=["中文(简体)","中文(繁體)","english","日本語","Français","Русский язык","svenska","España"]
var language_key=["zh","et","en","ja","fr","ru","sv","es"]
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	for i in range(language.size()):
		get_node("select").add_item(language[i])
	get_node("select").connect("item_selected",self,"_on_select")
	get_parent().get_node("save").connect("pressed",self,"_on_save")
	
	pass
var id=0
func _on_select(id):
	self.id=id
func _on_save():
	TranslationServer.set_locale(language_key[id])
	get_tree().call_group(0,"set","set_language",id)