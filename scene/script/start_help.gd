extends Button

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	connect("pressed",self,"_on_open")
	get_node("window/close").connect("pressed",self,"_on_close")
	get_node("window/qq qun").connect("pressed",self,"_on_in_qun")
	pass
func _on_open():
	get_node("window").show()
func _on_close():
	get_node("window").hide()
func _on_in_qun():
	OS.shell_open("https://jq.qq.com/?_wv=1027&k=5uCRFZJ")