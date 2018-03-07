extends Panel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var act=0
func _ready():
	get_node("wechat").connect("pressed",self,"_on_wechat")
	get_node("ali").connect("pressed",self,"_on_ali")
	get_parent().get_node("donate").connect("pressed",self,"_on_open")
	get_node("close").connect("pressed",self,"_on_close")
	get_node("ali window/open").connect("pressed",self,"_on_open_ali")
	get_node("ali window/big").connect("pressed",self,"_on_big",["ali"])
	#get_node("wechat window/open").connect("pressed",self,"_on_open_wechat")
	get_node("wechat window/big").connect("pressed",self,"_on_big",["wechat"])
	set_process_input(true)
	#OS.shell_open("HTTPS://QR.ALIPAY.COM/FKX08349RKEXLZ4DXWDL4D")
	# Called every time the node is added to the scene.
	# Initialization here
	pass
func _input(event):
	if(event.is_action_released("mouse_left")):
		get_node("ali window/img").hide()
		get_node("wechat window/img").hide()
func _on_close():
	if(act):
		get_node("ali window").hide()
		get_node("wechat window").hide()
		act=0
	else:
		hide()
func _on_open():
	show()
func _on_wechat():
	act=1
	get_node("wechat window").show()
	pass
func _on_ali():
	act=1
	get_node("ali window").show()
func _on_open_ali():
	OS.shell_open("https://qr.alipay.com/FKX08349RKEXLZ4DXWDL4D")
func _on_big(name):
	get_node(name+" window/img").show()
func _on_save(name):
	#var image = Image()
	get_node(name+" window/img").show()
	get_viewport().queue_screen_capture()
	yield(get_tree(),"idle_frame")
	yield(get_tree(),"idle_frame")
	get_viewport().get_screen_capture().save_png("user://"+name+"_donate.png")
	get_node(name+" window/img").hide()
	#image.load("res://assets/img/donate/"+name+".png")
	#image.save_png("user://"+name+"_donate.png")
func _on_open_wechat():
	OS.shell_open("com.tencent.mm")
	#OS.shell_open(OS.get_data_dir()+"/wechat_donate.png")
	pass