extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	connect("mouse_enter",self,"_on_enter",[1])
	connect("mouse_exit",self,"_on_enter",[0])
	# Called every time the node is added to the scene.
	# Initialization here
	pass
func _on_enter(dis):
	print(dis)
